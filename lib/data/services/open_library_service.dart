import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:libreria/domain/services/info_libro_service.dart';

/// API pública y gratuita de Open Library. Solo se envían título y autor.
class OpenLibraryService implements InfoLibroService {
  OpenLibraryService({http.Client? cliente})
    : _cliente = cliente ?? http.Client();

  final http.Client _cliente;

  @override
  Future<InfoExterna?> buscar(String titulo, String autor) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      'title': titulo,
      'author': autor,
      'limit': '1',
      'fields': 'cover_i,first_publish_year',
    });
    final respuesta = await _cliente
        .get(uri)
        .timeout(const Duration(seconds: 10));
    if (respuesta.statusCode != 200) {
      throw Exception('Open Library respondió ${respuesta.statusCode}');
    }
    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    final resultados = datos['docs'] as List<dynamic>? ?? const [];
    if (resultados.isEmpty) return null;
    final primero = resultados.first as Map<String, dynamic>;
    final tapa = primero['cover_i'] as int?;
    return InfoExterna(
      urlTapa: tapa == null
          ? null
          : 'https://covers.openlibrary.org/b/id/$tapa-L.jpg',
      primeraEdicion: primero['first_publish_year'] as int?,
    );
  }
}
