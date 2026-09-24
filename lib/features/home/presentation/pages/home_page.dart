import 'package:flutter/material.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Trang chủ',
    container: true,
    child: const AppGradientBackground(child: SizedBox.expand()),
  );
}
