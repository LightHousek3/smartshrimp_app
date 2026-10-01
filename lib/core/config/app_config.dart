abstract final class AppConfig {
  static const appName = 'SmartShrimp';

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  static const osmNominatimBaseUrl = String.fromEnvironment(
    'OSM_NOMINATIM_BASE_URL',
    defaultValue: 'https://nominatim.openstreetmap.org',
  );
  static const osmTileUrlTemplate = String.fromEnvironment(
    'OSM_TILE_URL_TEMPLATE',
    defaultValue: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  );
  static const osmUserAgent = String.fromEnvironment(
    'OSM_USER_AGENT',
    defaultValue: 'SmartShrimp/1.0 (Flutter farm management app)',
  );
  static const appPackageName = 'com.example.smartshrimp_app';

  static String? get socketBaseUrl {
    final uri = Uri.tryParse(apiBaseUrl);
    return uri != null && uri.hasScheme && uri.hasAuthority ? uri.origin : null;
  }

  static const cloudinaryCloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: '',
  );
  static const cloudinaryUploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
    defaultValue: '',
  );
  static const cloudinaryAvatarFolder = 'smartshrimp/avatars';

  static String get cloudinaryImageUploadUrl =>
      'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload';

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 20);
}
