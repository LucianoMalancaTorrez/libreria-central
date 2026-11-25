import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libreria/domain/services/fotos.dart';

class ImagePickerFuente implements FuenteFotos {
  final _selector = ImagePicker();

  @override
  Future<Uint8List?> elegir(OrigenFoto origen) async {
    final archivo = await _selector.pickImage(
      source: origen == OrigenFoto.camara
          ? ImageSource.camera
          : ImageSource.gallery,
      // Se achica al elegir: tiene que entrar en la base de datos.
      maxWidth: 500,
      maxHeight: 700,
      imageQuality: 60,
    );
    return archivo?.readAsBytes();
  }

  @override
  Future<Uint8List?> recuperarPerdida() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return null;
    final perdida = await _selector.retrieveLostData();
    return perdida.file?.readAsBytes();
  }
}
