enum AppUserRole {
  technician('TECHNICIAN'),
  farmOwner('FARM_OWNER'),
  expert('EXPERT'),
  admin('ADMIN'),
  unknown('UNKNOWN');

  const AppUserRole(this.apiValue);

  final String apiValue;

  static AppUserRole fromApi(String? value) {
    return AppUserRole.values.firstWhere(
      (role) => role.apiValue == value?.toUpperCase(),
      orElse: () => AppUserRole.unknown,
    );
  }
}

final class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    required this.status,
    this.phone,
    this.avatarUrl,
    this.managedByOwnerId,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final email = json['email'];
    final fullName = json['fullName'];
    final status = json['status'];
    if (id is! String ||
        email is! String ||
        fullName is! String ||
        status is! String) {
      throw const FormatException('Invalid user payload');
    }

    return AuthUser(
      id: id,
      email: email,
      fullName: fullName,
      role: AppUserRole.fromApi(json['role'] as String?),
      status: status,
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      managedByOwnerId: json['managedByOwnerId'] as String?,
    );
  }

  final String id;
  final String email;
  final String fullName;
  final AppUserRole role;
  final String status;
  final String? phone;
  final String? avatarUrl;
  final String? managedByOwnerId;

  bool get canUseMobileApp =>
      role == AppUserRole.technician || role == AppUserRole.farmOwner;
}
