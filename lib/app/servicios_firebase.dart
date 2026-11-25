import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libreria/app/dependencias.dart';
import 'package:libreria/data/repositories/asset_libro_repository.dart';
import 'package:libreria/data/repositories/firestore_horarios_repository.dart';
import 'package:libreria/data/repositories/firestore_libro_repository.dart';
import 'package:libreria/data/services/firebase_auth_service.dart';

/// Arma los servicios conectados a la nube.
Servicios serviciosFirebase(FirebaseFirestore base, FirebaseAuth auth) {
  final respaldo = AssetLibroRepository();
  final libros = FirestoreLibroRepository(base, respaldo: respaldo);
  final horarios = FirestoreHorariosRepository(base);
  return Servicios(
    libros: libros,
    horarios: horarios,
    administracion: Administracion(
      auth: FirebaseAuthService(auth, base),
      catalogo: libros,
      horarios: horarios,
      catalogoDeEjemplo: respaldo,
    ),
  );
}
