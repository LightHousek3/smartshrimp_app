import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartshrimp_app/features/auth/data/services/auth_api_service.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_user.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthApiService(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    sessionStore: ref.watch(sessionStoreProvider),
    deviceIdStore: ref.watch(deviceIdStoreProvider),
  );
});

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthUser?>(
  AuthController.new,
);

final class AuthController extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() {
    return ref.read(authRepositoryProvider).restoreSession();
  }

  Future<bool> login({required String email, required String password}) async {
    if (state.isLoading) return false;

    state = const AsyncLoading<AuthUser?>();
    state = await AsyncValue.guard<AuthUser?>(() {
      return ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
    });
    return state.hasValue && state.value != null;
  }

  Future<void> logout() async {
    state = const AsyncLoading<AuthUser?>();
    state = await AsyncValue.guard<AuthUser?>(() async {
      await ref.read(authRepositoryProvider).logout();
      return null;
    });
  }
}
