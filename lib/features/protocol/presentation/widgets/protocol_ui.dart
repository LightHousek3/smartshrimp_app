import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';

const protocolPanel = Color(0xFFEEF1F6);
const protocolTeal = Color(0xFF0F9B8E);
const protocolTealPanel = Color(0xFFE2F6F3);
const protocolRose = Color(0xFFD43B57);
const protocolRosePanel = Color(0xFFFBE6EA);
const protocolAmber = Color(0xFFD98314);
const protocolAmberPanel = Color(0xFFFBF0DC);

String protocolStatusLabel(ProtocolStatus status) => switch (status) {
  ProtocolStatus.draft => 'Bản nháp',
  ProtocolStatus.pendingApproval => 'Chờ duyệt',
  ProtocolStatus.approved => 'Đang có hiệu lực',
  ProtocolStatus.rejected => 'Đã từ chối',
  ProtocolStatus.superseded => 'Hết hiệu lực',
  ProtocolStatus.cancelled => 'Đã hủy',
  ProtocolStatus.aborted => 'Dừng khẩn cấp',
  ProtocolStatus.unknown => 'Chưa xác định',
};

String protocolNumber(num number) => number
    .toStringAsFixed(4)
    .replaceFirst(RegExp(r'\.?0+$'), '')
    .replaceAll('.', ',');
String protocolUnit(String unit) => switch (unit) {
  'PACK' => 'gói',
  'BOTTLE' => 'chai',
  'PCS' => 'cái',
  _ => unit.toLowerCase(),
};
DateTime vietnamTime(DateTime value) =>
    value.toUtc().add(const Duration(hours: 7));
String _two(int value) => value.toString().padLeft(2, '0');
String protocolDate(DateTime? value, {bool year = false, bool time = false}) {
  if (value == null) return '—';
  final d = vietnamTime(value);
  return '${time ? '${_two(d.hour)}:${_two(d.minute)} ' : ''}${_two(d.day)}${year ? '/' : '–'}${_two(d.month)}${year ? '/${d.year}' : ''}';
}

String protocolError(Object error) => error is AppException
    ? error.message
    : 'Không thể tải dữ liệu phác đồ. Vui lòng thử lại.';

class ProtocolSurface extends StatelessWidget {
  const ProtocolSurface({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
    this.border = AppColors.line,
    this.radius = 16,
    this.shadow = false,
    super.key,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color border;
  final double radius;
  final bool shadow;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: border, width: 1.25),
      boxShadow: shadow
          ? const [
              BoxShadow(
                color: Color(0x0F0F172A),
                blurRadius: 12,
                offset: Offset(0, 2),
              ),
            ]
          : null,
    ),
    clipBehavior: Clip.antiAlias,
    padding: padding,
    child: child,
  );
}

class ProtocolBadge extends StatelessWidget {
  const ProtocolBadge(
    this.label, {
    this.color = const Color(0xFF64748B),
    this.background = protocolPanel,
    this.dot = false,
    super.key,
  });
  factory ProtocolBadge.status(ProtocolStatus status, {bool dot = false}) {
    final (color, background) = switch (status) {
      ProtocolStatus.pendingApproval => (protocolAmber, protocolAmberPanel),
      ProtocolStatus.approved => (protocolTeal, protocolTealPanel),
      ProtocolStatus.rejected ||
      ProtocolStatus.aborted => (protocolRose, protocolRosePanel),
      _ => (const Color(0xFF64748B), protocolPanel),
    };
    return ProtocolBadge(
      protocolStatusLabel(status),
      color: color,
      background: background,
      dot: dot,
    );
  }
  final String label;
  final Color color;
  final Color background;
  final bool dot;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot) ...[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            height: 1,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    ),
  );
}

class ProtocolFrame extends StatelessWidget {
  const ProtocolFrame({
    required this.title,
    required this.child,
    this.subtitle,
    this.bottom,
    super.key,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? bottom;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: DefaultTextStyle.merge(
      style: const TextStyle(fontFamily: 'PlusJakartaSans'),
      child: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              PageHeaderBar(
                title: title,
                subtitle: subtitle,
                backgroundColor: Colors.transparent,
                titleStyle:
                    AppTypography.display(
                      fontSize: 16,
                      height: 1.25,
                      color: AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ).copyWith(
                      fontFamily: 'Sora',
                      fontFamilyFallback: const ['PlusJakartaSans'],
                    ),
                backButton: SizedBox.square(
                  dimension: 36,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    tooltip: 'Quay lại',
                    onPressed: () =>
                        context.canPop() ? context.pop() : context.go('/'),
                    icon: const AppSvgIcon(
                      AppSvgIconName.back,
                      size: 20,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ),
              ),
              ?bottom,
              Expanded(child: child),
            ],
          ),
        ),
      ),
    ),
  );
}

class ProtocolFailure extends StatelessWidget {
  const ProtocolFailure({
    required this.error,
    required this.onRetry,
    super.key,
  });
  final Object error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            protocolError(error),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    ),
  );
}

class ProtocolCard extends StatelessWidget {
  const ProtocolCard({required this.data, required this.onTap, super.key});
  final ProtocolCardData data;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final treatment = data.protocolType == ProtocolType.treatment;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.line, width: 1.25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x590F1C2E),
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x0A0F1C2E),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 14,
                          height: 1.375,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ProtocolBadge.status(
                      data.status,
                      dot: data.status == ProtocolStatus.pendingApproval,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  data.diseaseCaseTitle != null
                      ? 'Ca bệnh: ${data.diseaseCaseTitle}'
                      : data.summary ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.625,
                    color: data.diseaseCaseTitle != null
                        ? const Color(0xFFFF2F61)
                        : AppColors.inkSoft,
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1, color: Color(0xFFEEF1F7)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ProtocolBadge(
                      treatment ? 'Điều trị' : 'Nuôi',
                      color: treatment ? protocolRose : const Color(0xFF0C4E8F),
                      background: treatment
                          ? protocolRosePanel
                          : const Color(0xFFEAF4FF),
                    ),
                    const SizedBox(width: 6),
                    ProtocolBadge('v${data.versionNo}'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${data.authorName} · ${protocolDate(data.submittedAt, year: true)}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const AppSvgIcon(AppSvgIconName.chevron, size: 13),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
