import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/domain/models/horario_atencion.dart';

/// Cambia las horas de invierno y verano con el selector de hora.
class PestanaHorarios extends StatefulWidget {
  const PestanaHorarios({super.key});

  @override
  State<PestanaHorarios> createState() => _PestanaHorariosState();
}

class _PestanaHorariosState extends State<PestanaHorarios> {
  /// Cuatro horas por temporada, en minutos.
  List<int>? _invierno;
  List<int>? _verano;

  static const _etiquetas = [
    'Abre a la mañana',
    'Cierra a la mañana',
    'Abre a la tarde',
    'Cierra a la tarde',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_invierno == null) _cargar();
  }

  Future<void> _cargar() async {
    final horarios = await Dependencias.of(context).horarios
        .observarHorarios()
        .first;
    if (!mounted) return;
    setState(() {
      _invierno = horarios.invierno.toList();
      _verano = horarios.verano.toList();
    });
  }

  Future<void> _elegir(List<int> temporada, int i) async {
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: temporada[i] ~/ 60,
        minute: temporada[i] % 60,
      ),
    );
    if (hora == null || !mounted) return;
    setState(() => temporada[i] = hora.hour * 60 + hora.minute);
  }

  Future<void> _guardar() async {
    final mensajero = ScaffoldMessenger.of(context);
    void avisar(String texto) =>
        mensajero.showSnackBar(SnackBar(content: Text(texto)));

    // Las cuatro horas de cada temporada tienen que ir en orden.
    for (final t in [_invierno!, _verano!]) {
      if (!(t[0] < t[1] && t[1] <= t[2] && t[2] < t[3])) {
        avisar('Revisá el orden de las horas.');
        return;
      }
    }
    try {
      await Dependencias.of(context).administracion!.horarios.guardarHorarios(
        Horarios(
          invierno: HorarioTemporada.fromList(_invierno!),
          verano: HorarioTemporada.fromList(_verano!),
        ),
      );
      avisar('Horarios guardados');
    } catch (e) {
      debugPrint('Horarios: $e');
      avisar('No se pudieron guardar.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final invierno = _invierno;
    final verano = _verano;
    if (invierno == null || verano == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final (nombre, temporada) in [
          ('Invierno', invierno),
          ('Verano', verano),
        ]) ...[
          Text(nombre, style: Theme.of(context).textTheme.titleLarge),
          for (var i = 0; i < 4; i++)
            ListTile(
              title: Text(_etiquetas[i]),
              trailing: Text(
                Turno.hora(temporada[i]),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              onTap: () => _elegir(temporada, i),
            ),
          const Divider(),
        ],
        ElevatedButton(
          onPressed: _guardar,
          child: const Text('Guardar horarios'),
        ),
      ],
    );
  }
}
