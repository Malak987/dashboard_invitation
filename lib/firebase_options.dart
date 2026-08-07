// Firebase options — نفس مشروع موقع الدعوة الأساسي
// Project: sofamirna-2026
// تم النقل من https://github.com/Malak987/wedding_invitation/lib/firebase_options.dart
// لتشغيل flutterfire configure مستقبلاً: flutterfire configure --project=sofamirna-2026
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
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
        return linux;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCe2AKfu2IscejauuGiqUuV__5GlruZ_PQ',
    appId: '1:583646649398:web:f4161850590660edd48c97',
    messagingSenderId: '583646649398',
    projectId: 'sofamirna-2026',
    authDomain: 'sofamirna-2026.firebaseapp.com',
    storageBucket: 'sofamirna-2026.firebasestorage.app',
    measurementId: 'G-59H8F6MHHX',
  );

  static const FirebaseOptions android = web;
  static const FirebaseOptions ios = web;
  static const FirebaseOptions macos = web;
  static const FirebaseOptions windows = web;
  static const FirebaseOptions linux = web;
}
