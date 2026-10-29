import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

enum AppSvgIconName {
  plus,
  dropdownChevron,
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
  info,
  clock,
  medicine,
  chemical,
  mineral,
  check,
  close,
  email,
  phone,
  badge,
  edit,
  logout,
  eye,
  shieldOutline,
  sparkles,
  pin,
  person,
  arrowBack,
  calendarDays,
  farmCompact,
  homeCompact,
  bellOutline,
  chevronCompact,
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

  String get _assetName => switch (icon) {
    AppSvgIconName.dropdownChevron => 'dropdown-chevron',
    AppSvgIconName.shrimpFeed => 'shrimp-feed',
    AppSvgIconName.chevronDown => 'chevron-down',
    AppSvgIconName.shieldOutline => 'shield-outline',
    AppSvgIconName.arrowBack => 'arrow-back',
    AppSvgIconName.calendarDays => 'calendar-days',
    AppSvgIconName.farmCompact => 'farm-compact',
    AppSvgIconName.homeCompact => 'home-compact',
    AppSvgIconName.bellOutline => 'bell-outline',
    AppSvgIconName.chevronCompact => 'chevron-compact',
    _ => icon.name,
  };

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/icons/common/$_assetName.svg',
    width: size,
    height: icon == AppSvgIconName.dropdownChevron ? size * .6 : size,
    fit: BoxFit.contain,
    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    excludeFromSemantics: true,
  );
}
