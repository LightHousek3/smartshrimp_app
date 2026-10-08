import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';

class OperationStatsPage extends ConsumerWidget {
  const OperationStatsPage({required this.seasonId, super.key});

  final String seasonId;

  Widget _buildSummaryCard({
    required String label,
    required String value,
    Color? color,
  }) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.inkMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color ?? AppColors.ink,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildTypeProgressRow({
    required String label,
    required int total,
    required int completed,
    required Color color,
  }) {
    final pct = total > 0 ? completed / total : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              Text(
                '$completed / $total (${(pct * 100).toStringAsFixed(0)}%)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: const Color(0xFFEFF2F7),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(operationStatsProvider(seasonId));
    final listState = ref.watch(operationListProvider(seasonId)).value;
    final subtitle = [
      if (listState?.pondName != null) listState!.pondName,
      if (listState?.seasonName != null) listState!.seasonName,
    ].join(' · ');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: statsAsync.when(
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
                    onPressed: () =>
                        ref.refresh(operationStatsProvider(seasonId)),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
            data: (stats) => CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                StickyPageHeader(
                  title: 'Thống kê vận hành',
                  subtitle: subtitle.isNotEmpty ? subtitle : null,
                  onBack: context.pop,
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Overall rate card with account-page background
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/profile_background.png',
                              ),
                              fit: BoxFit.cover,
                            ),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Color(0x33205080),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: const LinearGradient(
                                colors: <Color>[
                                  Color(0xCC1467B5),
                                  Color(0x4412BDD0),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text(
                                        'Tỷ lệ hoàn thành kế hoạch',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          shadows: <Shadow>[
                                            Shadow(
                                              color: Color(0x55000000),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.22,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.35,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          '${stats.completed}/${stats.total} lịch',
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '${stats.completionRate.toStringAsFixed(1)}%',
                                    style: const TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                      shadows: <Shadow>[
                                        Shadow(
                                          color: Color(0x44000000),
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: stats.completionRate / 100.0,
                                      minHeight: 8,
                                      backgroundColor: Colors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Metric Grid
                        Row(
                          children: <Widget>[
                            _buildSummaryCard(
                              label: 'Tổng số lịch',
                              value: '${stats.total}',
                            ),
                            const SizedBox(width: 10),
                            _buildSummaryCard(
                              label: 'Đã hoàn thành',
                              value: '${stats.completed}',
                              color: const Color(0xFF0F9B8E),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            _buildSummaryCard(
                              label: 'Chờ thực hiện',
                              value: '${stats.planned}',
                              color: const Color(0xFF1378D1),
                            ),
                            const SizedBox(width: 10),
                            _buildSummaryCard(
                              label: 'Đã quá hạn',
                              value: '${stats.overdue}',
                              color: stats.overdue > 0
                                  ? AppColors.error
                                  : AppColors.inkMuted,
                            ),
                            const SizedBox(width: 10),
                            _buildSummaryCard(
                              label: 'Đã hủy',
                              value: '${stats.cancelled}',
                              color: AppColors.inkMuted,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // By Type Breakdown Card
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.02),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Text(
                                'Theo loại hoạt động',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildTypeProgressRow(
                                label: 'Cho ăn',
                                total: stats.byType['feeding']?.total ?? 0,
                                completed:
                                    stats.byType['feeding']?.completed ?? 0,
                                color: const Color(0xFF0F9B8E),
                              ),
                              _buildTypeProgressRow(
                                label: 'Khoáng',
                                total: stats.byType['mineral']?.total ?? 0,
                                completed:
                                    stats.byType['mineral']?.completed ?? 0,
                                color: const Color(0xFF1378D1),
                              ),
                              _buildTypeProgressRow(
                                label: 'Hóa chất',
                                total: stats.byType['chemical']?.total ?? 0,
                                completed:
                                    stats.byType['chemical']?.completed ?? 0,
                                color: const Color(0xFF7B5BD6),
                              ),
                              _buildTypeProgressRow(
                                label: 'Thuốc điều trị',
                                total: stats.byType['medicine']?.total ?? 0,
                                completed:
                                    stats.byType['medicine']?.completed ?? 0,
                                color: AppColors.error,
                              ),
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
      ),
    );
  }
}
