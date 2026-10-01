import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';

part 'assigned_season_detail.freezed.dart';

@freezed
abstract class AssignedSeasonPersonnel with _$AssignedSeasonPersonnel {
  const factory AssignedSeasonPersonnel({
    required String role,
    required String name,
    String? avatarUrl,
  }) = _AssignedSeasonPersonnel;
}

@freezed
abstract class OtherAssignedSeason with _$OtherAssignedSeason {
  const factory OtherAssignedSeason({
    required String id,
    required String name,
    required String status,
    required DateTime assignedAt,
    required String pondId,
    required String pondName,
    required String pondStatus,
    double? pondAreaM2,
    double? pondVolumeM3,
  }) = _OtherAssignedSeason;
}

@freezed
abstract class AssignedSeasonDetail with _$AssignedSeasonDetail {
  const AssignedSeasonDetail._();

  const factory AssignedSeasonDetail({
    required String id,
    required String name,
    required AssignedSeasonStatus status,
    required String shrimpType,
    required String pondId,
    required String pondName,
    required String pondType,
    required String pondStatus,
    required String farmId,
    required String farmName,
    required List<AssignedSeasonPersonnel> personnel,
    required List<OtherAssignedSeason> otherAssignedSeasons,
    required DateTime assignedAt,
    String? farmAddress,
    DateTime? stockingDate,
    DateTime? expectedEndDate,
    int? initialQuantity,
    double? initialDensityPerM2,
    double? currentBiomassKg,
    double? areaM2,
    double? depthM,
    double? volumeM3,
  }) = _AssignedSeasonDetail;

  int? get dayOfCulture =>
      stockingDate == null || status != AssignedSeasonStatus.active
      ? null
      : DateTime.now().difference(stockingDate!).inDays + 1;

  static AssignedSeasonDetail parse(Map<String, dynamic> json) {
    try {
      final pond = json['pond'] as Map<String, dynamic>;
      final farm = json['farm'] as Map<String, dynamic>;
      final assignment = json['assignment'] as Map<String, dynamic>;
      final status = switch (json['status']) {
        'PLANNING' => AssignedSeasonStatus.planning,
        'ACTIVE' => AssignedSeasonStatus.active,
        'COMPLETED' => AssignedSeasonStatus.completed,
        'CANCELLED' => AssignedSeasonStatus.cancelled,
        _ => throw const InvalidResponseException(),
      };
      return AssignedSeasonDetail(
        id: json['id'] as String,
        name: json['name'] as String,
        status: status,
        shrimpType: json['shrimpType'] as String,
        pondId: pond['id'] as String,
        pondName: pond['name'] as String,
        pondType: pond['type'] as String,
        pondStatus: pond['status'] as String,
        farmId: farm['id'] as String,
        farmName: farm['name'] as String,
        farmAddress: farm['address'] as String?,
        stockingDate: _date(json['stockingDate']),
        expectedEndDate: _date(json['expectedEndDate']),
        initialQuantity: (json['initialQuantity'] as num?)?.toInt(),
        initialDensityPerM2: _number(json['initialDensityPerM2']),
        currentBiomassKg: _number(json['currentBiomassKg']),
        areaM2: _number(pond['areaM2']),
        depthM: _number(pond['depthM']),
        volumeM3: _number(pond['volumeM3']),
        personnel: (json['personnel'] as List<dynamic>)
            .map((raw) {
              final item = raw as Map<String, dynamic>;
              final account = item['account'] as Map<String, dynamic>;
              return AssignedSeasonPersonnel(
                role: item['role'] as String,
                name: (account['fullName'] as String?) ?? 'Chưa cập nhật tên',
                avatarUrl: account['avatarUrl'] as String?,
              );
            })
            .toList(growable: false),
        otherAssignedSeasons: (json['otherAssignedSeasons'] as List<dynamic>)
            .map((raw) {
              final item = raw as Map<String, dynamic>;
              final otherPond = item['pond'] as Map<String, dynamic>;
              return OtherAssignedSeason(
                id: item['id'] as String,
                name: item['name'] as String,
                status: item['status'] as String,
                assignedAt: DateTime.parse(item['assignedAt'] as String),
                pondId: otherPond['id'] as String,
                pondName: otherPond['name'] as String,
                pondStatus: otherPond['status'] as String,
                pondAreaM2: _number(otherPond['areaM2']),
                pondVolumeM3: _number(otherPond['volumeM3']),
              );
            })
            .toList(growable: false),
        assignedAt: DateTime.parse(assignment['assignedAt'] as String),
      );
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }
}

double? _number(Object? value) => (value as num?)?.toDouble();
DateTime? _date(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;
