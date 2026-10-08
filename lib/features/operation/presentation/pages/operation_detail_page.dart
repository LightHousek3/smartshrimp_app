import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_sheet.dart';

class OperationDetailPage extends ConsumerWidget {
  const OperationDetailPage({
    required this.seasonId,
    required this.scheduleId,
    super.key,
  });

  final String seasonId;
  final String scheduleId;

  (Color bg, Color fg, IconData icon) _typeVisuals(OperationType type) =>
      switch (type) {
        OperationType.feeding => (
          const Color(0xFFE2F6F3),
          const Color(0xFF0F9B8E),
          Icons.settings_outlined,
        ),
        OperationType.mineral => (
          const Color(0xFFEAF4FF),
          const Color(0xFF1378D1),
          Icons.grain_rounded,
        ),
        OperationType.chemical => (
          const Color(0xFFF0E9FF),
          const Color(0xFF7B5BD6),
          Icons.biotech_rounded,
        ),
        OperationType.medicine => (
          const Color(0xFFFBE6EA),
          AppColors.error,
          Icons.medical_services_rounded,
        ),
        OperationType.other => (
          const Color(0xFFF5F5F5),
          AppColors.inkSoft,
          Icons.category_rounded,
        ),
      };

  String _formatBasisUnit(String? unit) {
    if (unit == null || unit.isEmpty) return '';
    final lower = unit.toLowerCase();
    if (lower == 'kg_biomass' || lower == 'percent_biomass') return 'kg sinh khối';
    if (lower == 'm3_water') return 'm³ nước';
    return unit;
  }

  String _formatBasisQuantity(double qty) {
    if (qty == qty.roundToDouble()) {
      final intVal = qty.toInt();
      if (intVal >= 1000) {
        final str = intVal.toString();
        final buffer = StringBuffer();
        for (int i = 0; i < str.length; i++) {
          if (i > 0 && (str.length - i) % 3 == 0) {
            buffer.write('.');
          }
          buffer.write(str[i]);
        }
        return buffer.toString();
      }
      return intVal.toString();
    }
    return qty.toString();
  }

  String _formatLocation(OperationSchedule schedule) {
    final pond = schedule.pondName?.trim();
    final season = schedule.seasonName?.trim();

    final formattedSeason = season != null && season.isNotEmpty
        ? (season.toLowerCase().startsWith('vụ') ? season : 'Vụ $season')
        : null;

    final parts = <String>[
      if (pond != null && pond.isNotEmpty) pond,
      ?formattedSeason,
    ];

    if (parts.isNotEmpty) {
      return parts.join(' · ');
    }
    return 'Vụ nuôi: $seasonId';
  }

