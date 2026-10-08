import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_schedule_card.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_stats_bar.dart';

class OperationListPage extends ConsumerWidget {
  const OperationListPage({required this.seasonId, super.key});

  final String seasonId;

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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? AppColors.ocean : const Color(0xFFEDF5FF),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : AppColors.inkSoft,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
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
        child: Icon(icon, color: iconColor, size: 16),
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: listState.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.ocean),
            ),
            error: (err, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Lỗi: $err',
                    style: const TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref
                        .read(operationListProvider(seasonId).notifier)
                        .refresh(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
            data: (result) {
              final filteredSchedules = switch (activeTab) {
                'PLANNED' =>
                  result.schedules
                      .where((s) => s.status == OperationStatus.planned)
                      .toList(growable: false),
                'COMPLETED' =>
                  result.schedules
                      .where((s) => s.status == OperationStatus.completed)
                      .toList(growable: false),
                'CANCELLED' =>
                  result.schedules
                      .where((s) => s.status == OperationStatus.cancelled)
                      .toList(growable: false),
                _ => result.schedules,
              };

              final feedingAndMedicine = filteredSchedules
                  .where(
                    (s) =>
                        s.operationType == OperationType.feeding ||
                        s.operationType == OperationType.medicine,
                  )
                  .toList(growable: false);

              final mineralAndChemical = filteredSchedules
                  .where(
                    (s) =>
                        s.operationType == OperationType.mineral ||
                        s.operationType == OperationType.chemical ||
                        s.operationType == OperationType.other,
                  )
                  .toList(growable: false);

              final subtitle = [
                if (result.pondName != null) result.pondName,
                if (result.seasonName != null) result.seasonName,
              ].join(' · ');

              return RefreshIndicator(
                onRefresh: () => ref
                    .read(operationListProvider(seasonId).notifier)
                    .refresh(),
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
                            color: const Color(0xFFE0F2FE),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.ocean.withValues(alpha: 0.35),
                              width: 1.2,
                            ),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppColors.ocean.withValues(alpha: 0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.bar_chart_rounded,
                                size: 18,
                                color: AppColors.ocean,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Thống kê',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ocean,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Top stats section title & link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  'Tiến độ hôm nay',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => context.push(
                                    '/seasons/$seasonId/operations/stats',
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 2,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          'Xem báo cáo chi tiết',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.ocean,
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Icon(
                                          Icons.chevron_right_rounded,
                                          size: 16,
                                          color: AppColors.ocean,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Top 3 stats cards (tap to open detailed stats)
                            InkWell(
                              onTap: () => context.push(
                                '/seasons/$seasonId/operations/stats',
                              ),
                              borderRadius: BorderRadius.circular(18),
                              child: OperationStatsBar(
                                summary: result.summary,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Warning banner if biomass missing
                            if (result.banner.hasBiomassWarning) ...<Widget>[
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF3E0),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFFFB74D,
                                    ).withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Color(0xFFE65100),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const Text(
                                            'Chưa thể sinh lịch kế tiếp',
                                            style: TextStyle(
                                              color: Color(0xFFBF360C),
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            result.banner.message ??
                                                'Chưa có bản ghi sinh khối hợp lệ trong 3 ngày — không thể tính liều theo % sinh khối.',
                                            style: const TextStyle(
                                              color: Color(0xFFD84315),
                                              fontSize: 11.5,
                                              height: 1.35,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                            ],

                            // 4 Tabs: Tất cả / Chờ làm / Hoàn thành / Đã hủy
                            Row(
                              children: <Widget>[
                                _buildTabButton(
                                  context,
                                  ref,
                                  label: 'Tất cả',
                                  tabKey: 'ALL',
                                  activeTab: activeTab,
                                ),
                                const SizedBox(width: 8),
                                _buildTabButton(
                                  context,
                                  ref,
                                  label: 'Chờ làm',
                                  tabKey: 'PLANNED',
                                  activeTab: activeTab,
                                ),
                                const SizedBox(width: 8),
                                _buildTabButton(
                                  context,
                                  ref,
                                  label: 'Hoàn thành',
                                  tabKey: 'COMPLETED',
                                  activeTab: activeTab,
                                ),
                                const SizedBox(width: 8),
                                _buildTabButton(
                                  context,
                                  ref,
                                  label: 'Đã hủy',
                                  tabKey: 'CANCELLED',
                                  activeTab: activeTab,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // If totally empty for this tab
                            if (filteredSchedules.isEmpty) ...<Widget>[
                              _buildEmptyGroupBox(
                                icon: Icons.assignment_outlined,
                                message: 'Không có lịch vận hành phù hợp',
                              ),
                            ] else ...<Widget>[
                              // Group 1: Cữ ăn & thuốc theo cữ
                              if (feedingAndMedicine.isNotEmpty ||
                                  mineralAndChemical.isNotEmpty) ...<Widget>[
                                _buildSectionHeader(
                                  icon: Icons.restaurant_rounded,
                                  title: 'Cữ ăn & thuốc theo cữ',
                                  iconColor: const Color(0xFF0F9B8E),
                                  iconBg: const Color(0xFFE2F6F3),
                                ),
                                const SizedBox(height: 10),
                                if (feedingAndMedicine.isEmpty)
                                  _buildEmptyGroupBox(
                                    icon: Icons.restaurant_rounded,
                                    message: 'Không có cữ ăn hoặc thuốc',
                                  )
                                else
                                  for (final s
                                      in feedingAndMedicine) ...<Widget>[
                                    OperationScheduleCard(
                                      schedule: s,
                                      onTap: () => context.push(
                                        '/seasons/$seasonId/operations/${s.id}',
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                const SizedBox(height: 16),

                                // Group 2: Xử lý khoáng / hóa chất
                                _buildSectionHeader(
                                  icon: Icons.science_rounded,
                                  title: 'Xử lý khoáng / hóa chất',
                                  iconColor: const Color(0xFF7B5BD6),
                                  iconBg: const Color(0xFFF0E9FF),
                                ),
                                const SizedBox(height: 10),
                                if (mineralAndChemical.isEmpty)
                                  _buildEmptyGroupBox(
                                    icon: Icons.science_rounded,
                                    message: 'Không có xử lý khoáng/hóa chất',
                                  )
                                else
                                  for (final s
                                      in mineralAndChemical) ...<Widget>[
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
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
