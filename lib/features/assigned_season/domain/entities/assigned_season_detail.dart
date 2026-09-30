import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';

final class AssignedSeasonPersonnel {
  const AssignedSeasonPersonnel({
    required this.role,
    required this.name,
    this.avatarUrl,
  });
  final String role, name;
  final String? avatarUrl;
}

final class OtherAssignedSeason {
  const OtherAssignedSeason({
    required this.id,
    required this.name,
    required this.status,
    required this.assignedAt,
    required this.pondId,
    required this.pondName,
    required this.pondStatus,
    this.pondAreaM2,
    this.pondVolumeM3,
  });
  final String id, name, status, pondId, pondName, pondStatus;
  final DateTime assignedAt;
  final double? pondAreaM2, pondVolumeM3;
}

final class AssignedSeasonDetail {
  const AssignedSeasonDetail({
    required this.id,
    required this.name,
    required this.status,
    required this.shrimpType,
    required this.pondId,
    required this.pondName,
    required this.pondType,
    required this.pondStatus,
    required this.farmId,
    required this.farmName,
    required this.personnel,
    required this.otherAssignedSeasons,
    required this.assignedAt,
    this.farmAddress,
    this.stockingDate,
    this.expectedEndDate,
    this.initialQuantity,
    this.initialAvgWeightG,
    this.initialBiomassKg,
    this.initialDensityPerM2,
    this.areaM2,
    this.depthM,
    this.volumeM3,
  });
  final String id,
      name,
      shrimpType,
      pondId,
      pondName,
      pondType,
      pondStatus,
      farmId,
      farmName;
  final AssignedSeasonStatus status;
  final String? farmAddress;
  final DateTime? stockingDate, expectedEndDate;
  final int? initialQuantity;
  final double? initialAvgWeightG,
      initialBiomassKg,
      initialDensityPerM2,
      areaM2,
      depthM,
      volumeM3;
  final List<AssignedSeasonPersonnel> personnel;
  final List<OtherAssignedSeason> otherAssignedSeasons;
  final DateTime assignedAt;

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
        initialAvgWeightG: _number(json['initialAvgWeightG']),
        initialBiomassKg: _number(json['initialBiomassKg']),
        initialDensityPerM2: _number(json['initialDensityPerM2']),
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
