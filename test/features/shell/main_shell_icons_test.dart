import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/shell/presentation/pages/main_shell.dart';

import '../home/owner_dashboard_fixtures.dart';

final class _Auth implements AuthRepository {
  _Auth(this.role);
  final AccountRole role;

  @override
  Future<AuthAccount?> restoreSession() async => AuthAccount(
    id: 'account-one',
    email: 'account@example.com',
    role: role,
    status: AccountStatus.active,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  for (final role in [AccountRole.technician, AccountRole.farmOwner]) {
    testWidgets(
      'navigation icons stay consistent on every tab for ${role.name}',
      (tester) async {
        final owner = role == AccountRole.farmOwner;
        final paths = [
          '/',
          owner ? '/farms' : '/seasons',
          '/tasks',
          '/notifications',
          '/account',
        ];
        final icons = owner
            ? [
                AppSvgIconName.home,
                AppSvgIconName.farm,
                AppSvgIconName.tasks,
                AppSvgIconName.notifications,
                AppSvgIconName.account,
              ]
            : [
                AppSvgIconName.homeCompact,
                AppSvgIconName.shrimp,
                AppSvgIconName.tasks,
                AppSvgIconName.bellOutline,
                AppSvgIconName.person,
              ];
        final router = GoRouter(
          routes: [
            StatefulShellRoute.indexedStack(
              builder: (context, state, shell) =>
                  MainShell(navigationShell: shell),
              branches: [
                for (final path in paths)
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: path,
                        builder: (context, state) => Text('page $path'),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authRepositoryProvider.overrideWithValue(_Auth(role)),
              notificationRepositoryProvider.overrideWithValue(
                DashboardFixtureNotifications(),
              ),
              notificationSocketProvider.overrideWith((ref) => null),
            ],
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();
        for (final path in paths) {
          router.go(path);
          await tester.pumpAndSettle();
          final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
          final nav = find.byWidget(scaffold.bottomNavigationBar!);
          expect(
            tester
                .widgetList<AppSvgIcon>(
                  find.descendant(of: nav, matching: find.byType(AppSvgIcon)),
                )
                .map((icon) => icon.icon),
            icons,
          );
          expect(tester.takeException(), isNull);
        }
      },
    );
  }
}
