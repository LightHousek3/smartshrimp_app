import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_meal_group_card.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_schedule_card.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_stats_bar.dart';

class OperationListPage extends ConsumerWidget {
  const OperationListPage({required this.seasonId, super.key});

  final String seasonId;

  static const Color _blueBg = Color(0xFFDEEDFD);
  static const Color _blueFg = Color(0xFF1D7AD6);

  String _fmtDayMonth(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

  Future<void> _pickOperationDate(
    BuildContext context,
    WidgetRef ref,
    DateTime currentDate,
    DateTime today,
    DateTime? seasonStartDate,
  ) async {
    final lastDate = today.add(const Duration(days: 2));
    final seasonStart = seasonStartDate == null
        ? today.subtract(const Duration(days: 365))
        : AssignedSeasonRules.vietnamDay(seasonStartDate);
    final firstDate = seasonStart.isAfter(today) ? today : seasonStart;
    final initialDate = currentDate.isBefore(firstDate)
        ? firstDate
        : currentDate.isAfter(lastDate)
        ? lastDate
        : currentDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      currentDate: today,
      helpText: 'CHỌN NGÀY VẬN HÀNH',
      cancelText: 'Hủy',
      confirmText: 'Xem lịch',
    );
    if (picked != null && context.mounted) {
      await ref
          .read(operationListProvider(seasonId).notifier)
          .selectDate(picked);
    }
  }

