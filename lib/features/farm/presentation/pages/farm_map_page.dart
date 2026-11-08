import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_location_map.dart';

class FarmMapPage extends StatelessWidget {
  const FarmMapPage({
    required this.latitude,
    required this.longitude,
    required this.farmName,
    super.key,
  });

  final double latitude;
  final double longitude;
  final String farmName;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            PageHeaderBar(
              title: 'Bản đồ trang trại',
              subtitle: farmName,
              onBack: context.pop,
            ),
            Expanded(
              child: FarmLocationMap(
                latitude: latitude,
                longitude: longitude,
                expandToConstraints: true,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
