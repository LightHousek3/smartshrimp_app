import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/auth/presentation/pages/auth_info_page.dart';
import 'package:smartshrimp_app/features/auth/presentation/pages/login_page.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
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
  static const tasks = '/tasks';
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
          _emptyBranch(AppRoutes.seasons, 'Vụ nuôi'),
          _emptyBranch(AppRoutes.tasks, 'Nhiệm vụ'),
          _emptyBranch(AppRoutes.notifications, 'Thông báo'),
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
