import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';

/// Owner pond operations. The backend independently verifies farm/pond ownership.
abstract interface class PondRepository {
  /// Server-filtered pagination, separate from the farm detail's embedded pond list.
  Future<PondPage> getPonds({
    required String farmId,
    required int page,
    int limit = 20,
    String search = '',
    PondStatus? status,
    PondType? type,
  });

  Future<Pond> getPond(String farmId, String pondId);

  /// Omitted volume lets the backend calculate capacity from area and depth.
  Future<Pond> createPond({
    required String farmId,
    required String name,
    required double areaM2,
    required double depthM,
    double? volumeM3,
    required PondType type,
    required PondStatus status,
  });

  /// Dimensions are immutable; omitted volume preserves its stored value.
  Future<Pond> updatePond({
    required String farmId,
    required String pondId,
    required String name,
    double? volumeM3,
    required PondType type,
    required PondStatus status,
  });

  /// Physically delete an unreferenced pond; history may prevent deletion.
  Future<Pond> deletePond(String farmId, String pondId);
}
