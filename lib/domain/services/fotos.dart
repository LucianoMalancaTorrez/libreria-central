import 'dart:typed_data';

enum OrigenFoto { camara, galeria }

/// De dónde salen las fotos. Los tests usan una fuente falsa.
abstract class FuenteFotos {
  /// null si la persona canceló.
  Future<Uint8List?> elegir(OrigenFoto origen);

  /// Android puede cerrar la app mientras está la cámara: recupera esa foto.
  Future<Uint8List?> recuperarPerdida();
}

/// Foto elegida y todavía sin guardar en la nube.
abstract class BorradorFoto {
  Future<void> guardar(String clave, Uint8List foto);
  Future<Uint8List?> leer(String clave);
  Future<void> borrar(String clave);
}
