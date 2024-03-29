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
    apiKey: 'AIzaSyALlXwDeWvUO3nE5tsRGA-QyYMF52t0wEA',
    appId: '1:598622044476:web:63d7e702293026b0ac1e39',
    messagingSenderId: '598622044476',
    projectId: 'bitirme-proje-1',
    authDomain: 'bitirme-proje-1.firebaseapp.com',
    storageBucket: 'bitirme-proje-1.appspot.com',
    measurementId: 'G-5ZRBCGQ51J',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5k2drfSqYfLp09opMemfwG3fR1M1ZlGk',
    appId: '1:598622044476:android:64264c6b2a76b359ac1e39',
    messagingSenderId: '598622044476',
    projectId: 'bitirme-proje-1',
    storageBucket: 'bitirme-proje-1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBef_YV1Cz1J2-tcGhH23Uj7JsXW9iE4GA',
    appId: '1:598622044476:ios:49c92ee8d28a8889ac1e39',
    messagingSenderId: '598622044476',
    projectId: 'bitirme-proje-1',
    storageBucket: 'bitirme-proje-1.appspot.com',
    iosBundleId: 'com.example.flutterGoogleMapsEx',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBef_YV1Cz1J2-tcGhH23Uj7JsXW9iE4GA',
    appId: '1:598622044476:ios:111738ca57d18957ac1e39',
    messagingSenderId: '598622044476',
    projectId: 'bitirme-proje-1',
    storageBucket: 'bitirme-proje-1.appspot.com',
    iosBundleId: 'com.example.flutterGoogleMapsEx.RunnerTests',
  );
}
