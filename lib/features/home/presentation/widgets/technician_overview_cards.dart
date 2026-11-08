import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/home/domain/entities/technician_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/dashboard_widgets.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';

const _amber = Color(0xFFD98314);
const _amberPanel = Color(0xFFFFF7E9);
const _metricNames = {
  'temperatureC': 'Nhiệt độ',
  'ph': 'pH',
  'dissolvedOxygenMgL': 'Oxy hòa tan',
  'salinityPpt': 'Độ mặn',
  'nh3MgL': 'NH₃',
  'no2MgL': 'NO₂',
  'alkalinityMgLCaCO3': 'Độ kiềm',
  'h2sMgL': 'H₂S',
};

// Preserve the app's font family when the shared button theme only overrides weight.
ButtonStyle technicianDashboardLinkStyle(BuildContext context) =>
    TextButton.styleFrom(
      textStyle: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
    );

String technicianTime(DateTime at) {
  final value = vietnamTime(at);
  return '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}

String technicianDateTime(DateTime at) {
  final value = vietnamTime(at);
  return '${technicianTime(at)} ${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
}

/// Display precision never changes a planned dose; very small positive doses remain visible.
String technicianQuantity(double value) {
  if (value != 0 && value.abs() < 0.000000001) {
    return value.toStringAsPrecision(3);
  }
  return value
      .toStringAsFixed(9)
      .replaceFirst(RegExp(r'\.?0+$'), '')
      .replaceAll('.', ',');
}

String _unit(String value) => switch (value) {
  'KG' => 'kg',
  'G' => 'g',
  'L' => 'L',
  'ML' => 'mL',
  'PACK' => 'gói',
  'BOTTLE' => 'chai',
  'PCS' => 'cái',
  _ => value,
};

String _waterRange(TechnicianWaterMetric metric) {
  if (metric.min != null && metric.max != null) {
    return '${technicianQuantity(metric.min!)}–${technicianQuantity(metric.max!)}';
  }
  if (metric.min != null) return '≥ ${technicianQuantity(metric.min!)}';
  if (metric.max != null) return '≤ ${technicianQuantity(metric.max!)}';
  return 'chưa xác định';
}

String _blockerText(TechnicianAlert alert) => alert.reasonCodes
    .map(
      (code) => switch (code) {
        'VOLUME_MISSING' => 'Thiếu thể tích nước hợp lệ.',
        'BIOMASS_MISSING_OR_STALE' =>
          'Thiếu nguồn sinh khối hợp lệ cho cữ dự kiến (tối đa 7 ngày/168 giờ).',
        _ => 'Cữ chưa đủ dữ liệu hợp lệ.',
      },
    )
    .join(' ');

class TechnicianSummaryRow extends StatelessWidget {
  const TechnicianSummaryRow(this.summary, {super.key});
  final TechnicianSummary summary;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: _SummaryCard(
          summary.activeSeasonCount,
          'Vụ đang nuôi',
          dashboardTeal,
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: _SummaryCard(
          summary.openTaskCount,
          'Nhiệm vụ mở',
          AppColors.ocean,
        ),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Tooltip(
          message: 'Ca chưa kết luận trong các vụ đang nuôi phụ trách',
          child: _SummaryCard(
            summary.unresolvedActiveSeasonCaseCount,
            'Ca chưa kết luận',
            AppColors.error,
          ),
        ),
      ),
    ],
  );
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard(this.count, this.label, this.color);
  final int count;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => DashboardCard(
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            '$count',
            style: dashboardDisplay(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            height: 1.4,
            color: AppColors.inkMuted,
          ),
        ),
      ],
    ),
  );
}

/// Navigation uses existing, server-authorized resources; unknown alert kinds remain read-only.
String? technicianAlertLocation(TechnicianAlert alert) => switch (alert.kind) {
  TechnicianAlertKind.water => '/seasons/${alert.seasonId}/water-logs',
  TechnicianAlertKind.overdueOperations =>
    '/seasons/${alert.seasonId}/operations',
  TechnicianAlertKind.scheduleBlocked =>
    alert.reasonCodes.isEmpty ||
            alert.reasonCodes.any(
              (code) => ![
                'VOLUME_MISSING',
                'BIOMASS_MISSING_OR_STALE',
              ].contains(code),
            )
        ? null
        : alert.reasonCodes.contains('VOLUME_MISSING')
        ? '/seasons/${alert.seasonId}'
        : '/seasons/${alert.seasonId}/shrimp-health',
  TechnicianAlertKind.unknown => null,
};

