import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'protocol.freezed.dart';
part 'protocol.g.dart';

enum ProtocolType {
  @JsonValue('PRODUCTION')
  production,
  @JsonValue('TREATMENT')
  treatment,
  @JsonValue('UNKNOWN')
  unknown,
}

enum ProtocolStatus {
  @JsonValue('DRAFT')
  draft,
  @JsonValue('PENDING_APPROVAL')
  pendingApproval,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
  @JsonValue('SUPERSEDED')
  superseded,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('ABORTED')
  aborted,
  @JsonValue('UNKNOWN')
  unknown,
}

enum ProtocolOperationStatus {
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('PLANNED')
  planned,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('PENDING_APPROVAL')
  pendingApproval,
  @JsonValue('NOT_GENERATED')
  notGenerated,
  @JsonValue('UNKNOWN')
  unknown,
}

@freezed
abstract class ProtocolCardData with _$ProtocolCardData {
  @JsonSerializable(checked: true)
  const factory ProtocolCardData({
    required String id,
    required String seasonId,
    @JsonKey(unknownEnumValue: ProtocolType.unknown)
    required ProtocolType protocolType,
    required String title,
    String? summary,
    required int versionNo,
    @JsonKey(unknownEnumValue: ProtocolStatus.unknown)
    required ProtocolStatus status,
    required String authorName,
    DateTime? submittedAt,
    String? diseaseCaseId,
    String? diseaseCaseTitle,
    required String seasonName,
    required String pondName,
    required String farmName,
  }) = _ProtocolCardData;
  factory ProtocolCardData.fromJson(Map<String, dynamic> json) =>
      _$ProtocolCardDataFromJson(json);

  static ProtocolCardData parse(Map<String, dynamic> json) => _parse(() {
    final value = ProtocolCardData.fromJson(json);
    _strings([
      value.id,
      value.seasonId,
      value.title,
      value.authorName,
      value.seasonName,
      value.pondName,
      value.farmName,
    ]);
    if (value.versionNo < 1) throw const InvalidResponseException();
    return value;
  });
}

@freezed
abstract class ProtocolHistory with _$ProtocolHistory {
  @JsonSerializable(checked: true)
  const factory ProtocolHistory({
    required String id,
    @JsonKey(unknownEnumValue: ProtocolStatus.unknown)
    ProtocolStatus? fromStatus,
    @JsonKey(unknownEnumValue: ProtocolStatus.unknown)
    required ProtocolStatus toStatus,
    required String changedByName,
    required DateTime changedAt,
    String? reason,
  }) = _ProtocolHistory;
  factory ProtocolHistory.fromJson(Map<String, dynamic> json) =>
      _$ProtocolHistoryFromJson(json);
}

@freezed
abstract class ProtocolDayMarker with _$ProtocolDayMarker {
  @JsonSerializable(checked: true)
  const factory ProtocolDayMarker({
    required int day,
    required int completed,
    required int planned,
    required int cancelled,
    @Default(0) int issues,
  }) = _ProtocolDayMarker;
  factory ProtocolDayMarker.fromJson(Map<String, dynamic> json) =>
      _$ProtocolDayMarkerFromJson(json);
}

@freezed
abstract class ProtocolDetail with _$ProtocolDetail {
  @JsonSerializable(checked: true)
  const factory ProtocolDetail({
    required ProtocolCardData card,
    required DateTime updatedAt,
    String? anchorDate,
    required int durationDays,
    DateTime? reviewedAt,
    String? reviewerName,
    String? rejectionReason,
    DateTime? supersededAt,
    required List<ProtocolDayMarker> dayMarkers,
    required List<ProtocolHistory> history,
    required bool canReview,
  }) = _ProtocolDetail;
  factory ProtocolDetail.fromJson(Map<String, dynamic> json) =>
      _$ProtocolDetailFromJson(json);

  static ProtocolDetail parse(Map<String, dynamic> json) => _parse(() {
    final card = ProtocolCardData.parse(json);
    final value = ProtocolDetail.fromJson({...json, 'card': json});
    if (value.durationDays < 0 ||
        value.dayMarkers.any(
          (m) =>
              m.day < 1 ||
              m.day > value.durationDays ||
              m.completed < 0 ||
              m.planned < 0 ||
              m.cancelled < 0 ||
              m.issues < 0,
        )) {
      throw const InvalidResponseException();
    }
    if (value.anchorDate case final date?) {
      final parsed = DateTime.tryParse(date);
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(date) ||
          parsed == null ||
          parsed.toIso8601String().substring(0, 10) != date) {
        throw const InvalidResponseException();
      }
    }
    return value.copyWith(
      card: card,
      canReview:
          value.canReview &&
          card.status == ProtocolStatus.pendingApproval &&
          card.protocolType != ProtocolType.unknown,
    );
  });
}

