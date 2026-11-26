import 'package:flutter/services.dart';
import 'package:smartshrimp_app/core/utils/vietnamese_number.dart';

/// Group digits during editing and keep the caret at the same logical digit.
class VietnameseNumberInputFormatter extends TextInputFormatter {
  const VietnameseNumberInputFormatter({
    this.rejectNonNumeric = false,
    this.groupThousands = true,
  });

  final bool rejectNonNumeric;
  final bool groupThousands;
  static final _numeric = RegExp(r'^[-+0-9.,]*$');
  static final _digits = RegExp(r'^\d+$');
  static final _editable = RegExp(r'^[-+]?\d*(?:,\d*)?$');
  static final _groupedEditable = RegExp(
    r'^[-+]?[1-9]\d{0,2}(?:\.\d{3})+(?:,\d*)?$',
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;
    final text = newValue.text;
    if (!_numeric.hasMatch(text)) {
      return rejectNonNumeric ? oldValue : newValue;
    }
    if (!groupThousands) {
      return !text.contains(',') && text.indexOf('.') == text.lastIndexOf('.')
          ? newValue.copyWith(text: text.replaceFirst('.', ','))
          : newValue;
    }

    var decimalDot = -1;
    final removedGroups = <int>{};
    final old = oldValue.text;
    final replacedAll =
        oldValue.selection.start == 0 && oldValue.selection.end == old.length;
    if (!replacedAll &&
        (_groupedEditable.hasMatch(old) || _editable.hasMatch(old))) {
      var start = 0;
      while (start < old.length &&
          start < text.length &&
          old[start] == text[start]) {
        start++;
      }
      var oldEnd = old.length;
      var newEnd = text.length;
      while (oldEnd > start &&
          newEnd > start &&
          old[oldEnd - 1] == text[newEnd - 1]) {
        oldEnd--;
        newEnd--;
      }
      // A digit-only insertion can shift existing grouping separators.
      final replacement = text.substring(start, newEnd);
      if (replacement.length <= 1 || _digits.hasMatch(replacement)) {
        for (var i = 0; i < text.length; i++) {
          if (text[i] == '.' && (i < start || i >= newEnd)) {
            removedGroups.add(i);
          }
        }
        if (replacement == '.') decimalDot = start;
      }
    }

    final normalized = normalizeVietnameseNumber(text);
    if (removedGroups.isEmpty &&
        decimalDot < 0 &&
        !text.contains(',') &&
        text.contains('.') &&
        (normalized?.contains('.') ?? false)) {
      decimalDot = text.indexOf('.');
    }
    final ungrouped = StringBuffer();
    final offsets = <int>[0];
    for (var i = 0; i < text.length; i++) {
      if (!removedGroups.contains(i) &&
          (text[i] != '.' ||
              i == decimalDot ||
              (removedGroups.isEmpty && normalized == null))) {
        ungrouped.write(i == decimalDot ? ',' : text[i]);
      }
      offsets.add(ungrouped.length);
    }
    final input = ungrouped.toString();
    if (!_editable.hasMatch(input)) return newValue;
    final comma = input.indexOf(',');
    final whole = comma < 0 ? input : input.substring(0, comma);
    final signLength = whole.startsWith('-') || whole.startsWith('+') ? 1 : 0;
    final digits = whole.substring(signLength);
    final trimmed = digits.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    final droppedZeroes = digits.length - trimmed.length;
    final formatted =
        '${whole.substring(0, signLength)}'
        '${groupVietnameseDigits(trimmed)}'
        '${comma < 0 ? '' : input.substring(comma)}';
    if (formatted == text) return newValue;

    int caret(int offset) {
      if (offset < 0) return offset;
      var remaining = offsets[offset];
      if (remaining > signLength) {
        final zeroesBeforeCaret = remaining - signLength;
        remaining -= zeroesBeforeCaret < droppedZeroes
            ? zeroesBeforeCaret
            : droppedZeroes;
      }
      var position = 0;
      while (remaining > 0 && position < formatted.length) {
        if (formatted[position++] != '.') remaining--;
      }
      return position;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection(
        baseOffset: caret(newValue.selection.baseOffset),
        extentOffset: caret(newValue.selection.extentOffset),
      ),
    );
  }
}
