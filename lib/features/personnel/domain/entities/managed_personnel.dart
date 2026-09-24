import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';

part 'managed_personnel.freezed.dart';
part 'managed_personnel.g.dart';

@freezed
abstract class ManagedPersonnel with _$ManagedPersonnel {
  const ManagedPersonnel._();

  const factory ManagedPersonnel({
    required String id,
    required String email,
    String? phone,
    String? fullName,
    String? avatarUrl,
    @JsonKey(unknownEnumValue: AccountRole.unknown) required AccountRole role,
    @JsonKey(unknownEnumValue: AccountStatus.unknown)
    required AccountStatus status,
    required int currentSeasonAssignments,
    required DateTime createdAt,
    DateTime? activatedAt,
    DateTime? lastLoginAt,
    DateTime? updatedAt,
  }) = _ManagedPersonnel;

  factory ManagedPersonnel.fromJson(Map<String, dynamic> json) =>
      _$ManagedPersonnelFromJson(json);

  static ManagedPersonnel parse(
    Map<String, dynamic> json, {
    bool detail = false,
  }) {
    if (json['id'] is! String ||
        (json['id'] as String).trim().isEmpty ||
        json['email'] is! String ||
        (json['email'] as String).trim().isEmpty ||
        json['role'] is! String ||
        json['status'] is! String ||
        json['createdAt'] is! String ||
        json['currentSeasonAssignments'] is! int ||
        (json['currentSeasonAssignments'] as int) < 0 ||
        (detail && json['updatedAt'] is! String)) {
      throw const InvalidResponseException();
    }

    try {
      return ManagedPersonnel.fromJson(json);
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  String get displayName {
    final name = fullName?.trim();
    return name == null || name.isEmpty ? email : name;
  }

  String get initials {
    final parts = displayName
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);
    if (parts.isEmpty) return 'NV';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}

@freezed
abstract class ManagedPersonnelPage with _$ManagedPersonnelPage {
  const factory ManagedPersonnelPage({
    required List<ManagedPersonnel> items,
    required int limit,
    required int totalResults,
    required bool hasNextPage,
    String? nextCursor,
  }) = _ManagedPersonnelPage;

  static ManagedPersonnelPage parse(Object? data, Map<String, dynamic>? meta) {
    if (data is! List ||
        meta == null ||
        meta['limit'] is! int ||
        (meta['limit'] as int) < 1 ||
        (meta['limit'] as int) > 100 ||
        meta['totalResults'] is! int ||
        (meta['totalResults'] as int) < 0 ||
        meta['hasNextPage'] is! bool ||
        (meta['nextCursor'] != null && meta['nextCursor'] is! String) ||
        (meta['hasNextPage'] == true &&
            (meta['nextCursor'] is! String ||
                (meta['nextCursor'] as String).isEmpty))) {
      throw const InvalidResponseException();
    }

    final items = data
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const InvalidResponseException();
          }
          return ManagedPersonnel.parse(item);
        })
        .toList(growable: false);
    if (meta['hasNextPage'] == true && items.isEmpty) {
      throw const InvalidResponseException();
    }

    return ManagedPersonnelPage(
      items: items,
      limit: meta['limit'] as int,
      totalResults: meta['totalResults'] as int,
      hasNextPage: meta['hasNextPage'] as bool,
      nextCursor: meta['nextCursor'] as String?,
    );
  }
}
