import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_user.dart';

final class UserProfile {
  const UserProfile({
    required this.id,
    required this.email,
    required this.role,
    required this.status,
    this.fullName,
    this.phone,
    this.avatarUrl,
    this.managedByOwnerId,
    this.managedByOwner,
    this.technicianKpi,
    this.activatedAt,
    this.lastLoginAt,
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final email = json['email'];
    final role = json['role'];
    final status = json['status'];
    if (id is! String ||
        email is! String ||
        role is! String ||
        status is! String) {
      throw const InvalidResponseException();
    }

    return UserProfile(
      id: id,
      email: email,
      fullName: _nullableString(json['fullName']),
      phone: _nullableString(json['phone']),
      avatarUrl: _nullableString(json['avatarUrl']),
      role: AppUserRole.fromApi(role),
      status: status,
      managedByOwnerId: _nullableString(json['managedByOwnerId']),
      managedByOwner: ManagedOwner.fromNullableJson(json['managedByOwner']),
      technicianKpi: TechnicianKpi.fromNullableJson(json['technicianKpi']),
      activatedAt: _nullableDate(json['activatedAt']),
      lastLoginAt: _nullableDate(json['lastLoginAt']),
      createdAt: _nullableDate(json['createdAt']),
      updatedAt: _nullableDate(json['updatedAt']),
    );
  }

  final String id;
  final String email;
  final String? fullName;
  final String? phone;
  final String? avatarUrl;
  final AppUserRole role;
  final String status;
  final String? managedByOwnerId;
  final ManagedOwner? managedByOwner;
  final TechnicianKpi? technicianKpi;
  final DateTime? activatedAt;
  final DateTime? lastLoginAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get displayName {
    final name = fullName?.trim();
    return name == null || name.isEmpty ? email : name;
  }

  String get roleLabel => switch (role) {
    AppUserRole.technician => 'Kỹ thuật viên',
    AppUserRole.farmOwner => 'Chủ trang trại',
    AppUserRole.expert => 'Chuyên gia',
    AppUserRole.admin => 'Quản trị viên',
    AppUserRole.unknown => 'Tài khoản',
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

  UserProfile copyWith({String? fullName, String? phone, String? avatarUrl}) {
    return UserProfile(
      id: id,
      email: email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role,
      status: status,
      managedByOwnerId: managedByOwnerId,
      managedByOwner: managedByOwner,
      technicianKpi: technicianKpi,
      activatedAt: activatedAt,
      lastLoginAt: lastLoginAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static String? _nullableString(Object? value) {
    if (value == null) return null;
    if (value is! String) throw const InvalidResponseException();
    return value;
  }

  static DateTime? _nullableDate(Object? value) {
    if (value == null) return null;
    if (value is! String) throw const InvalidResponseException();
    final result = DateTime.tryParse(value);
    if (result == null) throw const InvalidResponseException();
    return result;
  }
}

final class ManagedOwner {
  const ManagedOwner({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
  });

  factory ManagedOwner.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final email = json['email'];
    if (id is! String || email is! String) {
      throw const InvalidResponseException();
    }
    return ManagedOwner(
      id: id,
      email: email,
      fullName: UserProfile._nullableString(json['fullName']),
      avatarUrl: UserProfile._nullableString(json['avatarUrl']),
    );
  }

  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;

  String get displayName {
    final name = fullName?.trim();
    return name == null || name.isEmpty ? email : name;
  }

  static ManagedOwner? fromNullableJson(Object? value) {
    if (value == null) return null;
    if (value is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    return ManagedOwner.fromJson(value);
  }
}

final class TechnicianKpi {
  const TechnicianKpi({
    required this.seasonsParticipated,
    required this.completedTasks,
    required this.onTimeCompletedTasks,
    required this.onTimeCompletionRatePct,
  });

  factory TechnicianKpi.fromJson(Map<String, dynamic> json) {
    final seasonsParticipated = json['seasonsParticipated'];
    final completedTasks = json['completedTasks'];
    final onTimeCompletedTasks = json['onTimeCompletedTasks'];
    final onTimeCompletionRatePct = json['onTimeCompletionRatePct'];
    if (seasonsParticipated is! int ||
        completedTasks is! int ||
        onTimeCompletedTasks is! int ||
        (onTimeCompletionRatePct != null && onTimeCompletionRatePct is! num)) {
      throw const InvalidResponseException();
    }
    return TechnicianKpi(
      seasonsParticipated: seasonsParticipated,
      completedTasks: completedTasks,
      onTimeCompletedTasks: onTimeCompletedTasks,
      onTimeCompletionRatePct: (onTimeCompletionRatePct as num?)?.toDouble(),
    );
  }

  final int seasonsParticipated;
  final int completedTasks;
  final int onTimeCompletedTasks;
  final double? onTimeCompletionRatePct;

  static TechnicianKpi? fromNullableJson(Object? value) {
    if (value == null) return null;
    if (value is! Map<String, dynamic>) {
      throw const InvalidResponseException();
    }
    return TechnicianKpi.fromJson(value);
  }
}
