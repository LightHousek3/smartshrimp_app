import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';

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
      'Thông báo',
      '/notifications',
      Icons.notifications_none_rounded,
      Icons.notifications_rounded,
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
      'Thông báo',
      '/notifications',
      Icons.notifications_none_rounded,
      Icons.notifications_rounded,
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
    final unreadNotifications = ref.watch(
      notificationListProvider(NotificationReadStatus.unread),
    );
    final notificationBadgeText = switch (unreadNotifications) {
      AsyncData(:final value) when value.totalResults > 99 => '99+',
      AsyncData(:final value) when value.totalResults > 0 =>
        '${value.totalResults}',
      AsyncError() => '!',
      _ => null,
    };

    return Scaffold(
      body: navigationShell,
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
            height: 64,
            child: Row(
              children: List<Widget>.generate(items.length, (index) {
                final item = items[index];
                final selected =
                    location == item.path ||
                    (item.path != '/' &&
                        location.startsWith('${item.path}/')) ||
                    (item.path == '/account' &&
                        location.startsWith('/personnel'));
                final isNotificationTab = item.path == '/notifications';
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
                              width: 32,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: AppColors.ocean,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(5),
                                ),
                              ),
                            ),
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    Icon(
                                      selected ? item.selectedIcon : item.icon,
                                      color: selected
                                          ? AppColors.ocean
                                          : AppColors.inkMuted,
                                      size: 22,
                                    ),
                                    if (isNotificationTab &&
                                        notificationBadgeText != null)
                                      Positioned(
                                        top: -7,
                                        right: -12,
                                        child: Semantics(
                                          label: notificationBadgeText == '!'
                                              ? 'Không thể tải số thông báo chưa đọc'
                                              : '$notificationBadgeText thông báo chưa đọc',
                                          child: Container(
                                            key: const Key(
                                              'notif_tab_unread_badge',
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 18,
                                              minHeight: 18,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColors.error,
                                              borderRadius:
                                                  BorderRadius.circular(99),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Text(
                                              notificationBadgeText,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                                height: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: selected
                                        ? AppColors.ocean
                                        : AppColors.inkMuted,
                                    fontSize: 10,
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
