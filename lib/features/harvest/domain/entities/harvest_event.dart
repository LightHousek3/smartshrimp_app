import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'harvest_event.freezed.dart';
part 'harvest_event.g.dart';

enum HarvestType {
  @JsonValue('PARTIAL')
  partial,
  @JsonValue('FINAL')
  finalHarvest,
  unknown,
}

@freezed
abstract class HarvestPlace with _$HarvestPlace {
  const factory HarvestPlace({
    required String id,
    required String name,
    HarvestPlace? farm,
  }) = _HarvestPlace;
  factory HarvestPlace.fromJson(Map<String, dynamic> json) =>
      _$HarvestPlaceFromJson(json);
}

@freezed
abstract class HarvestSeason with _$HarvestSeason {
  const factory HarvestSeason({
    required String id,
    required String name,
    required String status,
    required HarvestPlace pond,
  }) = _HarvestSeason;
  factory HarvestSeason.fromJson(Map<String, dynamic> json) =>
      _$HarvestSeasonFromJson(json);
}

@Freezed(fromJson: true, toJson: true)
abstract class HarvestEvent with _$HarvestEvent {
  const factory HarvestEvent({
    required String id,
    required String seasonId,
    @JsonKey(unknownEnumValue: HarvestType.unknown)
    required HarvestType harvestType,
    required DateTime harvestedAt,
    required double totalWeightKg,
    required String recordedBy,
    required DateTime createdAt,
    required HarvestSeason season,
    String? quantityCount,
    double? avgSizePerKg,
    double? pricePerKg,
    double? totalRevenue,
    String? estimatedRemainingCount,
    String? buyerName,
    String? buyerContact,
    String? note,
    String? recorderName,
  }) = _HarvestEvent;

  factory HarvestEvent.fromJson(Map<String, dynamic> json) {
    try {
      final event = _$HarvestEventFromJson(json);
      // Invalid payloads must not turn into plausible production facts.
      if (event.id.isEmpty ||
          event.seasonId.isEmpty ||
          event.recordedBy.isEmpty ||
          event.season.id != event.seasonId ||
          !event.totalWeightKg.isFinite ||
          event.totalWeightKg <= 0 ||
          [
            event.avgSizePerKg,
            event.pricePerKg,
            event.totalRevenue,
          ].any((v) => v != null && (!v.isFinite || v < 0)) ||
          [
            event.quantityCount,
            event.estimatedRemainingCount,
          ].any((v) => v != null && !RegExp(r'^\d+$').hasMatch(v))) {
        throw const InvalidResponseException();
      }
      return event;
    } on InvalidResponseException {
      rethrow;
    } on Object catch (_, stack) {
      Error.throwWithStackTrace(const InvalidResponseException(), stack);
    }
  }
}

@freezed
abstract class HarvestPage with _$HarvestPage {
  const factory HarvestPage({
    required List<HarvestEvent> items,
    required int limit,
    required int totalResults,
    required bool hasNextPage,
    String? nextCursor,
    required double totalWeightKg,
    required double totalRevenue,
  }) = _HarvestPage;
}
