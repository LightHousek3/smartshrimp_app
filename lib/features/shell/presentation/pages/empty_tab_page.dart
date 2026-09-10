import 'package:flutter/material.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';

class EmptyTabPage extends StatelessWidget {
  const EmptyTabPage({required this.semanticLabel, super.key});

  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      container: true,
      child: const AppGradientBackground(child: SizedBox.expand()),
    );
  }
}
