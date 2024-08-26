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
    apiKey: 'AIzaSyAd-iOZj8gyU50j2EUSHLEr9vhzwM1kIcc',
    appId: '1:13589558508:web:64b9fb45bdb410edfee1c9',
    messagingSenderId: '13589558508',
    projectId: 'deafspace-21d65',
    authDomain: 'deafspace-21d65.firebaseapp.com',
    storageBucket: 'deafspace-21d65.appspot.com',
    measurementId: 'G-7YHHCMWNDF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB97cJ_CnHohUZNSbH7yY1oSn4lzRoBCfM',
    appId: '1:13589558508:android:ebb6a02dc1da83c8fee1c9',
    messagingSenderId: '13589558508',
    projectId: 'deafspace-21d65',
    storageBucket: 'deafspace-21d65.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBWJ6-pXlmphU_LqhQoSD6dXT2kVee18ZU',
    appId: '1:179966136343:ios:2f36e375879efd3fb9cc52',
    messagingSenderId: '179966136343',
    projectId: 'firebase-auth-007',
    storageBucket: 'firebase-auth-007.appspot.com',
    iosBundleId: 'com.example.authFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBWJ6-pXlmphU_LqhQoSD6dXT2kVee18ZU',
    appId: '1:179966136343:ios:2f36e375879efd3fb9cc52',
    messagingSenderId: '179966136343',
    projectId: 'firebase-auth-007',
    storageBucket: 'firebase-auth-007.appspot.com',
    iosBundleId: 'com.example.authFirebase',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAd-iOZj8gyU50j2EUSHLEr9vhzwM1kIcc',
    appId: '1:13589558508:web:df90018a1ce48da3fee1c9',
    messagingSenderId: '13589558508',
    projectId: 'deafspace-21d65',
    authDomain: 'deafspace-21d65.firebaseapp.com',
    storageBucket: 'deafspace-21d65.appspot.com',
    measurementId: 'G-N6XE01Y6BZ',
  );

}