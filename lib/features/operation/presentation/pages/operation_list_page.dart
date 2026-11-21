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

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _pickPastDate(
    BuildContext context,
    WidgetRef ref,
    DateTime currentDate,
    DateTime today,
    DateTime? seasonStartDate,
  ) async {
    // 1. Chỉ cho phép ngày quá khứ: Giới hạn tối đa là ngày hôm qua (trước ngày hôm nay)
    final yesterday = today.subtract(const Duration(days: 1));
    final lastDate = DateTime(yesterday.year, yesterday.month, yesterday.day);

    // 2. Giới hạn tối thiểu từ ngày bắt đầu vụ nuôi (stockingDate hoặc createdAt)
    final normalizedSeasonStart = seasonStartDate != null
        ? DateTime(
            seasonStartDate.year,
            seasonStartDate.month,
            seasonStartDate.day,
          )
        : null;
    final firstDate = normalizedSeasonStart ??
        today.subtract(const Duration(days: 365));

    // 3. Nếu vụ nuôi mới bắt đầu từ hôm nay hoặc trong tương lai (firstDate > lastDate)
    if (firstDate.isAfter(lastDate)) {
      final startFmt =
          '${firstDate.day.toString().padLeft(2, '0')}/${firstDate.month.toString().padLeft(2, '0')}/${firstDate.year}';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vụ nuôi bắt đầu từ ngày $startFmt, chưa có lịch vận hành trong quá khứ.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 4. Xác định initialDate an toàn nằm trong [firstDate, lastDate]
    DateTime initialDate;
    if (currentDate.isBefore(today)) {
      if (currentDate.isBefore(firstDate)) {
        initialDate = firstDate;
      } else if (currentDate.isAfter(lastDate)) {
        initialDate = lastDate;
      } else {
        initialDate = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );
      }
    } else {
      initialDate = lastDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'CHỌN NGÀY VẬN HÀNH TRONG QUÁ KHỨ',
      cancelText: 'Hủy',
      confirmText: 'Xem lịch',
    );
    if (picked != null) {
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
      Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: AppColors.ink,
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

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dayAfterTomorrow = today.add(const Duration(days: 2));

    final isToday = _isSameDay(selectedDate, today);
    final isTomorrow = _isSameDay(selectedDate, tomorrow);
    final isDayAfter = _isSameDay(selectedDate, dayAfterTomorrow);
    final isPast = selectedDate.isBefore(today);

    final result = listState.value;
    final isReloading = listState.isLoading && result != null;

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

      final seasonDetail =
          ref.watch(assignedSeasonDetailProvider(seasonId)).asData?.value;
      final seasonStartDate = result.seasonStartDate ??
          seasonDetail?.stockingDate ??
          seasonDetail?.assignedAt;

      // 1. Phân loại theo cụm nghiệp vụ:
      // - Toàn bộ lịch thuộc phác đồ điều trị (isTreatment) hoặc thức ăn/thuốc phác đồ nuôi
      //   được đưa vào gom nhóm Cữ & Box Điều trị
      // - Các lịch khoáng & hóa chất thông thường (phác đồ nuôi) hiển thị riêng
      final mealAndTreatmentSchedules = result.schedules
          .where(
            (s) =>
                s.isTreatment ||
                s.operationType == OperationType.feeding ||
                s.operationType == OperationType.medicine,
          )
          .toList(growable: false);

      final mineralAndChemicalRaw = result.schedules
          .where(
            (s) =>
                !s.isTreatment &&
                (s.operationType == OperationType.mineral ||
                    s.operationType == OperationType.chemical ||
                    s.operationType == OperationType.other),
          )
          .toList(growable: false);

      // 2. Gom nhóm Cữ ăn và Box Điều trị
      final allMealGroups =
          FeedingMedicineMealGroup.group(mealAndTreatmentSchedules);

      // 3. Lọc theo Tab trạng thái (đồng bộ tuyệt đối với overallStatus của cữ)
      final filteredMealGroups = switch (activeTab) {
        'PLANNED' => allMealGroups
            .where((g) => g.overallStatus == OperationStatus.planned)
            .toList(growable: false),
        'COMPLETED' => allMealGroups
            .where((g) => g.overallStatus == OperationStatus.completed)
            .toList(growable: false),
        'CANCELLED' => allMealGroups
            .where((g) => g.overallStatus == OperationStatus.cancelled)
            .toList(growable: false),
        _ => allMealGroups,
      };

      final filteredMineralAndChemical = switch (activeTab) {
        'PLANNED' =>
          mineralAndChemicalRaw
              .where((s) => s.status == OperationStatus.planned)
              .toList(growable: false),
        'COMPLETED' =>
          mineralAndChemicalRaw
              .where((s) => s.status == OperationStatus.completed)
              .toList(growable: false),
        'CANCELLED' =>
          mineralAndChemicalRaw
              .where((s) => s.status == OperationStatus.cancelled)
              .toList(growable: false),
        _ => mineralAndChemicalRaw,
      };

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
                  child: const Row(
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
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 1. Top 3 stats cards (chỉ hiển thị số liệu thống kê)
                    OperationStatsBar(
                      summary: result.summary,
                    ),
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
                            onTap: () => _pickPastDate(
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
                    AnimatedOpacity(
                      opacity: isReloading ? 0.55 : 1.0,
                      duration: const Duration(milliseconds: 180),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                title: 'Cữ ăn & thuốc theo cữ',
                                iconColor: _blueFg,
                                iconBg: _blueBg,
                              ),
                              const SizedBox(height: 10),
                              for (final group
                                  in filteredMealGroups) ...<Widget>[
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
                                title: 'Xử lý khoáng / hóa chất',
                                iconColor: const Color(0xFF0D9488),
                                iconBg: const Color(0xFFE6FFFA),
                              ),
                              const SizedBox(height: 10),
                              for (final s
                                  in filteredMineralAndChemical) ...<Widget>[
                                OperationScheduleCard(
                                  schedule: s,
                                  onTap: () => context.push(
                                    '/seasons/$seasonId/operations/${s.id}',
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ],
                          ],
                        ],
                      ),
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
