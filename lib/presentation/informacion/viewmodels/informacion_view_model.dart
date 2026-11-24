import 'package:libreria/core/viewmodels/view_model.dart';
import 'package:libreria/domain/models/horario_atencion.dart';
import 'package:libreria/domain/repositories/horarios_repository.dart';

class InformacionViewModel extends ViewModel {
  InformacionViewModel(this._repositorio);

  final HorariosRepository _repositorio;
  List<HorarioAtencion> _horarios = const [];
  InfoLibreria? _info;

  List<HorarioAtencion> get horarios => _horarios;
  InfoLibreria? get info => _info;

  Future<void> cargar() => ejecutar(() async {
    // Los dos pedidos corren en paralelo.
    final (horarios, info) = await (
      _repositorio.getHorarios(),
      _repositorio.getInfoLibreria(),
    ).wait;
    _horarios = horarios;
    _info = info;
  }, mensajeError: 'No se pudo cargar la información.');
}
