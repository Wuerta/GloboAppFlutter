import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_fYT9GHXwoilM7rsCM3qqFm0zXmr3GYM',
    appId: '1:616124543553:android:dae36064e02b2e2de9ccc0',
    messagingSenderId: '616124543553',
    projectId: 'globoapp-3a2d8',
    storageBucket: 'globoapp-3a2d8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC3WSYyEs2iSSXXvxBhUo-OGoT2JF7mNeQ',
    appId: '1:616124543553:ios:e0f4d99fabbe2fd8e9ccc0',
    messagingSenderId: '616124543553',
    projectId: 'globoapp-3a2d8',
    storageBucket: 'globoapp-3a2d8.appspot.com',
    iosBundleId: 'com.example.globoapp',
  );
}
