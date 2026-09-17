import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';

class MainShell extends ConsumerWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const _items = <_NavigationItem>[
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationSocketProvider);
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
            height: 72,
            child: Row(
              children: List<Widget>.generate(_items.length, (index) {
                final item = _items[index];
                final selected = navigationShell.currentIndex == index;
                return Expanded(
                  child: Semantics(
                    selected: selected,
                    button: true,
                    label: item.label,
                    child: InkWell(
                      onTap: () => navigationShell.goBranch(
                        index,
                        initialLocation: index == navigationShell.currentIndex,
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          if (selected)
                            Container(
                              width: 34,
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
                                  size: 27,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.label,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: selected
                                        ? AppColors.ocean
                                        : AppColors.inkMuted,
                                    fontSize: 11.5,
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
