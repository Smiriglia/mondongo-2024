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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBQmdEBrYbfcgrSQxvlsJ1sQJCYpl39Kqc',
    appId: '1:378810790089:web:fbc971a2520899a146dd18',
    messagingSenderId: '378810790089',
    projectId: 'pps-login-18305',
    authDomain: 'pps-login-18305.firebaseapp.com',
    storageBucket: 'pps-login-18305.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC6E92o6p_MDPn4gNQhXHv7A_RVtNazm0w',
    appId: '1:378810790089:android:eed3edb6bfe91f5646dd18',
    messagingSenderId: '378810790089',
    projectId: 'pps-login-18305',
    storageBucket: 'pps-login-18305.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA5xtByYS09oLKpUjqmOLrjzcmRbltw_U0',
    appId: '1:378810790089:ios:f814d3a4cdb9ec8d46dd18',
    messagingSenderId: '378810790089',
    projectId: 'pps-login-18305',
    storageBucket: 'pps-login-18305.firebasestorage.app',
    iosBundleId: 'com.example.mondongo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA5xtByYS09oLKpUjqmOLrjzcmRbltw_U0',
    appId: '1:378810790089:ios:f814d3a4cdb9ec8d46dd18',
    messagingSenderId: '378810790089',
    projectId: 'pps-login-18305',
    storageBucket: 'pps-login-18305.firebasestorage.app',
    iosBundleId: 'com.example.mondongo',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBQmdEBrYbfcgrSQxvlsJ1sQJCYpl39Kqc',
    appId: '1:378810790089:web:291d89f724f5085b46dd18',
    messagingSenderId: '378810790089',
    projectId: 'pps-login-18305',
    authDomain: 'pps-login-18305.firebaseapp.com',
    storageBucket: 'pps-login-18305.firebasestorage.app',
  );
}
