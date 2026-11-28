import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/home/domain/entities/technician_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/dashboard_widgets.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_meal_group_card.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_type_badge.dart';

class TechnicianOperationRow extends StatelessWidget {
  const TechnicianOperationRow(this.group, {super.key});

  final TechnicianOperationGroup group;

  @override
  Widget build(BuildContext context) {
    final hasOccurrenceKeys = group.items.every(
      (item) => item.occurrenceKey != null,
    );
    final occurrences = <String, List<TechnicianOperation>>{};
    if (hasOccurrenceKeys) {
      for (final item in group.items) {
        (occurrences[item.occurrenceKey!] ??= []).add(item);
      }
    }
    final meals = <List<TechnicianOperation>>[];
    final environmental = <List<TechnicianOperation>>[];
    for (final items in occurrences.values) {
      (items.any(_belongsToMeal) ? meals : environmental).add(items);
    }
    final count =
        group.occurrenceCount ??
        (hasOccurrenceKeys ? occurrences.length : null);

    return Padding(
      key: Key('daily-operations-${group.seasonId}'),
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const AppSvgIcon(
                AppSvgIconName.pin,
                size: 15,
                color: AppColors.ocean,
              ),
              const SizedBox(width: 5),
              Expanded(
                flex: 2,
                child: Text(
                  '${group.pondName} · ${group.farmName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      '$count lượt vận hành',
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 2, bottom: 8),
            child: Text(
              group.seasonName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
            ),
          ),
          if (!hasOccurrenceKeys)
            TextButton(
              onPressed: () =>
                  context.push('/seasons/${group.seasonId}/operations'),
              child: const Text('Xem lịch vận hành'),
            ),
          if (meals.isNotEmpty)
            _OperationPreviewSection(
              occurrences: meals,
              seasonId: group.seasonId,
            ),
          if (environmental.isNotEmpty)
            _OperationPreviewSection(
              occurrences: environmental,
              seasonId: group.seasonId,
              environmental: true,
            ),
        ],
      ),
    );
  }

  static bool _belongsToMeal(TechnicianOperation item) =>
      OperationType.parse(item.operationType).belongsToMeal(
        mealNumber: item.mealNumber,
        productionMealId: item.productionMealId,
      );
}

class _OperationPreviewSection extends StatelessWidget {
  const _OperationPreviewSection({
    required this.occurrences,
    required this.seasonId,
    this.environmental = false,
  });

  final List<List<TechnicianOperation>> occurrences;
  final String seasonId;
  final bool environmental;

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(13) / 13;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (environmental) ...[
          Text(
            operationEnvironmentSectionTitle(
              occurrences.expand(
                (items) => items.map(
                  (item) => OperationType.parse(item.operationType),
                ),
              ),
            ),
            style: const TextStyle(fontSize: 12, color: AppColors.inkSoft),
          ),
          const SizedBox(height: 6),
        ],
        SizedBox(
          height: 66 + 38 * textScale,
          child: LayoutBuilder(
            builder: (_, constraints) => ListView.separated(
              padding: const EdgeInsets.only(bottom: 8),
              scrollDirection: Axis.horizontal,
              itemCount: occurrences.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, index) => SizedBox(
                width: (164 * textScale)
                    .clamp(164.0, constraints.maxWidth.clamp(164.0, 300.0))
                    .toDouble(),
                child: _OperationPreview(
                  occurrences[index],
                  seasonId: seasonId,
                  environmental: environmental,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OperationPreview extends StatelessWidget {
  const _OperationPreview(
    this.items, {
    required this.seasonId,
    required this.environmental,
  });

  final List<TechnicianOperation> items;
  final String seasonId;
  final bool environmental;

  @override
  Widget build(BuildContext context) {
    final first = items.first;
    final target = items.firstWhere(
      (item) =>
          OperationType.parse(item.operationType) == OperationType.feeding,
      orElse: () => first,
    );
    final dueAt = items.fold(
      first.dueAt,
      (end, item) => item.dueAt.isAfter(end) ? item.dueAt : end,
    );
    final title = environmental
        ? items.length > 1
              ? 'Xử lý môi trường'
              : first.productName ??
                    materialCategoryLabel(
                      OperationType.parse(first.operationType),
                    )
        : operationMealTitle(
            mealNumber: first.mealNumber,
            isTreatment: first.isTreatment,
          );
    final color = first.isTreatment ? AppColors.treatmentAccent : AppColors.ink;

    return DashboardCard(
      key: ValueKey(first.occurrenceKey),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      onTap: () => context.push(
        '/seasons/$seasonId/operations/${target.id}?date=${vietnamDate(target.scheduledAt)}',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              OperationOccurrenceIcon(
                isTreatment: first.isTreatment,
                environmental: environmental,
                size: 30,
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.inkMuted,
                size: 17,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            operationTimeRange(first.scheduledAt, dueAt),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}
