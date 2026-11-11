import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';

import '../../domain/entities/owner_disease_case.dart';

typedef CaseTone = ({Color foreground, Color background});

const CaseTone caseBlue = (
  foreground: Color(0xFF0C4E8F),
  background: Color(0xFFEAF4FF),
);
const CaseTone casePurple = (
  foreground: Color(0xFF7B5BD6),
  background: Color(0xFFEFEAFC),
);
const CaseTone caseRose = (
  foreground: AppColors.error,
  background: Color(0xFFFBE6EA),
);
const CaseTone caseAmber = (
  foreground: Color(0xFFD98314),
  background: Color(0xFFFBF0DC),
);
const CaseTone caseTeal = (
  foreground: Color(0xFF0F9B8E),
  background: Color(0xFFE2F6F3),
);
const CaseTone caseNeutral = (
  foreground: Color(0xFF64748B),
  background: Color(0xFFEEF1F6),
);
const caseAiAccent = Color(0xFF831CFF);
const caseDivider = Divider(height: 1, thickness: 1, color: Color(0xFFEEF1F6));
const caseMetadataStyle = TextStyle(
  color: AppColors.inkMuted,
  fontSize: 10,
  height: 1.5,
);
const caseTitleStyle = TextStyle(
  color: AppColors.ink,
  fontSize: 14,
  height: 1.375,
  fontWeight: FontWeight.w700,
);
const caseBodyStyle = TextStyle(
  color: AppColors.inkSoft,
  fontSize: 12,
  height: 1.55,
);

String caseErrorMessage(Object error) => error is AppException
    ? error.message
    : 'Không thể tải dữ liệu ca bệnh. Vui lòng thử lại.';

class DiseaseCaseFrame extends StatelessWidget {
  const DiseaseCaseFrame({
    required this.title,
    required this.slivers,
    this.subtitle,
    this.tabs,
    this.onRefresh,
    this.scrollKey,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? tabs;
  final List<Widget> slivers;
  final Future<void> Function()? onRefresh;
  final Key? scrollKey;

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    final scroll = CustomScrollView(
      key: scrollKey,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        StickyPageHeader(
          title: title,
          subtitle: subtitle,
          height: 62 + (textScaler.scale(28) - 28).clamp(0, double.infinity),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          backButton: SizedBox(
            width: 36,
            height: 44,
            child: IconButton(
              tooltip: 'Quay lại',
              padding: EdgeInsets.zero,
              onPressed: () =>
                  context.canPop() ? context.pop() : context.go('/farms'),
              icon: const AppSvgIcon(
                AppSvgIconName.arrowBack,
                color: AppColors.inkSoft,
              ),
            ),
          ),
          titleStyle: const TextStyle(
            fontFamily: 'Sora',
            fontFamilyFallback: ['PlusJakartaSans'],
            fontSize: 16,
            height: 1.25,
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
          subtitleStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            height: 1.5,
            color: AppColors.inkMuted,
            letterSpacing: 0,
          ),
          bottom: tabs,
          bottomHeight:
              52 + 3 * (textScaler.scale(13) - 13).clamp(0, double.infinity),
        ),
        ...slivers,
      ],
    );
    return Scaffold(
      body: DefaultTextStyle.merge(
        style: const TextStyle(fontFamily: 'PlusJakartaSans'),
        child: AppGradientBackground(
          colors: [
            AppColors.backgroundTop,
            Color.lerp(
              AppColors.backgroundTop,
              AppColors.backgroundBottom,
              .925,
            )!,
          ],
          stops: const [0, 1],
          child: SafeArea(
            bottom: false,
            child: onRefresh == null
                ? scroll
                : RefreshIndicator(onRefresh: onRefresh!, child: scroll),
          ),
        ),
      ),
    );
  }
}

class DiseaseCaseSurface extends StatelessWidget {
  const DiseaseCaseSurface({
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.onTap,
    this.summary = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool summary;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(summary ? 16 : 18);
    final content = Padding(
      padding: summary ? padding : padding.add(const EdgeInsets.all(1)),
      child: child,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: summary
            ? const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x590F1C2E),
                  blurRadius: 12,
                  offset: Offset(0, 8),
                ),
              ],
      ),
      child: Material(
        color: Colors.white,
        textStyle: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          letterSpacing: 0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: summary
              ? BorderSide.none
              : const BorderSide(color: AppColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: double.infinity,
          child: onTap == null
              ? content
              : InkWell(onTap: onTap, child: content),
        ),
      ),
    );
  }
}

class DiseaseCaseBadge extends StatelessWidget {
  const DiseaseCaseBadge(
    this.label, {
    this.tone = caseNeutral,
    this.dot = false,
    super.key,
  });

  factory DiseaseCaseBadge.status(
    DiseaseCaseStatus status, {
    bool dot = true,
    bool list = false,
  }) {
    final (label, tone) = switch (status) {
      DiseaseCaseStatus.open => ('Mới mở', caseBlue),
      DiseaseCaseStatus.waitingForInfo => ('Chờ thông tin', caseAmber),
      DiseaseCaseStatus.monitoring => ('Đang theo dõi', casePurple),
      DiseaseCaseStatus.inTreatment => (
        'Đang điều trị',
        list ? casePurple : caseRose,
      ),
      DiseaseCaseStatus.resolved => ('Đã giải quyết', caseTeal),
      DiseaseCaseStatus.unknown => ('Chưa xác định', caseNeutral),
    };
    return DiseaseCaseBadge(label, tone: tone, dot: dot);
  }

  factory DiseaseCaseBadge.severity(DiseaseCaseSeverity severity) {
    final (label, tone) = switch (severity) {
      DiseaseCaseSeverity.low => ('Mức Thấp', caseNeutral),
      DiseaseCaseSeverity.medium => ('Mức Trung bình', caseAmber),
      DiseaseCaseSeverity.high => ('Mức Cao', caseRose),
      DiseaseCaseSeverity.critical => ('Mức Nguy cấp', caseRose),
      DiseaseCaseSeverity.unknown => ('Chưa xác định', caseNeutral),
    };
    return DiseaseCaseBadge(label, tone: tone);
  }

  final String label;
  final CaseTone tone;
  final bool dot;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: tone.background,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot) ...[
          DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tone.foreground,
            ),
            child: const SizedBox.square(dimension: 6),
          ),
          const SizedBox(width: 6),
        ],
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: tone.foreground,
              fontSize: 11,
              height: 1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class DiseaseCaseSectionTitle extends StatelessWidget {
  const DiseaseCaseSectionTitle(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Sora',
            fontFamilyFallback: ['PlusJakartaSans'],
            color: AppColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
      ),
      if (trailing != null) ...[const SizedBox(width: 8), trailing!],
    ],
  );
}

class DiseaseCaseTitleRow extends StatelessWidget {
  const DiseaseCaseTitleRow({
    required this.title,
    required this.badge,
    super.key,
  });

  final Widget title;
  final Widget badge;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Expanded(child: title),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: constraints.maxWidth * .42),
          child: badge,
        ),
      ],
    ),
  );
}

class DiseaseCaseFailure extends StatelessWidget {
  const DiseaseCaseFailure({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFormMessageBanner(
          title: 'Không thể tải ca bệnh',
          message: caseErrorMessage(error),
          level: AppNoticeLevel.danger,
        ),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: onRetry, child: const Text('Thử lại')),
      ],
    ),
  );
}
