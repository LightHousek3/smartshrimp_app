import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';

abstract interface class FarmRepository {
  Future<List<Farm>> getFarms();

  Future<Farm> getFarm(String farmId);

  Future<Farm> createFarm({
    required String name,
    String? address,
    double? totalAreaHectares,
  });

  Future<Farm> updateFarm({
    required String farmId,
    required String name,
    String? address,
    double? totalAreaHectares,
  });

  Future<Farm> deleteFarm(String farmId);
}
