import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/core/services/avisos.dart';
import 'package:libreria/core/utils/abrir_enlace.dart';
import 'package:libreria/domain/logic/club_lectura.dart';
import 'package:libreria/domain/logic/recordatorio.dart';

class PestanaEncuentros extends StatelessWidget {
  const PestanaEncuentros({super.key});

  void _anotarse(BuildContext context, DateTime fecha) => abrirEnlace(
    context,
    LibreriaConfig.enlaceWhatsApp(
      'Hola Amelia! Quiero ir al club de lectura del ${fechaLarga(fecha)}.',
    ),
  );

  Future<void> _elegirFecha(BuildContext context) async {
    final proximos = proximosEncuentros(DateTime.now(), cantidad: 12);
    final fecha = await showDatePicker(
      context: context,
      initialDate: proximos.first,
      firstDate: proximos.first,
      lastDate: proximos.last,
      selectableDayPredicate: esDiaDeClub,
      helpText: 'Elegí un jueves',
    );
    if (fecha != null && context.mounted) _anotarse(context, fecha);
  }

  Future<void> _recordar(BuildContext context, DateTime fecha) async {
    final avisos = Dependencias.of(context).avisos;
    final mensajero = ScaffoldMessenger.of(context);
    void decir(String texto) =>
        mensajero.showSnackBar(SnackBar(content: Text(texto)));

    final hora = horaDelRecordatorio(fecha, DateTime.now());
    if (hora == null) return decir('Ese encuentro es muy pronto.');
    try {
      if (await avisos.pedirPermiso() != ResultadoPermiso.concedido) {
        return decir('Sin permiso no podemos avisarte.');
      }
      await avisos.programar(
        hora,
        'Hoy hay club de lectura',
        'Te esperamos en Librería Central.',
      );
      decir('Te avisamos el ${fechaLarga(fecha)} a las 10.');
    } catch (e) {
      debugPrint('Recordatorio: $e');
      decir('No se pudo programar el aviso.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Nos juntamos los jueves en el local. Consultá el horario por '
          'WhatsApp.',
        ),
        const SizedBox(height: 12),
        for (final fecha in proximosEncuentros(DateTime.now()))
          Card(
            child: ListTile(
              leading: const Icon(Icons.event),
              title: Text(fechaLarga(fecha)),
              subtitle: const Text(LibreriaConfig.direccion),
              trailing: Dependencias.of(context).avisos.soportaSegundoPlano
                  ? IconButton(
                      tooltip: 'Recordármelo',
                      icon: const Icon(Icons.alarm_add),
                      onPressed: () => _recordar(context, fecha),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: () => _anotarse(context, fecha),
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _elegirFecha(context),
          icon: const Icon(Icons.calendar_month),
          label: const Text('Elegir otra fecha'),
        ),
      ],
    );
  }
}