  Widget _buildParamBox({
    required String label,
    required String value,
    String? sub,
  }) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(16),
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
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          if (sub != null) ...<Widget>[
            const SizedBox(height: 2),
            Text(
              sub,
              style: const TextStyle(fontSize: 10.5, color: AppColors.inkMuted),
            ),
          ],
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(operationDetailProvider(scheduleId));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: state.when(
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
                        .read(operationDetailProvider(scheduleId).notifier)
                        .refresh(),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
            data: (schedule) {
              final isCompleted = schedule.status == OperationStatus.completed;
              final isPlanned = schedule.status == OperationStatus.planned;

              final localTime = schedule.scheduledAt.toLocal();
              final timeStr =
                  '${localTime.hour.toString().padLeft(2, '0')}:${localTime.minute.toString().padLeft(2, '0')}';

              final mealStr = schedule.protocolItem?.mealNumber != null
                  ? 'Cữ ${schedule.protocolItem!.mealNumber}'
                  : null;

              final instructions = schedule.protocolItem?.instructions;
              final (iconBg, iconFg, icon) = _typeVisuals(schedule.operationType);

              // Status chip colors
              final (
                statusDot,
                statusText,
                statusBg,
              ) = switch (schedule.status) {
                OperationStatus.planned => (
                  const Color(0xFF1378D1),
                  const Color(0xFF1378D1),
                  const Color(0xFFEAF4FF),
                ),
                OperationStatus.completed => (
                  const Color(0xFF0F9B8E),
                  const Color(0xFF0F9B8E),
                  const Color(0xFFE2F6F3),
                ),
                OperationStatus.cancelled => (
                  AppColors.inkMuted,
                  AppColors.inkMuted,
                  const Color(0xFFF5F5F5),
                ),
              };

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  StickyPageHeader(
                    title: 'Chi tiết vận hành',
                    subtitle: 'Mã lịch: ${schedule.id.substring(0, 8)}',
                    onBack: context.pop,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: statusDot,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            schedule.status.displayName,
                            style: TextStyle(
                              color: statusText,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Breadcrumb card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBF4FD),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.location_on_rounded,
                                  size: 16,
                                  color: Color(0xFF1378D1),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    _formatLocation(schedule),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1378D1),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Main Card
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Header: Icon container + Type & Slot badge + Product Title
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: iconBg,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Icon(icon, color: iconFg, size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 9,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: iconBg,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  schedule.operationType.displayName,
                                                  style: TextStyle(
                                                    color: iconFg,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              if (mealStr != null) ...<Widget>[
                                                const SizedBox(width: 8),
                                                Text(
                                                  mealStr,
                                                  style: const TextStyle(
                                                    color: AppColors.inkSoft,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            schedule.productName,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.ink,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Row 1: Giờ dự kiến + Cách tính liều
                                Row(
                                  children: <Widget>[
                                    _buildParamBox(
                                      label: 'Giờ dự kiến',
                                      value: timeStr,
                                    ),
                                    const SizedBox(width: 10),
                                    _buildParamBox(
                                      label: 'Cách tính liều',
                                      value: schedule.doseBasisDescription,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Row 2: Liều kế hoạch + Thực tế (nếu có)
                                Row(
                                  children: <Widget>[
                                    _buildParamBox(
                                      label: 'Liều kế hoạch',
                                      value:
                                          '${schedule.plannedQuantity} ${schedule.unit.toLowerCase()}',
                                    ),
                                    if (isCompleted &&
                                        schedule.execution != null) ...<Widget>[
                                      const SizedBox(width: 10),
                                      _buildParamBox(
                                        label: 'Thực tế',
                                        value:
                                            '${schedule.execution!.actualQuantity} ${schedule.unit.toLowerCase()}',
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Row 3: Dữ liệu tính liều & Phiên bản tính
                                if (schedule.basisQuantity != null ||
                                    isCompleted) ...<Widget>[
                                  Row(
                                    children: <Widget>[
                                      if (schedule.basisQuantity != null) ...<Widget>[
                                        _buildParamBox(
                                          label: 'Dữ liệu tính liều',
                                          value:
                                              '${_formatBasisQuantity(schedule.basisQuantity!)} ${_formatBasisUnit(schedule.basisUnit)}',
                                        ),
                                        const SizedBox(width: 10),
                                      ],
                                      _buildParamBox(
                                        label: 'Phiên bản tính',
                                        value: schedule.calculationVersion,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],

                                // Instructions box
                                if (instructions != null &&
                                    instructions.isNotEmpty) ...<Widget>[
                                  const SizedBox(height: 4),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F7FA),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      instructions,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.inkSoft,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],


                              ],
                            ),
                          ),
                          // Completed Block
                          if (isCompleted &&
                              schedule.execution != null) ...<Widget>[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(
                                  color: const Color(
                                    0xFF0F9B8E,
                                  ).withValues(alpha: 0.25),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.check_rounded,
                                        color: Color(0xFF0F9B8E),
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Đã ghi nhận thực hiện',
                                        style: TextStyle(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF0F9B8E),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Thực hiện lúc ${schedule.execution!.executedAt.hour.toString().padLeft(2, '0')}:${schedule.execution!.executedAt.minute.toString().padLeft(2, '0')} · ${schedule.execution!.executedAt.day.toString().padLeft(2, '0')}-${schedule.execution!.executedAt.month.toString().padLeft(2, '0')}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.inkMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (schedule.execution!.note != null &&
                                      schedule
                                          .execution!
                                          .note!
                                          .isNotEmpty) ...<Widget>[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Ghi chú: ${schedule.execution!.note}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.inkSoft,
                                      ),
                                    ),
                                  ],
                                  if (schedule.execution!.varianceReason !=
                                          null &&
                                      schedule
                                          .execution!
                                          .varianceReason!
                                          .isNotEmpty) ...<Widget>[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Lý do chênh lệch: ${schedule.execution!.varianceReason}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],

                          // Cancelled info
                          if (schedule.status ==
                              OperationStatus.cancelled) ...<Widget>[
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9FAFB),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: AppColors.line),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.cancel_outlined,
                                        color: AppColors.inkMuted,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Lịch vận hành đã bị hủy',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.inkMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (schedule.cancellationReason !=
                                      null) ...<Widget>[
                                    const SizedBox(height: 8),
                                    Text(
                                      'Lý do hủy: ${schedule.cancellationReason}',
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.inkSoft,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],

                          // Action button for PLANNED
                          if (isPlanned) ...<Widget>[
                            const SizedBox(height: 16),
                            GradientButton(
                              label: 'Ghi nhận thực hiện',
                              onPressed: () => OperationExecuteSheet.show(
                                context,
                                schedule: schedule,
                                onSuccess: () {
                                  ref
                                      .read(
                                        operationDetailProvider(
                                          scheduleId,
                                        ).notifier,
                                      )
                                      .refresh();
                                  ref
                                      .read(
                                        operationListProvider(
                                          seasonId,
                                        ).notifier,
                                      )
                                      .refresh();
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
