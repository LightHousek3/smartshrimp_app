import 'package:smartshrimp_app/core/widgets/app_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_type_badge.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/domain/protocol_occurrence.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart';

class ProtocolDayAudit extends StatelessWidget {
  const ProtocolDayAudit({
    required this.farmId,
    required this.day,
    required this.protocolStatus,
    this.mealNumbersByItem = const {},
    this.now,
    super.key,
  });
  final String farmId;
  final ProtocolDay day;
  final ProtocolStatus protocolStatus;
  final Map<String, int> mealNumbersByItem;
  final DateTime? now;
  @override
  Widget build(BuildContext context) {
    final groups = protocolMeals(
      day.rows,
      mealNumbersByItem: mealNumbersByItem,
    );
    final clock = now ?? DateTime.now();
    return ProtocolSurface(
      padding: const EdgeInsets.all(12),
      shadow: true,
      child: Column(
        children: [
          if (groups.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Ngưỡng sai lệch: ±${protocolNumber(day.allowedVariancePct)}%',
                style: const TextStyle(fontSize: 10, color: AppColors.inkMuted),
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (groups.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Không có hạng mục trong ngày này.',
                style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
              ),
            ),
          ...groups.entries.map((entry) {
            final current = protocolCurrentRows(entry.value);
            final time = protocolMealTimeRange(entry.key.time, current);
            return Padding(
              padding: EdgeInsets.only(
                top: entry.key == groups.keys.first ? 0 : 12,
              ),
              child: ProtocolSurface(
                radius: 12,
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _MealHeader(
                      time: time,
                      mealNumber: entry.key.mealNumber,
                      productCount: current.length,
                      state: _mealState(current, protocolStatus, clock),
                    ),
                    for (
                      var index = 0;
                      index < entry.value.length;
                      index++
                    ) ...[
                      if (index > 0)
                        const Divider(height: 1, color: Color(0xFFEEF1F7)),
                      _ProductAudit(
                        farmId: farmId,
                        row: entry.value[index],
                        allowedVariancePct: day.allowedVariancePct,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _MealHeader extends StatelessWidget {
  const _MealHeader({
    required this.time,
    required this.mealNumber,
    required this.productCount,
    required this.state,
  });

  final String time;
  final int? mealNumber;
  final int productCount;
  final ProtocolOccurrenceState state;

  @override
  Widget build(BuildContext context) {
    final badges = _occurrenceBadges(state);
    return Container(
      color: protocolPanel,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: const {0: FlexColumnWidth(1.5), 1: FlexColumnWidth()},
        children: [
          TableRow(
            children: [
              Row(
                children: [
                  const AppSvgIcon(
                    AppSvgIconName.clock,
                    size: 14,
                    color: AppColors.ocean,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: time,
                        children: [
                          if (mealNumber != null)
                            TextSpan(
                              text: ' (Cữ\u00a0$mealNumber)',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.inkMuted,
                              ),
                            ),
                        ],
                      ),
                      style: AppTypography.mono(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ],
              ),
              _RightBadge(badges.status),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '$productCount vật tư',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: badges.label == null
                    ? const SizedBox.shrink()
                    : _RightBadge(badges.label!),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RightBadge extends StatelessWidget {
  const _RightBadge(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 6),
    child: Align(
      alignment: Alignment.centerRight,
      child: FittedBox(fit: BoxFit.scaleDown, child: child),
    ),
  );
}

ProtocolOccurrenceState _mealState(
  List<ProtocolDayRow> current,
  ProtocolStatus protocolStatus,
  DateTime now,
) {
  final states = current
      .map((row) => protocolOccurrenceState(row, protocolStatus, now))
      .toSet();
  for (final state in [
    ProtocolOccurrenceState.overdue,
    ProtocolOccurrenceState.notRecorded,
    ProtocolOccurrenceState.awaitingActivation,
    ProtocolOccurrenceState.paused,
    ProtocolOccurrenceState.locked,
    ProtocolOccurrenceState.planned,
    ProtocolOccurrenceState.notGenerated,
    ProtocolOccurrenceState.pendingApproval,
    ProtocolOccurrenceState.completed,
    ProtocolOccurrenceState.cancelled,
  ]) {
    if (states.contains(state)) return state;
  }
  return ProtocolOccurrenceState.unknown;
}

({Widget status, Widget? label}) _occurrenceBadges(
  ProtocolOccurrenceState state,
) {
  final status = switch (state) {
    ProtocolOccurrenceState.completed => OperationStatus.completed,
    ProtocolOccurrenceState.cancelled => OperationStatus.cancelled,
    ProtocolOccurrenceState.planned ||
    ProtocolOccurrenceState.notRecorded ||
    ProtocolOccurrenceState.overdue ||
    ProtocolOccurrenceState.awaitingActivation ||
    ProtocolOccurrenceState.paused ||
    ProtocolOccurrenceState.locked => OperationStatus.planned,
    _ => null,
  };
  final label = switch (state) {
    ProtocolOccurrenceState.awaitingActivation => 'Chờ hiệu lực',
    ProtocolOccurrenceState.paused => 'Tạm hoãn',
    ProtocolOccurrenceState.locked => 'Đã khóa ghi nhận',
    _ => null,
  };
  final neutralLabel = switch (state) {
    ProtocolOccurrenceState.pendingApproval => 'Chờ duyệt',
    ProtocolOccurrenceState.notGenerated => 'Chưa sinh lịch',
    _ => 'Chưa xác định',
  };
  if (status == null) {
    return (status: ProtocolBadge(neutralLabel), label: null);
  }
  final (color, background) = switch (state) {
    ProtocolOccurrenceState.locked => (AppColors.inkMuted, protocolPanel),
    _ => (protocolAmber, protocolAmberPanel),
  };
  return (
    status: OperationStatusBadge(status: status),
    label: switch (state) {
      ProtocolOccurrenceState.notRecorded => const OperationUnrecordedBadge(),
      ProtocolOccurrenceState.overdue => const OperationOverdueBadge(
        compact: true,
      ),
      _ =>
        label == null
            ? null
            : ProtocolBadge(label, color: color, background: background),
    },
  );
}

class _ProductAudit extends StatelessWidget {
  const _ProductAudit({
    required this.farmId,
    required this.row,
    required this.allowedVariancePct,
  });
  final String farmId;
  final ProtocolDayRow row;
  final double allowedVariancePct;
  @override
  Widget build(BuildContext context) {
    final (icon, color, background) = switch (row.operationType) {
      'FEEDING' => (
        AppSvgIconName.shrimpFeed,
        const Color(0xFF009D90),
        protocolTealPanel,
      ),
      'MEDICINE' => (AppSvgIconName.medicine, protocolRose, protocolRosePanel),
      'CHEMICAL' => (
        AppSvgIconName.chemical,
        const Color(0xFF7F55E8),
        const Color(0xFFEFEAFC),
      ),
      'MINERAL' => (
        AppSvgIconName.mineral,
        AppColors.ocean,
        const Color(0xFFEAF4FF),
      ),
      _ => (AppSvgIconName.box, AppColors.inkMuted, protocolPanel),
    };
    final planned = row.plannedQuantity;
    final actual = row.actualQuantity;
    final executor = row.executorName?.trim() ?? '';
    final varianceReason = row.varianceReason?.trim() ?? '';
    final note = row.note?.trim() ?? '';
    // Percent comparisons require the same unit and product as the frozen plan.
    final comparable =
        planned != null &&
        planned > 0 &&
        actual != null &&
        row.actualUnit == row.unit &&
        (row.quantityExceedsThreshold != null ||
            row.actualProductName == null ||
            row.actualProductName == row.productName);
    final variance = comparable ? (actual - planned) / planned * 100 : null;
    final exceeds =
        row.quantityExceedsThreshold ??
        (variance != null && variance.abs() > allowedVariancePct);
    final quantity = planned == null
        ? _dose(row)
        : '${protocolNumber(planned)} ${protocolUnit(row.unit)}';
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: row.productImageUrls.isEmpty
                    ? AppSvgIcon(icon, size: 14, color: color)
                    : InkWell(
                        onTap: () => showAppImageViewer(
                          context,
                          builder: (_) => AppImageViewer(
                            itemCount: row.productImageUrls.length,
                            initialIndex: 0,
                            imageBuilder: (index, fit) => Image.network(
                              row.productImageUrls[index],
                              fit: fit,
                              errorBuilder: (_, _, _) =>
                                  AppSvgIcon(icon, size: 20, color: color),
                            ),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            row.productImageUrls.first,
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                AppSvgIcon(icon, size: 14, color: color),
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.productName,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.375,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _Quantity('KẾ HOẠCH', quantity)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _Quantity(
                              'THỰC SỰ DÙNG',
                              actual == null
                                  ? 'Chưa có'
                                  : '${protocolNumber(actual)} ${protocolUnit(row.actualUnit ?? row.unit)}',
                              actual: actual != null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (variance != null && variance != 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Chênh lệch ${variance > 0 ? '+' : ''}${variance.abs() < .05 ? '<0,1' : variance.toStringAsFixed(1)}%${exceeds ? ' · Vượt ngưỡng' : ''}',
                            style: TextStyle(
                              fontSize: 9,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                              color: exceeds
                                  ? const Color(0xFFFF2F61)
                                  : const Color(0xFFE17100),
                            ),
                          ),
                        ),
                      ),
                    if (row.actualProductName != null &&
                        row.actualProductName != row.productName)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Vật tư thực dùng: ${row.actualProductName}',
                          style: const TextStyle(
                            fontSize: 9,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ),
                    if (row.basisQuantity != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Cơ sở tính: ${protocolNumber(row.basisQuantity!)} ${row.basisUnit == 'kg_biomass' ? 'kg sinh khối' : row.basisUnit ?? ''}',
                          style: const TextStyle(
                            fontSize: 9,
                            height: 1.5,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (row.cancellationReason?.isNotEmpty == true)
            _CancellationReason(
              '${row.cancellationReason}${row.cancelledAt == null ? '' : '\n${protocolDate(row.cancelledAt, time: true)}'}',
            ),
          if (row.status == ProtocolOperationStatus.completed &&
              (row.executedAt != null ||
                  executor.isNotEmpty ||
                  varianceReason.isNotEmpty ||
                  note.isNotEmpty))
            _ExecutionAudit(
              executor: executor,
              executedAt: row.executedAt,
              varianceReason: varianceReason,
              note: note,
            ),
          if (row.status == ProtocolOperationStatus.completed &&
              row.executedAt != null &&
              row.scheduleId != null &&
              farmId.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const AppSvgIcon(
                  AppSvgIconName.clock,
                  size: 13,
                  color: AppColors.inkSoft,
                ),
                label: const Text('Kiểm tra giao dịch kho'),
                onPressed: () => context.push(
                  Uri(
                    path:
                        '/farms/${Uri.encodeComponent(farmId)}/inventory/history',
                    queryParameters: {'scheduleId': row.scheduleId},
                  ).toString(),
                ),
              ),
            ),
          ],
          if (row.instructions?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              row.instructions!,
              style: const TextStyle(
                fontSize: 10,
                height: 1.625,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _dose(ProtocolDayRow r) {
    final dose = protocolNumber(r.doseValue);
    final unit = protocolUnit(r.doseUnit);
    return switch (r.doseBasis) {
      'PER_KG_BIOMASS' => '$dose $unit/kg sinh khối',
      'PERCENT_BIOMASS' => '$dose% sinh khối',
      'PER_M3_WATER' => '$dose $unit/m³ nước',
      _ => '$dose $unit/lần',
    };
  }
}

class _ExecutionAudit extends StatelessWidget {
  const _ExecutionAudit({
    required this.executor,
    required this.executedAt,
    required this.varianceReason,
    required this.note,
  });

  final String executor;
  final DateTime? executedAt;
  final String varianceReason;
  final String note;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: ProtocolSurface(
      radius: 8,
      color: protocolTealPanel,
      border: protocolTealPanel,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: 'Chịu trách nhiệm: ',
                    children: [
                      TextSpan(
                        text: executor.isEmpty ? 'Chưa có tên' : executor,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.5,
                    color: Color(0xFF00786F),
                  ),
                ),
              ),
              if (executedAt != null) ...[
                const SizedBox(width: 8),
                Text(
                  protocolDate(executedAt, time: true),
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.5,
                    color: Color(0xFF00786F),
                  ),
                ),
              ],
            ],
          ),
          if (varianceReason.isNotEmpty || note.isNotEmpty) ...[
            const Divider(height: 12, color: Color(0xFFCBFBF1)),
            if (varianceReason.isNotEmpty)
              _ExecutionDetail('Lý do điều chỉnh lượng dùng', varianceReason),
            if (varianceReason.isNotEmpty && note.isNotEmpty)
              const SizedBox(height: 6),
            if (note.isNotEmpty)
              _ExecutionDetail('Ghi chú của Kỹ thuật viên', note),
          ],
        ],
      ),
    ),
  );
}

class _ExecutionDetail extends StatelessWidget {
  const _ExecutionDetail(this.title, this.value);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      Text(
        value,
        style: const TextStyle(
          fontSize: 10,
          height: 1.5,
          color: AppColors.inkSoft,
        ),
      ),
    ],
  );
}

class _Quantity extends StatelessWidget {
  const _Quantity(this.label, this.value, {this.actual = false});
  final String label;
  final String value;
  final bool actual;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: actual ? protocolTealPanel : protocolPanel,
      borderRadius: BorderRadius.circular(8),
      border: actual ? Border.all(color: const Color(0xFFCBFBF1)) : null,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            height: 1.5,
            letterSpacing: .225,
            color: AppColors.inkMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.mono(
            fontSize: actual ? 13 : 12,
            fontWeight: actual ? FontWeight.w800 : FontWeight.w700,
            color: actual
                ? const Color(0xFF00786F)
                : value == 'Chưa có'
                ? AppColors.inkMuted
                : AppColors.ink,
          ).copyWith(fontFamily: 'JetBrainsMono'),
        ),
      ],
    ),
  );
}

class _CancellationReason extends StatelessWidget {
  const _CancellationReason(this.text);

  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: ProtocolSurface(
      radius: 8,
      padding: const EdgeInsets.all(10),
      color: protocolRosePanel,
      border: protocolRosePanel,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lý do không thực hiện',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFFD70040),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              height: 1.625,
              color: Color(0xFFD70040),
            ),
          ),
        ],
      ),
    ),
  );
}
