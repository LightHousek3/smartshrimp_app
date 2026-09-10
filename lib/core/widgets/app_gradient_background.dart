import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.backgroundTop,
            Color(0xFFD8EAF0),
            AppColors.backgroundBottom,
          ],
          stops: <double>[0, 0.54, 1],
        ),
      ),
      child: child,
    );
  }
}
