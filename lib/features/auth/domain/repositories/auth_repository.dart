import 'package:smartshrimp_app/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser> login({required String email, required String password});

  Future<AuthUser?> restoreSession();

  Future<void> logout();
}
