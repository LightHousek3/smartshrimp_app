import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';

abstract interface class AuthRepository {
  Future<AuthAccount> login({required String email, required String password});

  Future<AuthAccount?> restoreSession();

  Future<void> logout();
}
