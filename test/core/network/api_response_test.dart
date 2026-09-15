import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_response.dart';

void main() {
  group('ApiResponse', () {
    test('parses the backend success envelope with data and meta', () {
      final response = ApiResponse.parse(<String, dynamic>{
        'success': true,
        'message': 'Fetched successfully',
        'data': <String, dynamic>{'id': 'account-1'},
        'meta': <String, dynamic>{'totalResults': 1},
      });

      expect(response.message, 'Fetched successfully');
      expect(response.requireMapData()['id'], 'account-1');
      expect(response.meta?['totalResults'], 1);
    });

    test('accepts a success envelope without optional data', () {
      final response = ApiResponse.parse(<String, dynamic>{
        'success': true,
        'message': 'Logged out successfully',
      });

      expect(response.data, isNull);
    });

    test('rejects malformed or unsuccessful envelopes', () {
      expect(
        () => ApiResponse.parse(<String, dynamic>{
          'success': false,
          'message': 'Rejected',
        }),
        throwsA(isA<InvalidResponseException>()),
      );
      expect(
        () => ApiResponse.parse(<String, dynamic>{'success': true}),
        throwsA(isA<InvalidResponseException>()),
      );
    });

    test('rejects a mismatched required data shape', () {
      final response = ApiResponse.parse(<String, dynamic>{
        'success': true,
        'message': 'Fetched successfully',
        'data': <dynamic>[],
      });

      expect(response.requireMapData, throwsA(isA<InvalidResponseException>()));
    });
  });
}
