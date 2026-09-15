// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountProfile _$AccountProfileFromJson(
  Map<String, dynamic> json,
) => _AccountProfile(
  id: json['id'] as String,
  email: json['email'] as String,
  fullName: json['fullName'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  role: $enumDecode(
    _$AccountRoleEnumMap,
    json['role'],
    unknownValue: AccountRole.unknown,
  ),
  status: $enumDecode(
    _$AccountStatusEnumMap,
    json['status'],
    unknownValue: AccountStatus.unknown,
  ),
  managedByOwnerId: json['managedByOwnerId'] as String?,
  managedByOwner: json['managedByOwner'] == null
      ? null
      : ManagedOwner.fromJson(json['managedByOwner'] as Map<String, dynamic>),
  technicianKpi: json['technicianKpi'] == null
      ? null
      : TechnicianKpi.fromJson(json['technicianKpi'] as Map<String, dynamic>),
  activatedAt: json['activatedAt'] == null
      ? null
      : DateTime.parse(json['activatedAt'] as String),
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AccountProfileToJson(_AccountProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'avatarUrl': instance.avatarUrl,
      'role': _$AccountRoleEnumMap[instance.role]!,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'managedByOwnerId': instance.managedByOwnerId,
      'managedByOwner': instance.managedByOwner?.toJson(),
      'technicianKpi': instance.technicianKpi?.toJson(),
      'activatedAt': instance.activatedAt?.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$AccountRoleEnumMap = {
  AccountRole.technician: 'TECHNICIAN',
  AccountRole.farmOwner: 'FARM_OWNER',
  AccountRole.expert: 'EXPERT',
  AccountRole.admin: 'ADMIN',
  AccountRole.unknown: 'UNKNOWN',
};

const _$AccountStatusEnumMap = {
  AccountStatus.pendingActivation: 'PENDING_ACTIVATION',
  AccountStatus.active: 'ACTIVE',
  AccountStatus.inactive: 'INACTIVE',
  AccountStatus.blocked: 'BLOCKED',
  AccountStatus.unknown: 'UNKNOWN',
};

_ManagedOwner _$ManagedOwnerFromJson(Map<String, dynamic> json) =>
    _ManagedOwner(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );

Map<String, dynamic> _$ManagedOwnerToJson(_ManagedOwner instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'avatarUrl': instance.avatarUrl,
    };

_TechnicianKpi _$TechnicianKpiFromJson(Map<String, dynamic> json) =>
    _TechnicianKpi(
      seasonsParticipated: (json['seasonsParticipated'] as num).toInt(),
      completedTasks: (json['completedTasks'] as num).toInt(),
      onTimeCompletedTasks: (json['onTimeCompletedTasks'] as num).toInt(),
      onTimeCompletionRatePct: (json['onTimeCompletionRatePct'] as num?)
          ?.toDouble(),
    );

Map<String, dynamic> _$TechnicianKpiToJson(_TechnicianKpi instance) =>
    <String, dynamic>{
      'seasonsParticipated': instance.seasonsParticipated,
      'completedTasks': instance.completedTasks,
      'onTimeCompletedTasks': instance.onTimeCompletedTasks,
      'onTimeCompletionRatePct': instance.onTimeCompletionRatePct,
    };
