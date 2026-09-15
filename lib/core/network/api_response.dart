import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'api_response.freezed.dart';

/// Parsed form of the response envelope produced by the SmartShrimp backend.
///
/// Success responses follow `{ success: true, message, data?, meta? }`.
@freezed
abstract class ApiResponse with _$ApiResponse {
  const ApiResponse._();

  const factory ApiResponse({
    required String message,
    Object? data,
    Map<String, dynamic>? meta,
  }) = _ApiResponse;

  static ApiResponse parse(Object? body) {
    if (body is! Map<String, dynamic> ||
        body['success'] != true ||
        body['message'] is! String ||
        (body['message']! as String).trim().isEmpty) {
      throw const InvalidResponseException();
    }

    final rawMeta = body['meta'];
    if (rawMeta != null && rawMeta is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }

    return ApiResponse(
      message: body['message']! as String,
      data: body['data'],
      meta: rawMeta as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> requireMapData() {
    final value = data;
    if (value is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    return value;
  }
}