@freezed
abstract class ProtocolDayRow with _$ProtocolDayRow {
  @JsonSerializable(checked: true)
  const factory ProtocolDayRow({
    required String itemId,
    required String operationType,
    required String productName,
    String? time,
    required String doseBasis,
    required double doseValue,
    required String doseUnit,
    String? instructions,
    String? scheduleId,
    @JsonKey(unknownEnumValue: ProtocolOperationStatus.unknown)
    required ProtocolOperationStatus status,
    double? plannedQuantity,
    required String unit,
    double? basisQuantity,
    String? basisUnit,
    double? actualQuantity,
    String? actualProductName,
    String? actualUnit,
    String? varianceReason,
    String? executorName,
    DateTime? executedAt,
    String? cancellationReason,
    DateTime? cancelledAt,
  }) = _ProtocolDayRow;
  factory ProtocolDayRow.fromJson(Map<String, dynamic> json) =>
      _$ProtocolDayRowFromJson(json);
}

@freezed
abstract class ProtocolDay with _$ProtocolDay {
  @JsonSerializable(checked: true)
  const factory ProtocolDay({
    required int day,
    String? date,
    required List<ProtocolDayRow> rows,
  }) = _ProtocolDay;
  factory ProtocolDay.fromJson(Map<String, dynamic> json) =>
      _$ProtocolDayFromJson(json);

  static ProtocolDay parse(Map<String, dynamic> json) => _parse(() {
    final value = ProtocolDay.fromJson(json);
    if (value.day < 1) throw const InvalidResponseException();
    for (final row in value.rows) {
      _strings([
        row.itemId,
        row.productName,
        row.operationType,
        row.doseBasis,
        row.doseUnit,
        row.unit,
      ]);
      if (!row.doseValue.isFinite ||
          row.doseValue <= 0 ||
          [
            row.plannedQuantity,
            row.actualQuantity,
            row.basisQuantity,
          ].whereType<double>().any((n) => !n.isFinite || n < 0) ||
          row.time != null &&
              !RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').hasMatch(row.time!)) {
        throw const InvalidResponseException();
      }
    }
    return value;
  });
}

@freezed
abstract class ProtocolPage with _$ProtocolPage {
  const factory ProtocolPage({
    required List<ProtocolCardData> items,
    required int page,
    required bool hasNextPage,
    required int productionCount,
    required int treatmentCount,
  }) = _ProtocolPage;

  static ProtocolPage parse(List<Object?> data, Map<String, dynamic>? meta) =>
      _parse(() {
        if (meta == null ||
            meta['page'] is! int ||
            meta['hasNextPage'] is! bool ||
            meta['productionCount'] is! int ||
            meta['treatmentCount'] is! int ||
            (meta['page'] as int) < 1 ||
            (meta['productionCount'] as int) < 0 ||
            (meta['treatmentCount'] as int) < 0) {
          throw const InvalidResponseException();
        }
        return ProtocolPage(
          items: data
              .map((row) => ProtocolCardData.parse(row as Map<String, dynamic>))
              .toList(),
          page: meta['page'] as int,
          hasNextPage: meta['hasNextPage'] as bool,
          productionCount: meta['productionCount'] as int,
          treatmentCount: meta['treatmentCount'] as int,
        );
      });
}

@freezed
abstract class ProtocolInventoryEntry with _$ProtocolInventoryEntry {
  @JsonSerializable(checked: true)
  const factory ProtocolInventoryEntry({
    required String id,
    required String productName,
    required String lotNumber,
    required double quantity,
    required String unit,
    required String performedByName,
    required DateTime createdAt,
    String? reason,
  }) = _ProtocolInventoryEntry;
  factory ProtocolInventoryEntry.fromJson(Map<String, dynamic> json) =>
      _$ProtocolInventoryEntryFromJson(json);
  static ProtocolInventoryEntry parse(Map<String, dynamic> json) => _parse(() {
    final value = ProtocolInventoryEntry.fromJson(json);
    _strings([
      value.id,
      value.productName,
      value.lotNumber,
      value.unit,
      value.performedByName,
    ]);
    if (!value.quantity.isFinite || value.quantity <= 0) {
      throw const InvalidResponseException();
    }
    return value;
  });
}

T _parse<T>(T Function() parse) {
  try {
    return parse();
  }
  // Mapping errors belong to the API boundary and must not leak generator exceptions.
  on Object catch (_, stack) {
    Error.throwWithStackTrace(const InvalidResponseException(), stack);
  }
}

void _strings(List<String> values) {
  if (values.any((s) => s.trim().isEmpty)) {
    throw const InvalidResponseException();
  }
}
