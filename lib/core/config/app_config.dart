abstract final class AppConfig {
  static const appName = 'SmartShrimp';

  static const logoUrl =
      'https://res.cloudinary.com/dmv1uhpq/image/upload/v1789054756/logo.png';

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

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
