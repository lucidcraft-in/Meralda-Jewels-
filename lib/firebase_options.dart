import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError('Platform not supported');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDqnUKlR6sTW8l2U4-eHihr5cC6eC9liv0',
    authDomain: 'meralda-gold-9ff64.firebaseapp.com',
    projectId: 'meralda-gold-9ff64',
    storageBucket: 'meralda-gold-9ff64.firebasestorage.app',
    messagingSenderId: '179645452293',
    appId: '1:179645452293:web:9a1fdab50eb88db2604c6c',
  );
}
