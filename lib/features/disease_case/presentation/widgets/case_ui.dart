import 'package:flutter/material.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import '../../domain/domain.dart';

String caseError(Object error) => error is AppException
    ? error.message
    : 'Không thể xử lý yêu cầu. Vui lòng thử lại.';
String caseDate(DateTime value) {
  final date = value.toUtc().add(const Duration(hours: 7));
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(date.day)}/${two(date.month)}/${date.year} ${two(date.hour)}:${two(date.minute)}';
}

String caseContext(Map<String, dynamic> value) => [
  value['pondName'],
  value['seasonName'] ?? value['name'],
].whereType<String>().where((s) => s.trim().isNotEmpty).join(' · ');

String caseAiLabel(Map<dynamic, dynamic> ai) {
  if (ai['recognitionStatus'] == 'UNRECOGNIZED') return 'Chưa thể nhận diện';
  return switch (ai['predictedLabel']) {
    'WSSV' => 'Đốm trắng',
    'BG' => 'Mang đen',
    'WSSV_BG' => 'Đốm trắng và mang đen',
    'Healthy' => 'Khỏe mạnh',
    final String label when label.trim().isNotEmpty => label,
    _ => 'Chưa thể nhận diện',
  };
}

String caseAiConfidence(num? confidence) {
  if (confidence == null ||
      !confidence.isFinite ||
      confidence < 0 ||
      confidence > 1) {
    return 'Chưa có độ tin cậy';
  }
  // Preserve the same truncated display precision as the AI history.
  final percent = (confidence * 10000).floor() / 100;
  final digits = percent == percent.roundToDouble() ? 0 : 2;
  return 'Độ tin cậy ${percent.toStringAsFixed(digits).replaceAll('.', ',')}%';
}

const caseRose = Color(0xFFD63858);
const caseViolet = Color(0xFF8054F4);

class CaseFrame extends StatelessWidget {
  const CaseFrame({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.composer,
    this.notice,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? trailing;
  final Widget? composer;
  final Widget? notice;
  @override
  Widget build(BuildContext context) => AppGradientBackground(
    child: Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Column(
              children: [
                PageHeaderBar(
                  title: title,
                  subtitle: subtitle,
                  trailing: trailing,
                  backgroundColor: Colors.transparent,
                  onBack: () => Navigator.of(context).maybePop(),
                  titleStyle: AppTypography.display(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    height: 1.5,
                  ).copyWith(fontFamilyFallback: const ['PlusJakartaSans']),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      child,
                      if (notice != null)
                        Positioned(top: 0, left: 0, right: 0, child: notice!),
                    ],
                  ),
                ),
                ?composer,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class CaseSurface extends StatelessWidget {
  const CaseSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(15),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.line),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A0F1C2E),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

class CaseBadge extends StatelessWidget {
  const CaseBadge(
    this.label, {
    super.key,
    this.color = AppColors.inkMuted,
    this.background = const Color(0xFFF0F3F8),
    this.dot = false,
  });
  final String label;
  final Color color;
  final Color background;
  final bool dot;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot) ...[
          Icon(Icons.circle, size: 5, color: color),
          const SizedBox(width: 4),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              height: 1.2,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class CaseStatusBadge extends StatelessWidget {
  const CaseStatusBadge(this.status, {super.key});
  final DiseaseCaseStatus status;
  @override
  Widget build(BuildContext context) {
    final (color, background) = switch (status) {
      DiseaseCaseStatus.resolved => (
        const Color(0xFF0F9B8E),
        const Color(0xFFE2F6F3),
      ),
      DiseaseCaseStatus.inTreatment => (caseRose, const Color(0xFFFBE6EA)),
      DiseaseCaseStatus.waitingForInfo => (
        const Color(0xFFB97714),
        const Color(0xFFFFF2D9),
      ),
      DiseaseCaseStatus.monitoring => (caseViolet, const Color(0xFFF0E9FF)),
      _ => (AppColors.ocean, const Color(0xFFEAF4FF)),
    };
    return Tooltip(
      message: status.label,
      child: CaseBadge(
        status.label,
        color: color,
        background: background,
        dot: true,
      ),
    );
  }
}

class CasePrimaryButton extends StatelessWidget {
  const CasePrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.health_and_safety_rounded,
    this.busy = false,
    this.destructive = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool busy;
  final bool destructive;
  @override
  Widget build(BuildContext context) => GradientButton(
    label: label,
    onPressed: onPressed,
    isLoading: busy,
    icon: icon,
    compact: true,
    height: 48,
    borderRadius: 12,
    gradientColors: destructive ? const [caseRose, Color(0xFFE75D72)] : null,
  );
}

InputDecoration caseInput(String hint) => InputDecoration(
  isDense: true,
  hintText: hint,
  hintStyle: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
  contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.line),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.ocean),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: caseRose),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: caseRose),
  ),
);

class CaseField extends StatelessWidget {
  const CaseField(
    this.label, {
    super.key,
    required this.child,
    this.bottomGap = 13,
  });
  final String label;
  final Widget child;
  final double bottomGap;
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: bottomGap),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            height: 1.2,
            color: AppColors.inkSoft,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    ),
  );
}

class CaseFailure extends StatelessWidget {
  const CaseFailure({super.key, required this.error, required this.retry});
  final Object error;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(caseError(error), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: retry, child: const Text('Thử lại')),
        ],
      ),
    ),
  );
}
