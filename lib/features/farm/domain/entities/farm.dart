import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'farm.freezed.dart';
part 'farm.g.dart';

enum PondType {
  @JsonValue('AQUACULTURE')
  aquaculture,
  @JsonValue('WATER_TREATMENT')
  waterTreatment,
  unknown,
}

enum PondStatus {
  @JsonValue('AVAILABLE')
  available,
  @JsonValue('MAINTENANCE')
  maintenance,
  @JsonValue('INACTIVE')
  inactive,
  unknown,
}

enum FarmSeasonStatus {
  @JsonValue('PLANNING')
  planning,
  @JsonValue('ACTIVE')
  active,
  unknown,
}

@freezed
abstract class FarmCurrentSeason with _$FarmCurrentSeason {
  const factory FarmCurrentSeason({
    required String id,
    @JsonKey(unknownEnumValue: FarmSeasonStatus.unknown)
    required FarmSeasonStatus status,
    DateTime? stockingDate,
    int? dayOfCulture,
  }) = _FarmCurrentSeason;

  factory FarmCurrentSeason.fromJson(Map<String, dynamic> json) =>
      _$FarmCurrentSeasonFromJson(json);
}

@freezed
abstract class FarmPond with _$FarmPond {
  const factory FarmPond({
    required String id,
    required String name,
    double? areaM2,
    double? depthM,
    double? volumeM3,
    @JsonKey(unknownEnumValue: PondType.unknown) required PondType type,
    @JsonKey(unknownEnumValue: PondStatus.unknown) required PondStatus status,
    FarmCurrentSeason? currentSeason,
  }) = _FarmPond;

  factory FarmPond.fromJson(Map<String, dynamic> json) =>
      _$FarmPondFromJson(json);
}

@freezed
abstract class Farm with _$Farm {
  const Farm._();

  const factory Farm({
    required String id,
    required String ownerId,
    required String name,
    String? address,
    double? latitude,
    double? longitude,
    double? totalAreaHectares,
    @Default(0) int pondCount,
    @Default(0) int activeSeasonCount,
    @Default(true) bool canArchive,
    @Default(<FarmPond>[]) List<FarmPond> ponds,
    DateTime? archivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Farm;

  factory Farm.fromJson(Map<String, dynamic> json) => _$FarmFromJson(json);

  static Farm parse(Map<String, dynamic> json) {
    try {
      return Farm.fromJson(json);
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  bool get isArchived => archivedAt != null;
}

@freezed
abstract class FarmPage with _$FarmPage {
  const FarmPage._();

  const factory FarmPage({
    required List<Farm> items,
    required int page,
    required int limit,
    required int totalResults,
    required int totalPages,
  }) = _FarmPage;

  bool get hasNextPage => page < totalPages;
}
