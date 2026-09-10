import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({this.width = 250, super.key});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/smartshrimp_logo.png',
      width: width,
      fit: BoxFit.contain,
      semanticLabel: 'SmartShrimp',
    );
  }
}
