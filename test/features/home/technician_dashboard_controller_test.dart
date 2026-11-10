import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/domain/entities/technician_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/technician_dashboard_controller.dart';
import 'owner_dashboard_fixtures.dart';
import 'technician_dashboard_fixtures.dart';

void main() {
  test(
    'N/A: switching accounts refetches and logout cannot return the previous account cache',
    () async {
      final repository = TechnicianFixtureRepository();
      final auth = _SwitchableAuth();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          technicianDashboardRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authControllerProvider.future);
      await container.read(technicianDashboardProvider.future);
      auth.accountId = 'technician-b';
      await container
          .read(authControllerProvider.notifier)
          .login(email: 'b@example.test', password: 'unused');
      await container.read(technicianDashboardProvider.future);
      expect(repository.overviewCalls, 2);
      await container.read(authControllerProvider.notifier).logout();
      await expectLater(
        container.read(technicianDashboardProvider.future),
        throwsA(isA<SessionExpiredException>()),
      );
      expect(repository.overviewCalls, 2);
    },
  );
  test(
    'N: cache survives loss of listeners; profile updates do not reload; explicit invalidation does',
    () async {
      final repository = TechnicianFixtureRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            const DashboardFixtureAuth(role: AccountRole.technician),
          ),
          technicianDashboardRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authControllerProvider.future);
      final subscription = container.listen(
        technicianDashboardProvider,
        (_, _) {},
      );
      await container.read(technicianDashboardProvider.future);
      subscription.close();
      await container.pump();
      container
          .read(authControllerProvider.notifier)
          .updateAccountDetails(
            fullName: 'Tên mới',
            phone: null,
            avatarUrl: null,
          );
      await container.read(technicianDashboardProvider.future);
      expect(repository.overviewCalls, 1);
      container.invalidate(technicianDashboardProvider);
      await container.read(technicianDashboardProvider.future);
      expect(repository.overviewCalls, 2);
    },
  );

  test(
    'A: errors remain errors and do not trigger background retries or log out an active account',
    () async {
      final repository = _FailingRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            const DashboardFixtureAuth(role: AccountRole.technician),
          ),
          technicianDashboardRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authControllerProvider.future);
      await expectLater(
        container.read(technicianDashboardProvider.future),
        throwsA(isA<ApiException>()),
      );
      await container.pump();
      expect(repository.overviewCalls, 1);
      expect(
        container.read(authControllerProvider).value?.status,
        AccountStatus.active,
      );
    },
  );

  test('A: owner sessions never request the technician endpoint', () async {
    final repository = TechnicianFixtureRepository();
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(const DashboardFixtureAuth()),
        technicianDashboardRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authControllerProvider.future);
    await expectLater(
      container.read(technicianDashboardProvider.future),
      throwsA(isA<UnsupportedRoleException>()),
    );
    expect(repository.overviewCalls, 0);
  });
}

class _FailingRepository extends TechnicianFixtureRepository {
  @override
  Future<TechnicianDashboard> getOverview() async {
    overviewCalls++;
    throw const ApiException('Không thể kết nối.');
  }
}

class _SwitchableAuth extends DashboardFixtureAuth {
  _SwitchableAuth() : super(role: AccountRole.technician);
  String accountId = 'technician-a';
  @override
  Future<AuthAccount?> restoreSession() async => AuthAccount(
    id: accountId,
    email: 'test@example.test',
    role: AccountRole.technician,
    status: AccountStatus.active,
  );
  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => (await restoreSession())!;
}
