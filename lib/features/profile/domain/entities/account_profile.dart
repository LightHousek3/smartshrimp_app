import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';

part 'account_profile.freezed.dart';
part 'account_profile.g.dart';

@freezed
abstract class AccountProfile with _$AccountProfile {
  const AccountProfile._();

  @JsonSerializable(explicitToJson: true)
  const factory AccountProfile({
    required String id,
    required String email,
    String? fullName,
    String? phone,
    String? avatarUrl,
    @JsonKey(unknownEnumValue: AccountRole.unknown) required AccountRole role,
    @JsonKey(unknownEnumValue: AccountStatus.unknown)
    required AccountStatus status,
    String? managedByOwnerId,
    ManagedOwner? managedByOwner,
    TechnicianKpi? technicianKpi,
    ExpertKpi? expertKpi,
    FarmOwnerKpi? farmOwnerKpi,
    DateTime? activatedAt,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AccountProfile;

  factory AccountProfile.fromJson(Map<String, dynamic> json) =>
      _$AccountProfileFromJson(json);

  static AccountProfile parse(Map<String, dynamic> json) {
    try {
      return AccountProfile.fromJson(json);
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  String get displayName {
    final name = fullName?.trim();
    return name == null || name.isEmpty ? email : name;
  }

  String get roleLabel => switch (role) {
    AccountRole.technician => 'Kỹ thuật viên',
    AccountRole.farmOwner => 'Chủ trang trại',
    AccountRole.expert => 'Chuyên gia',
    AccountRole.admin => 'Quản trị viên',
    AccountRole.unknown => 'Tài khoản',
  };

  String get initials {
    final words = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return 'S';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

@freezed
abstract class ManagedOwner with _$ManagedOwner {
  const ManagedOwner._();

  const factory ManagedOwner({
    required String id,
    required String email,
    String? fullName,
    String? avatarUrl,
  }) = _ManagedOwner;

  factory ManagedOwner.fromJson(Map<String, dynamic> json) =>
      _$ManagedOwnerFromJson(json);

  String get displayName {
    final name = fullName?.trim();
    return name == null || name.isEmpty ? email : name;
  }
}

@freezed
abstract class TechnicianKpi with _$TechnicianKpi {
  const factory TechnicianKpi({
    required int seasonsParticipated,
    required int completedTasks,
    required int onTimeCompletedTasks,
    double? onTimeCompletionRatePct,
  }) = _TechnicianKpi;

  factory TechnicianKpi.fromJson(Map<String, dynamic> json) =>
      _$TechnicianKpiFromJson(json);
}

@freezed
abstract class ExpertKpi with _$ExpertKpi {
  const factory ExpertKpi({
    required int seasonsParticipated,
    required int diseaseCasesHandled,
    required int diseaseCasesResolved,
    double? avgResolutionHours,
  }) = _ExpertKpi;

  factory ExpertKpi.fromJson(Map<String, dynamic> json) =>
      _$ExpertKpiFromJson(json);
}

@freezed
abstract class FarmOwnerKpi with _$FarmOwnerKpi {
  const factory FarmOwnerKpi({
    required int farmsOwned,
    required int pondsManaged,
    required int activeSeasons,
  }) = _FarmOwnerKpi;

  factory FarmOwnerKpi.fromJson(Map<String, dynamic> json) =>
      _$FarmOwnerKpiFromJson(json);
}
