import 'dart:async';

import 'package:libreria/core/viewmodels/view_model.dart';
import 'package:libreria/domain/services/auth_service.dart';

/// Sesión de la administradora: quién entró y si está habilitada.
class AccesoViewModel extends ViewModel {
  AccesoViewModel(this._auth) {
    _suscripcionUsuario = _auth.observarUsuario().listen(_cambio);
  }

  final AuthService _auth;
  late final StreamSubscription<Usuario?> _suscripcionUsuario;
  Usuario? _usuario;
  bool? _habilitado;

  Usuario? get usuario => _usuario;

  /// null mientras se está comprobando.
  bool? get habilitado => _habilitado;

  Future<void> _cambio(Usuario? usuario) async {
    _usuario = usuario;
    _habilitado = null;
    notifyListeners();
    if (usuario == null) return;
    try {
      _habilitado = await _auth.esAdministrador(usuario.uid);
    } catch (e) {
      _habilitado = false;
    }
    notifyListeners();
  }

  Future<void> ingresar(String email, String clave) => ejecutar(
    () => _auth.ingresar(email.trim(), clave),
    mensajeError: 'No se pudo ingresar. Revisá el correo y la contraseña.',
  );

  Future<void> salir() => _auth.salir();

  @override
  void dispose() {
    _suscripcionUsuario.cancel();
    super.dispose();
  }
}
