import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/view_models/protocol_controller.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart';

class ProtocolDayAudit extends StatelessWidget {
  const ProtocolDayAudit({
    required this.protocolId,
    required this.day,
    super.key,
  });
  final String protocolId;
  final ProtocolDay day;
  @override
  Widget build(BuildContext context) {
    final groups = <String?, List<ProtocolDayRow>>{};
    for (final row in day.rows) {
      groups.putIfAbsent(row.time, () => []).add(row);
    }
    return ProtocolSurface(
      padding: const EdgeInsets.all(12),
      shadow: true,
      child: Column(
        children: [
          if (groups.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Không có hạng mục trong ngày này.',
                style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
              ),
            ),
          for (final entry in groups.entries) ...[
            if (entry.key != groups.keys.first) const SizedBox(height: 12),
            ProtocolSurface(
              radius: 12,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Container(
                    color: protocolPanel,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const AppSvgIcon(
                                    AppSvgIconName.clock,
                                    size: 14,
                                    color: AppColors.ocean,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    entry.key ?? 'Chưa đặt giờ',
                                    style: AppTypography.mono(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.ink,
                                    ).copyWith(fontFamily: 'JetBrainsMono'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                entry.value.length > 1
                                    ? 'Kết hợp ${entry.value.length} sản phẩm'
                                    : '1 sản phẩm',
                                style: const TextStyle(
                                  fontSize: 9,
                                  height: 1.5,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _OperationBadge(entry.value),
                      ],
                    ),
                  ),
                  for (var index = 0; index < entry.value.length; index++) ...[
                    if (index > 0)
                      const Divider(height: 1, color: Color(0xFFEEF1F7)),
                    _ProductAudit(
                      protocolId: protocolId,
                      row: entry.value[index],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OperationBadge extends StatelessWidget {
  const _OperationBadge(this.rows);
  final List<ProtocolDayRow> rows;
  @override
  Widget build(BuildContext context) {
    final statuses = rows.map((r) => r.status).toSet();
    final status = statuses.length == 1
        ? statuses.first
        : statuses.contains(ProtocolOperationStatus.planned)
        ? ProtocolOperationStatus.planned
        : ProtocolOperationStatus.unknown;
    return switch (status) {
      ProtocolOperationStatus.completed => const ProtocolBadge(
        'Đã hoàn thành',
        color: protocolTeal,
        background: protocolTealPanel,
      ),
      ProtocolOperationStatus.pendingApproval => const ProtocolBadge(
        'Chờ duyệt',
        color: protocolAmber,
        background: protocolAmberPanel,
      ),
      ProtocolOperationStatus.planned => const ProtocolBadge(
        'Đang chờ',
        color: protocolAmber,
        background: protocolAmberPanel,
      ),
      _ => Text(
        switch (status) {
          ProtocolOperationStatus.cancelled => 'Đã hủy',
          ProtocolOperationStatus.notGenerated => 'Chưa sinh lịch',
          _ => 'Nhiều trạng thái',
        },
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
        ),
      ),
    };
  }
}

class _ProductAudit extends StatelessWidget {
  const _ProductAudit({required this.protocolId, required this.row});
  final String protocolId;
  final ProtocolDayRow row;
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
    // Percent comparisons require the same unit and product as the frozen plan.
    final comparable =
        planned != null &&
        planned > 0 &&
        actual != null &&
        row.actualUnit == row.unit &&
        (row.actualProductName == null ||
            row.actualProductName == row.productName);
    final variance = comparable ? (actual - planned) / planned * 100 : null;
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
                child: AppSvgIcon(icon, size: 14, color: color),
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
                              'KTV THỰC SỰ DÙNG',
                              actual == null
                                  ? 'Chưa có'
                                  : '${protocolNumber(actual)} ${protocolUnit(row.actualUnit ?? row.unit)}',
                              actual: actual != null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (variance != null && variance.abs() > .05)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Chênh lệch ${variance > 0 ? '+' : ''}${variance.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 9,
                              height: 1.5,
                              fontWeight: FontWeight.w700,
                              color: variance.abs() > 10
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
          if (row.varianceReason?.isNotEmpty == true)
            _Reason(
              'Lý do điều chỉnh lượng dùng',
              row.varianceReason!,
              danger: false,
            ),
          if (row.cancellationReason?.isNotEmpty == true)
            _Reason(
              'Lý do không thực hiện',
              '${row.cancellationReason}${row.cancelledAt == null ? '' : '\n${protocolDate(row.cancelledAt, time: true)}'}',
              danger: true,
            ),
          if (row.executedAt != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: protocolTealPanel,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Chịu trách nhiệm: '),
                          TextSpan(
                            text: row.executorName ?? 'Chưa có tên',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      style: const TextStyle(
                        fontSize: 9,
                        height: 1.5,
                        color: Color(0xFF00786F),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    protocolDate(row.executedAt, time: true),
                    style: const TextStyle(
                      fontSize: 9,
                      color: Color(0xFF00786F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: protocolPanel,
                  foregroundColor: AppColors.inkSoft,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  minimumSize: const Size(0, 34),
                  side: const BorderSide(color: AppColors.line, width: 1.25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: row.scheduleId == null
                    ? null
                    : () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        showDragHandle: true,
                        builder: (_) => _InventoryTrace(
                          protocolId: protocolId,
                          scheduleId: row.scheduleId!,
                        ),
                      ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppSvgIcon(
                      AppSvgIconName.clock,
                      size: 13,
                      color: AppColors.inkSoft,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Kiểm tra giao dịch kho',
                      style: TextStyle(
                        fontSize: 10,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
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

class _Reason extends StatelessWidget {
  const _Reason(this.title, this.text, {required this.danger});
  final String title;
  final String text;
  final bool danger;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: ProtocolSurface(
      radius: 8,
      padding: const EdgeInsets.all(10),
      color: danger ? protocolRosePanel : protocolAmberPanel,
      border: danger ? protocolRosePanel : const Color(0xFFFFEFC0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: danger ? const Color(0xFFD70040) : const Color(0xFFBB4D00),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              height: 1.625,
              color: danger ? const Color(0xFFD70040) : const Color(0xFFBB4D00),
            ),
          ),
        ],
      ),
    ),
  );
}

class _InventoryTrace extends ConsumerWidget {
  const _InventoryTrace({required this.protocolId, required this.scheduleId});
  final String protocolId;
  final String scheduleId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = (id: protocolId, scheduleId: scheduleId);
    final state = ref.watch(protocolInventoryProvider(scope));
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .6,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Truy vết giao dịch kho',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ProtocolFailure(
                  error: e,
                  onRetry: () =>
                      ref.invalidate(protocolInventoryProvider(scope)),
                ),
                data: (rows) => rows.isEmpty
                    ? const Center(
                        child: Text('Chưa có giao dịch kho cho cữ này.'),
                      )
                    : ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          for (final row in rows)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ProtocolSurface(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      row.productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Lô ${row.lotNumber} · Xuất ${protocolNumber(row.quantity)} ${protocolUnit(row.unit)}',
                                    ),
                                    Text(
                                      '${row.performedByName} · ${protocolDate(row.createdAt, time: true)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.inkMuted,
                                      ),
                                    ),
                                    if (row.reason != null)
                                      Text(
                                        row.reason!,
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                  ],
                                ),
                              ),
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
