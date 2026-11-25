import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libreria/domain/services/auth_service.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuthService(this._auth, this._base);

  final FirebaseAuth _auth;
  final FirebaseFirestore _base;

  @override
  Stream<Usuario?> observarUsuario() => _auth.authStateChanges().map(
    (u) => u == null ? null : Usuario(uid: u.uid, email: u.email ?? ''),
  );

  @override
  Future<void> ingresar(String email, String clave) =>
      _auth.signInWithEmailAndPassword(email: email, password: clave);

  @override
  Future<void> salir() => _auth.signOut();

  @override
  Future<bool> esAdministrador(String uid) async =>
      (await _base.collection('admins').doc(uid).get()).exists;
}
