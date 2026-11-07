import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import '../../domain/entities/ai_diagnosis.dart';

abstract final class AiDiagnosisStyle {
  static const purple = Color(0xFF7B5BD6);
  static const lavender = Color(0xFFEFEAFC);
  static const muted = Color(0xFFEEF1F6);
  static const teal = Color(0xFF0F9B8E);
  static const assetRoot = 'assets/icons/ai-diagnosis';

  // The bundled Sora face does not contain all Vietnamese glyphs.
  static TextStyle heading({double fontSize = 14}) => AppTypography.display(
    fontSize: fontSize,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    height: 1.5,
  ).copyWith(fontFamilyFallback: const ['PlusJakartaSans']);
}

class AiIcon extends StatelessWidget {
  const AiIcon(this.name, {super.key});
  final String name;
  @override
  Widget build(BuildContext context) =>
      SvgPicture.asset('${AiDiagnosisStyle.assetRoot}/$name.svg');
}

abstract final class AiDiagnosisText {
  static const unrecognized = 'Chưa thể nhận diện';
  static const unrecognizedDetail =
      'Chưa thể nhận diện bệnh thuộc các nhóm của mô hình';
  static String resultLabel(
    AiDiseaseLabel? value,
    AiRecognitionStatus? status,
  ) => status == AiRecognitionStatus.unrecognized ? unrecognized : label(value);
  static String label(AiDiseaseLabel? label) => switch (label) {
    AiDiseaseLabel.healthy => 'Khỏe mạnh',
    AiDiseaseLabel.bg => 'Mang đen',
    AiDiseaseLabel.wssv => 'Đốm trắng',
    AiDiseaseLabel.wssvBg => 'Đốm trắng và mang đen',
    _ => 'Chưa xác định',
  };
  static String percent(double value) {
    // Truncate display precision so confidence below a cutoff does not appear to reach it.
    final number = (value * 10000).floor() / 100;
    return '${number.toStringAsFixed(number == number.roundToDouble() ? 0 : 2).replaceAll('.', ',')}%';
  }

  static String date(DateTime value) {
    final local = value.toLocal();
    String two(int v) => '$v'.padLeft(2, '0');
    return '${two(local.hour)}:${two(local.minute)} ${two(local.day)}/${two(local.month)}/${local.year}';
  }

  static String message(Object error) => error is AppException
      ? error.message
      : 'Không thể hoàn thành thao tác. Vui lòng thử lại.';
}

class AiDiagnosisFrame extends StatelessWidget {
  const AiDiagnosisFrame({
    required this.title,
    required this.child,
    this.subtitle,
    super.key,
  });
  final String title;
  final String? subtitle;
  final Widget child;
  @override
  Widget build(BuildContext context) => AppGradientBackground(
    child: SafeArea(
      bottom: false,
      child: Column(
        children: [
          PageHeaderBar(
            title: title,
            titleStyle: AiDiagnosisStyle.heading(fontSize: 16),
            subtitle: subtitle,
            onBack: () => Navigator.of(context).maybePop(),
            backButton: SizedBox(
              width: 36,
              height: 44,
              child: IconButton(
                tooltip: 'Quay lại',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const AiIcon('back'),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    ),
  );
}

class AiCard extends StatelessWidget {
  const AiCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    super.key,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(
          color: Color(0x590F1C2E),
          blurRadius: 12,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Material(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.line, width: 0.8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}

class AiTitle extends StatelessWidget {
  const AiTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) =>
      Text(text, style: AiDiagnosisStyle.heading());
}

class AiBadge extends StatelessWidget {
  const AiBadge(this.text, {this.empty = false, this.error = false, super.key});
  final String text;
  final bool empty;
  final bool error;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: error
          ? const Color(0xFFFBE6EA)
          : empty
          ? AiDiagnosisStyle.muted
          : AiDiagnosisStyle.lavender,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: error
            ? AppColors.error
            : empty
            ? AppColors.inkMuted
            : AiDiagnosisStyle.purple,
      ),
    ),
  );
}

class AiFailure extends StatelessWidget {
  const AiFailure({required this.error, required this.onRetry, super.key});
  final Object error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AiDiagnosisText.message(error),
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.error),
        ),
        TextButton(onPressed: onRetry, child: const Text('Thử lại')),
      ],
    ),
  );
}

class AiDashedBox extends StatelessWidget {
  const AiDashedBox({
    required this.child,
    required this.onTap,
    this.radius = 16,
    super.key,
  });
  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: _DashedOutline(radius),
    child: Material(
      color: AiDiagnosisStyle.purple.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: child,
      ),
    ),
  );
}

class _DashedOutline extends CustomPainter {
  _DashedOutline(this.radius);
  final double radius;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    final paint = Paint()
      ..color = AiDiagnosisStyle.purple.withValues(alpha: 0.25)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    for (final metric in path.computeMetrics()) {
      for (double offset = 0; offset < metric.length; offset += 9) {
        canvas.drawPath(metric.extractPath(offset, offset + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedOutline oldDelegate) =>
      radius != oldDelegate.radius;
}
