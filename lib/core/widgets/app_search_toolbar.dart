import 'package:flutter/material.dart';

/// Share toolbar geometry while each page owns its search and filter behavior.
class AppSearchToolbar extends StatelessWidget {
  const AppSearchToolbar({
    required this.search,
    required this.filter,
    super.key,
  });

  final Widget search;
  final Widget filter;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: Row(
      children: [
        Expanded(child: SizedBox(height: 40, child: search)),
        const SizedBox(width: 8),
        SizedBox(width: 128, height: 40, child: filter),
      ],
    ),
  );
}
