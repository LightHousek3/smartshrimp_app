import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/destructive_action_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';

const inventoryInputTextStyle = TextStyle(
  color: AppColors.ink,
  fontSize: 14,
  height: 1.5,
);

abstract final class InventoryAssets {
  static const _root = 'assets/icons/inventory';
  static const back = '$_root/back.svg';
  static const building = '$_root/building.svg';
  static const chevronDown = '$_root/chevron_down.svg';
  static const search = '$_root/search.svg';
  static const add = '$_root/add.svg';
  static const inventoryBox = '$_root/inventory_box.svg';
  static const medicine = '$_root/medicine.svg';
  static const chevronRight = '$_root/chevron_right.svg';
  static const history = '$_root/history.svg';
  static const edit = '$_root/edit.svg';
  static const plusWhite = '$_root/plus_white.svg';
  static const close = '$_root/close.svg';
  static const closeDark = '$_root/close_dark.svg';
  static const stockIn = '$_root/stock_in.svg';
  static const removeImage = '$_root/remove_image.svg';
  static const camera = '$_root/camera.svg';
  static const save = '$_root/save.svg';
}

class InventoryPageFrame extends StatelessWidget {
  const InventoryPageFrame({
    required this.title,
    required this.child,
    required this.onBack,
    this.headerHeight = 76,
    this.subtitle,
    this.trailing,
    this.stackChildren = const <Widget>[],
    super.key,
  });

  final double headerHeight;
  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback onBack;
  final Widget? trailing;
  final List<Widget> stackChildren;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                PageHeaderBar(
                  title: title,
                  subtitle: subtitle,
                  onBack: onBack,
                  height: headerHeight,
                  backgroundColor: Colors.transparent,
                  backButton: Semantics(
                    button: true,
                    label: 'Quay lại',
                    child: InkResponse(
                      onTap: onBack,
                      radius: 22,
                      child: SizedBox.square(
                        dimension: 36,
                        child: Center(
                          child: SvgPicture.asset(
                            InventoryAssets.back,
                            width: 20,
                            height: 20,
                            colorFilter: const ColorFilter.mode(
                              AppColors.inkSoft,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  trailing: trailing,
                ),
                Expanded(child: child),
              ],
            ),
            ...stackChildren,
          ],
        ),
      ),
    ),
  );
}

class InventorySvgIcon extends StatelessWidget {
  const InventorySvgIcon(
    this.asset, {
    required this.size,
    this.colorFilter,
    super.key,
  });

  final String asset;
  final double size;
  final ColorFilter? colorFilter;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    asset,
    width: size,
    height: size,
    colorFilter: colorFilter,
  );
}

class InventorySurface extends StatelessWidget {
  const InventorySurface({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 16,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: AppColors.line),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x0F000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );
}

class InventoryCategoryBadge extends StatelessWidget {
  const InventoryCategoryBadge({required this.category, super.key});

  final InventoryProductCategory category;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: category.background,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      category.label,
      maxLines: 1,
      style: TextStyle(
        color: category.foreground,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1,
      ),
    ),
  );
}

class LowStockBadge extends StatelessWidget {
  const LowStockBadge({super.key});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFFBE6EA),
      borderRadius: BorderRadius.circular(99),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.error,
            shape: BoxShape.circle,
          ),
          child: SizedBox.square(dimension: 6),
        ),
        SizedBox(width: 6),
        Text(
          'Tồn kho thấp',
          style: TextStyle(
            color: AppColors.error,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ],
    ),
  );
}

class InventoryField extends StatelessWidget {
  const InventoryField({
    required this.label,
    required this.child,
    this.spacing = 7,
    this.labelSize = 13,
    super.key,
  });

  final String label;
  final Widget child;
  final double spacing;
  final double labelSize;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: TextStyle(
          color: AppColors.inkSoft,
          fontSize: labelSize,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
      ),
      SizedBox(height: spacing),
      child,
    ],
  );
}

class InventoryFilterChip extends StatelessWidget {
  const InventoryFilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label, maxLines: 1, textAlign: TextAlign.center),
    showCheckmark: false,
    labelStyle: TextStyle(
      color: selected ? AppColors.ocean : AppColors.inkSoft,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),
    backgroundColor: Colors.white,
    selectedColor: const Color(0xFFEAF4FF),
    side: BorderSide(color: selected ? AppColors.oceanLight : AppColors.line),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    selected: selected,
    onSelected: onSelected,
  );
}

InputDecoration inventoryInputDecoration({
  String? hintText,
  Widget? suffixIcon,
  EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 12,
  ),
}) => InputDecoration(
  hintText: hintText,
  hintStyle: const TextStyle(
    color: AppColors.inkMuted,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
  isDense: true,
  filled: true,
  fillColor: Colors.white,
  contentPadding: contentPadding,
  suffixIcon: suffixIcon,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.line, width: 1),
  ),
  disabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.line),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.oceanLight, width: 1.5),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.error),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: AppColors.error, width: 1.5),
  ),
  errorStyle: const TextStyle(
    color: AppColors.error,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
);

class InventoryGradientButton extends StatelessWidget {
  const InventoryGradientButton({
    required this.label,
    required this.iconAsset,
    required this.onPressed,
    this.iconColor,
    this.height = 45,
    this.radius = 16,
    this.gradientColors = const [
      AppColors.oceanLight,
      AppColors.tealLight,
      AppColors.oceanLight,
    ],
    super.key,
  });

  final String label;
  final String iconAsset;
  final Color? iconColor;
  final VoidCallback? onPressed;
  final double height;
  final double radius;
  final List<Color> gradientColors;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: onPressed == null
            ? const <Color>[Color(0xFFBAC6D1), Color(0xFFBAC6D1)]
            : gradientColors,
      ),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: onPressed == null
          ? null
          : const <BoxShadow>[
              BoxShadow(
                color: Color(0x3377A1D3),
                blurRadius: 14,
                offset: Offset(0, 7),
              ),
            ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(radius),
        child: SizedBox(
          height: height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InventorySvgIcon(
                iconAsset,
                size: 18,
                colorFilter: iconColor == null
                    ? null
                    : ColorFilter.mode(iconColor!, BlendMode.srcIn),
              ),
              const SizedBox(width: 9),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class InventoryDangerButton extends StatelessWidget {
  const InventoryDangerButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 46,
    child: DestructiveActionButton(label: label, onPressed: onPressed),
  );
}
