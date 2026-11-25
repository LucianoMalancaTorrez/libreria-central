import 'package:flutter/foundation.dart';
import 'package:libreria/domain/repositories/preferencias_repository.dart';

/// Lista "Quiero verlo en el local". No es un carrito: no hay precios ni
/// compra, solo libros para preguntar en el mostrador.
class FavoritosViewModel extends ChangeNotifier {
  FavoritosViewModel(this._preferencias);

  static const _clave = 'favoritos';
  final PreferenciasRepository _preferencias;
  final List<String> _ids = [];

  /// En el orden que eligió la persona.
  List<String> get ids => List.unmodifiable(_ids);
  int get cantidad => _ids.length;
  bool contiene(String id) => _ids.contains(id);

  Future<void> cargar() async {
    final guardados = await _preferencias.leerLista(_clave);
    for (final id in guardados) {
      if (!_ids.contains(id)) _ids.add(id);
    }
    notifyListeners();
  }

  void alternar(String id) {
    _ids.contains(id) ? _ids.remove(id) : _ids.add(id);
    _guardar();
  }

  /// Devuelve la posición que ocupaba, para poder deshacer.
  int quitar(String id) {
    final posicion = _ids.indexOf(id);
    if (posicion >= 0) {
      _ids.removeAt(posicion);
      _guardar();
    }
    return posicion;
  }

  void insertar(int posicion, String id) {
    if (_ids.contains(id)) return;
    _ids.insert(posicion.clamp(0, _ids.length), id);
    _guardar();
  }

  /// [hasta] es la posición final, ya descontado el elemento movido.
  void mover(int desde, int hasta) {
    _ids.insert(hasta, _ids.removeAt(desde));
    _guardar();
  }

  void vaciar() {
    _ids.clear();
    _guardar();
  }

  void _guardar() {
    notifyListeners();
    _preferencias.guardarLista(_clave, List.of(_ids));
  }
}
