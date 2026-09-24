import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';

class MainShell extends ConsumerWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _technicianItems = <_NavigationItem>[
    _NavigationItem('Trang chủ', '/', Icons.home_outlined, Icons.home_rounded),
    _NavigationItem(
      'Vụ nuôi',
      '/seasons',
      Icons.layers_outlined,
      Icons.layers_rounded,
    ),
    _NavigationItem(
      'Nhiệm vụ',
      '/tasks',
      Icons.checklist_rtl_outlined,
      Icons.checklist_rtl_rounded,
    ),
    _NavigationItem(
      'Tài khoản',
      '/account',
      Icons.person_outline,
      Icons.person_rounded,
    ),
  ];

  static const _ownerItems = <_NavigationItem>[
    _NavigationItem('Trang chủ', '/', Icons.home_outlined, Icons.home_rounded),
    _NavigationItem(
      'Trang trại',
      '/farms',
      Icons.grid_view_outlined,
      Icons.grid_view_rounded,
    ),
    _NavigationItem(
      'Nhiệm vụ',
      '/tasks',
      Icons.format_list_bulleted_outlined,
      Icons.format_list_bulleted_rounded,
    ),
    _NavigationItem(
      'Phê duyệt',
      '/approvals',
      Icons.verified_user_outlined,
      Icons.verified_user_rounded,
    ),
    _NavigationItem(
      'Tài khoản',
      '/account',
      Icons.person_outline,
      Icons.person_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationSocketProvider);
    final isOwner =
        ref.watch(authControllerProvider).value?.role == AccountRole.farmOwner;
    final items = isOwner ? _ownerItems : _technicianItems;
    final location = GoRouterState.of(context).uri.path;
    final unreadNotifications = location == '/'
        ? ref.watch(notificationListProvider(NotificationReadStatus.unread))
        : null;
    final badgeText = switch (unreadNotifications) {
      AsyncData(:final value) => '${value.totalResults}',
      AsyncError() => '!',
      _ => '…',
    };
    final badgeDescription = switch (unreadNotifications) {
      AsyncData(:final value) => '${value.totalResults} thông báo chưa đọc',
      AsyncError() => 'Không thể tải số thông báo chưa đọc',
      _ => 'Đang tải số thông báo chưa đọc',
    };
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          navigationShell,
          if (location == '/')
            Positioned(
              top: MediaQuery.paddingOf(context).top + 16,
              right: 16,
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Material(
                    color: Colors.white,
                    elevation: 2,
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: 'Mở thông báo',
                      icon: const Icon(Icons.notifications_none_rounded),
                      color: AppColors.ocean,
                      iconSize: 26,
                      padding: const EdgeInsets.all(12),
                      onPressed: () => context.go('/notifications'),
                    ),
                  ),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: IgnorePointer(
                      child: Semantics(
                        label: badgeDescription,
                        child: Container(
                          key: const Key('home_unread_notification_badge'),
                          constraints: const BoxConstraints(
                            minWidth: 22,
                            minHeight: 22,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            badgeText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0xFAFFFFFF),
          border: Border(top: BorderSide(color: AppColors.line)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Color(0x120F1C2E),
              blurRadius: 18,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: isOwner ? 64 : 72,
            child: Row(
              children: List<Widget>.generate(items.length, (index) {
                final item = items[index];
                final selected =
                    location == item.path ||
                    (item.path != '/' &&
                        location.startsWith('${item.path}/')) ||
                    (item.path == '/' &&
                        location.startsWith('/notifications')) ||
                    (item.path == '/account' &&
                        location.startsWith('/personnel'));
                return Expanded(
                  child: Semantics(
                    selected: selected,
                    button: true,
                    label: item.label,
                    child: InkWell(
                      onTap: () => context.go(item.path),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          if (selected)
                            Container(
                              width: isOwner ? 32 : 34,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.ocean,
                                borderRadius: const BorderRadius.vertical(
                                  bottom: Radius.circular(5),
                                ),
                              ),
                            ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  selected ? item.selectedIcon : item.icon,
                                  color: selected
                                      ? AppColors.ocean
                                      : AppColors.inkMuted,
                                  size: isOwner ? 22 : 27,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.label,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: selected
                                        ? AppColors.ocean
                                        : AppColors.inkMuted,
                                    fontSize: isOwner ? 10 : 11.5,
                                    fontWeight: selected
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

final class _NavigationItem {
  const _NavigationItem(this.label, this.path, this.icon, this.selectedIcon);

  final String label;
  final String path;
  final IconData icon;
  final IconData selectedIcon;
}
