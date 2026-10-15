import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/domain/repositories/owner_dashboard_repository.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';

final overviewFixture = OwnerDashboard(
  date: '2026-10-13',
  summary: const DashboardSummary(farms: 2, ponds: 3, activeSeasons: 3),
  financeFarms: const [
    DashboardFarm(id: 'farm1', name: 'Trang trại Cửa Lấp'),
    DashboardFarm(id: 'farm2', name: 'Trang trại Đông Hải'),
  ],
  alerts: [
    for (final (kind, title) in [
      (DashboardAlertKind.urgentTask, 'Kiểm tra & xử lý NO2 cao tại Ao A3'),
      (
        DashboardAlertKind.pendingTreatment,
        'Phác đồ điều trị Phân trắng — Ao A3 v2',
      ),
      (
        DashboardAlertKind.pendingProduction,
        'Phác đồ nuôi Tôm thẻ — Vụ Đông 2025 — Ao D2 v1',
      ),
      (DashboardAlertKind.lowStock, 'Doxycycline 98% (trộn thức ăn)'),
      (DashboardAlertKind.inTreatment, 'Nghi phân trắng & mềm vỏ — Ao A3'),
      (DashboardAlertKind.monitoring, 'Đốm đen trên vỏ — theo dõi'),
    ])
      DashboardAlert(
        kind: kind,
        count: 1,
        preview: DashboardAlertPreview(
          id: kind.name,
          title: title,
          farmId: kind == DashboardAlertKind.pendingProduction
              ? 'farm2'
              : 'farm1',
          farmName: kind == DashboardAlertKind.pendingProduction
              ? 'Trang trại Đông Hải'
              : 'Trang trại Cửa Lấp',
          pondId: kind == DashboardAlertKind.lowStock ? null : 'pond1',
          pondName: kind == DashboardAlertKind.lowStock
              ? null
              : kind == DashboardAlertKind.monitoring
              ? 'Ao A5'
              : kind == DashboardAlertKind.pendingProduction
              ? 'Ao D2'
              : 'Ao A3',
          seasonId: kind == DashboardAlertKind.lowStock ? null : 'season1',
          seasonName: kind == DashboardAlertKind.lowStock
              ? null
              : 'Vụ Đông Xuân 2025',
          quantity: kind == DashboardAlertKind.lowStock ? 8 : null,
          minAlertQuantity: kind == DashboardAlertKind.lowStock ? 10 : null,
          unit: kind == DashboardAlertKind.lowStock ? 'KG' : null,
        ),
      ),
  ],
  seasons: [
    for (final (pond, doc, shrimp) in [
      ('Ao A3', 72, 'WHITELEG'),
      ('Ao A5', 50, 'WHITELEG'),
      ('Ao B1', 14, 'BLACK_TIGER'),
    ])
      DashboardSeason(
        seasonId: pond,
        seasonName: 'Vụ Đông Xuân 2025',
        pondId: pond,
        pondName: pond,
        farmId: 'farm1',
        farmName: 'Trang trại Cửa Lấp',
        shrimpType: shrimp,
        dayOfCulture: doc,
      ),
  ],
  inventories: const [
    DashboardInventory(
      farmId: 'farm1',
      farmName: 'Trang trại Cửa Lấp',
      productCount: 5,
      lowStockCount: 1,
      stockValue: 38300000,
    ),
    DashboardInventory(
      farmId: 'farm2',
      farmName: 'Trang trại Đông Hải',
      productCount: 2,
      lowStockCount: 0,
      stockValue: 13400000,
    ),
  ],
  personnel: const DashboardPersonnel(technicians: 2, experts: 2, active: 4),
);

const financeFixture = OwnerFinance(
  from: '2026-10-01',
  to: '2026-10-13',
  months: [FinanceMonth(month: '2026-10', income: 117800000, cost: 52700000)],
  totals: FinanceTotals(income: 117800000, cost: 52700000, profit: 65100000),
);

const customFinanceFixture = OwnerFinance(
  from: '2026-07-01',
  to: '2026-09-08',
  months: [
    FinanceMonth(month: '2026-07', income: 209000000, cost: 87300000),
    FinanceMonth(month: '2026-08', income: 86100000, cost: 103700000),
    FinanceMonth(month: '2026-09', income: 121800000, cost: 55700000),
  ],
  totals: FinanceTotals(income: 416900000, cost: 246700000, profit: 170200000),
);

class DashboardFixtureRepository implements OwnerDashboardRepository {
  final List<FinanceFilter> calls = [];
  @override
  Future<OwnerDashboard> getOverview() async => overviewFixture;
  @override
  Future<OwnerFinance> getFinance(FinanceFilter filter) async {
    calls.add(filter);
    return filter.period == FinancePeriod.custom
        ? customFinanceFixture
        : financeFixture;
  }
}

class DashboardFixtureAuth implements AuthRepository {
  const DashboardFixtureAuth({this.role = AccountRole.farmOwner});
  final AccountRole role;
  @override
  Future<AuthAccount?> restoreSession() async => AuthAccount(
    id: 'owner',
    email: 'owner@example.com',
    fullName: 'Nguyễn Văn Đạt',
    role: role,
    status: AccountStatus.active,
  );
  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => (await restoreSession())!;
  @override
  Future<void> logout() async {}
}

class DashboardFixtureNotifications implements NotificationRepository {
  @override
  Future<NotificationPage> getNotifications({
    required NotificationReadStatus readStatus,
    NotificationCategory category = NotificationCategory.all,
    String? cursor,
    int limit = 10,
  }) async =>
      const NotificationPage(items: [], totalResults: 3, hasNextPage: false);
  @override
  Future<AppNotification> getNotification(String id) =>
      throw UnimplementedError();
  @override
  Future<int> markAllAsRead() async => 3;
}
