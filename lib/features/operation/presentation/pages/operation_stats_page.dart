import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_type_badge.dart';

class OperationStatsPage extends ConsumerWidget {
  const OperationStatsPage({required this.seasonId, super.key});

  final String seasonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = operationStatsProvider(seasonId);
    final state = ref.watch(provider);
    final stats = state.asData?.value;
    final subtitle = [
      stats?.pondName,
      stats?.seasonName,
    ].whereType<String>().join(' · ');

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              StickyPageHeader(
                title: 'Thống kê vận hành',
                subtitle: subtitle.isEmpty ? null : subtitle,
                onBack: context.pop,
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                sliver: SliverToBoxAdapter(
                  child: state.when(
                    loading: () => const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, _) => AppErrorState(
                      error: error,
                      onRetry: () => ref.invalidate(provider),
                    ),
                    data: (stats) => stats.progress == null
                        ? AppErrorState(onRetry: () => ref.invalidate(provider))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _SeasonProgress(progress: stats.progress!),
                              if (stats.materialProgress
                                  case final counts?) ...[
                                const SizedBox(height: 14),
                                _MaterialProgress(counts: counts),
                              ],
                            ],
                          ),
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

class _SeasonProgress extends StatelessWidget {
  const _SeasonProgress({required this.progress});

  final OperationProgress progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: const Color(0xFF13579B),
            borderRadius: BorderRadius.circular(24),
            image: const DecorationImage(
              image: AssetImage('assets/images/profile_background.png'),
              fit: BoxFit.cover,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33205080),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xCC1467B5), Color(0x4412BDD0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tỷ lệ đã ghi nhận toàn vụ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                if (progress.started > 0) ...[
                  Text(
                    _percentageText(progress),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress.fraction,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  progress.started == 0
                      ? 'Chưa có lượt đã đến giờ'
                      : '${progress.completed}/${progress.started} lượt đã đến giờ',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
          children: [
            TableRow(
              children: [
                _SummaryCard(
                  label: 'Đã hoàn thành',
                  count: progress.completed,
                  color: const Color(0xFF0F766E),
                ),
                _SummaryCard(
                  label: 'Chờ thực hiện',
                  count: progress.waiting,
                  color: AppColors.ocean,
                ),
              ],
            ),
            TableRow(
              children: [
                _SummaryCard(
                  label: 'Quá hạn',
                  count: progress.overdue,
                  color: AppColors.error,
                ),
                _SummaryCard(
                  label: 'Đã khóa ghi nhận',
                  count: progress.lockedUnrecorded,
                  color: AppColors.inkSoft,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

String _percentageText(OperationCompletion completion) {
  final percent = completion.percentage;
  final decimals = percent % 1 == 0 ? 0 : 1;
  return '${percent.toStringAsFixed(decimals).replaceFirst('.', ',')}%';
}

class _MaterialProgress extends StatelessWidget {
  const _MaterialProgress({required this.counts});

  final Map<String, OperationCompletion> counts;

  @override
  Widget build(BuildContext context) {
    final types = OperationType.values.where(
      (type) => (counts[type.name]?.started ?? 0) > 0,
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Tỷ lệ ghi nhận theo nhóm vật tư',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            types.isEmpty
                ? 'Chưa có lượt dùng vật tư đã đến giờ.'
                : 'Tính theo từng vật tư trong các lượt đã đến giờ.',
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
          ),
          for (final type in types) ...[
            const SizedBox(height: 16),
            _MaterialProgressRow(type: type, completion: counts[type.name]!),
          ],
        ],
      ),
    );
  }
}

class _MaterialProgressRow extends StatelessWidget {
  const _MaterialProgressRow({required this.type, required this.completion});

  final OperationType type;
  final OperationCompletion completion;

  @override
  Widget build(BuildContext context) {
    final visuals = OperationTypeVisuals.of(type);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(materialCategoryLabel(type))),
            const SizedBox(width: 8),
            Text(
              _percentageText(completion),
              style: TextStyle(color: visuals.fg, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: LinearProgressIndicator(
            value: completion.fraction,
            backgroundColor: visuals.bg,
            color: visuals.fg,
            borderRadius: BorderRadius.circular(6),
            minHeight: 6,
          ),
        ),
        Text(
          '${completion.completed}/${completion.started} lượt dùng đã đến giờ',
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.count,
    required this.color,
  });

  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(4),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.inkMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
