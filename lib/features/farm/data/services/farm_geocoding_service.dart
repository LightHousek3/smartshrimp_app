import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm_location.dart';
import 'package:smartshrimp_app/features/farm/domain/farm_rules.dart';

abstract interface class FarmGeocodingService {
  Future<FarmLocation?> findByAddress(String address);

  Future<FarmLocation?> findByCoordinates({
    required double latitude,
    required double longitude,
  });
}

/// The backend owns the Goong REST key and validates the provider response.
final class GoongFarmGeocodingService implements FarmGeocodingService {
  GoongFarmGeocodingService(this._client);

  final ApiClient _client;
  final Map<String, FarmLocation?> _cache = <String, FarmLocation?>{};
  static const _path = '/owner/farms/geocode';

  @override
  Future<FarmLocation?> findByAddress(String address) {
    final normalized = FarmRules.normalizeText(address);
    if (normalized.isEmpty) return Future<FarmLocation?>.value();
    return _lookup('address:${normalized.toLowerCase()}', <String, dynamic>{
      'address': normalized,
    });
  }

  @override
  Future<FarmLocation?> findByCoordinates({
    required double latitude,
    required double longitude,
  }) => _lookup(
    'coordinates:${latitude.toStringAsFixed(6)},${longitude.toStringAsFixed(6)}',
    <String, dynamic>{'latitude': latitude, 'longitude': longitude},
  );

  Future<FarmLocation?> _lookup(
    String cacheKey,
    Map<String, dynamic> query,
  ) async {
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey];
    final response = await _client.get(
      _path,
      queryParameters: query,
      authenticated: true,
    );
    final raw = response.requireMapData()['location'];
    if (raw == null) {
      _cache[cacheKey] = null;
      return null;
    }
    if (raw is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    final latitude = raw['latitude'];
    final longitude = raw['longitude'];
    final displayAddress = raw['displayAddress'];
    if (latitude is! num ||
        !latitude.isFinite ||
        latitude < -90 ||
        latitude > 90 ||
        longitude is! num ||
        !longitude.isFinite ||
        longitude < -180 ||
        longitude > 180 ||
        (displayAddress != null && displayAddress is! String)) {
      throw const InvalidResponseException();
    }
    final location = FarmLocation(
      latitude: latitude.toDouble(),
      longitude: longitude.toDouble(),
      displayAddress: displayAddress as String?,
    );
    _cache[cacheKey] = location;
    return location;
  }
}
