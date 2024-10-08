// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDQrU9siE47nAndmoEV1HdIWMKaKZ5j9e0',
    appId: '1:410572097735:web:d368e899644ccdc3fd16e2',
    messagingSenderId: '410572097735',
    projectId: 'neuroblast-dashboard',
    authDomain: 'neuroblast-dashboard.firebaseapp.com',
    storageBucket: 'neuroblast-dashboard.appspot.com',
    measurementId: 'G-L2DL0VM5T2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBsTu8g0wpAaP184l6ai_A5qTfRoMZw3n8',
    appId: '1:410572097735:android:d4a218d4e6928dfffd16e2',
    messagingSenderId: '410572097735',
    projectId: 'neuroblast-dashboard',
    storageBucket: 'neuroblast-dashboard.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBj2vFAFtblATJ0WWBKbLDmTc6jMcgujvo',
    appId: '1:410572097735:ios:05122382c57f7a8efd16e2',
    messagingSenderId: '410572097735',
    projectId: 'neuroblast-dashboard',
    storageBucket: 'neuroblast-dashboard.appspot.com',
    iosBundleId: 'com.example.neuroblastDashboard',
  );
}
