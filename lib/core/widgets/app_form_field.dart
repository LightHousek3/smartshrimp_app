import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

abstract final class AppFormMetrics {
  static const inputHeight = 43.373;
  static const selectHeight = 38.0;
  static const controlHeight = 35.0;
  static const radius = 12.0;
  static const borderWidth = 1.208;
  static const labelGap = 6.0;
  static const errorGap = 0.0;
  static const errorBorderColor = Color(0xFFFF637E);
  static const contentPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: 10,
  );
  // InputDecorator excludes the outline from its content-height calculation.
  static const inputPadding = EdgeInsets.symmetric(
    horizontal: 14,
    vertical: (inputHeight - 21) / 2,
  );
  static const selectPadding = EdgeInsets.only(left: 18);
  static const labelStyle = TextStyle(
    fontSize: 12,
    height: 1.5,
    fontWeight: FontWeight.w600,
    color: AppColors.inkSoft,
  );
  static const errorStyle = TextStyle(
    fontSize: 11,
    height: 1.5,
    fontWeight: FontWeight.w600,
    color: AppColors.error,
  );
  static const inputStyle = TextStyle(
    fontSize: 14,
    height: 1.5,
    color: AppColors.ink,
  );

  static OutlineInputBorder border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(color: color, width: borderWidth),
  );

  static InputDecoration decoration(
    InputDecoration source, {
    bool hasError = false,
    bool select = false,
  }) => InputDecoration(
    hintText: source.hintText,
    hintStyle: (source.hintStyle ?? const TextStyle()).copyWith(
      fontSize: 14,
      height: 1.5,
      color: AppColors.inkMuted,
    ),
    isDense: true,
    filled: true,
    fillColor: source.fillColor ?? Colors.white,
    enabled: source.enabled,
    constraints: const BoxConstraints(),
    contentPadding: select ? selectPadding : inputPadding,
    error: hasError ? const SizedBox.shrink() : null,
    counterText: '',
    prefixIcon: source.prefixIcon,
    prefixIconConstraints: const BoxConstraints(minWidth: 42, minHeight: 0),
    suffixIcon: source.suffixIcon,
    suffixIconConstraints: const BoxConstraints(minWidth: 42, minHeight: 0),
    prefix: source.prefix,
    prefixText: source.prefixText,
    prefixStyle: source.prefixStyle,
    suffix: source.suffix,
    suffixText: source.suffixText,
    suffixStyle: source.suffixStyle,
    border: border(AppColors.line),
    enabledBorder: border(AppColors.line),
    disabledBorder: border(AppColors.line),
    focusedBorder: border(AppColors.oceanLight),
    errorBorder: border(errorBorderColor),
    focusedErrorBorder: border(errorBorderColor),
  );
}

class AppFieldLabel extends StatelessWidget {
  const AppFieldLabel(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) =>
      Text(label, style: AppFormMetrics.labelStyle);
}

class AppFieldError extends StatelessWidget {
  const AppFieldError(this.message, {super.key});
  final String message;
  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(minHeight: 21),
    child: Padding(
      padding: const EdgeInsets.only(top: AppFormMetrics.errorGap),
      child: Text(message, style: AppFormMetrics.errorStyle),
    ),
  );
}

