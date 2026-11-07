import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';

void main() {
  AppConfig.validate(
    requireHttps: kReleaseMode,
    requireMaptilesKey:
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS),
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: SmartShrimpApp()));
}
