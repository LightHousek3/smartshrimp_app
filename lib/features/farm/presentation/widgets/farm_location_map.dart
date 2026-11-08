import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
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
  MapLibreMapController? _controller;
  Circle? _marker;
  Timer? _timeout;
  var _ready = false;
  var _failed = false;
  var _generation = 0;

  bool get _supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  LatLng get _point => LatLng(widget.latitude, widget.longitude);

  @override
  void initState() {
    super.initState();
    _startTimeout();
  }

  void _startTimeout() {
    if (!_supported || AppConfig.goongMapStyleUrl == null) return;
    _timeout?.cancel();
    _timeout = Timer(const Duration(seconds: 15), () {
      if (mounted && !_ready) setState(() => _failed = true);
    });
  }

  @override
  void didUpdateWidget(covariant FarmLocationMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude ||
        oldWidget.longitude != widget.longitude) {
      unawaited(_updateLocation());
    }
  }

  Future<void> _updateLocation() async {
    final controller = _controller;
    final marker = _marker;
    if (!_ready || controller == null || marker == null) return;
    try {
      await controller.updateCircle(marker, CircleOptions(geometry: _point));
      await controller.animateCamera(CameraUpdate.newLatLngZoom(_point, 15));
    } on Exception {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _onStyleLoaded() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      // MapLibre annotations are available only after the Goong style loads.
      _marker = await controller.addCircle(
        CircleOptions(
          geometry: _point,
          circleColor: '#7AC943',
          circleRadius: 11,
          circleStrokeColor: '#FFFFFF',
          circleStrokeWidth: 3,
        ),
      );
      if (mounted) {
        _timeout?.cancel();
        setState(() {
          _ready = true;
          _failed = false;
        });
      }
    } on Exception {
      if (mounted) setState(() => _failed = true);
    }
  }

  void _retry() {
    setState(() {
      _controller = null;
      _marker = null;
      _ready = false;
      _failed = false;
      _generation++;
    });
    _startTimeout();
  }

  @override
  void dispose() {
    _timeout?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styleUrl = AppConfig.goongMapStyleUrl;
    return SizedBox(
      height: widget.expandToConstraints ? double.infinity : widget.height,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: styleUrl == null || !_supported
            ? const _MapMessage(
                'Bản đồ Goong chưa được cấu hình cho thiết bị này.',
              )
            : Stack(
                children: <Widget>[
                  MapLibreMap(
                    key: ValueKey(_generation),
                    styleString: styleUrl,
                    initialCameraPosition: CameraPosition(
                      target: _point,
                      zoom: 15,
                    ),
                    onMapCreated: (controller) => _controller = controller,
                    onStyleLoadedCallback: () => unawaited(_onStyleLoaded()),
                    compassEnabled: widget.interactive,
                    dragEnabled: widget.interactive,
                    rotateGesturesEnabled: widget.interactive,
                    scrollGesturesEnabled: widget.interactive,
                    zoomGesturesEnabled: widget.interactive,
                    tiltGesturesEnabled: widget.interactive,
                    logoEnabled: false,
                  ),
                  if (!_ready && !_failed)
                    const ColoredBox(
                      color: Color(0xFFF1F3F6),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (_failed)
                    _MapMessage(
                      'Không thể tải bản đồ Goong. Vui lòng kiểm tra kết nối.',
                      onRetry: _retry,
                    ),
                ],
              ),
      ),
    );
  }
}

class _MapMessage extends StatelessWidget {
  const _MapMessage(this.message, {this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: const Color(0xFFF1F3F6),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.map_outlined, color: AppColors.inkMuted),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    ),
  );
}
