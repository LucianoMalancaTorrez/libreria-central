/// Ingreso de la administradora. Los clientes no tienen cuentas.
class Usuario {
  const Usuario({required this.uid, required this.email});

  final String uid;
  final String email;
}

abstract class AuthService {
  Stream<Usuario?> observarUsuario();
  Future<void> ingresar(String email, String clave);
  Future<void> salir();

  /// Solo es verdadero si el usuario fue habilitado desde la consola.
  Future<bool> esAdministrador(String uid);
}
