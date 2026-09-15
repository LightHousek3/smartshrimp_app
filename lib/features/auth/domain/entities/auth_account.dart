import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'auth_account.freezed.dart';
part 'auth_account.g.dart';

enum AccountRole {
  @JsonValue('TECHNICIAN')
  technician,
  @JsonValue('FARM_OWNER')
  farmOwner,
  @JsonValue('EXPERT')
  expert,
  @JsonValue('ADMIN')
  admin,
  @JsonValue('UNKNOWN')
  unknown,
}

enum AccountStatus {
  @JsonValue('PENDING_ACTIVATION')
  pendingActivation,
  @JsonValue('ACTIVE')
  active,
  @JsonValue('INACTIVE')
  inactive,
  @JsonValue('BLOCKED')
  blocked,
  @JsonValue('UNKNOWN')
  unknown,
}

@freezed
abstract class AuthAccount with _$AuthAccount {
  const AuthAccount._();

  const factory AuthAccount({
    required String id,
    required String email,
    String? fullName,
    String? phone,
    String? avatarUrl,
    @JsonKey(unknownEnumValue: AccountRole.unknown) required AccountRole role,
    @JsonKey(unknownEnumValue: AccountStatus.unknown)
    required AccountStatus status,
    String? managedByOwnerId,
    DateTime? activatedAt,
    DateTime? lastLoginAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AuthAccount;

  factory AuthAccount.fromJson(Map<String, dynamic> json) =>
      _$AuthAccountFromJson(json);

  static AuthAccount parse(Map<String, dynamic> json) {
    try {
      return AuthAccount.fromJson(json);
    } on Object catch (_, stackTrace) {
      Error.throwWithStackTrace(const InvalidResponseException(), stackTrace);
    }
  }

  bool get canUseMobileApp =>
      role == AccountRole.technician || role == AccountRole.farmOwner;
}
