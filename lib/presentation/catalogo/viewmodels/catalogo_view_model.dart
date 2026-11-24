import 'package:libreria/core/viewmodels/view_model.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';

class CatalogoViewModel extends ViewModel {
  CatalogoViewModel(this._repositorio);

  final LibroRepository _repositorio;
  List<Libro> _todos = const [];
  String _busqueda = '';

  List<Libro> get libros =>
      _todos.where((libro) => libro.coincide(_busqueda)).toList();

  Future<void> cargar() => ejecutar(
    () async => _todos = await _repositorio.getLibros(),
    mensajeError: 'No se pudo cargar el catálogo.',
  );

  void buscar(String texto) {
    _busqueda = texto;
    notifyListeners();
  }
}