class TechnicianAlertCard extends StatelessWidget {
  const TechnicianAlertCard(this.alert, {super.key});
  final TechnicianAlert alert;

  @override
  Widget build(BuildContext context) {
    final location = technicianAlertLocation(alert);
    final title = switch (alert.kind) {
      TechnicianAlertKind.water => '${alert.count} chỉ số nước ngoài ngưỡng',
      TechnicianAlertKind.overdueOperations =>
        '${alert.count} cữ quá giờ chưa thực hiện',
      TechnicianAlertKind.scheduleBlocked =>
        '${alert.count} cữ chưa đủ dữ liệu tính liều',
      TechnicianAlertKind.unknown => 'Vấn đề vận hành',
    };
    final place = '${alert.pondName} · ${alert.farmName}';
    final details = switch (alert.kind) {
      TechnicianAlertKind.water =>
        alert.metrics
            .map(
              (metric) =>
                  '${_metricNames[metric.field] ?? metric.field}: ${technicianQuantity(metric.value)} ${metric.unit}'
                  ' (ngưỡng ${_waterRange(metric)}; đo ${technicianDateTime(metric.recordedAt)})',
            )
            .join(' · '),
      TechnicianAlertKind.overdueOperations =>
        'Cữ sớm nhất: ${technicianDateTime(alert.observedAt)}',
      TechnicianAlertKind.scheduleBlocked =>
        '${_blockerText(alert)} Cữ sớm nhất: ${technicianDateTime(alert.observedAt)}',
      TechnicianAlertKind.unknown =>
        'Chưa hỗ trợ loại vấn đề này · ${technicianDateTime(alert.observedAt)}',
    };
    // Keep exactly three visible lines; long-press retains every reading and its source time.
    return Tooltip(
      message: '$title\n$place · ${alert.seasonName}\n$details',
      child: Material(
        color: _amberPanel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFF0D4A2)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: location == null ? null : () => context.push(location),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                DashboardIconTile(
                  alert.kind == TechnicianAlertKind.overdueOperations
                      ? AppSvgIconName.clock
                      : AppSvgIconName.warning,
                  color: _amber,
                  background: const Color(0xFFF5E5C6),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        place,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        details,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                if (location != null) ...[
                  const SizedBox(width: 4),
                  const AppSvgIcon(
                    AppSvgIconName.chevron,
                    size: 12,
                    color: _amber,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TechnicianTaskPreview extends StatelessWidget {
  const TechnicianTaskPreview({
    required this.tasks,
    required this.now,
    super.key,
  });
  final List<TaskItem> tasks;
  final DateTime now;
  @override
  Widget build(BuildContext context) => DashboardCard(
    padding: EdgeInsets.zero,
    child: Column(
      children: [
        for (var i = 0; i < tasks.length; i++) ...[
          if (i > 0) const Divider(height: 1, color: AppColors.line),
          InkWell(
            onTap: () => context.push('/tasks/${tasks[i].id}'),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
              child: _TaskRow(tasks[i], now),
            ),
          ),
        ],
      ],
    ),
  );
}

class _TaskRow extends StatelessWidget {
  const _TaskRow(this.task, this.now);
  final TaskItem task;
  final DateTime now;
  @override
  Widget build(BuildContext context) {
    final colors = priorityColors(task.priority);
    final overdue = task.overdueAt(now);
    final due = task.dueAt;
    final deadline = due == null
        ? 'Chưa có hạn'
        : 'Hạn ${vietnamDate(due) == vietnamDate(now) ? technicianTime(due) : technicianDateTime(due)}';
    final deadlineColor = overdue ? AppColors.error : AppColors.inkMuted;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.$1,
            borderRadius: BorderRadius.circular(12),
          ),
          child: AppSvgIcon(AppSvgIconName.tasks, size: 16, color: colors.$2),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  AppSvgIcon(
                    AppSvgIconName.clock,
                    size: 13,
                    color: deadlineColor,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      deadline,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: deadlineColor,
                        fontWeight: overdue ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TaskBadge(taskPriorityLabel(task.priority), colors),
            if (overdue) ...[
              const SizedBox(height: 4),
              const TaskBadge('Quá hạn', (taskRed, AppColors.error)),
            ],
          ],
        ),
      ],
    );
  }
}

/// Seasons stack vertically. Every row lazily renders all remaining cards for that Vietnam day.
class TechnicianOperationRow extends StatelessWidget {
  const TechnicianOperationRow(this.group, {super.key});
  final TechnicianOperationGroup group;
  @override
  Widget build(BuildContext context) => Padding(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${group.pondName} · ${group.farmName}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  Text(
                    group.seasonName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${group.items.length} cữ',
              style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 132 * MediaQuery.textScalerOf(context).scale(1).clamp(1, 2),
          child: ListView.separated(
            key: Key('daily-operations-${group.seasonId}'),
            scrollDirection: Axis.horizontal,
            itemCount: group.items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, index) => SizedBox(
              width:
                  166 * MediaQuery.textScalerOf(context).scale(1).clamp(1, 2),
              child: _OperationCard(group.items[index], group.seasonId),
            ),
          ),
        ),
      ],
    ),
  );
}

