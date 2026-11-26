import 'package:flutter/material.dart';

class StatisticsHeaderButton extends StatelessWidget {
  const StatisticsHeaderButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: onPressed,
    icon: const Icon(Icons.bar_chart_rounded, size: 18),
    label: const Text('Thống kê'),
  );
}
