import 'package:libreria/core/viewmodels/view_model.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';

enum VistaCatalogo { grilla, porGenero }

enum OrdenCatalogo { original, titulo, autor }

/// Fila de la lista agrupada: puede ser un encabezado o un libro.
sealed class FilaCatalogo {
  const FilaCatalogo();
}

class FilaEncabezado extends FilaCatalogo {
  const FilaEncabezado(this.genero);
  final String genero;
}

class FilaLibro extends FilaCatalogo {
  const FilaLibro(this.libro);
  final Libro libro;
}

class CatalogoViewModel extends ViewModel {
  CatalogoViewModel(this._repositorio);

  final LibroRepository _repositorio;
  List<Libro> _todos = const [];
  String _busqueda = '';
  String? _genero;
  VistaCatalogo _vista = VistaCatalogo.grilla;
  OrdenCatalogo _orden = OrdenCatalogo.original;

  String? get genero => _genero;
  VistaCatalogo get vista => _vista;
  bool get sinFiltros => _busqueda.trim().isEmpty && _genero == null;
  List<String> get generos =>
      ({for (final libro in _todos) libro.genero}.toList())..sort();
  List<Libro> get destacados => _todos.take(8).toList();

  OrdenCatalogo get orden => _orden;

  List<Libro> get libros {
    final visibles = _todos
        .where((l) => _genero == null || l.genero == _genero)
        .where((l) => l.coincide(_busqueda))
        .toList();
    switch (_orden) {
      case OrdenCatalogo.original:
        break;
      case OrdenCatalogo.titulo:
        visibles.sort((a, b) => a.titulo.compareTo(b.titulo));
      case OrdenCatalogo.autor:
        visibles.sort((a, b) => a.autor.compareTo(b.autor));
    }
    return visibles;
  }

  void ordenar(OrdenCatalogo orden) {
    _orden = orden;
    notifyListeners();
  }

  List<FilaCatalogo> get filas {
    final visibles = libros;
    return [
      for (final genero in generos)
        if (visibles.any((l) => l.genero == genero)) ...[
          FilaEncabezado(genero),
          for (final libro in visibles.where((l) => l.genero == genero))
            FilaLibro(libro),
        ],
    ];
  }

  /// Al volver a la app: pide el catálogo otra vez sin tapar la pantalla.
  Future<void> refrescar() => cargar(silencioso: true);

  Future<void> cargar({bool silencioso = false}) => escuchar<List<Libro>>(
    _repositorio.observarLibros(),
    (libros) {
      _todos = libros;
      // El género elegido pudo desaparecer al editar el catálogo.
      if (!libros.any((l) => l.genero == _genero)) _genero = null;
    },
    silencioso: silencioso,
    mensajeError: 'No se pudo cargar el catálogo.',
  );
  void buscar(String texto) {
    _busqueda = texto;
    notifyListeners();
  }

  void filtrarGenero(String? genero) {
    _genero = genero;
    notifyListeners();
  }

  void cambiarVista(VistaCatalogo vista) {
    _vista = vista;
    notifyListeners();
  }
}
