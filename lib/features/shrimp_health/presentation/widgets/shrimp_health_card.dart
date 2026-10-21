import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';

class ShrimpHealthCard extends StatelessWidget {
  const ShrimpHealthCard({
    required this.log,
    required this.onTap,
    super.key,
  });

  final ShrimpHealthLog log;
  final VoidCallback onTap;

  static String _formatTime(DateTime dt) {
    final local = dt.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String _formatDayMonth(DateTime dt) {
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$day-$month';
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
    if (log.isVoided) {
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

    final (Color bg, Color text, String label) = switch (log.healthStatus) {
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
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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

  @override
  Widget build(BuildContext context) {
    final shortId = log.id.length >= 4 ? log.id.substring(0, 3).toUpperCase() : log.id;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: log.isVoided
              ? const Color(0xFFF1F5F9)
              : const Color(0xFFE5E8F0),
          width: 1,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Header row: Heart icon + Time/Code + Status badge
                Row(
                  children: <Widget>[
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFBE6EA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        color: Color(0xFFD43B57),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _formatTime(log.recordedAt),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: log.isVoided ? AppColors.inkMuted : const Color(0xFF0F1C2E),
                              decoration: log.isVoided ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            'H-$shortId · ${_formatDayMonth(log.recordedAt)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF6A7994),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(),
                  ],
                ),
                const SizedBox(height: 12),

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

                // Observation note if present
                if (log.note != null && log.note!.trim().isNotEmpty) ...<Widget>[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF1F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      log.note!.trim(),
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF3A4A63),
                        height: 1.4,
                      ),
                    ),
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
