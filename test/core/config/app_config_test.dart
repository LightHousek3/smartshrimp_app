import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';

void main() {
  test('accepts a complete mobile release configuration', () {
    expect(
      () => _validate(requireHttps: true, requireMaptilesKey: true),
      returnsNormally,
    );
  });

  for (final url in <String>[
    '',
    '/api/v1',
    'ftp://api.example.com/api/v1',
    'https://user:password@api.example.com/api/v1',
    'https://api.example.com/api/v1?token=secret',
    'https://api.example.com/api/v1#fragment',
    ' https://api.example.com/api/v1',
    'https://',
  ]) {
    test('rejects an invalid API base URL: $url', () {
      expect(
        () => _validate(apiBaseUrl: url),
        _invalidVariable('API_BASE_URL'),
      );
    });
  }

  test('allows HTTP for local development and rejects it for release', () {
    const url = 'http://localhost:3000/api/v1';
    expect(() => _validate(apiBaseUrl: url), returnsNormally);
    expect(
      () => _validate(apiBaseUrl: url, requireHttps: true),
      _invalidVariable('API_BASE_URL'),
    );
  });

  test('requires Cloudinary values without surrounding whitespace', () {
    for (final value in <String>['', ' ', ' cloud ']) {
      expect(
        () => _validate(cloudinaryCloudName: value),
        _invalidVariable('CLOUDINARY_CLOUD_NAME'),
      );
      expect(
        () => _validate(cloudinaryUploadPreset: value),
        _invalidVariable('CLOUDINARY_UPLOAD_PRESET'),
      );
    }
  });

  test('requires the map key only for supported map platforms', () {
    expect(() => _validate(goongMaptilesKey: ''), returnsNormally);
    expect(
      () => _validate(goongMaptilesKey: '', requireMaptilesKey: true),
      _invalidVariable('GOONG_MAPTILES_KEY'),
    );
  });

  test('rejects nonpositive diagnosis timeouts', () {
    for (final seconds in <int>[0, -1]) {
      expect(
        () => _validate(aiDiagnosisTimeout: Duration(seconds: seconds)),
        _invalidVariable('AI_DIAGNOSIS_TIMEOUT_SECONDS'),
      );
    }
    expect(
      () => _validate(aiDiagnosisTimeout: const Duration(seconds: 1)),
      returnsNormally,
    );
  });

  test('configuration errors expose variable names without their values', () {
    try {
      _validate(
        apiBaseUrl: 'https://user:private-password@api.example.com',
        goongMaptilesKey: ' private-map-key ',
        requireMaptilesKey: true,
      );
      fail('Expected invalid configuration to be rejected.');
    } on StateError catch (error) {
      expect(error.message, contains('API_BASE_URL'));
      expect(error.message, contains('GOONG_MAPTILES_KEY'));
      expect(error.message, isNot(contains('private-password')));
      expect(error.message, isNot(contains('private-map-key')));
    }
  });
}

Matcher _invalidVariable(String name) => throwsA(
  isA<StateError>().having((error) => error.message, 'message', contains(name)),
);

void _validate({
  String apiBaseUrl = 'https://api.example.com/api/v1',
  String cloudinaryCloudName = 'test-cloud',
  String cloudinaryUploadPreset = 'test-preset',
  String goongMaptilesKey = 'test-map-key',
  Duration aiDiagnosisTimeout = const Duration(seconds: 300),
  bool requireHttps = false,
  bool requireMaptilesKey = false,
}) => AppConfig.validate(
  apiBaseUrl: apiBaseUrl,
  cloudinaryCloudName: cloudinaryCloudName,
  cloudinaryUploadPreset: cloudinaryUploadPreset,
  goongMaptilesKey: goongMaptilesKey,
  aiDiagnosisTimeout: aiDiagnosisTimeout,
  requireHttps: requireHttps,
  requireMaptilesKey: requireMaptilesKey,
);