class _OperationCard extends StatelessWidget {
  const _OperationCard(this.item, this.seasonId);
  final TechnicianOperation item;
  final String seasonId;
  @override
  Widget build(BuildContext context) {
    final type = OperationType.parse(item.operationType);
    final icon = switch (type) {
      OperationType.feeding => AppSvgIconName.shrimpFeed,
      OperationType.chemical => AppSvgIconName.chemical,
      OperationType.medicine => AppSvgIconName.medicine,
      OperationType.mineral => AppSvgIconName.mineral,
      OperationType.other => AppSvgIconName.document,
    };
    final color = type == OperationType.feeding
        ? dashboardTeal
        : dashboardPurple;
    return DashboardCard(
      padding: const EdgeInsets.all(12),
      onTap: () => context.push('/seasons/$seasonId/operations/${item.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AppSvgIcon(icon, size: 17, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  technicianTime(item.scheduledAt),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            type == OperationType.medicine ? 'Thuốc' : type.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.productName ?? 'Chưa xác định vật tư',
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
          ),
          const SizedBox(height: 6),
          Text(
            '${technicianQuantity(item.plannedQuantity)} ${_unit(item.unit)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.ocean,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class TechnicianSeasonCard extends StatelessWidget {
  const TechnicianSeasonCard(this.season, {super.key});
  final TechnicianSeasonSnapshot season;
  @override
  Widget build(BuildContext context) {
    final biomass = switch (season.biomassState) {
      BiomassSnapshotState.recorded || BiomassSnapshotState.stale =>
        '${dashboardQuantity(season.biomassKg)} kg · '
            '${season.biomassState == BiomassSnapshotState.stale ? 'Số đo cũ · ' : 'Đo '}${technicianDateTime(season.biomassRecordedAt!)}',
      BiomassSnapshotState.afterHarvest => 'Chờ cập nhật sinh khối sau thu tỉa',
      BiomassSnapshotState.populationChanged =>
        'Chờ cập nhật sinh khối theo quần thể mới',
      BiomassSnapshotState.missing => 'Chưa có số đo sinh khối',
      BiomassSnapshotState.unknown => 'Chưa xác định trạng thái sinh khối',
    };
    return DashboardCard(
      onTap: () => context.push('/seasons/${season.seasonId}'),
      child: Row(
        children: [
          const DashboardIconTile(AppSvgIconName.shrimp),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  season.pondName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${season.farmName}${season.cultureDay == null ? '' : ' · DOC ${season.cultureDay}'}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.inkMuted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  biomass,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.inkMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const AppSvgIcon(AppSvgIconName.chevron, size: 12),
        ],
      ),
    );
  }
}
