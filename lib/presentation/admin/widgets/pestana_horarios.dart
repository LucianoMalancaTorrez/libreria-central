import 'package:flutter/material.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/core/widgets/vista_estado.dart';
import 'package:libreria/domain/models/horario_atencion.dart';
import 'package:libreria/presentation/admin/viewmodels/horarios_admin_view_model.dart';

/// Cambia las horas de invierno y verano con el selector de hora.
class PestanaHorarios extends StatefulWidget {
  const PestanaHorarios({super.key});

  @override
  State<PestanaHorarios> createState() => _PestanaHorariosState();
}

/// El mixin conserva lo editado al cambiar de pestaña.
class _PestanaHorariosState extends State<PestanaHorarios>
    with AutomaticKeepAliveClientMixin {
  late final HorariosAdminViewModel _viewModel;

  static const _etiquetas = [
    'Abre a la mañana',
    'Cierra a la mañana',
    'Abre a la tarde',
    'Cierra a la tarde',
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    final servicios = Dependencias.of(context);
    _viewModel = HorariosAdminViewModel(
      servicios.horarios,
      servicios.administracion!.horarios,
    )..cargar();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _elegir(Temporada temporada, int i) async {
    final actual = _viewModel.horas(temporada)[i];
    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: actual ~/ 60, minute: actual % 60),
    );
    if (hora == null || !mounted) return;
    _viewModel.cambiar(temporada, i, hora.hour * 60 + hora.minute);
  }

  Future<void> _guardar() async {
    final mensajero = ScaffoldMessenger.of(context);
    final mensaje = await _viewModel.guardar();
    mensajero.showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return VistaEstado(
      viewModel: _viewModel,
      alReintentar: _viewModel.cargar,
      builder: (context) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final (nombre, temporada) in const [
            ('Invierno', Temporada.invierno),
            ('Verano', Temporada.verano),
          ]) ...[
            Text(nombre, style: Theme.of(context).textTheme.titleLarge),
            for (final (i, minutos) in _viewModel.horas(temporada).indexed)
              ListTile(
                title: Text(_etiquetas[i]),
                trailing: Text(
                  Turno.hora(minutos),
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
      ),
    );
  }
}
