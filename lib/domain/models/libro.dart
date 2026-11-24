class Libro {
  final String id;
  final String titulo;
  final String autor;
  final String editorial;
  final String genero;
  final String descripcion;

  const Libro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.editorial,
    required this.genero,
    required this.descripcion,
  });

  /// Indica si el libro coincide con una búsqueda por título, autor o género.
  bool coincide(String busqueda) {
    final texto = _normalizar(busqueda);
    if (texto.isEmpty) return true;
    return [titulo, autor, genero].any((c) => _normalizar(c).contains(texto));
  }

  /// Sin mayúsculas ni tildes: "garcia" encuentra "García".
  static String _normalizar(String valor) {
    const conTilde = 'áéíóúü';
    const sinTilde = 'aeiouu';
    var salida = valor.trim().toLowerCase();
    for (var i = 0; i < conTilde.length; i++) {
      salida = salida.replaceAll(conTilde[i], sinTilde[i]);
    }
    return salida;
  }
}
