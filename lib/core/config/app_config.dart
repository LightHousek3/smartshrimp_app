abstract final class AppConfig {
  static const appName = 'SmartShrimp';

  /// Android Emulator uses 10.0.2.2 for the host machine. Override this for a
  /// physical device or deployed environment with --dart-define=API_BASE_URL=.
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://j6295vbc-3000.asse.devtunnels.ms/api/v1',
  );

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 20);
}
