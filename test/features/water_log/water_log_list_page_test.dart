import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/repositories/water_log_repository.dart';
import 'package:smartshrimp_app/features/water_log/presentation/pages/water_log_list_page.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';

WaterLog _log(
  String id, {
  bool warning = false,
  bool voided = false,
  int day = 8,
}) => WaterLog(
  id: id,
  seasonId: 'season',
  recordedAt: DateTime(2026, 9, day, 6, 30),
  createdAt: DateTime(2026, 9, day),
  isVoided: voided,
  exceededParameters: warning ? ['ph'] : [],
  temperatureC: 28.5,
  ph: warning ? 9 : 7.9,
  dissolvedOxygenMgL: 5.4,
  salinityPpt: 20,
  nh3MgL: 0.08,
  no2MgL: 0.4,
  alkalinityMgLCaCO3: 132,
  h2sMgL: 0,
);

Future<void> _open(WidgetTester tester, _Repository repository) async {
  GoogleFonts.config.allowRuntimeFetching = false;
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await icons.load();
  tester.view.physicalSize = const Size(395, 854);
  tester.view.devicePixelRatio = 1;
  tester.view.padding = const FakeViewPadding(top: 24);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPadding);
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(_Auth()),
      waterLogRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const WaterLogListPage(
          seasonId: 'season',
          pondName: 'Ao A5',
          seasonName: 'Vụ Đông Xuân 2025',
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.runAsync(() => GoogleFonts.pendingFonts());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('filters include later pages and exclude voided warnings', (
    tester,
  ) async {
    final repository = _Repository(paginated: true);
    await _open(tester, repository);
    expect(repository.cursors, [null, 'next']);
    expect(find.text('Tất cả (3)'), findsOneWidget);
    expect(find.text('Cảnh báo (1)'), findsOneWidget);
    expect(find.text('Vô hiệu (1)'), findsOneWidget);
    await tester.tap(find.text('Cảnh báo (1)'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<WaterLogCard>(find.byType(WaterLogCard)).log.id,
      'warning',
    );
    await tester.tap(find.text('Vô hiệu (1)'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<WaterLogCard>(find.byType(WaterLogCard)).log.id,
      'voided',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'renders eight parameters and handles empty filter on narrow screen',
    (tester) async {
      await _open(tester, _Repository());
      expect(find.text('H2S'), findsOneWidget);
      expect(find.text('Ao A5 · Vụ Đông Xuân 2025'), findsOneWidget);
      expect(find.text('DO MỚI NHẤT'), findsOneWidget);
      tester.view.physicalSize = const Size(320, 700);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Cảnh báo (0)'));
      await tester.pumpAndSettle();
      expect(find.byType(WaterLogCard), findsNothing);
      expect(find.text('Không có bản ghi trong bộ lọc này.'), findsOneWidget);
    },
  );
}

class _Auth implements AuthRepository {
  @override
  Future<AuthAccount?> restoreSession() async => const AuthAccount(
    id: 'tech',
    email: 'tech@example.com',
    role: AccountRole.technician,
    status: AccountStatus.active,
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Repository implements WaterLogRepository {
  _Repository({this.paginated = false});
  final bool paginated;
  final cursors = <String?>[];
  @override
  Future<WaterLogPage> getWaterLogs({
    required String seasonId,
    DateTime? from,
    DateTime? to,
    bool includeVoided = false,
    int limit = 20,
    String? cursor,
  }) async {
    cursors.add(cursor);
    if (!paginated) {
      return WaterLogPage(
        items: [_log('valid')],
        totalResults: 1,
        hasNextPage: false,
      );
    }
    if (cursor == null) {
      return WaterLogPage(
        items: [_log('valid')],
        totalResults: 3,
        hasNextPage: true,
        nextCursor: 'next',
      );
    }
    return WaterLogPage(
      items: [
        _log('warning', warning: true, day: 7),
        _log('voided', warning: true, voided: true, day: 9),
      ],
      totalResults: 3,
      hasNextPage: false,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
