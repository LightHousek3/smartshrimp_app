import 'dart:async';

import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm_location.dart';
import 'package:smartshrimp_app/features/farm/domain/farm_rules.dart';

abstract interface class FarmGeocodingService {
  Future<FarmLocation?> findByAddress(String address);

  Future<FarmLocation?> findByCoordinates({
    required double latitude,
    required double longitude,
  });
}

/// Small, policy-aware adapter for the public Nominatim service.
///
/// Nominatim forbids autocomplete and limits applications to one request per
/// second. Farm forms call this adapter only for explicit blur/current-location
/// actions; repeated lookups are served from the in-memory cache.
final class NominatimFarmGeocodingService implements FarmGeocodingService {
  NominatimFarmGeocodingService(this._dio);

  final Dio _dio;
  final Map<String, FarmLocation?> _cache = <String, FarmLocation?>{};
  Future<void> _requestQueue = Future<void>.value();
  DateTime? _lastRequestAt;

  @override
  Future<FarmLocation?> findByAddress(String address) {
    final normalized = FarmRules.normalizeText(address);
    if (normalized.isEmpty) return Future<FarmLocation?>.value();
    final cacheKey = 'search:${normalized.toLowerCase()}';
    return _cachedRequest(cacheKey, () async {
      final response = await _dio.get<List<dynamic>>(
        '/search',
        queryParameters: <String, Object>{
          'q': normalized,
          'format': 'jsonv2',
          'limit': 1,
          'countrycodes': 'vn',
          'addressdetails': 1,
        },
      );
      final results = response.data;
      if (results == null || results.isEmpty) return null;
      return _parseLocation(results.first);
    });
  }

  @override
  Future<FarmLocation?> findByCoordinates({
    required double latitude,
    required double longitude,
  }) {
    final cacheKey =
        'reverse:${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}';
    return _cachedRequest(cacheKey, () async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/reverse',
        queryParameters: <String, Object>{
          'lat': latitude,
          'lon': longitude,
          'format': 'jsonv2',
          'zoom': 16,
          'addressdetails': 1,
        },
      );
      final data = response.data;
      return data == null ? null : _parseLocation(data);
    });
  }

  Future<FarmLocation?> _cachedRequest(
    String key,
    Future<FarmLocation?> Function() request,
  ) async {
    if (_cache.containsKey(key)) return _cache[key];

    final previous = _requestQueue;
    final turn = Completer<void>();
    _requestQueue = turn.future;
    await previous;
    try {
      if (_cache.containsKey(key)) return _cache[key];
      final previousRequestAt = _lastRequestAt;
      if (previousRequestAt != null) {
        final remaining =
            const Duration(seconds: 1) -
            DateTime.now().difference(previousRequestAt);
        if (remaining.isNegative == false) {
          await Future<void>.delayed(remaining);
        }
      }
      _lastRequestAt = DateTime.now();
      final result = await request();
      _cache[key] = result;
      return result;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        throw const NetworkException(
          'Không thể tra cứu vị trí. Vui lòng kiểm tra mạng và thử lại.',
        );
      }
      throw ApiException(
        'Dịch vụ bản đồ đang bận. Vui lòng thử lại sau.',
        statusCode: error.response?.statusCode,
      );
    } finally {
      turn.complete();
    }
  }

  static FarmLocation? _parseLocation(Object? raw) {
    if (raw is! Map) return null;
    final latitude = double.tryParse('${raw['lat'] ?? ''}');
    final longitude = double.tryParse('${raw['lon'] ?? ''}');
    if (latitude == null ||
        longitude == null ||
        latitude < -90 ||
        latitude > 90 ||
        longitude < -180 ||
        longitude > 180) {
      return null;
    }
    final displayName = raw['display_name'];
    return FarmLocation(
      latitude: latitude,
      longitude: longitude,
      displayAddress: displayName is String && displayName.trim().isNotEmpty
          ? displayName.trim()
          : null,
    );
  }
}
