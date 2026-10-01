import 'package:flutter/material.dart';

const farmCardShadow = <BoxShadow>[
  BoxShadow(color: Color(0x160F1C2E), blurRadius: 22, offset: Offset(0, 8)),
];

String formatCompactNumber(double? value, {int fractionDigits = 2}) {
  if (value == null) return '—';
  final fixed = value.toStringAsFixed(fractionDigits);
  return fixed.replaceFirst(RegExp(r'\.?0+$'), '');
}