/// A shared input with an independent error row, matching Figma 261:3847.
/// Single-line controls keep their geometry when validation messages appear.
class AppTextField extends FormField<String> {
  AppTextField({
    this.controller,
    String? initialValue,
    this.focusNode,
    this.decoration = const InputDecoration(),
    this.style,
    super.enabled = true,
    bool readOnly = false,
    bool obscureText = false,
    bool autocorrect = true,
    bool enableSuggestions = true,
    bool autofocus = false,
    bool expands = false,
    int? maxLength,
    int? maxLines = 1,
    int? minLines,
    double? height,
    MaxLengthEnforcement? maxLengthEnforcement,
    List<TextInputFormatter>? inputFormatters,
    Iterable<String>? autofillHints,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextAlignVertical? textAlignVertical,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onTap,
    super.validator,
    super.onSaved,
    super.autovalidateMode,
    super.key,
  }) : assert(controller == null || initialValue == null),
       super(
         initialValue: controller?.text ?? initialValue ?? '',
         builder: (field) {
           final state = field as _AppTextFieldState;
           final error = field.errorText ?? decoration.errorText;
           final multiline = expands || maxLines == null || maxLines > 1;
           final scale = MediaQuery.textScalerOf(field.context).scale(14) / 14;
           final baseHeight = height ?? AppFormMetrics.inputHeight;
           final controlHeight = math.max(
             baseHeight,
             AppFormMetrics.inputHeight + (scale - 1) * 21,
           );
           Widget input = TextField(
             controller: state.effectiveController,
             focusNode: focusNode,
             enabled: enabled,
             readOnly: readOnly,
             obscureText: obscureText,
             autocorrect: autocorrect,
             enableSuggestions: enableSuggestions,
             autofocus: autofocus,
             expands: expands,
             maxLength: maxLength,
             maxLengthEnforcement: maxLengthEnforcement,
             maxLines: maxLines,
             minLines: minLines,
             inputFormatters: inputFormatters,
             autofillHints: autofillHints,
             keyboardType: keyboardType,
             textInputAction: textInputAction,
             textCapitalization: textCapitalization,
             textAlignVertical:
                 textAlignVertical ??
                 (multiline ? TextAlignVertical.top : TextAlignVertical.center),
             style: (style ?? AppFormMetrics.inputStyle).copyWith(
               fontSize: 14,
               height: 1.5,
             ),
             onChanged: onChanged,
             onSubmitted: onFieldSubmitted ?? onSubmitted,
             onTap: onTap,
             decoration: AppFormMetrics.decoration(
               decoration,
               hasError: error != null,
             ),
           );
           input = !multiline || height != null
               ? SizedBox(height: controlHeight, child: input)
               : ConstrainedBox(
                   constraints: BoxConstraints(minHeight: controlHeight),
                   child: input,
                 );
           if (expands && height == null) input = Expanded(child: input);
           return Column(
             mainAxisSize: expands && height == null
                 ? MainAxisSize.max
                 : MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               if (decoration.labelText != null) ...[
                 AppFieldLabel(decoration.labelText!),
                 const SizedBox(height: AppFormMetrics.labelGap),
               ],
               input,
               if (error != null) AppFieldError(error),
               if (error == null && decoration.helperText != null)
                 Padding(
                   padding: const EdgeInsets.only(top: AppFormMetrics.errorGap),
                   child: Text(
                     decoration.helperText!,
                     style: AppFormMetrics.errorStyle.copyWith(
                       color: AppColors.inkMuted,
                     ),
                   ),
                 ),
             ],
           );
         },
       );

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration decoration;
  final TextStyle? style;

  @override
  FormFieldState<String> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends FormFieldState<String> {
  TextEditingController? _localController;
  @override
  AppTextField get widget => super.widget as AppTextField;
  TextEditingController get effectiveController =>
      widget.controller ?? _localController!;

  void _syncValue() {
    if (value != effectiveController.text) didChange(effectiveController.text);
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _localController = TextEditingController(text: widget.initialValue);
    }
    effectiveController.addListener(_syncValue);
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == oldWidget.controller) return;
    final previous = oldWidget.controller ?? _localController!;
    previous.removeListener(_syncValue);
    if (widget.controller == null) {
      _localController = TextEditingController.fromValue(previous.value);
    }
    if (oldWidget.controller == null) {
      previous.dispose();
      _localController = null;
    }
    effectiveController.addListener(_syncValue);
    setValue(effectiveController.text);
  }

  @override
  void reset() {
    effectiveController.text = widget.initialValue ?? '';
    super.reset();
  }

  @override
  void dispose() {
    effectiveController.removeListener(_syncValue);
    _localController?.dispose();
    super.dispose();
  }
}
