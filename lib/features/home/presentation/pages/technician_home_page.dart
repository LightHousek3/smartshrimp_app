import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/technician_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/dashboard_widgets.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/technician_overview_cards.dart';

class TechnicianHomePage extends ConsumerWidget {
  const TechnicianHomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(technicianDashboardProvider);
    final name = ref
        .watch(authControllerProvider.select((state) => state.value?.fullName))
        ?.trim()
        .split(RegExp(r'\s+'))
        .last;
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            // The watched provider publishes any reload error in the page's error state.
            await AsyncValue.guard(
              () => ref.refresh(technicianDashboardProvider.future),
            );
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              StickyPageHeader(
                title: name == null || name.isEmpty
                    ? 'Xin chào'
                    : 'Chào, $name',
                subtitle: state.value == null
                    ? null
                    : _greetingDate(state.value!.date),
                showBack: false,
                height: 86,
                titleSize: 22,
                contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
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
                      onRetry: () =>
                          ref.invalidate(technicianDashboardProvider),
                    ),
                  ),
                ),
                data: (dashboard) => SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                  sliver: SliverList.list(
                    children: [
                      TechnicianSummaryRow(dashboard.summary),
                      const DashboardSectionTitle('Cần chú ý'),
                      if (dashboard.alerts.isEmpty)
                        const _CompactEmpty(
                          'Chưa ghi nhận vấn đề vận hành cần chú ý.',
                        ),
                      for (final alert in dashboard.alerts)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TechnicianAlertCard(alert),
                        ),
                      DashboardSectionTitle(
                        'Nhiệm vụ cần làm',
                        trailing: TextButton(
                          style: technicianDashboardLinkStyle(context),
                          onPressed: () => context.go('/tasks'),
                          child: const Text('Nhiệm vụ'),
                        ),
                      ),
                      if (dashboard.tasks.isEmpty)
                        const _CompactEmpty('Không có nhiệm vụ đang mở.')
                      else
                        TechnicianTaskPreview(
                          tasks: dashboard.tasks,
                          now: dashboard.serverNow,
                        ),
                      const DashboardSectionTitle('Cữ sắp tới hôm nay'),
                      if (dashboard.operationGroups.isEmpty)
                        const _CompactEmpty(
                          'Không còn cữ đã lên lịch trong hôm nay.',
                        ),
                      for (final group in dashboard.operationGroups)
                        TechnicianOperationRow(
                          group,
                          key: ValueKey('operation-group-${group.seasonId}'),
                        ),
                      DashboardSectionTitle(
                        'Vụ đang nuôi phụ trách',
                        trailing: TextButton(
                          style: technicianDashboardLinkStyle(context),
                          onPressed: () => context.go('/seasons'),
                          child: const Text('Tất cả'),
                        ),
                      ),
                      if (dashboard.seasons.isEmpty)
                        const _CompactEmpty(
                          'Chưa có vụ đang nuôi được phân công.',
                        ),
                      for (final season in dashboard.seasons)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: TechnicianSeasonCard(season),
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

class _CompactEmpty extends StatelessWidget {
  const _CompactEmpty(this.message);
  final String message;
  @override
  Widget build(BuildContext context) => DashboardCard(
    child: Text(
      message,
      style: const TextStyle(
        fontSize: 12,
        color: AppColors.inkMuted,
        height: 1.5,
      ),
    ),
  );
}

String _greetingDate(String date) {
  final value = DateTime.parse(date);
  const days = [
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ Nhật',
  ];
  return '${days[value.weekday - 1]}, ${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}
