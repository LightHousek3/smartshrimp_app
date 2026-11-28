import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/tab_page_layout.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/technician_dashboard_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/dashboard_widgets.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/technician_overview_cards.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/technician_operation_row.dart';

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
    return TabPageLayout(
      title: name == null || name.isEmpty ? 'Xin chào' : 'Chào, $name',
      subtitle: state.value == null ? null : _greetingDate(state.value!.date),
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
            state.when(
              skipLoadingOnRefresh: false,
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => SliverFillRemaining(
                child: Center(
                  child: AppErrorState(
                    error: error,
                    onRetry: () => ref.invalidate(technicianDashboardProvider),
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
                      const _SectionEmpty(
                        AppSvgIconName.shieldOutline,
                        'Chưa ghi nhận vấn đề vận hành cần chú ý.',
                      ),
                    for (final (index, alert) in dashboard.alerts.indexed)
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: index == dashboard.alerts.length - 1 ? 0 : 8,
                        ),
                        child: TechnicianAlertCard(alert),
                      ),
                    DashboardSectionTitle(
                      'Nhiệm vụ cần làm',
                      topSpacing: 4,
                      trailing: TextButton(
                        style: technicianDashboardLinkStyle(context),
                        onPressed: () => context.go('/tasks'),
                        child: const Text('Nhiệm vụ'),
                      ),
                    ),
                    if (dashboard.tasks.isEmpty)
                      const _SectionEmpty(
                        AppSvgIconName.tasks,
                        'Không có nhiệm vụ đang mở.',
                      )
                    else
                      TechnicianTaskPreview(
                        tasks: dashboard.tasks,
                        now: dashboard.serverNow,
                      ),
                    const DashboardSectionTitle('Vận hành còn lại hôm nay'),
                    if (dashboard.operationGroups.isEmpty)
                      const _SectionEmpty(
                        AppSvgIconName.calendarDays,
                        'Không có lượt vận hành nào còn lại hôm nay.',
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
                      const _SectionEmpty(
                        AppSvgIconName.shrimp,
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
    );
  }
}

class _SectionEmpty extends StatelessWidget {
  const _SectionEmpty(this.icon, this.message);
  final AppSvgIconName icon;
  final String message;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppSvgIcon(icon, color: AppColors.inkSoft, size: 25),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.inkSoft,
              height: 1.5,
            ),
          ),
        ],
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
