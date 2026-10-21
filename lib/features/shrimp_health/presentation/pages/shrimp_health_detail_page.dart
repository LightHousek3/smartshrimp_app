import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/view_models/shrimp_health_controller.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/widgets/void_shrimp_health_sheet.dart';

class ShrimpHealthDetailPage extends ConsumerWidget {
  const ShrimpHealthDetailPage({
    required this.seasonId,
    required this.logId,
    super.key,
  });

  final String seasonId;
  final String logId;

  String _formatDateTime(DateTime dt) {
    final local = dt.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year;
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$d/$m/$y · $h:$min';
  }

  String _formatNumber(num? value, {int fractionDigits = 2}) {
    if (value == null) return '-';
    if (value is int || fractionDigits == 0 || value == value.roundToDouble()) {
      final intVal = fractionDigits == 0 ? value.round() : value.toInt();
      return intVal.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    final parts = value.toStringAsFixed(fractionDigits).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return parts.length > 1 ? '$intPart.${parts[1]}' : intPart;
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    String? unit,
    Color? valueColor,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: <Widget>[
        Icon(icon, size: 18, color: AppColors.inkMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.inkMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.ink,
              ),
            ),
            if (unit != null) ...<Widget>[
              const SizedBox(width: 2),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.inkMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(
      shrimpHealthDetailProvider(
        (seasonId: seasonId, logId: logId),
      ),
    );

    return Scaffold(
      body: AppGradientBackground(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ink),
                      tooltip: 'Quay lại',
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        'Chi tiết nhật ký sức khỏe',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: detailAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.error_outline_rounded,
                            size: 48,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            error.toString().replaceAll('Exception: ', ''),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppColors.ink),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              ref.invalidate(
                                shrimpHealthDetailProvider(
                                  (seasonId: seasonId, logId: logId),
                                ),
                              );
                            },
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Tải lại'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  data: (log) {
                    final status = log.healthStatus;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Voided Alert Banner
                          if (log.isVoided) ...<Widget>[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFFECACA)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.cancel_rounded,
                                        color: Color(0xFFDC2626),
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Bản ghi đã bị hủy hiệu lực',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFFDC2626),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Lý do hủy: ${log.voidReason ?? 'Không có lý do'}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF991B1B),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Người hủy: ${log.voidedByName ?? 'Kỹ thuật viên'} · ${log.voidedAt != null ? _formatDateTime(log.voidedAt!) : ''}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFB91C1C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Status Header Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: status.backgroundColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(status.icon, size: 16, color: status.color),
                                          const SizedBox(width: 6),
                                          Text(
                                            status.displayName,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: status.color,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    if (log.dayOfCulture != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'DOC ${log.dayOfCulture}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF334155),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _formatDateTime(log.recordedAt),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: log.isVoided ? AppColors.inkMuted : AppColors.ink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Measurements Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Chỉ số tăng trưởng & thể trạng',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                                const SizedBox(height: 4),
                                _buildDetailRow(
                                  icon: Icons.scale_rounded,
                                  label: 'Trọng lượng trung bình',
                                  value: _formatNumber(log.avgWeightG, fractionDigits: 2),
                                  unit: 'g/con',
                                ),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF8FAFC)),
                                _buildDetailRow(
                                  icon: Icons.straighten_rounded,
                                  label: 'Chiều dài trung bình',
                                  value: _formatNumber(log.avgLengthCm, fractionDigits: 1),
                                  unit: 'cm',
                                ),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF8FAFC)),
                                _buildDetailRow(
                                  icon: Icons.inventory_2_rounded,
                                  label: 'Sinh khối ao ước tính',
                                  value: _formatNumber(log.estimatedBiomassKg, fractionDigits: 1),
                                  unit: 'kg',
                                  valueColor: AppColors.ocean,
                                ),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF8FAFC)),
                                _buildDetailRow(
                                  icon: Icons.groups_rounded,
                                  label: 'Ước tính đàn',
                                  value: _formatNumber(log.estimatedPopulation),
                                  unit: 'con',
                                ),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF8FAFC)),
                                _buildDetailRow(
                                  icon: Icons.catching_pokemon_rounded,
                                  label: 'Số lượng mẫu bắt kiểm tra',
                                  value: log.sampleSize != null ? '${log.sampleSize}' : '-',
                                  unit: 'con',
                                ),
                                const Divider(height: 1, thickness: 1, color: Color(0xFFF8FAFC)),
                                _buildDetailRow(
                                  icon: Icons.heart_broken_rounded,
                                  label: 'Số tôm chết quan sát',
                                  value: '${log.mortalityCount}',
                                  unit: 'con',
                                  valueColor: log.mortalityCount > 0 ? const Color(0xFFDC2626) : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Note Card
                          if (log.note != null && log.note!.isNotEmpty) ...<Widget>[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    'Ghi chú tình trạng tôm',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    log.note!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF334155),
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Auditor Info Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Thông tin ghi nhận',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.person_outline_rounded,
                                      size: 16,
                                      color: AppColors.inkMuted,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      log.recordedByName ?? 'Kỹ thuật viên',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    if (log.recordedByEmail != null) ...<Widget>[
                                      const SizedBox(width: 6),
                                      Text(
                                        '(${log.recordedByEmail})',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.inkMuted,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.access_time_rounded,
                                      size: 16,
                                      color: AppColors.inkMuted,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Tạo lúc: ${_formatDateTime(log.createdAt)}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.inkMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Void Button (if not voided)
                          if (!log.isVoided) ...<Widget>[
                            Builder(
                              builder: (_) {
                                final now = DateTime.now();
                                final isRecordedToday = log.recordedAt.year == now.year &&
                                    log.recordedAt.month == now.month &&
                                    log.recordedAt.day == now.day;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    SizedBox(
                                      width: double.infinity,
                                      height: 48,
                                      child: OutlinedButton.icon(
                                        onPressed: isRecordedToday
                                            ? () {
                                                VoidShrimpHealthSheet.show(
                                                  context,
                                                  seasonId: seasonId,
                                                  logId: logId,
                                                  onVoided: () {
                                                    ref.invalidate(
                                                      shrimpHealthDetailProvider(
                                                        (seasonId: seasonId, logId: logId),
                                                      ),
                                                    );
                                                    ref
                                                        .read(shrimpHealthListProvider(seasonId).notifier)
                                                        .refresh();
                                                  },
                                                );
                                              }
                                            : null,
                                        icon: Icon(
                                          Icons.cancel_outlined,
                                          color: isRecordedToday
                                              ? const Color(0xFFDC2626)
                                              : const Color(0xFF94A3B8),
                                          size: 18,
                                        ),
                                        label: Text(
                                          'Hủy bản ghi này',
                                          style: TextStyle(
                                            color: isRecordedToday
                                                ? const Color(0xFFDC2626)
                                                : const Color(0xFF94A3B8),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          disabledForegroundColor: const Color(0xFF94A3B8),
                                          side: BorderSide(
                                            color: isRecordedToday
                                                ? const Color(0xFFFCA5A5)
                                                : const Color(0xFFE2E8F0),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14),
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (!isRecordedToday) ...<Widget>[
                                      const SizedBox(height: 6),
                                      const Center(
                                        child: Text(
                                          'Chỉ được hủy hiệu lực bản ghi trong ngày',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF94A3B8),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 30),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
