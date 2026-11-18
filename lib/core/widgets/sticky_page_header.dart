import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_circle_button.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';

/// A page header that stays pinned while its [CustomScrollView] scrolls.
///
/// The separate [PageHeaderBar] can be used by full-screen pages that do not
/// scroll, while preserving the same title, navigation and action treatment.
class StickyPageHeader extends StatelessWidget {
  const StickyPageHeader({
    required this.title,
    this.subtitle,
    this.onBack,
    this.showBack = true,
    this.trailing,
    this.backButton,
    this.bottom,
    this.bottomHeight = 0,
    this.height = 76,
    this.titleSize = 16,
    this.backgroundColor,
    this.titleStyle,
    this.subtitleStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;
  final Widget? backButton;
  final Widget? bottom;
  final double bottomHeight;
  final double height;
  final double titleSize;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
    pinned: true,
    delegate: _StickyPageHeaderDelegate(
      title: title,
      subtitle: subtitle,
      onBack: onBack,
      showBack: showBack,
      trailing: trailing,
      backButton: backButton,
      bottom: bottom,
      bottomHeight: bottomHeight,
      height: _headerHeight(
        context,
        height,
        titleSize,
        subtitle,
        titleStyle,
        subtitleStyle,
      ),
      titleSize: titleSize,
      backgroundColor: backgroundColor,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      contentPadding: contentPadding,
    ),
  );
}

/// Static counterpart for screens such as a full-screen map.
class PageHeaderBar extends StatelessWidget {
  const PageHeaderBar({
    required this.title,
    this.subtitle,
    this.onBack,
    this.showBack = true,
    this.trailing,
    this.height = 76,
    this.titleSize = 16,
    this.backgroundColor,
    this.backButton,
    this.titleStyle,
    this.subtitleStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;
  final double height;
  final double titleSize;
  final Color? backgroundColor;
  final Widget? backButton;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: _headerHeight(
      context,
      height,
      titleSize,
      subtitle,
      titleStyle,
      subtitleStyle,
    ),
    child: AppBackgroundSurface(
      color: backgroundColor,
      child: _PageHeaderContent(
        title: title,
        subtitle: subtitle,
        onBack: onBack,
        showBack: showBack,
        trailing: trailing,
        titleSize: titleSize,
        backButton: backButton,
        titleStyle: titleStyle,
        subtitleStyle: subtitleStyle,
        contentPadding: contentPadding,
      ),
    ),
  );
}

class _StickyPageHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _StickyPageHeaderDelegate({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.showBack,
    required this.trailing,
    required this.backButton,
    required this.bottom,
    required this.bottomHeight,
    required this.height,
    required this.titleSize,
    required this.backgroundColor,
    required this.titleStyle,
    required this.subtitleStyle,
    required this.contentPadding,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;
  final Widget? backButton;
  final Widget? bottom;
  final double bottomHeight;
  final double height;
  final double titleSize;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry contentPadding;

  @override
  double get minExtent => height + (bottom == null ? 0 : bottomHeight);

  @override
  double get maxExtent => minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => AppBackgroundSurface(
    color: backgroundColor,
    child: Column(
      children: <Widget>[
        SizedBox(
          height: height,
          child: _PageHeaderContent(
            title: title,
            subtitle: subtitle,
            onBack: onBack,
            showBack: showBack,
            trailing: trailing,
            backButton: backButton,
            titleSize: titleSize,
            titleStyle: titleStyle,
            subtitleStyle: subtitleStyle,
            contentPadding: contentPadding,
          ),
        ),
        if (bottom != null)
          SizedBox(width: double.infinity, height: bottomHeight, child: bottom),
      ],
    ),
  );

  @override
  bool shouldRebuild(covariant _StickyPageHeaderDelegate oldDelegate) =>
      title != oldDelegate.title ||
      subtitle != oldDelegate.subtitle ||
      onBack != oldDelegate.onBack ||
      showBack != oldDelegate.showBack ||
      trailing != oldDelegate.trailing ||
      backButton != oldDelegate.backButton ||
      bottom != oldDelegate.bottom ||
      bottomHeight != oldDelegate.bottomHeight ||
      height != oldDelegate.height ||
      titleSize != oldDelegate.titleSize ||
      backgroundColor != oldDelegate.backgroundColor ||
      titleStyle != oldDelegate.titleStyle ||
      subtitleStyle != oldDelegate.subtitleStyle ||
      contentPadding != oldDelegate.contentPadding;
}

class _PageHeaderContent extends StatelessWidget {
  const _PageHeaderContent({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.showBack,
    required this.trailing,
    required this.titleSize,
    this.backButton,
    this.titleStyle,
    this.subtitleStyle,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16),
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;
  final double titleSize;
  final Widget? backButton;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) => SizedBox.expand(
    child: Padding(
      padding: contentPadding,
      child: LayoutBuilder(
        builder: (context, constraints) => Row(
          children: <Widget>[
            if (showBack) ...<Widget>[
              SizedBox(
                width: 36,
                height: 44,
                child:
                    backButton ??
                    AppCircleButton(
                      icon: Icons.arrow_back,
                      tooltip: 'Quay lại',
                      onPressed: onBack,
                      size: 36,
                      backgroundColor: Colors.transparent,
                      iconWidget: const Center(
                        child: AppSvgIcon(
                          AppSvgIconName.back,
                          size: 20,
                          color: AppColors.inkSoft,
                        ),
                      ),
                    ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        titleStyle ??
                        AppTypography.display(
                          color: AppColors.ink,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ).copyWith(
                          fontFamilyFallback: const ['PlusJakartaSans'],
                        ),
                  ),
                  if (subtitle case final subtitle?)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          subtitleStyle ??
                          const TextStyle(
                            color: AppColors.inkSoft,
                            fontSize: 13,
                            height: 1.5,
                          ),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...<Widget>[
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * .45,
                ),
                child: trailing!,
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

/// Keep controls usable when accessibility text is larger than the standard header.
double _headerHeight(
  BuildContext context,
  double height,
  double titleSize,
  String? subtitle,
  TextStyle? titleStyle,
  TextStyle? subtitleStyle,
) {
  final scaler = MediaQuery.textScalerOf(context);
  final titleHeight =
      scaler.scale(titleStyle?.fontSize ?? titleSize) *
      (titleStyle?.height ?? 1.25);
  final subtitleHeight = subtitle == null
      ? 0
      : scaler.scale(subtitleStyle?.fontSize ?? 13) *
            (subtitleStyle?.height ?? 1.5);
  return math.max(height, 24 + titleHeight + subtitleHeight);
}
