import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/view_models/shrimp_health_controller.dart';

class ShrimpHealthDetailSheet extends ConsumerStatefulWidget {
  const ShrimpHealthDetailSheet({
    required this.seasonId,
    required this.log,
    this.onVoided,
    super.key,
  });

  final String seasonId;
  final ShrimpHealthLog log;
  final VoidCallback? onVoided;

  static Future<bool?> show(
    BuildContext context, {
    required String seasonId,
    required ShrimpHealthLog log,
    VoidCallback? onVoided,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ShrimpHealthDetailSheet(
          seasonId: seasonId,
          log: log,
          onVoided: onVoided,
        ),
      );

  @override
  ConsumerState<ShrimpHealthDetailSheet> createState() =>
      _ShrimpHealthDetailSheetState();
}

class _ShrimpHealthDetailSheetState extends ConsumerState<ShrimpHealthDetailSheet> {
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isVoidingMode = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  static String _formatTimeDayMonth(DateTime dt) {
    final local = dt.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$hour:$minute · $day-$month';
  }

  static String _formatNumber(num? value, {int fractionDigits = 1}) {
    if (value == null) return '-';
    if (value is int || fractionDigits == 0 || value == value.roundToDouble()) {
      final intVal = fractionDigits == 0 ? value.round() : value.toInt();
      return intVal.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]}.',
      );
    }
    final fixed = value.toStringAsFixed(fractionDigits);
    final parts = fixed.split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return parts.length > 1 ? '$intPart,${parts[1]}' : intPart;
  }

  Widget _buildStatusBadge() {
    if (widget.log.isVoided) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          '● Đã hủy',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6A7994),
          ),
        ),
      );
    }

    final (Color bg, Color text, String label) = switch (widget.log.healthStatus) {
      HealthStatus.warning => (
        const Color(0xFFFBF0DC),
        const Color(0xFFD98314),
        '● Cần chú ý',
      ),
      HealthStatus.critical => (
        const Color(0xFFFBE6EA),
        const Color(0xFFD43B57),
        '● Nguy cấp',
      ),
      HealthStatus.excellent => (
        const Color(0xFFE2F6F3),
        const Color(0xFF0F9B8E),
        '● Rất tốt',
      ),
      HealthStatus.good => (
        const Color(0xFFE2F6F3),
        const Color(0xFF0F9B8E),
        '● Tốt',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          color: text,
        ),
      ),
    );
  }

  Widget _buildTile(String label, String value, String unit) => Container(
    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
    decoration: BoxDecoration(
      color: const Color(0xFFEEF1F6),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF6A7994),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F1C2E),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 1),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6A7994),
          ),
        ),
      ],
    ),
  );

  Future<void> _submitVoid() async {
    if (!_formKey.currentState!.validate()) return;

    final reason = _reasonController.text.trim();
    setState(() => _isSubmitting = true);

    try {
      await ref.read(shrimpHealthRepositoryProvider).voidLog(
        widget.seasonId,
        widget.log.id,
        reason,
      );

      if (!mounted) return;

      AppNoticeService.show(
        context,
        message: 'Hủy hiệu lực bản ghi thành công',
        level: AppNoticeLevel.success,
      );

      widget.onVoided?.call();
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      AppNoticeService.show(
        context,
        message: e.toString().replaceAll('Exception: ', ''),
        level: AppNoticeLevel.danger,
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final log = widget.log;
    final shortId = log.id.length >= 4 ? log.id.substring(0, 3).toUpperCase() : log.id;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Header row: Sức khỏe H-XXX + Circular close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Sức khỏe H-$shortId',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F1C2E),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEF1F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFF6A7994),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Time & Status badge row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _formatTimeDayMonth(log.recordedAt),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6A7994),
                    ),
                  ),
                  _buildStatusBadge(),
                ],
              ),
              const SizedBox(height: 14),

              // Metric Grid: 3 columns x 2 rows
              Row(
                children: <Widget>[
                  Expanded(child: _buildTile('Cỡ TB', _formatNumber(log.avgWeightG, fractionDigits: 1), 'g')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTile('Dài TB', _formatNumber(log.avgLengthCm, fractionDigits: 1), 'cm')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTile('Sinh khối', _formatNumber(log.estimatedBiomassKg, fractionDigits: 0), 'kg')),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(child: _buildTile('Ước tính đàn', _formatNumber(log.estimatedPopulation), 'con')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTile('Cỡ mẫu', log.sampleSize != null ? '${log.sampleSize}' : '-', 'con')),
                  const SizedBox(width: 8),
                  Expanded(child: _buildTile('Hao hụt', '${log.mortalityCount}', 'con')),
                ],
              ),
              const SizedBox(height: 14),

              // Observation Note
              if (log.note != null && log.note!.trim().isNotEmpty) ...<Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF1F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    log.note!.trim(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF3A4A63),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Void status or Void action section
              if (log.isVoided) ...<Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBE6EA),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFF7CCD3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Row(
                        children: <Widget>[
                          Icon(Icons.info_outline_rounded, size: 16, color: Color(0xFFD43B57)),
                          SizedBox(width: 6),
                          Text(
                            'Bản ghi đã bị hủy hiệu lực',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD43B57),
                            ),
                          ),
                        ],
                      ),
                      if (log.voidReason != null && log.voidReason!.trim().isNotEmpty) ...<Widget>[
                        const SizedBox(height: 6),
                        Text(
                          'Lý do: ${log.voidReason!.trim()}',
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF6A7994),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ] else if (!_isVoidingMode) ...<Widget>[
                // Outlined Void Trigger Button (figma_detail.png)
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
                          child: OutlinedButton(
                            onPressed: isRecordedToday
                                ? () => setState(() => _isVoidingMode = true)
                                : null,
                            style: OutlinedButton.styleFrom(
                              disabledForegroundColor: const Color(0xFF94A3B8),
                              side: BorderSide(
                                color: isRecordedToday
                                    ? const Color(0xFFDDE3EA)
                                    : const Color(0xFFE2E8F0),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.cancel_outlined,
                                  size: 18,
                                  color: isRecordedToday
                                      ? const Color(0xFF0F1C2E)
                                      : const Color(0xFF94A3B8),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Hủy hiệu lực bản ghi',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: isRecordedToday
                                        ? const Color(0xFF0F1C2E)
                                        : const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
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
              ] else ...<Widget>[
                // Inline Void Confirmation Flow (figma_void.png)
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Lý do hủy hiệu lực (bắt buộc)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F1C2E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _reasonController,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập lý do hủy hiệu lực';
                          }
                          return null;
                        },
                        style: const TextStyle(fontSize: 14, color: Color(0xFF0F1C2E)),
                        decoration: InputDecoration(
                          hintText: 'Nhập lý do hủy bản ghi...',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFDDE3EA)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFDDE3EA)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFD43B57), width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: <Widget>[
                          // Hủy bỏ button
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: OutlinedButton(
                                onPressed: _isSubmitting
                                    ? null
                                    : () => setState(() => _isVoidingMode = false),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Color(0xFFDDE3EA)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Hủy bỏ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0F1C2E),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Xác nhận button
                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: ElevatedButton(
                                onPressed: _isSubmitting ? null : _submitVoid,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD43B57),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: _isSubmitting
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Xác nhận',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
