import 'package:libreria/core/viewmodels/view_model.dart';
import 'package:libreria/domain/models/horario_atencion.dart';
import 'package:libreria/domain/repositories/horarios_repository.dart';

class InformacionViewModel extends ViewModel {
  InformacionViewModel(this._repositorio);

  final HorariosRepository _repositorio;
  Horarios _horarios = Horarios.habituales;
  InfoLibreria? _info;

  Horarios get horarios => _horarios;
  InfoLibreria? get info => _info;

  Future<void> cargar() async {
    await ejecutar(
      () async => _info = await _repositorio.getInfoLibreria(),
      mensajeError: 'No se pudo cargar la información.',
    );
    if (error != null) return;
    await escuchar<Horarios>(
      _repositorio.observarHorarios(),
      (nuevos) => _horarios = nuevos,
      mensajeError: 'No se pudieron cargar los horarios.',
    );
  }
}
