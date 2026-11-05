import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_form_field.dart';

class OtpInput extends StatefulWidget {
  const OtpInput({required this.onChanged, this.enabled = true, super.key});
  final ValueChanged<String> onChanged;
  final bool enabled;
  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _nodes = List.generate(6, (_) => FocusNode());
  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _change(int index, String value) {
    if (value.length > 1) {
      final start = value.length == 6 ? 0 : index;
      for (var i = start; i < 6; i++) {
        final offset = i - start;
        _controllers[i].text = offset < value.length ? value[offset] : '';
      }
      _nodes[(start + value.length).clamp(0, 5)].requestFocus();
    } else if (value.isNotEmpty && index < 5) {
      _nodes[index + 1].requestFocus();
    }
    widget.onChanged(_controllers.map((controller) => controller.text).join());
  }

  @override
  Widget build(BuildContext context) => Row(
    children: List.generate(
      6,
      (index) => Expanded(
        child: Padding(
          padding: EdgeInsets.only(right: index < 5 ? 8 : 0),
          child: Focus(
            onKeyEvent: (_, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace &&
                  _controllers[index].text.isEmpty &&
                  index > 0) {
                _nodes[index - 1].requestFocus();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: Semantics(
              label: 'Chữ số OTP ${index + 1} trên 6',
              child: TextField(
                key: Key('otp_digit_$index'),
                controller: _controllers[index],
                focusNode: _nodes[index],
                enabled: widget.enabled,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                textInputAction: index < 5
                    ? TextInputAction.next
                    : TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                style: AppTypography.mono(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
                onChanged: (value) => _change(index, value),
                onTap: () => _controllers[index].selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: _controllers[index].text.length,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  filled: true,
                  fillColor: Colors.white,
                  constraints: const BoxConstraints(minHeight: 48),
                  border: AppFormMetrics.border(AppColors.line),
                  enabledBorder: AppFormMetrics.border(AppColors.line),
                  disabledBorder: AppFormMetrics.border(AppColors.line),
                  focusedBorder: AppFormMetrics.border(AppColors.oceanLight),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
