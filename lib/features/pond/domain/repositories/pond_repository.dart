import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';

abstract interface class PondRepository {
  Future<PondPage> getPonds({
    required String farmId,
    required int page,
    int limit = 20,
    String search = '',
    PondStatus? status,
    PondType? type,
    bool archived = false,
  });

  Future<Pond> getPond(String farmId, String pondId);

  Future<Pond> createPond({
    required String farmId,
    required String name,
    required double areaM2,
    required double depthM,
    required PondType type,
    required PondStatus status,
  });

  Future<Pond> updatePond({
    required String farmId,
    required String pondId,
    required String name,
    required double areaM2,
    required double depthM,
    required PondType type,
    required PondStatus status,
  });

  Future<Pond> archivePond(String farmId, String pondId);
  Future<Pond> restorePond(String farmId, String pondId);
}
