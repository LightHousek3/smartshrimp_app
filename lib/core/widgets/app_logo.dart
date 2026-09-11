import 'package:flutter/material.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({this.width = 250, super.key});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      AppConfig.logoUrl,
      width: width,
      fit: BoxFit.contain,
      semanticLabel: 'SmartShrimp',
      errorBuilder: (context, error, stackTrace) => SizedBox(
        width: width,
        child: Text(
          AppConfig.appName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
