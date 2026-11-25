import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:libreria/domain/models/libro.dart';
import 'package:libreria/domain/repositories/libro_repository.dart';

/// Catálogo en Firestore. Mientras la nube esté vacía o no responda, muestra
/// el catálogo de ejemplo incluido en la app.
class FirestoreLibroRepository
    implements LibroRepository, CatalogoAdminRepository {
  FirestoreLibroRepository(this._base, {required this.respaldo});

  final FirebaseFirestore _base;
  final LibroRepository respaldo;

  CollectionReference<Map<String, dynamic>> get _libros =>
      _base.collection('libros');

  @override
  Stream<List<Libro>> observarLibros() async* {
    try {
      await for (final consulta in _libros.snapshots()) {
        if (consulta.docs.isEmpty) {
          yield await respaldo.observarLibros().first;
        } else {
          yield [
            for (final doc in consulta.docs)
              Libro.fromJson(doc.data(), id: doc.id),
          ]..sort((a, b) => a.titulo.compareTo(b.titulo));
        }
      }
    } catch (e) {
      debugPrint('Catálogo en la nube no disponible: $e');
      yield await respaldo.observarLibros().first;
    }
  }

  @override
  Stream<List<Libro>> observarPublicados() => _libros.snapshots().map(
    (consulta) => [
      for (final doc in consulta.docs) Libro.fromJson(doc.data(), id: doc.id),
    ]..sort((a, b) => a.titulo.compareTo(b.titulo)),
  );

  @override
  Future<void> guardar(Libro libro) => libro.id.isEmpty
      ? _libros.add(libro.toJson())
      : _libros.doc(libro.id).set(libro.toJson());

  @override
  Future<void> eliminar(String id) => _libros.doc(id).delete();

  @override
  Future<void> importar(List<Libro> libros) async {
    // Un lote admite hasta 500 escrituras; las reglas verifican cada una.
    for (var i = 0; i < libros.length; i += 10) {
      final lote = _base.batch();
      for (final libro in libros.skip(i).take(10)) {
        lote.set(_libros.doc(libro.id), libro.toJson());
      }
      await lote.commit();
    }
  }
}
