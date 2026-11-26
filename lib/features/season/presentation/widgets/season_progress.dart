import 'package:smartshrimp_app/core/utils/vietnamese_number.dart';
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';

/// Time elapsed against the plan; this does not measure production performance.
class SeasonProgress extends StatelessWidget {
  const SeasonProgress({
    required this.status,
    required this.stockingDate,
    required this.expectedEndDate,
    required this.dayOfCulture,
    super.key,
  });

  final SeasonStatus status;
  final DateTime? stockingDate;
  final DateTime? expectedEndDate;
  final int? dayOfCulture;

  @override
  Widget build(BuildContext context) {
    final start = stockingDate;
    final end = expectedEndDate;
    // API dates are calendar dates, so preserve their year/month/day fields.
    final totalDays = start == null || end == null
        ? null
        : DateTime.utc(end.year, end.month, end.day)
                  .difference(DateTime.utc(start.year, start.month, start.day))
                  .inDays +
              1;
    final doc = dayOfCulture;
    final active = status == SeasonStatus.active;
    final valid = active && doc != null && totalDays != null && totalDays > 0;
    final progress = valid ? (doc / totalDays).clamp(0.0, 1.0) : 0.0;
    final remaining = valid ? totalDays - doc : null;
    final statusLabel = switch (status) {
      SeasonStatus.planning => 'Đang chuẩn bị',
      SeasonStatus.completed => 'Đã kết thúc',
      SeasonStatus.cancelled => 'Đã hủy',
      _ => doc == null ? 'DOC —' : 'DOC $doc',
    };
    final message = switch (status) {
      SeasonStatus.planning => 'Tiến trình hiển thị khi vụ được kích hoạt.',
      SeasonStatus.completed => 'Vụ đã kết thúc theo dõi tiến trình.',
      SeasonStatus.cancelled => 'Vụ đã dừng theo dõi tiến trình.',
      _ when !valid => 'Chưa đủ dữ liệu ngày hợp lệ để tính tiến trình.',
      _ when remaining! < 0 => 'Vượt dự kiến ${-remaining} ngày',
      _ when remaining == 0 => 'Hôm nay là ngày kết thúc dự kiến',
      _ => 'Còn $remaining ngày đến ngày kết thúc dự kiến',
    };
    final color = remaining != null && remaining < 0
        ? AppColors.error
        : AppColors.ocean;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tiến trình vụ nuôi',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _Milestone(
                label: status == SeasonStatus.planning
                    ? 'Thả giống dự kiến'
                    : 'Thả giống',
                value: _date(start),
                alignment: TextAlign.left,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Milestone(
                label: 'Hiện tại',
                value: statusLabel,
                alignment: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Milestone(
                label: 'Kết thúc dự kiến',
                value: _date(end),
                alignment: TextAlign.right,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Semantics(
          label: 'Tiến trình thời gian nuôi',
          value: valid
              ? '${formatVietnameseDecimal((progress * 100).toStringAsFixed(1), trimTrailingZeroes: false)}%'
              : message,
          child: ExcludeSemantics(
            child: SizedBox(
              height: 18,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(8),
                    backgroundColor: AppColors.line,
                    color: color,
                  ),
                  if (valid)
                    Align(
                      alignment: Alignment(progress * 2 - 1, 0),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (valid) ...[
          Text(
            '$doc / $totalDays ngày · ${formatVietnameseDecimal((progress * 100).toStringAsFixed(1), trimTrailingZeroes: false)}%',
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
        ],
        Text(
          message,
          style: TextStyle(
            color: valid ? color : AppColors.inkMuted,
            fontSize: 12,
          ),
        ),
        if (valid) ...[
          const SizedBox(height: 6),
          const Text(
            'Theo thời gian nuôi so với kế hoạch',
            style: TextStyle(color: AppColors.inkMuted, fontSize: 11),
          ),
        ],
      ],
    );
  }
}

class _Milestone extends StatelessWidget {
  const _Milestone({
    required this.label,
    required this.value,
    required this.alignment,
  });

  final String label;
  final String value;
  final TextAlign alignment;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        textAlign: alignment,
        style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        textAlign: alignment,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

String _date(DateTime? date) => date == null
    ? 'Chưa cập nhật'
    : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
