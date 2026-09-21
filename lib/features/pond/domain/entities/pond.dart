import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'pond.freezed.dart';
part 'pond.g.dart';

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

enum PondSeasonStatus {
  @JsonValue('PLANNING')
  planning,
  @JsonValue('ACTIVE')
  active,
  unknown,
}

@freezed
abstract class PondFarm with _$PondFarm {
  const factory PondFarm({
    required String id,
    required String name,
    DateTime? archivedAt,
  }) = _PondFarm;

  factory PondFarm.fromJson(Map<String, dynamic> json) =>
      _$PondFarmFromJson(json);
}

@freezed
abstract class PondCurrentSeason with _$PondCurrentSeason {
  const factory PondCurrentSeason({
    required String id,
    @JsonKey(unknownEnumValue: PondSeasonStatus.unknown)
    required PondSeasonStatus status,
    DateTime? stockingDate,
  }) = _PondCurrentSeason;

  factory PondCurrentSeason.fromJson(Map<String, dynamic> json) =>
      _$PondCurrentSeasonFromJson(json);
}

@freezed
abstract class Pond with _$Pond {
  const Pond._();

  const factory Pond({
    required String id,
    required String farmId,
    required String name,
    double? areaM2,
    double? depthM,
    double? volumeM3,
    @JsonKey(unknownEnumValue: PondType.unknown) required PondType type,
    @JsonKey(unknownEnumValue: PondStatus.unknown) required PondStatus status,
    DateTime? archivedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    PondFarm? farm,
    PondCurrentSeason? currentSeason,
  }) = _Pond;

  factory Pond.fromJson(Map<String, dynamic> json) => _$PondFromJson(json);

  static Pond parse(Map<String, dynamic> json) {
    try {
      return Pond.fromJson(json);
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  bool get isArchived => archivedAt != null;
  bool get hasOpenSeason => currentSeason != null;
}

@freezed
abstract class PondPage with _$PondPage {
  const PondPage._();

  const factory PondPage({
    required List<Pond> items,
    required int page,
    required int limit,
    required int totalResults,
    required int totalPages,
    required bool hasNextPage,
  }) = _PondPage;
}
