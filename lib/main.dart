import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:libreria/app/app.dart';
import 'package:libreria/app/servicios_firebase.dart';
import 'package:libreria/data/services/push_firebase.dart';
import 'package:libreria/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Guarda una copia local para que el catálogo se vea sin conexión.
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
    );
    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(alRecibirEnSegundoPlano);
    }
    runApp(
      LibreriaApp(
        servicios: serviciosFirebase(
          FirebaseFirestore.instance,
          FirebaseAuth.instance,
        ),
      ),
    );
  } catch (e) {
    // Sin Firebase la app sigue funcionando con los datos incluidos.
    debugPrint('Firebase no disponible: $e');
    runApp(const LibreriaApp());
  }
}
