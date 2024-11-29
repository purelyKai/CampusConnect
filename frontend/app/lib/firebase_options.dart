import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static FirebaseOptions web = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_OPTIONS_API_KEY_WEB_AND_WINDOWS']!,
    appId: dotenv.env['FIREBASE_OPTIONS_APP_ID_WEB']!,
    messagingSenderId:
        dotenv.env['FIREBASE_OPTIONS_MESSAGING_SENDER_ID_ALL_PLATFORMS']!,
    projectId: dotenv.env['FIREBASE_OPTIONS_PROJECT_ID_ALL_PLATFORMS']!,
    authDomain: dotenv.env['FIREBASE_OPTIONS_AUTH_DOMAIN_WEB_AND_WINDOWS']!,
    storageBucket: dotenv.env['FIREBASE_OPTIONS_STORAGE_BUCKET_ALL_PLATFORMS']!,
    measurementId: dotenv.env['FIREBASE_OPTIONS_MEASUREMENT_ID_WEB']!,
  );

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_OPTIONS_API_KEY_ANDROID']!,
    appId: dotenv.env['FIREBASE_OPTIONS_APP_ID_ANDROID']!,
    messagingSenderId:
        dotenv.env['FIREBASE_OPTIONS_MESSAGING_SENDER_ID_ALL_PLATFORMS']!,
    projectId: dotenv.env['FIREBASE_OPTIONS_PROJECT_ID_ALL_PLATFORMS']!,
    storageBucket: dotenv.env['FIREBASE_OPTIONS_STORAGE_BUCKET_ALL_PLATFORMS']!,
  );

  static FirebaseOptions ios = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_OPTIONS_API_KEY_IOS_AND_MACOS']!,
    appId: dotenv.env['FIREBASE_OPTIONS_APP_ID_IOS_AND_MACOS']!,
    messagingSenderId:
        dotenv.env['FIREBASE_OPTIONS_MESSAGING_SENDER_ID_ALL_PLATFORMS']!,
    projectId: dotenv.env['FIREBASE_OPTIONS_PROJECT_ID_ALL_PLATFORMS']!,
    storageBucket: dotenv.env['FIREBASE_OPTIONS_STORAGE_BUCKET_ALL_PLATFORMS']!,
    iosBundleId: dotenv.env['FIREBASE_OPTIONS_IOS_BUNDLE_ID_IOS_AND_MACOS']!,
  );

  static FirebaseOptions macos = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_OPTIONS_API_KEY_IOS_AND_MACOS']!,
    appId: dotenv.env['FIREBASE_OPTIONS_APP_ID_IOS_AND_MACOS']!,
    messagingSenderId:
        dotenv.env['FIREBASE_OPTIONS_MESSAGING_SENDER_ID_ALL_PLATFORMS']!,
    projectId: dotenv.env['FIREBASE_OPTIONS_PROJECT_ID_ALL_PLATFORMS']!,
    storageBucket: dotenv.env['FIREBASE_OPTIONS_STORAGE_BUCKET_ALL_PLATFORMS']!,
    iosBundleId: dotenv.env['FIREBASE_OPTIONS_IOS_BUNDLE_ID_IOS_AND_MACOS']!,
  );

  static FirebaseOptions windows = FirebaseOptions(
    apiKey: dotenv.env['FIREBASE_OPTIONS_API_KEY_WEB_AND_WINDOWS']!,
    appId: dotenv.env['FIREBASE_OPTIONS_API_KEY_WEB_AND_WINDOWS']!,
    messagingSenderId:
        dotenv.env['FIREBASE_OPTIONS_MESSAGING_SENDER_ID_ALL_PLATFORMS']!,
    projectId: dotenv.env['FIREBASE_OPTIONS_PROJECT_ID_ALL_PLATFORMS']!,
    authDomain: dotenv.env['FIREBASE_OPTIONS_AUTH_DOMAIN_WEB_AND_WINDOWS']!,
    storageBucket: dotenv.env['FIREBASE_OPTIONS_STORAGE_BUCKET_ALL_PLATFORMS']!,
    measurementId: dotenv.env['FIREBASE_OPTIONS_MEASUREMENT_ID_WINDOWS']!,
  );
}
