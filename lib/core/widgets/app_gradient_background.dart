import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({
    required this.child,
    this.colors = const [
      AppColors.backgroundTop,
      Color(0xFFD8EAF0),
      AppColors.backgroundBottom,
    ],
    this.stops = const [0, 0.54, 1],
    super.key,
  });

  final Widget child;
  final List<Color> colors;
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
          stops: stops,
        ),
      ),
      child: child,
    );
  }
}
