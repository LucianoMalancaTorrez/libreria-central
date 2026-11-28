import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/config/libreria_config.dart';
import 'package:libreria/core/utils/abrir_enlace.dart';
import 'package:libreria/domain/logic/club_lectura.dart';
import 'package:libreria/presentation/eventos/viewmodels/club_view_model.dart';

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
    final club = Dependencias.of(context).club;
    final mensajero = ScaffoldMessenger.of(context);
    final texto = switch (await club.recordar(fecha)) {
      ResultadoRecordatorio.programado =>
        'Te avisamos el ${fechaLarga(fecha)} a las 10.',
      ResultadoRecordatorio.muyPronto => 'Ese encuentro es muy pronto.',
      ResultadoRecordatorio.sinPermiso => 'Sin permiso no podemos avisarte.',
      ResultadoRecordatorio.fallo => 'No se pudo programar el aviso.',
    };
    mensajero.showSnackBar(SnackBar(content: Text(texto)));
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
              trailing: Dependencias.of(context).club.puedeAvisar
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
