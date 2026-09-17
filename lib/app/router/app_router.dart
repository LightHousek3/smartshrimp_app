import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/auth/presentation/pages/auth_info_page.dart';
import 'package:smartshrimp_app/features/auth/presentation/pages/login_page.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/presentation/pages/farm_detail_page.dart';
import 'package:smartshrimp_app/features/farm/presentation/pages/farm_form_page.dart';
import 'package:smartshrimp_app/features/farm/presentation/pages/farm_list_page.dart';
import 'package:smartshrimp_app/features/notifications/presentation/pages/notification_detail_page.dart';
import 'package:smartshrimp_app/features/notifications/presentation/pages/notification_list_page.dart';
import 'package:smartshrimp_app/features/profile/presentation/pages/account_page.dart';
import 'package:smartshrimp_app/features/profile/presentation/pages/change_password_page.dart';
import 'package:smartshrimp_app/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:smartshrimp_app/features/shell/presentation/pages/empty_tab_page.dart';
import 'package:smartshrimp_app/features/shell/presentation/pages/main_shell.dart';

abstract final class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const activateAccount = '/activate-account';
  static const forgotPassword = '/forgot-password';
  static const home = '/';
  static const seasons = '/seasons';
  static const farms = '/farms';
  static const tasks = '/tasks';
  static const approvals = '/approvals';
  static const notifications = '/notifications';
  static const account = '/account';
  static const profileEdit = '/account/edit';
  static const changePassword = '/account/change-password';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref
    ..onDispose(refreshNotifier.dispose)
    ..listen(authControllerProvider, (_, _) => refreshNotifier.refresh());

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final location = state.matchedLocation;
      final isAuthRoute =
          location == AppRoutes.login ||
          location == AppRoutes.activateAccount ||
          location == AppRoutes.forgotPassword;

      if (authState.isLoading) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final isAuthenticated = switch (authState) {
        AsyncData(:final value) => value != null,
        _ => false,
      };
      if (!isAuthenticated) {
        return isAuthRoute ? null : AppRoutes.login;
      }

      if (location == AppRoutes.splash || isAuthRoute) return AppRoutes.home;
      final account = authState.value;
      if (location.startsWith(AppRoutes.farms) &&
          account?.role != AccountRole.farmOwner) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const _SplashPage()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginPage()),
      GoRoute(
        path: AppRoutes.activateAccount,
        builder: (_, _) => const AuthInfoPage(
          title: 'Kích hoạt tài khoản',
          message:
              'Luồng kích hoạt tài khoản sẽ được hoàn thiện ở hạng mục xác thực tiếp theo.',
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (_, _) => const AuthInfoPage(
          title: 'Quên mật khẩu',
          message:
              'Luồng đặt lại mật khẩu sẽ được hoàn thiện ở hạng mục xác thực tiếp theo.',
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          _emptyBranch(AppRoutes.home, 'Trang chủ'),
          StatefulShellBranch(
            initialLocation: AppRoutes.seasons,
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.seasons,
                builder: (_, _) => const EmptyTabPage(semanticLabel: 'Vụ nuôi'),
              ),
              GoRoute(
                path: AppRoutes.farms,
                builder: (_, _) => const FarmListPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'create',
                    builder: (_, _) => const FarmFormPage(),
                  ),
                  GoRoute(
                    path: ':farmId',
                    builder: (_, state) =>
                        FarmDetailPage(farmId: state.pathParameters['farmId']!),
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'edit',
                        builder: (_, state) => FarmEditPage(
                          farmId: state.pathParameters['farmId']!,
                          initialFarm: state.extra is Farm
                              ? state.extra! as Farm
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          _emptyBranch(AppRoutes.tasks, 'Nhiệm vụ'),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.notifications,
                builder: (_, _) => const NotificationListPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: ':notificationId',
                    builder: (_, state) => NotificationDetailPage(
                      notificationId: state.pathParameters['notificationId']!,
                    ),
                  ),
                ],
              ),
              GoRoute(
                path: AppRoutes.approvals,
                builder: (_, _) =>
                    const EmptyTabPage(semanticLabel: 'Phê duyệt'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.account,
                builder: (_, _) => const AccountPage(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'edit',
                    builder: (_, _) => const ProfileEditPage(),
                  ),
                  GoRoute(
                    path: 'change-password',
                    builder: (_, _) => const ChangePasswordPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (_, _) => const Scaffold(
      body: AppGradientBackground(
        child: Center(
          child: Text(
            'Không tìm thấy trang.',
            style: TextStyle(color: AppColors.ink),
          ),
        ),
      ),
    ),
  );
  ref.onDispose(router.dispose);
  return router;
});

StatefulShellBranch _emptyBranch(String path, String label) {
  return StatefulShellBranch(
    routes: <RouteBase>[
      GoRoute(
        path: path,
        builder: (_, _) => EmptyTabPage(semanticLabel: label),
      ),
    ],
  );
}

final class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppGradientBackground(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.ocean,
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }
}