  Widget _buildDateSegmentItem({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    IconData? icon,
    int flex = 1,
  }) => Expanded(
    flex: flex,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6.5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? _blueBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...<Widget>[
                Icon(
                  icon,
                  size: 11.5,
                  color: isActive ? _blueFg : AppColors.inkMuted,
                ),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isActive ? _blueFg : AppColors.inkSoft,
                  fontSize: 11.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildTabButton(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required String tabKey,
    required String activeTab,
  }) {
    final isActive = activeTab == tabKey;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref
              .read(operationListProvider(seasonId).notifier)
              .setFilterTab(tabKey);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8.5, horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? _blueFg : Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? <BoxShadow>[
                    BoxShadow(
                      color: _blueFg.withValues(alpha: 0.22),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.inkSoft,
                fontSize: 11.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    IconData? icon,
    AppSvgIconName? svgIcon,
    required String title,
    required Color iconColor,
    required Color iconBg,
  }) => Row(
    children: <Widget>[
      Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: svgIcon != null
              ? AppSvgIcon(svgIcon, color: iconColor, size: 16)
              : Icon(icon, color: iconColor, size: 16),
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.ink,
          ),
        ),
      ),
    ],
  );

  Widget _buildEmptyGroupBox({
    required IconData icon,
    required String message,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: AppColors.line.withValues(alpha: 0.6),
        style: BorderStyle.solid,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.inkMuted, size: 22),
        ),
        const SizedBox(height: 12),
        Text(
          message,
          style: const TextStyle(
            color: AppColors.inkSoft,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listState = ref.watch(operationListProvider(seasonId));
    final activeTab = ref.watch(operationFilterTabProvider);
    final selectedDate = ref.watch(operationDateFilterProvider);

    final today = AssignedSeasonRules.vietnamDay(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfterTomorrow = today.add(const Duration(days: 2));

    final isToday = selectedDate == today;
    final isTomorrow = selectedDate == tomorrow;
    final isDayAfter = selectedDate == dayAfterTomorrow;
    final isPast = selectedDate.isBefore(today);

    final result = listState.asData?.value;

    Widget buildBody() {
      if (result == null) {
        if (listState.hasError) {
          return AppErrorState(
            error: listState.error,
            onRetry: ref.read(operationListProvider(seasonId).notifier).refresh,
          );
        }
        return const Center(child: CircularProgressIndicator(color: _blueFg));
      }

      final seasonDetail = ref
          .watch(assignedSeasonDetailProvider(seasonId))
          .asData
          ?.value;
      final seasonStartDate =
          result.seasonStartDate ??
          seasonDetail?.stockingDate ??
          seasonDetail?.assignedAt;

      // Group occurrences before applying the display section and status filters.
      final groups = FeedingMedicineMealGroup.group([
        ...result.schedules,
        ...result.historicalSchedules,
      ], includeEnvironmental: true);
      final dailySummary = OperationSummary.fromStatuses(
        groups.map((group) => group.overallStatus),
      );

      final selectedStatus = OperationStatus.parse(activeTab);
      final activeGroups = groups.where(
        (group) => group.overallStatus == selectedStatus,
      );
      final filteredMealGroups = activeGroups
          .where((group) => group.belongsToMeal)
          .toList(growable: false);
      final filteredMineralAndChemical = activeGroups
          .where((group) => !group.belongsToMeal)
          .toList(growable: false);

      final isAllEmpty =
          filteredMealGroups.isEmpty && filteredMineralAndChemical.isEmpty;
      final nearestMealGroupKey = FeedingMedicineMealGroup.pickNearestKey(
        filteredMealGroups,
      );

      final subtitle = [
        if (result.pondName != null) result.pondName,
        if (result.seasonName != null) result.seasonName,
      ].join(' · ');

      return RefreshIndicator(
        onRefresh: () =>
            ref.read(operationListProvider(seasonId).notifier).refresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            StickyPageHeader(
              title: 'Vận hành',
              subtitle: subtitle.isNotEmpty ? subtitle : null,
              onBack: context.pop,
              trailing: InkWell(
                onTap: () =>
                    context.push('/seasons/$seasonId/operations/stats'),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _blueBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _blueFg.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: _blueFg.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.bar_chart_rounded, size: 18, color: _blueFg),
                        SizedBox(width: 5),
                        Text(
                          'Thống kê',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: _blueFg,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    OperationStatsBar(summary: dailySummary),
                    const SizedBox(height: 14),

                    // 2. Warning banner if biomass missing
                    if (result.banner.hasBiomassWarning) ...<Widget>[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF5DB),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFF5D08A)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Row(
                              children: <Widget>[
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Color(0xFFB45309),
                                  size: 17,
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    'Chưa thể sinh lịch kế tiếp',
                                    style: TextStyle(
                                      color: Color(0xFFB45309),
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              result.banner.message ??
                                  'Chưa có nguồn sinh khối hợp lệ trong 7 ngày (168 giờ). Nguồn phải còn hạn tại cữ dự kiến.',
                              style: const TextStyle(
                                color: Color(0xFFC25E00),
                                fontSize: 12,
                                height: 1.4,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    // 3. 3 Tabs: Chờ làm / Hoàn thành / Đã hủy (mặc định Chờ làm)
                    Row(
                      children: <Widget>[
                        _buildTabButton(
                          context,
                          ref,
                          label: 'Chờ làm',
                          tabKey: 'PLANNED',
                          activeTab: activeTab,
                        ),
                        const SizedBox(width: 6),
                        _buildTabButton(
                          context,
                          ref,
                          label: 'Hoàn thành',
                          tabKey: 'COMPLETED',
                          activeTab: activeTab,
                        ),
                        const SizedBox(width: 6),
                        _buildTabButton(
                          context,
                          ref,
                          label: 'Đã hủy',
                          tabKey: 'CANCELLED',
                          activeTab: activeTab,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // 4. THANH FILTER NGÀY dạng Segmented Bar gọn nhẹ (nền trắng mờ, active nền #DEEDFD chữ #1D7AD6)
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.025),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          _buildDateSegmentItem(
                            label: 'Hôm nay',
                            isActive: isToday,
                            flex: 3,
                            onTap: () => ref
                                .read(operationListProvider(seasonId).notifier)
                                .selectDate(today),
                          ),
                          _buildDateSegmentItem(
                            label: _fmtDayMonth(tomorrow),
                            isActive: isTomorrow,
                            flex: 2,
                            onTap: () => ref
                                .read(operationListProvider(seasonId).notifier)
                                .selectDate(tomorrow),
                          ),
                          _buildDateSegmentItem(
                            label: _fmtDayMonth(dayAfterTomorrow),
                            isActive: isDayAfter,
                            flex: 2,
                            onTap: () => ref
                                .read(operationListProvider(seasonId).notifier)
                                .selectDate(dayAfterTomorrow),
                          ),
                          Container(
                            width: 1,
                            height: 16,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            color: AppColors.line.withValues(alpha: 0.9),
                          ),
                          _buildDateSegmentItem(
                            label: isPast
                                ? _fmtDayMonth(selectedDate)
                                : 'Chọn ngày',
                            icon: Icons.calendar_today_rounded,
                            isActive: isPast,
                            flex: 3,
                            onTap: () => _pickOperationDate(
                              context,
                              ref,
                              selectedDate,
                              today,
                              seasonStartDate,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 5. Danh sách lịch vận hành
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (result.historicalFeedingAvailable &&
                            activeTab == 'PLANNED')
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Card(
                              child: ListTile(
                                leading: Icon(
                                  Icons.history_rounded,
                                  color: _blueFg,
                                ),
                                title: Text('Vụ kích hoạt muộn'),
                                subtitle: Text(
                                  'Chọn ngày có cữ cần ghi nhận bổ sung.',
                                  style: TextStyle(fontSize: 11.5),
                                ),
                              ),
                            ),
                          ),
                        if (isAllEmpty) ...<Widget>[
                          _buildEmptyGroupBox(
                            icon: Icons.assignment_outlined,
                            message: 'Không có lịch vận hành phù hợp',
                          ),
                        ] else ...<Widget>[
                          // Group 1: Cữ ăn & thuốc theo cữ (chỉ hiện khi có dữ liệu)
                          if (filteredMealGroups.isNotEmpty) ...<Widget>[
                            _buildSectionHeader(
                              svgIcon: AppSvgIconName.calendarDays,
                              title: operationMealSectionTitle,
                              iconColor: _blueFg,
                              iconBg: _blueBg,
                            ),
                            const SizedBox(height: 10),
                            for (final group in filteredMealGroups) ...<Widget>[
                              OperationMealGroupCard(
                                key: ValueKey<String>(
                                  '${activeTab}_${group.key}',
                                ),
                                group: group,
                                initiallyExpanded:
                                    group.key == nearestMealGroupKey,
                                onTapDetail: (s) => context.push(
                                  '/seasons/$seasonId/operations/${s.id}',
                                  extra: group,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                            if (filteredMineralAndChemical.isNotEmpty)
                              const SizedBox(height: 16),
                          ],

                          // Group 2: Xử lý khoáng / hóa chất (ẩn hoàn toàn khi không có)
                          if (filteredMineralAndChemical
                              .isNotEmpty) ...<Widget>[
                            _buildSectionHeader(
                              svgIcon: AppSvgIconName.chemical,
                              title: operationEnvironmentSectionTitle(
                                filteredMineralAndChemical.expand(
                                  (group) => group.allSchedules.map(
                                    (schedule) => schedule.operationType,
                                  ),
                                ),
                              ),
                              iconColor: const Color(0xFF0D9488),
                              iconBg: const Color(0xFFE6FFFA),
                            ),
                            const SizedBox(height: 10),
                            for (final group
                                in filteredMineralAndChemical) ...<Widget>[
                              if (group.allSchedules.length == 1)
                                OperationScheduleCard(
                                  schedule: group.allSchedules.single,
                                  onTap: () => context.push(
                                    '/seasons/$seasonId/operations/${group.allSchedules.single.id}',
                                  ),
                                )
                              else
                                OperationMealGroupCard(
                                  key: ValueKey('${activeTab}_${group.key}'),
                                  group: group,
                                  onTapDetail: (s) => context.push(
                                    '/seasons/$seasonId/operations/${s.id}',
                                    extra: group,
                                  ),
                                ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(bottom: false, child: buildBody()),
      ),
    );
  }
}
