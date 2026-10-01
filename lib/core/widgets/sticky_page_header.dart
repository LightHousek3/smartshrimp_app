import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

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
    this.bottom,
    this.bottomHeight = 0,
    this.height = 76,
    this.titleSize = 16,
    this.backgroundColor = AppColors.backgroundTop,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;
  final Widget? bottom;
  final double bottomHeight;
  final double height;
  final double titleSize;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
    pinned: true,
    delegate: _StickyPageHeaderDelegate(
      title: title,
      subtitle: subtitle,
      onBack: onBack,
      showBack: showBack,
      trailing: trailing,
      bottom: bottom,
      bottomHeight: bottomHeight,
      height: height,
      titleSize: titleSize,
      backgroundColor: backgroundColor,
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
    this.backgroundColor = AppColors.backgroundTop,
    super.key,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;
  final double height;
  final double titleSize;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: height,
    child: _PageHeaderContent(
      title: title,
      subtitle: subtitle,
      onBack: onBack,
      showBack: showBack,
      trailing: trailing,
      titleSize: titleSize,
      backgroundColor: backgroundColor,
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
    required this.bottom,
    required this.bottomHeight,
    required this.height,
    required this.titleSize,
    required this.backgroundColor,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;
  final Widget? bottom;
  final double bottomHeight;
  final double height;
  final double titleSize;
  final Color backgroundColor;

  @override
  double get minExtent => height + (bottom == null ? 0 : bottomHeight);

  @override
  double get maxExtent => minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => ColoredBox(
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
            titleSize: titleSize,
            backgroundColor: backgroundColor,
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
      bottom != oldDelegate.bottom ||
      bottomHeight != oldDelegate.bottomHeight ||
      height != oldDelegate.height ||
      titleSize != oldDelegate.titleSize ||
      backgroundColor != oldDelegate.backgroundColor;
}

class _PageHeaderContent extends StatelessWidget {
  const _PageHeaderContent({
    required this.title,
    required this.subtitle,
    required this.onBack,
    required this.showBack,
    required this.trailing,
    required this.titleSize,
    required this.backgroundColor,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final bool showBack;
  final Widget? trailing;
  final double titleSize;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: backgroundColor,
    child: SizedBox.expand(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            if (showBack) ...<Widget>[
              SizedBox(
                width: 40,
                height: 44,
                child: IconButton(
                  tooltip: 'Quay lại',
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 44,
                  ),
                  icon: const Icon(Icons.arrow_back_rounded, size: 22),
                  color: AppColors.inkSoft,
                ),
              ),
              const SizedBox(width: 8),
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
                    style: AppTypography.display(
                      color: AppColors.ink,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  if (subtitle case final subtitle?)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...<Widget>[
              const SizedBox(width: 8),
              trailing!,
            ],
          ],
        ),
      ),
    ),
  );
}
