import 'package:libreria/core/viewmodels/view_model.dart';
import 'package:libreria/domain/models/escuela.dart';
import 'package:libreria/domain/repositories/escuela_repository.dart';

class EscuelasViewModel extends ViewModel {
  EscuelasViewModel(this._repositorio);

  final EscuelaRepository _repositorio;
  List<Escuela> _escuelas = const [];

  List<Escuela> get escuelas => _escuelas;

  Future<void> cargar() => ejecutar(
    () async => _escuelas = await _repositorio.getEscuelas(),
    mensajeError: 'No se pudieron cargar las escuelas.',
  );
}
