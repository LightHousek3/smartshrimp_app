import 'package:smartshrimp_app/features/pond/data/services/pond_api_service.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/domain/pond_rules.dart';
import 'package:smartshrimp_app/features/pond/domain/repositories/pond_repository.dart';

final class PondRepositoryImpl implements PondRepository {
  PondRepositoryImpl(this._remote);
  final PondRemoteDataSource _remote;

  @override
  Future<PondPage> getPonds({
    required String farmId,
    required int page,
    int limit = 20,
    String search = '',
    PondStatus? status,
    PondType? type,
  }) => _remote.getPonds(farmId, <String, dynamic>{
    'page': page,
    'limit': limit,
    'search': PondRules.normalizeName(search),
    if (status != null) 'status': _statusValue(status),
    if (type != null) 'type': _typeValue(type),
  });

  @override
  Future<Pond> getPond(String farmId, String pondId) =>
      _remote.getPond(farmId, pondId);

  @override
  Future<Pond> createPond({
    required String farmId,
    required String name,
    required double areaM2,
    required double depthM,
    required PondType type,
    required PondStatus status,
  }) => _remote.createPond(
    farmId,
    _writeData(name, areaM2, depthM, type, status),
  );

  @override
  Future<Pond> updatePond({
    required String farmId,
    required String pondId,
    required String name,
    required double areaM2,
    required double depthM,
    required PondType type,
    required PondStatus status,
  }) => _remote.updatePond(
    farmId,
    pondId,
    _writeData(name, areaM2, depthM, type, status),
  );

  static Map<String, dynamic> _writeData(
    String name,
    double areaM2,
    double depthM,
    PondType type,
    PondStatus status,
  ) => <String, dynamic>{
    'name': PondRules.normalizeName(name),
    'areaM2': areaM2,
    'depthM': depthM,
    'type': _typeValue(type),
    'status': _statusValue(status),
  };

  static String _typeValue(PondType type) => switch (type) {
    PondType.aquaculture => 'AQUACULTURE',
    PondType.waterTreatment => 'WATER_TREATMENT',
    PondType.unknown => throw ArgumentError.value(type, 'type'),
  };

  static String _statusValue(PondStatus status) => switch (status) {
    PondStatus.available => 'AVAILABLE',
    PondStatus.maintenance => 'MAINTENANCE',
    PondStatus.inactive => 'INACTIVE',
    PondStatus.unknown => throw ArgumentError.value(status, 'status'),
  };

  @override
  Future<Pond> deletePond(String farmId, String pondId) =>
      _remote.deletePond(farmId, pondId);
}
