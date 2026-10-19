import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';

/// Shared select geometry from Figma 261:3890 with a bounded, scrollable menu.
class AppSelectField<T> extends StatelessWidget {
  const AppSelectField({
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.hint,
    this.style,
    this.decoration = const InputDecoration(),
    super.key,
  });
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;
  final String? hint;
  final TextStyle? style;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) => FormField<T>(
    initialValue: value,
    validator: (_) => validator?.call(value),
    enabled: onChanged != null,
    builder: (field) {
      final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
      final height = math.max(
        AppFormMetrics.selectHeight,
        AppFormMetrics.selectHeight + (scale - 1) * 18.105,
      );
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (decoration.labelText != null) ...[
            AppFieldLabel(decoration.labelText!),
            const SizedBox(height: AppFormMetrics.labelGap),
          ],
          SizedBox(
            height: height,
            child: InputDecorator(
              isEmpty: value == null && hint != null,
              decoration: AppFormMetrics.decoration(
                decoration,
                select: true,
                hasError: field.hasError,
              ).copyWith(enabled: onChanged != null),
              child: SizedBox(
                height: height,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: value,
                    isExpanded: true,
                    isDense: true,
                    menuMaxHeight: 320,
                    menuWidth: (MediaQuery.sizeOf(context).width - 32)
                        .clamp(0, 400)
                        .toDouble(),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(AppFormMetrics.radius),
                    elevation: 4,
                    itemHeight: null,
                    style:
                        (style ??
                                const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  color: AppColors.ink,
                                ))
                            .copyWith(fontSize: 14, height: 18.105 / 14),
                    hint: hint == null ? null : Text(hint!),
                    icon: const SizedBox(
                      width: 20,
                      height: 18,
                      child: Center(
                        child: AppSvgIcon(
                          AppSvgIconName.dropdownChevron,
                          size: 10,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    selectedItemBuilder: (_) => items
                        .map(
                          (item) => Align(
                            alignment: Alignment.centerLeft,
                            child: _selectedLabel(item.child),
                          ),
                        )
                        .toList(),
                    items: items
                        .map(
                          (item) => DropdownMenuItem<T>(
                            value: item.value,
                            enabled: item.enabled,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: item.child,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: onChanged == null
                        ? null
                        : (next) {
                            field.didChange(next);
                            onChanged!(next);
                          },
                  ),
                ),
              ),
            ),
          ),
          if (field.hasError) AppFieldError(field.errorText!),
        ],
      );
    },
  );

  Widget _selectedLabel(Widget child) {
    if (child is Text && child.data != null) {
      return Tooltip(
        message: child.data!,
        child: Text(
          child.data!,
          style: child.style,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          semanticsLabel: child.semanticsLabel,
        ),
      );
    }
    return DefaultTextStyle.merge(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: child,
    );
  }
}
