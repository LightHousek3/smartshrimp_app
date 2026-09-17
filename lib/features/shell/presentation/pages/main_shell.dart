import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';

class MainShell extends ConsumerWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _technicianItems = <_NavigationItem>[
    _NavigationItem('Trang chủ', Icons.home_outlined, Icons.home_rounded),
    _NavigationItem('Vụ nuôi', Icons.layers_outlined, Icons.layers_rounded),
    _NavigationItem(
      'Nhiệm vụ',
      Icons.checklist_rtl_outlined,
      Icons.checklist_rtl_rounded,
    ),
    _NavigationItem(
      'Thông báo',
      Icons.notifications_none_rounded,
      Icons.notifications_rounded,
    ),
    _NavigationItem('Tài khoản', Icons.person_outline, Icons.person_rounded),
  ];

  static const _ownerItems = <_NavigationItem>[
    _NavigationItem('Trang chủ', Icons.home_outlined, Icons.home_rounded),
    _NavigationItem(
      'Trang trại',
      Icons.apartment_outlined,
      Icons.apartment_rounded,
    ),
    _NavigationItem(
      'Nhiệm vụ',
      Icons.checklist_rtl_outlined,
      Icons.checklist_rtl_rounded,
    ),
    _NavigationItem(
      'Phê duyệt',
      Icons.fact_check_outlined,
      Icons.fact_check_rounded,
    ),
    _NavigationItem('Tài khoản', Icons.person_outline, Icons.person_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationSocketProvider);
    final isOwner =
        ref.watch(authControllerProvider).value?.role == AccountRole.farmOwner;
    final items = isOwner ? _ownerItems : _technicianItems;
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
            height: isOwner ? 64 : 72,
            child: Row(
              children: List<Widget>.generate(items.length, (index) {
                final item = items[index];
                final selected = navigationShell.currentIndex == index;
                return Expanded(
                  child: Semantics(
                    selected: selected,
                    button: true,
                    label: item.label,
                    child: InkWell(
                      onTap: () {
                        if (isOwner && index == 1) {
                          context.go('/farms');
                        } else if (isOwner && index == 3) {
                          context.go('/approvals');
                        } else if (!isOwner && index == 1) {
                          context.go('/seasons');
                        } else if (!isOwner && index == 3) {
                          context.go('/notifications');
                        } else {
                          navigationShell.goBranch(
                            index,
                            initialLocation:
                                index == navigationShell.currentIndex,
                          );
                        }
                      },
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
  const _NavigationItem(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
