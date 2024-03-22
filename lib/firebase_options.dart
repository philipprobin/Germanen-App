// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyDnSMg2hafMg8EW2Ioc4e-xFz6UNO05zqc',
    appId: '1:81895078809:web:bb451b985b9cf297d4f108',
    messagingSenderId: '81895078809',
    projectId: 'germanen-app',
    authDomain: 'germanen-app.firebaseapp.com',
    storageBucket: 'germanen-app.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDmCmyV-K0McRmytO051O9UVJiIe4gXr30',
    appId: '1:81895078809:android:8f1a2ba60b8dcfb5d4f108',
    messagingSenderId: '81895078809',
    projectId: 'germanen-app',
    storageBucket: 'germanen-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCeEi3dFZVO9gyBVdF3aKj5JKimpwtzGCM',
    appId: '1:81895078809:ios:e05bd91e04ec2e6fd4f108',
    messagingSenderId: '81895078809',
    projectId: 'germanen-app',
    storageBucket: 'germanen-app.appspot.com',
    androidClientId: '81895078809-1cesknpasihhd79i14h3il0r8bkgk2ef.apps.googleusercontent.com',
    iosClientId: '81895078809-s5aouk9qn0q22pidibrq3rae2cgnk44u.apps.googleusercontent.com',
    iosBundleId: 'com.example.germanenapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCeEi3dFZVO9gyBVdF3aKj5JKimpwtzGCM',
    appId: '1:81895078809:ios:8ef4d70da9abf1bad4f108',
    messagingSenderId: '81895078809',
    projectId: 'germanen-app',
    storageBucket: 'germanen-app.appspot.com',
    androidClientId: '81895078809-1cesknpasihhd79i14h3il0r8bkgk2ef.apps.googleusercontent.com',
    iosBundleId: 'com.example.germanenapp.RunnerTests',
  );
}