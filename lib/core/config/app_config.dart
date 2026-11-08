abstract final class AppConfig {
  static const appName = 'SmartShrimp';

  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static const goongMaptilesKey = String.fromEnvironment('GOONG_MAPTILES_KEY');

  static String? get goongMapStyleUrl => goongMaptilesKey.isEmpty
      ? null
      : Uri.https(
          'tiles.goong.io',
          '/assets/goong_map_web.json',
          <String, String>{'api_key': goongMaptilesKey},
        ).toString();

  static String? get socketBaseUrl {
    final uri = Uri.tryParse(apiBaseUrl);
    return uri != null && uri.hasScheme && uri.hasAuthority ? uri.origin : null;
  }

  static const cloudinaryCloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
  );
  static const cloudinaryUploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
  );
  static const cloudinaryAvatarFolder = 'smartshrimp/avatars';
  static const cloudinaryInventoryFolder = 'smartshrimp/inventory';

  static String get cloudinaryImageUploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload';

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 20);
  // Five Cloudinary uploads and the AI call have separate server-side timeouts.
  static const aiDiagnosisTimeout = Duration(
    seconds: int.fromEnvironment('AI_DIAGNOSIS_TIMEOUT_SECONDS'),
  );

  /// Reject invalid build configuration before providers create network clients.
  static void validate({
    String apiBaseUrl = AppConfig.apiBaseUrl,
    String cloudinaryCloudName = AppConfig.cloudinaryCloudName,
    String cloudinaryUploadPreset = AppConfig.cloudinaryUploadPreset,
    String goongMaptilesKey = AppConfig.goongMaptilesKey,
    Duration aiDiagnosisTimeout = AppConfig.aiDiagnosisTimeout,
    bool requireHttps = false,
    bool requireMaptilesKey = false,
  }) {
    final invalid = <String>[];
    final apiUri = Uri.tryParse(apiBaseUrl);
    if (apiBaseUrl != apiBaseUrl.trim() ||
        apiUri == null ||
        !<String>{'http', 'https'}.contains(apiUri.scheme) ||
        apiUri.host.isEmpty ||
        apiUri.userInfo.isNotEmpty ||
        apiUri.hasQuery ||
        apiUri.hasFragment ||
        (requireHttps && apiUri.scheme != 'https')) {
      invalid.add('API_BASE_URL');
    }
    for (final entry in <String, String>{
      'CLOUDINARY_CLOUD_NAME': cloudinaryCloudName,
      'CLOUDINARY_UPLOAD_PRESET': cloudinaryUploadPreset,
      if (requireMaptilesKey) 'GOONG_MAPTILES_KEY': goongMaptilesKey,
    }.entries) {
      if (entry.value.trim().isEmpty || entry.value != entry.value.trim()) {
        invalid.add(entry.key);
      }
    }
    if (aiDiagnosisTimeout <= Duration.zero) {
      invalid.add('AI_DIAGNOSIS_TIMEOUT_SECONDS');
    }
    if (invalid.isNotEmpty) {
      // Report variable names only; configuration may contain credentials.
      throw StateError(
        'Missing or invalid app configuration: ${invalid.join(', ')}. '
        'Pass --dart-define-from-file=config/app.local.json '
        'or the configuration file for your deployment.',
      );
    }
  }
}
