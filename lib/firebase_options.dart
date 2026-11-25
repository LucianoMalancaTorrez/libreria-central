import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Identificadores públicos del proyecto Firebase. No son secretos: lo que
/// protege los datos son las reglas de `firestore.rules`.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return _web;
    if (defaultTargetPlatform == TargetPlatform.android) return _android;
    throw UnsupportedError('Firebase no está configurado para esta plataforma');
  }

  static const _web = FirebaseOptions(
    apiKey: 'AIzaSyB9XxZLZAWdSgkmtMJJAuOLI8FLl5FMHhk',
    appId: '1:249988708214:web:6882e015cdbdf60fa76c57',
    messagingSenderId: '249988708214',
    projectId: 'libreria-central-53b7c',
    authDomain: 'libreria-central-53b7c.firebaseapp.com',
    storageBucket: 'libreria-central-53b7c.firebasestorage.app',
  );

  static const _android = FirebaseOptions(
    apiKey: 'AIzaSyDFVkZMpjvtr5qig9pXv1mj3NQuelWzcgA',
    appId: '1:249988708214:android:617506363e25200aa76c57',
    messagingSenderId: '249988708214',
    projectId: 'libreria-central-53b7c',
    storageBucket: 'libreria-central-53b7c.firebasestorage.app',
  );
}
