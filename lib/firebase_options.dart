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
    apiKey: 'AIzaSyBo8bGS1dVcnNLRnApzvpktBnsAMh3G-Y4',
    appId: '1:567083599771:web:b00b0e68fc16994dd9433e',
    messagingSenderId: '567083599771',
    projectId: 'whatsapp-50f9f',
    authDomain: 'whatsapp-50f9f.firebaseapp.com',
    storageBucket: 'whatsapp-50f9f.appspot.com',
    measurementId: 'G-QPG183FE7E',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBB8SHpmucbC1Wgm1y3npAeykKT840Ei8A',
    appId: '1:567083599771:android:bc5a914bf7f7979ed9433e',
    messagingSenderId: '567083599771',
    projectId: 'whatsapp-50f9f',
    storageBucket: 'whatsapp-50f9f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA3OBkUwMb7kBWJr6qh8XEPhdENcgC0N7Q',
    appId: '1:567083599771:ios:dffdc9f5116c1fded9433e',
    messagingSenderId: '567083599771',
    projectId: 'whatsapp-50f9f',
    storageBucket: 'whatsapp-50f9f.appspot.com',
    androidClientId: '567083599771-gjgk0bs3rh9rqrmnpk14pqicmq7po313.apps.googleusercontent.com',
    iosClientId: '567083599771-vkh4vu10kctr26l3ql8mvmklmg4db4pq.apps.googleusercontent.com',
    iosBundleId: 'com.example.ChatHUb',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA3OBkUwMb7kBWJr6qh8XEPhdENcgC0N7Q',
    appId: '1:567083599771:ios:d59ce820fcdbaf95d9433e',
    messagingSenderId: '567083599771',
    projectId: 'whatsapp-50f9f',
    storageBucket: 'whatsapp-50f9f.appspot.com',
    androidClientId: '567083599771-gjgk0bs3rh9rqrmnpk14pqicmq7po313.apps.googleusercontent.com',
    iosClientId: '567083599771-p2qj0i48n99jn8vgqs00utms68jv7hug.apps.googleusercontent.com',
    iosBundleId: 'com.example.ChatHUb.RunnerTests',
  );
}
