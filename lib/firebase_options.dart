
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;


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
    apiKey: 'AIzaSyC10yDCVLitX5FNASLPabXcJs9JdKyGW1o',
    appId: '1:803137882974:web:f67a089c14feb795095dcf',
    messagingSenderId: '803137882974',
    projectId: 'artooms',
    authDomain: 'artooms.firebaseapp.com',
    storageBucket: 'artooms.appspot.com',
    measurementId: 'G-02ZM8Q3MZ3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyChbeX0W4ZLmOeM4ejiNrD9tQ7CjRRJGkY',
    appId: '1:803137882974:android:3dea9b7e2022784f095dcf',
    messagingSenderId: '803137882974',
    projectId: 'artooms',
    storageBucket: 'artooms.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBio1kqPieJ404D1SPOsHQfNtH42rbzZOk',
    appId: '1:803137882974:ios:a78719f0e79ba082095dcf',
    messagingSenderId: '803137882974',
    projectId: 'artooms',
    storageBucket: 'artooms.appspot.com',
    iosBundleId: 'com.artrooms',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBio1kqPieJ404D1SPOsHQfNtH42rbzZOk',
    appId: '1:803137882974:ios:1dafa11a27775a73095dcf',
    messagingSenderId: '803137882974',
    projectId: 'artooms',
    storageBucket: 'artooms.appspot.com',
    iosBundleId: 'com.artrooms.RunnerTests',
  );

}
