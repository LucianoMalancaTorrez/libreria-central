import 'package:libreria/domain/models/libro.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Acceso a la tabla `libros` de SQLite. Las fotos no se guardan acá: un
/// binario grande no va en la base.
class LibrosDao {
  LibrosDao(this._abrir);

  /// Base en el almacenamiento del celular.
  factory LibrosDao.enDispositivo() => LibrosDao(
    () async => openDatabase(
      p.join(await getDatabasesPath(), 'libreria.db'),
      version: 1,
      onCreate: (db, version) => db.execute(sqlCrear),
    ),
  );

  static const sqlCrear = '''
    CREATE TABLE libros (
      id TEXT PRIMARY KEY,
      titulo TEXT NOT NULL,
      autor TEXT NOT NULL,
      genero TEXT NOT NULL,
      editorial TEXT NOT NULL DEFAULT '',
      descripcion TEXT NOT NULL DEFAULT ''
    )''';

  final Future<Database> Function() _abrir;
  Future<Database>? _base;

  Future<Database> get _db => _base ??= _abrir();

  /// Todo o nada: si algo falla, queda la copia anterior.
  Future<void> reemplazarTodos(List<Libro> libros) async {
    final db = await _db;
    await db.transaction((tx) async {
      await tx.delete('libros');
      final lote = tx.batch();
      for (final libro in libros) {
        lote.insert('libros', {
          'id': libro.id,
          ...libro.toJson()..remove('foto'),
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await lote.commit(noResult: true);
    });
  }

  Future<List<Libro>> todos() async => _leer(await _db);

  /// El texto viaja como parámetro (`?`), nunca pegado dentro del SQL.
  Future<List<Libro>> buscarPorTitulo(String texto) async =>
      _leer(await _db, where: 'titulo LIKE ?', args: ['%$texto%']);

  Future<List<Libro>> _leer(
    Database db, {
    String? where,
    List<Object?>? args,
  }) async {
    final filas = await db.query(
      'libros',
      where: where,
      whereArgs: args,
      orderBy: 'titulo',
    );
    return [for (final fila in filas) Libro.fromJson(fila)];
  }

  Future<void> cerrar() async => (await _base)?.close();
}
