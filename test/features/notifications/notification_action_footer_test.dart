import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/domain/entities/app_notification.dart';
import 'package:smartshrimp_app/features/notifications/presentation/notification_navigation.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/widgets/notification_detail_sheet.dart';

final notification = AppNotification(
  id: 'notification',
  title: 'Vật tư sắp hết',
  type: NotificationType.inventoryLow,
  referenceType: 'PRODUCT',
  referenceId: 'product',
  createdAt: DateTime(2026),
);

Future<void> openSheet(
  WidgetTester tester,
  Future<Map<String, String>> Function() resolve, {
  AppNotification? notice,
}) async {
  final shown = notice ?? notification;
  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => Scaffold(
          body: Center(
            child: FilledButton(
              onPressed: () => showNotificationDetailSheet(
                context: context,
                notification: shown,
              ),
              child: const Text('Open notification'),
            ),
          ),
        ),
      ),
      GoRoute(
        path: '/protocols/:protocolId',
        builder: (_, state) => Scaffold(
          body: Text('Protocol ${state.pathParameters['protocolId']}'),
        ),
      ),
      GoRoute(
        path: '/farms/:farmId/inventory/:productId',
        builder: (_, state) => Scaffold(
          body: Text(
            'Product ${state.pathParameters['farmId']}/${state.pathParameters['productId']}',
          ),
        ),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(_Auth()),
        notificationDetailProvider(
          shown.id,
        ).overrideWith((ref) async => shown.copyWith(readAt: DateTime(2026))),
        notificationReferenceContextProvider(
          shown.id,
        ).overrideWith((ref) => resolve()),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Open notification'));
  await tester.pumpAndSettle();
}

void main() {
  for (final reference in [
    'protocol',
    'production_protocol',
    'treatment_protocol',
  ]) {
    testWidgets('Owner opens $reference detail using the shared footer', (
      tester,
    ) async {
      await openSheet(
        tester,
        () async => {'seasonId': 'season'},
        notice: notification.copyWith(
          type: NotificationType.productionProtocolPending,
          referenceType: reference,
          referenceId: 'protocol',
        ),
      );
      expect(find.text('Xem phác đồ'), findsOneWidget);
      await tester.tap(find.byKey(const Key('notification_action_button')));
      await tester.pumpAndSettle();
      expect(find.text('Protocol protocol'), findsOneWidget);
      expect(find.byKey(const Key('notification_detail_sheet')), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'resolves the target once and opens the exact product after dismissing the sheet',
    (tester) async {
      final pending = Completer<Map<String, String>>();
      var calls = 0;
      await openSheet(tester, () {
        calls++;
        return pending.future;
      });
      final button = find.byKey(const Key('notification_action_button'));
      await tester.tap(button);
      await tester.pump();
      await tester.tap(button);
      await tester.pump();
      expect(calls, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      pending.complete({'farmId': 'farm', 'productId': 'product'});
      await tester.pumpAndSettle();
      expect(find.text('Product farm/product'), findsOneWidget);
      expect(find.byKey(const Key('notification_detail_sheet')), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'an inaccessible target keeps the sheet open and shows a useful message',
    (tester) async {
      await openSheet(tester, () async => {});
      await tester.tap(find.byKey(const Key('notification_action_button')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('notification_detail_sheet')),
        findsOneWidget,
      );
      expect(
        find.text(
          'Nội dung liên quan không còn khả dụng hoặc bạn không có quyền truy cập.',
        ),
        findsOneWidget,
      );
      expect(find.text('Product farm/product'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 5));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a failed target lookup can be retried without leaving the notification',
    (tester) async {
      var calls = 0;
      await openSheet(tester, () async {
        if (++calls == 1) throw const ApiException('Không thể tải liên kết.');
        return {'farmId': 'farm', 'productId': 'product'};
      });
      await tester.tap(find.byKey(const Key('notification_action_button')));
      await tester.pumpAndSettle();
      expect(find.text('Không thể tải liên kết.'), findsOneWidget);
      await tester.tap(find.byKey(const Key('notification_action_button')));
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(find.text('Product farm/product'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 5));
      expect(tester.takeException(), isNull);
    },
  );
}

class _Auth implements AuthRepository {
  @override
  Future<AuthAccount?> restoreSession() async => const AuthAccount(
    id: 'owner',
    email: 'owner@example.com',
    role: AccountRole.farmOwner,
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
