import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

enum AppSvgIconName {
  home,
  farm,
  shrimp,
  shrimpFeed,
  tasks,
  notifications,
  account,
  warning,
  document,
  shield,
  box,
  users,
  calendar,
  expand,
  back,
  chevron,
  chevronDown,
}

class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon(
    this.icon, {
    this.size = 20,
    this.color = AppColors.inkMuted,
    super.key,
  });
  final AppSvgIconName icon;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/icons/common/${icon == AppSvgIconName.shrimpFeed
        ? 'shrimp-feed'
        : icon == AppSvgIconName.chevronDown
        ? 'chevron-down'
        : icon.name}.svg',
    width: size,
    height: size,
    fit: BoxFit.contain,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    excludeFromSemantics: true,
  );
}
