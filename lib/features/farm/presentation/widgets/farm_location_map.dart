import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';

class FarmLocationMap extends StatefulWidget {
  const FarmLocationMap({
    required this.latitude,
    required this.longitude,
    this.height = 176,
    this.interactive = true,
    this.expandToConstraints = false,
    super.key,
  });

  final double latitude;
  final double longitude;
  final double height;
  final bool interactive;
  final bool expandToConstraints;

  @override
  State<FarmLocationMap> createState() => _FarmLocationMapState();
}

class _FarmLocationMapState extends State<FarmLocationMap> {
  final MapController _controller = MapController();

  @override
  void didUpdateWidget(covariant FarmLocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.move(LatLng(widget.latitude, widget.longitude), 15);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final point = LatLng(widget.latitude, widget.longitude);
    return SizedBox(
      height: widget.expandToConstraints ? double.infinity : widget.height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: <Widget>[
            FlutterMap(
              mapController: _controller,
              options: MapOptions(
                initialCenter: point,
                initialZoom: 15,
                interactionOptions: InteractionOptions(
                  flags: widget.interactive
                      ? InteractiveFlag.all
                      : InteractiveFlag.none,
                ),
              ),
              children: <Widget>[
                TileLayer(
                  urlTemplate: AppConfig.osmTileUrlTemplate,
                  userAgentPackageName: AppConfig.appPackageName,
                  maxNativeZoom: 19,
                ),
                MarkerLayer(
                  markers: <Marker>[
                    Marker(
                      point: point,
                      width: 42,
                      height: 50,
                      alignment: Alignment.topCenter,
                      child: const _FarmPin(),
                    ),
                  ],
                ),
              ],
            ),
            const Positioned(left: 5, bottom: 4, child: _OsmAttribution()),
          ],
        ),
      ),
    );
  }
}

class _FarmPin extends StatelessWidget {
  const _FarmPin();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(
      color: Color(0xFF7AC943),
      shape: BoxShape.circle,
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Color(0x440F1C2E),
          blurRadius: 7,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Center(
      child: Icon(Icons.location_on_rounded, color: Colors.white, size: 25),
    ),
  );
}

class _OsmAttribution extends StatelessWidget {
  const _OsmAttribution();

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.82),
      borderRadius: BorderRadius.circular(3),
    ),
    child: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Text(
        '© OpenStreetMap contributors',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: AppColors.inkSoft,
          fontSize: 8,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
