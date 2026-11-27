import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/app.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // A failed widget may have no Material ancestors or inherited text style.
  ErrorWidget.builder = (_) => const Directionality(
    textDirection: TextDirection.ltr,
    child: ColoredBox(
      color: Colors.white,
      child: DefaultTextStyle(
        style: TextStyle(fontSize: 14, decoration: TextDecoration.none),
        child: AppErrorState(message: 'Không thể hiển thị nội dung này.'),
      ),
    ),
  );
  try {
    AppConfig.validate(
      requireHttps: kReleaseMode,
      requireMaptilesKey:
          !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS),
    );
  } on StateError catch (error, stack) {
    FlutterError.reportError(
      FlutterErrorDetails(exception: error, stack: stack),
    );
    runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: AppErrorState(
              message: 'Ứng dụng chưa được cấu hình để kết nối máy chủ.',
            ),
          ),
        ),
      ),
    );
    return;
  }
  // Optional push setup starts after authentication and cannot delay the first App frame.
  runApp(const ProviderScope(child: SmartShrimpApp()));
}
