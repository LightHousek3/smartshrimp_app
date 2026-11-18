import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/notifications/data/services/notification_socket.dart';
import '../task/task_api_test.dart' show TaskSessionStore;
import 'owner_dashboard_fixtures.dart';

void main() {
  late ProviderContainer container;
  late _CountingRepository repository;
  late _SwitchableAuth auth;
  setUp(() async {
    repository = _CountingRepository();
    auth = _SwitchableAuth();
    container = ProviderContainer(
      overrides: [
        notificationSocketProvider.overrideWith((ref) => null),
        authRepositoryProvider.overrideWithValue(auth),
        ownerDashboardRepositoryProvider.overrideWithValue(repository),
      ],
    );
    await container.read(authControllerProvider.future);
  });
  tearDown(() => container.dispose());

  test(
    'N: case events refresh overview once, preserve finance cache and ignore notification reads',
    () async {
      final transport = io.io(
        'http://localhost:1',
        io.OptionBuilder().disableAutoConnect().enableForceNew().build(),
      );
      final dio = Dio();
      final socket = NotificationSocket(
        serverUrl: 'http://localhost:1',
        apiClient: ApiClient(dio, TaskSessionStore()),
        onChanged: () {},
        onSessionExpired: () {},
        socket: transport,
      );
      addTearDown(() {
        socket.dispose();
        dio.close();
      });
      final live = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          ownerDashboardRepositoryProvider.overrideWithValue(repository),
          notificationSocketProvider.overrideWithValue(socket),
        ],
      );
      addTearDown(live.dispose);
      await live.read(authControllerProvider.future);
      await live.read(ownerDashboardProvider.future);
      await live.read(ownerFinanceProvider.future);
      for (var update = 0; update < 2; update++) {
        transport.emitEvent([
          'notification:new',
          {'referenceType': 'disease_case', 'referenceId': 'case-1'},
        ]);
        await Future<void>.delayed(Duration.zero);
        await live.pump();
        await live.read(ownerDashboardProvider.future);
        expect(repository.overviewCalls, update + 2);
        expect(repository.calls.length, 1);
      }
      transport.emitEvent([
        'notification:read',
        {'id': 'read'},
      ]);
      await Future<void>.delayed(Duration.zero);
      await live.pump();
      expect(repository.overviewCalls, 3);
      expect(repository.calls.length, 1);
      transport.emitEvent([
        'notification:new',
        {
          'referenceType': 'aquaculture_season',
          'type': 'TREATMENT_SCHEDULE_READY',
          'referenceId': 'season-1',
        },
      ]);
      await Future<void>.delayed(Duration.zero);
      await live.pump();
      await live.read(ownerDashboardProvider.future);
      expect(repository.overviewCalls, 4);
      transport.emitReserved('connect');
      await Future<void>.delayed(Duration.zero);
      await live.pump();
      expect(
        repository.overviewCalls,
        4,
        reason:
            'Initial connect must not duplicate the first dashboard request',
      );
      transport.emitReserved('connect');
      await Future<void>.delayed(Duration.zero);
      await live.pump();
      await live.read(ownerDashboardProvider.future);
      expect(repository.overviewCalls, 5);
      expect(repository.calls.length, 1);
    },
  );

  test(
    'N: removing all listeners and reopening retains responses without more requests',
    () async {
      final overview = container.listen(ownerDashboardProvider, (_, _) {});
      final finance = container.listen(ownerFinanceProvider, (_, _) {});
      await container.read(ownerDashboardProvider.future);
      await container.read(ownerFinanceProvider.future);
      overview.close();
      finance.close();
      await container.pump();
      await container.read(ownerDashboardProvider.future);
      await container.read(ownerFinanceProvider.future);
      expect(repository.overviewCalls, 1);
      expect(repository.calls, [const FinanceFilter()]);
    },
  );

  test(
    'N: changed filters fetch once; selecting the same filter does not fetch again',
    () async {
      await container.read(ownerDashboardProvider.future);
      await container.read(ownerFinanceProvider.future);
      final filters = container.read(financeFilterProvider.notifier);
      filters.selectFarm('farm2');
      await container.read(ownerFinanceProvider.future);
      filters.selectFarm('farm2');
      await container.pump();
      await container.read(ownerFinanceProvider.future);
      expect(repository.calls.length, 2);
      filters.selectPeriod(FinancePeriod.custom, DateTime(2026, 10, 15));
      await container.read(ownerFinanceProvider.future);
      filters.selectDates(DateTime(2026, 7, 1), DateTime(2026, 9, 8));
      await container.read(ownerFinanceProvider.future);
      filters.selectDates(DateTime(2026, 7, 1), DateTime(2026, 9, 8));
      await container.pump();
      await container.read(ownerFinanceProvider.future);
      expect(repository.calls.length, 4);
      expect(repository.calls.last.farmId, 'farm2');
      expect(repository.overviewCalls, 1);
    },
  );

  test(
    'N/A: account changes replace cached data; logout does not call owner APIs',
    () async {
      await container.read(ownerDashboardProvider.future);
      await container.read(ownerFinanceProvider.future);
      container.read(financeFilterProvider.notifier).selectFarm('farm1');
      await container.read(ownerFinanceProvider.future);
      auth.account = auth.account.copyWith(id: 'other-owner');
      await container
          .read(authControllerProvider.notifier)
          .login(email: 'other@example.com', password: 'fixture');
      await container.read(ownerDashboardProvider.future);
      await container.read(ownerFinanceProvider.future);
      expect(repository.overviewCalls, 2);
      expect(repository.calls.length, 3);
      expect(container.read(financeFilterProvider).farmId, isNull);
      await container.read(authControllerProvider.notifier).logout();
      await expectLater(
        container.read(ownerDashboardProvider.future),
        throwsA(isA<UnsupportedRoleException>()),
      );
      await expectLater(
        container.read(ownerFinanceProvider.future),
        throwsA(isA<UnsupportedRoleException>()),
      );
      expect(repository.overviewCalls, 2);
      expect(repository.calls.length, 3);
    },
  );

  test(
    'A: failed requests wait for an explicit retry instead of retrying automatically',
    () async {
      repository.fail = true;
      await expectLater(
        container.read(ownerDashboardProvider.future),
        throwsA(isA<ApiException>()),
      );
      await expectLater(
        container.read(ownerFinanceProvider.future),
        throwsA(isA<ApiException>()),
      );
      await Future<void>.delayed(const Duration(seconds: 1));
      await container.pump();
      expect(repository.overviewCalls, 1);
      expect(repository.calls.length, 1);
      repository.fail = false;
      container.invalidate(ownerDashboardProvider);
      container.invalidate(ownerFinanceProvider);
      await container.read(ownerDashboardProvider.future);
      await container.read(ownerFinanceProvider.future);
      expect(repository.overviewCalls, 2);
      expect(repository.calls.length, 2);
    },
  );
}

class _CountingRepository extends DashboardFixtureRepository {
  int overviewCalls = 0;
  bool fail = false;
  @override
  Future<OwnerDashboard> getOverview() async {
    overviewCalls++;
    if (fail) throw const ApiException('Không thể tải tổng quan.');
    return overviewFixture;
  }

  @override
  Future<OwnerFinance> getFinance(FinanceFilter filter) async {
    final finance = await super.getFinance(filter);
    if (fail) throw const ApiException('Không thể tải thu chi.');
    return finance;
  }
}

class _SwitchableAuth extends DashboardFixtureAuth {
  AuthAccount account = const AuthAccount(
    id: 'owner',
    email: 'owner@example.com',
    role: AccountRole.farmOwner,
    status: AccountStatus.active,
  );
  @override
  Future<AuthAccount?> restoreSession() async => account;
  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => account;
}
