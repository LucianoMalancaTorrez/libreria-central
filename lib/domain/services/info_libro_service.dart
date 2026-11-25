/// Datos extra de un libro obtenidos de una fuente externa.
class InfoExterna {
  const InfoExterna({this.urlTapa, this.primeraEdicion});

  final String? urlTapa;
  final int? primeraEdicion;
}

abstract class InfoLibroService {
  /// Devuelve null si la fuente no conoce el libro.
  Future<InfoExterna?> buscar(String titulo, String autor);
}
