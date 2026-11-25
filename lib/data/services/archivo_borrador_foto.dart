import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:libreria/domain/services/fotos.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Guarda el borrador como archivo en la carpeta de documentos de la app.
/// En la web no hay archivos, así que no hace nada.
class ArchivoBorradorFoto implements BorradorFoto {
  Future<File> _archivo(String clave) async {
    final carpeta = await getApplicationDocumentsDirectory();
    return File(p.join(carpeta.path, 'borrador_$clave.jpg'));
  }

  @override
  Future<void> guardar(String clave, Uint8List foto) async {
    if (kIsWeb) return;
    await (await _archivo(clave)).writeAsBytes(foto);
  }

  @override
  Future<Uint8List?> leer(String clave) async {
    if (kIsWeb) return null;
    final archivo = await _archivo(clave);
    return await archivo.exists() ? archivo.readAsBytes() : null;
  }

  @override
  Future<void> borrar(String clave) async {
    if (kIsWeb) return;
    final archivo = await _archivo(clave);
    if (await archivo.exists()) await archivo.delete();
  }
}
