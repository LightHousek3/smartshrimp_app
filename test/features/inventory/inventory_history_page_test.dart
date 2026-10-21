import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/inventory/data/services/inventory_api_service.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart'
    as domain;
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_history_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_history_filters.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

import 'inventory_test_data.dart';

void main() {
  late _HistoryRemote remote;
  setUp(() => remote = _HistoryRemote());

  Future<void> openPage(WidgetTester tester, {double width = 393}) async {
    tester.view.physicalSize = Size(width, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          authRepositoryProvider.overrideWithValue(
            const _OwnerAuthRepository(),
          ),
          inventoryRemoteDataSourceProvider.overrideWithValue(remote),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const InventoryHistoryPage(farmId: 'farm-1'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder field(String label, Type type) => find.descendant(
    of: find.byWidgetPredicate(
      (widget) => widget is InventoryField && widget.label == label,
    ),
    matching: find.byType(type),
  );

  DropdownButton<String> dropdown(String label, WidgetTester tester) => tester
      .widget<DropdownButton<String>>(field(label, DropdownButton<String>));

  Future<void> select(String label, String text, WidgetTester tester) async {
    final dropdown = field(label, DropdownButtonFormField<String>);
    await tester.ensureVisible(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text(text).last);
    await tester.pumpAndSettle();
  }

  Future<void> apply(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Xem kết quả'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xem kết quả'));
    await tester.pumpAndSettle();
  }

  Future<void> pickDate(
    String label,
    DateTime date,
    WidgetTester tester,
  ) async {
    final dateField = field(label, TextFormField);
    await tester.ensureVisible(dateField);
    await tester.pumpAndSettle();
    await tester.tap(dateField);
    await tester.pumpAndSettle();
    tester
        .widget<CalendarDatePicker>(find.byType(CalendarDatePicker))
        .onDateChanged(date);
    await tester.pump();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  Finder searchField() => find.byWidgetPredicate(
    (widget) =>
        widget is TextField &&
        widget.decoration?.hintText?.startsWith('Tìm theo') == true,
  );

  testWidgets(
    'renders all history filters in two rows with stable complete choices',
    (tester) async {
      await openPage(tester, width: 360);
      expect(find.text('Bộ lọc truy vết'), findsOneWidget);
      expect(find.text('Từ ngày'), findsOneWidget);
      expect(find.text('Đến ngày'), findsOneWidget);
      expect(find.text('Hình thức'), findsOneWidget);
      expect(find.text('Vật tư'), findsOneWidget);
      expect(find.text('Vụ nuôi liên quan'), findsOneWidget);
      expect(find.text('Đặt lại'), findsOneWidget);
      expect(find.text('Xem kết quả'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Từ ngày')).dy,
        tester.getTopLeft(find.text('Đến ngày')).dy,
      );
      expect(
        tester.getTopLeft(find.text('Hình thức')).dy,
        tester.getTopLeft(find.text('Vật tư')).dy,
      );
      final product = dropdown('Vật tư', tester);
      expect(product.items, hasLength(3));
      final season = dropdown('Vụ nuôi liên quan', tester);
      expect(season.items, hasLength(3));
      expect(
        season.items!.map((item) => (item.child as Text).data),
        contains('Vụ Đông Xuân · Ao A3'),
      );
      expect(remote.queries, <Map<String, dynamic>>[
        {'limit': 100},
      ]);
      tester.view.physicalSize = const Size(320, 852);
      await tester.pumpAndSettle();
      await select('Vật tư', 'Thuốc kiểm thử (đã xóa)', tester);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'changing drafts waits for apply and filters product, movement and season together',
    (tester) async {
      await openPage(tester);
      await select('Hình thức', 'Xuất kho', tester);
      await select('Vật tư', 'Thức ăn CP 9004', tester);
      await select('Vụ nuôi liên quan', 'Vụ Đông Xuân · Ao A3', tester);
      expect(remote.queries, hasLength(1));
      expect(find.text('Có thay đổi chưa áp dụng'), findsOneWidget);
      await apply(tester);
      expect(remote.queries.last, <String, dynamic>{
        'limit': 100,
        'transactionType': 'STOCK_OUT',
        'productId': 'product-1',
        'seasonId': 'season-1',
      });
      expect(find.text('350.000 ₫'), findsWidgets);
      expect(find.text('2.920.000 ₫'), findsNothing);
      expect(find.text('Giao dịch nhập CP'), findsNothing);
      final products = dropdown('Vật tư', tester);
      expect(products.items, hasLength(3));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'same-day filter includes late movements and excludes adjacent days',
    (tester) async {
      await openPage(tester);
      await pickDate('Từ ngày', DateTime(2026, 10, 2), tester);
      await pickDate('Đến ngày', DateTime(2026, 10, 2), tester);
      await apply(tester);
      expect(
        remote.queries.last['createdFrom'],
        DateTime(2026, 10, 2).toUtc().toIso8601String(),
      );
      expect(
        remote.queries.last['createdTo'],
        DateTime(2026, 10, 2, 23, 59, 59, 999).toUtc().toIso8601String(),
      );
      expect(find.text('362.000 ₫'), findsOneWidget);
      expect(find.text('Giao dịch nhập CP'), findsNothing);
      expect(find.text('Giao dịch nhập thuốc'), findsNothing);
      expect(find.text('Giao dịch xuất CP'), findsOneWidget);
      expect(find.text('Kiểm kê thuốc'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'invalid dates show inline error without issuing a history request',
    (tester) async {
      await openPage(tester);
      await pickDate('Từ ngày', DateTime(2026, 10, 3), tester);
      await pickDate('Đến ngày', DateTime(2026, 10, 2), tester);
      await apply(tester);
      expect(
        find.text('Ngày bắt đầu không được sau ngày kết thúc.'),
        findsOneWidget,
      );
      expect(remote.queries, hasLength(1));
      await tester.ensureVisible(field('Từ ngày', TextFormField));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Xóa Từ ngày'));
      await tester.pumpAndSettle();
      expect(
        find.text('Ngày bắt đầu không được sau ngày kết thúc.'),
        findsNothing,
      );
      await apply(tester);
      expect(remote.queries.last.containsKey('createdFrom'), isFalse);
      expect(remote.queries.last.containsKey('createdTo'), isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'an empty result keeps filter choices and reset restores unassigned movements',
    (tester) async {
      await openPage(tester);
      await select('Hình thức', 'Xuất kho', tester);
      await select('Vật tư', 'Thuốc kiểm thử (đã xóa)', tester);
      await apply(tester);
      expect(find.text('Không có giao dịch phù hợp'), findsOneWidget);
      expect(find.text('0 ₫'), findsNWidgets(2));
      expect(dropdown('Vật tư', tester).items, hasLength(3));
      await tester.ensureVisible(find.text('Đặt lại'));
      await tester.tap(find.text('Đặt lại'));
      await tester.pumpAndSettle();
      expect(find.text('Tất cả vật tư'), findsOneWidget);
      expect(find.text('Tất cả, kể cả không gắn vụ'), findsOneWidget);
      expect(find.text('Giao dịch nhập CP'), findsOneWidget);
      expect(find.text('2.920.000 ₫'), findsOneWidget);
      expect(find.text('Không có giao dịch phù hợp'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'history search is debounced and summary follows visible results',
    (tester) async {
      await openPage(tester);
      await tester.ensureVisible(searchField());
      await tester.enterText(searchField(), 'không có vật tư');
      await tester.pump(const Duration(milliseconds: 349));
      expect(find.text('2.920.000 ₫'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1));
      expect(find.text('Không có giao dịch phù hợp'), findsOneWidget);
      expect(find.text('0 ₫'), findsNWidgets(2));
      await tester.enterText(searchField(), 'CP');
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('2.800.000 ₫'), findsWidgets);
      expect(find.text('350.000 ₫'), findsWidgets);
      expect(find.text('Giao dịch nhập thuốc'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('filter panel collapses without losing draft values', (
    tester,
  ) async {
    await openPage(tester);
    await select('Hình thức', 'Điều chỉnh giảm', tester);
    await tester.ensureVisible(find.text('Bộ lọc truy vết'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bộ lọc truy vết'));
    await tester.pumpAndSettle();
    expect(find.text('Từ ngày'), findsNothing);
    await tester.ensureVisible(find.text('Bộ lọc truy vết'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bộ lọc truy vết'));
    await tester.pumpAndSettle();
    final panel = tester.widget<InventoryHistoryFilterPanel>(
      find.byType(InventoryHistoryFilterPanel),
    );
    expect(
      panel.filters.transactionType,
      domain.InventoryTransactionType.adjustmentOut,
    );
    await apply(tester);
    expect(remote.queries.last['transactionType'], 'ADJUSTMENT_OUT');
    expect(find.text('12.000 ₫'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'failed filters remain editable and retry preserves their request',
    (tester) async {
      await openPage(tester);
      await select('Hình thức', 'Xuất kho', tester);
      remote.failNext = true;
      await apply(tester);
      expect(find.text('Không thể lọc lịch sử'), findsOneWidget);
      expect(find.byType(InventoryHistoryFilterPanel), findsOneWidget);
      await tester.ensureVisible(find.text('Thử lại'));
      await tester.tap(find.text('Thử lại'));
      await tester.pumpAndSettle();
      expect(find.text('Không thể lọc lịch sử'), findsNothing);
      expect(remote.queries.last['transactionType'], 'STOCK_OUT');
      expect(find.text('350.000 ₫'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'reset during a pending request prevents its late result from replacing all history',
    (tester) async {
      await openPage(tester);
      await select('Hình thức', 'Xuất kho', tester);
      remote.pending = Completer<domain.InventoryHistoryPage>();
      await tester.ensureVisible(find.text('Xem kết quả'));
      await tester.tap(find.text('Xem kết quả'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 20));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.text('Đặt lại'));
      await tester.pump();
      expect(find.text('2.920.000 ₫'), findsOneWidget);
      remote.pending!.complete(_page(<domain.InventoryTransaction>[]));
      await tester.pumpAndSettle();
      expect(find.text('2.920.000 ₫'), findsOneWidget);
      expect(find.text('Không có giao dịch phù hợp'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}

List<domain.InventoryTransaction> _transactions() {
  const season = domain.InventoryTransactionSeason(
    id: 'season-1',
    name: 'Vụ Đông Xuân',
    pondName: 'Ao A3',
  );
  const otherSeason = domain.InventoryTransactionSeason(
    id: 'season-2',
    name: 'Vụ Hè Thu',
    pondName: 'Ao B1',
  );
  const medicine = domain.InventoryTransactionProduct(
    id: 'product-2',
    name: 'Thuốc kiểm thử',
    category: domain.InventoryProductCategory.medicine,
    unit: domain.InventoryProductUnit.kg,
    isDeleted: true,
  );
  return <domain.InventoryTransaction>[
    inventoryTestTransaction.copyWith(
      createdAt: DateTime(2026, 10, 1, 8).toUtc(),
      reason: 'Giao dịch nhập CP',
    ),
    inventoryTestTransaction.copyWith(
      id: 'transaction-2',
      transactionType: domain.InventoryTransactionType.stockOut,
      quantity: 10,
      totalAmount: 350000,
      createdAt: DateTime(2026, 10, 2, 23, 59, 59, 999).toUtc(),
      seasonId: season.id,
      season: season,
      reason: 'Giao dịch xuất CP',
    ),
    inventoryTestTransaction.copyWith(
      id: 'transaction-3',
      productId: medicine.id,
      product: medicine,
      totalAmount: 120000,
      createdAt: DateTime(2026, 10, 3).toUtc(),
      seasonId: otherSeason.id,
      season: otherSeason,
      reason: 'Giao dịch nhập thuốc',
    ),
    inventoryTestTransaction.copyWith(
      id: 'transaction-4',
      productId: medicine.id,
      product: medicine,
      transactionType: domain.InventoryTransactionType.adjustmentOut,
      totalAmount: 12000,
      createdAt: DateTime(2026, 10, 2, 12).toUtc(),
      seasonId: otherSeason.id,
      season: otherSeason,
      reason: 'Kiểm kê thuốc',
    ),
  ];
}

domain.InventoryHistoryPage _page(List<domain.InventoryTransaction> items) =>
    domain.InventoryHistoryPage(
      items: items,
      limit: 100,
      totalResults: items.length,
      hasNextPage: false,
      summary: domain.InventoryHistorySummary(
        totalInboundValue: items
            .where(
              (item) => <domain.InventoryTransactionType>{
                domain.InventoryTransactionType.stockIn,
                domain.InventoryTransactionType.adjustmentIn,
              }.contains(item.transactionType),
            )
            .fold(0, (total, item) => total + item.totalAmount),
        totalOutboundValue: items
            .where(
              (item) => <domain.InventoryTransactionType>{
                domain.InventoryTransactionType.stockOut,
                domain.InventoryTransactionType.adjustmentOut,
              }.contains(item.transactionType),
            )
            .fold(0, (total, item) => total + item.totalAmount),
      ),
    );

final class _HistoryRemote implements InventoryRemoteDataSource {
  final queries = <Map<String, dynamic>>[];
  bool failNext = false;
  Completer<domain.InventoryHistoryPage>? pending;

  @override
  Future<domain.InventoryHistoryPage> getHistory(
    String farmId,
    Map<String, dynamic> query,
  ) async {
    queries.add(Map<String, dynamic>.of(query));
    if (failNext) {
      failNext = false;
      throw const ApiException('Không thể lọc lịch sử', statusCode: 500);
    }
    if (pending != null && query['transactionType'] == 'STOCK_OUT') {
      return pending!.future;
    }
    final items = _transactions().where((item) {
      if (query['productId'] != null && query['productId'] != item.productId) {
        return false;
      }
      if (query['seasonId'] != null && query['seasonId'] != item.seasonId) {
        return false;
      }
      if (query['transactionType'] != null &&
          query['transactionType'] !=
              <domain.InventoryTransactionType, String>{
                domain.InventoryTransactionType.stockIn: 'STOCK_IN',
                domain.InventoryTransactionType.stockOut: 'STOCK_OUT',
                domain.InventoryTransactionType.adjustmentIn: 'ADJUSTMENT_IN',
                domain.InventoryTransactionType.adjustmentOut: 'ADJUSTMENT_OUT',
              }[item.transactionType]) {
        return false;
      }
      final from = query['createdFrom'] as String?;
      final to = query['createdTo'] as String?;
      return (from == null || !item.createdAt.isBefore(DateTime.parse(from))) &&
          (to == null || !item.createdAt.isAfter(DateTime.parse(to)));
    }).toList();
    return _page(items);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

final class _OwnerAuthRepository implements AuthRepository {
  const _OwnerAuthRepository();
  static const account = AuthAccount(
    id: 'owner-1',
    email: 'owner@smartshrimp.vn',
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
  @override
  Future<void> logout() async {}
}
