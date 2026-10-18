import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/owner_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/dashboard_widgets.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/finance_panel.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/owner_overview_cards.dart';

class OwnerHomePage extends ConsumerWidget {
  const OwnerHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(ownerDashboardProvider);
    // Load once with Home, rather than tying the request to chart visibility while scrolling.
    ref.watch(ownerFinanceProvider);
    final name = ref
        .watch(authControllerProvider)
        .value
        ?.fullName
        ?.trim()
        .split(RegExp(r'\s+'))
        .last;
    final date = state.value?.date;
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(ownerFinanceProvider);
            ref.invalidate(ownerDashboardProvider);
            await ref.read(ownerDashboardProvider.future);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              StickyPageHeader(
                title: name == null || name.isEmpty
                    ? 'Xin chào'
                    : 'Xin chào, $name',
                subtitle: date == null ? null : _greetingDate(date),
                showBack: false,
                height: 86,
                contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                titleSize: 22,
                titleStyle: dashboardDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              state.when(
                skipLoadingOnRefresh: false,
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => SliverFillRemaining(
                  child: Center(
                    child: DashboardFailure(
                      error: error,
                      onRetry: () => ref.invalidate(ownerDashboardProvider),
                    ),
                  ),
                ),
                data: (dashboard) => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                  sliver: SliverList.list(
                    children: [
                      DashboardSummaryRow(dashboard.summary),
                      const DashboardSectionTitle('Cảnh báo quan trọng'),
                      if (dashboard.alerts.isEmpty)
                        const DashboardEmptyState(
                          key: Key('owner-alerts-empty'),
                          title: 'Không có cảnh báo quan trọng',
                          hint: 'Các cảnh báo cần chú ý sẽ xuất hiện ở đây.',
                        ),
                      for (int i = 0; i < dashboard.alerts.length; i++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: i == dashboard.alerts.length - 1 ? 8 : 16,
                          ),
                          child: DashboardAlertCard(dashboard.alerts[i]),
                        ),
                      const DashboardSectionTitle('Vụ đang nuôi'),
                      if (dashboard.seasons.isEmpty)
                        const DashboardCard(
                          child: Text(
                            'Chưa có vụ nuôi đang hoạt động.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ),
                      for (final season in dashboard.seasons)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: DashboardSeasonCard(season),
                        ),
                      const DashboardSectionTitle('Kho vật tư'),
                      if (dashboard.inventories.isEmpty)
                        const DashboardCard(
                          child: Text(
                            'Chưa có trang trại.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ),
                      for (final inventory in dashboard.inventories)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: DashboardInventoryCard(inventory),
                        ),
                      FinancePanel(
                        farms: dashboard.financeFarms,
                        today: DateTime.parse(dashboard.date),
                      ),
                      const DashboardSectionTitle('Nhân sự'),
                      DashboardCard(
                        onTap: () => context.push('/personnel'),
                        child: Row(
                          children: [
                            const DashboardIconTile(
                              AppSvgIconName.users,
                              color: dashboardTeal,
                              background: Color(0xFFE1F6F3),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${dashboard.personnel.technicians} KTV · ${dashboard.personnel.experts} Chuyên gia',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.ink,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '${dashboard.personnel.active} đang hoạt động',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.inkMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const AppSvgIcon(AppSvgIconName.chevron, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _greetingDate(String date) {
  final value = DateTime.parse(date);
  const weekdays = [
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ Nhật',
  ];
  return '${weekdays[value.weekday - 1]}, ${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}
