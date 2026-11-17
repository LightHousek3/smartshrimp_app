import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<bool>? _initialization;

/// Unsupported platforms keep the inbox available without invoking native FCM.
bool get supportsNativePush =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);

/// Native client configuration supplies public Firebase options; server keys never enter the App.
Future<bool> initializePushFirebase() => _initialization ??= _initialize()
    .timeout(const Duration(seconds: 15), onTimeout: () => false)
    .then((ready) {
      // A temporary native failure must not disable registration until the next process restart.
      if (!ready) _initialization = null;
      return ready;
    });

Future<bool> _initialize() async {
  if (!supportsNativePush) return false;
  try {
    if (Firebase.apps.isEmpty) await Firebase.initializeApp();
    return true;
  } on FirebaseException {
    return false;
  } on PlatformException {
    return false;
  } on MissingPluginException {
    return false;
  }
}
