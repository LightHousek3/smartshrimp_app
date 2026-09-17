import 'package:smartshrimp_app/features/farm/data/services/farm_api_service.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/domain/farm_rules.dart';
import 'package:smartshrimp_app/features/farm/domain/repositories/farm_repository.dart';

final class FarmRepositoryImpl implements FarmRepository {
  FarmRepositoryImpl(this._remoteDataSource);

  final FarmRemoteDataSource _remoteDataSource;

  @override
  Future<List<Farm>> getFarms() => _remoteDataSource.getFarms();

  @override
  Future<Farm> getFarm(String farmId) => _remoteDataSource.getFarm(farmId);

  @override
  Future<Farm> createFarm({
    required String name,
    String? address,
    double? totalAreaHectares,
  }) => _remoteDataSource.createFarm(
    _writeData(name: name, address: address, area: totalAreaHectares),
  );

  @override
  Future<Farm> updateFarm({
    required String farmId,
    required String name,
    String? address,
    double? totalAreaHectares,
  }) => _remoteDataSource.updateFarm(
    farmId,
    _writeData(name: name, address: address, area: totalAreaHectares),
  );

  @override
  Future<Farm> archiveFarm(String farmId) =>
      _remoteDataSource.archiveFarm(farmId);

  @override
  Future<Farm> restoreFarm(String farmId) =>
      _remoteDataSource.restoreFarm(farmId);

  static Map<String, dynamic> _writeData({
    required String name,
    required String? address,
    required double? area,
  }) {
    final normalizedAddress = FarmRules.normalizeText(address ?? '');
    return <String, dynamic>{
      'name': FarmRules.normalizeText(name),
      'address': normalizedAddress.isEmpty ? null : normalizedAddress,
      'totalAreaHectares': area,
    };
  }
}
