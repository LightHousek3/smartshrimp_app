// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'managed_personnel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ManagedPersonnel _$ManagedPersonnelFromJson(Map<String, dynamic> json) =>
    _ManagedPersonnel(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      fullName: json['fullName'] as String?,
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
      currentSeasonAssignments: (json['currentSeasonAssignments'] as num)
          .toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      activatedAt: json['activatedAt'] == null
          ? null
          : DateTime.parse(json['activatedAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ManagedPersonnelToJson(_ManagedPersonnel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'fullName': instance.fullName,
      'avatarUrl': instance.avatarUrl,
      'role': _$AccountRoleEnumMap[instance.role]!,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'currentSeasonAssignments': instance.currentSeasonAssignments,
      'createdAt': instance.createdAt.toIso8601String(),
      'activatedAt': instance.activatedAt?.toIso8601String(),
      'lastLoginAt': instance.lastLoginAt?.toIso8601String(),
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
