import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_location_map.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FarmMapPage extends StatefulWidget {
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
  State<FarmMapPage> createState() => _FarmMapPageState();
}

class _FarmMapPageState extends State<FarmMapPage> {
  late final WebViewController _controller;
  late final bool _usesGoogleMapsWebView;
  var _loading = false;
  var _failed = false;

  @override
  void initState() {
    super.initState();
    _usesGoogleMapsWebView = _hasWebViewImplementation;
    if (!_usesGoogleMapsWebView) return;

    _loading = true;
    final coordinate =
        '${widget.latitude.toStringAsFixed(8)},${widget.longitude.toStringAsFixed(8)}';
    final uri = Uri.https('maps.google.com', '/maps', <String, String>{
      'q': coordinate,
      'z': '16',
      'output': 'embed',
    });
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF1F3F6))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (error) {
            if (error.isForMainFrame == true && mounted) {
              setState(() {
                _loading = false;
                _failed = true;
              });
            }
          },
        ),
      )
      ..loadRequest(uri);
  }

  bool get _hasWebViewImplementation {
    if (kIsWeb || WebViewPlatform.instance == null) return false;
    return switch (defaultTargetPlatform) {
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.macOS => true,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            PageHeaderBar(
              title: 'Bản đồ trang trại',
              subtitle: _usesGoogleMapsWebView
                  ? widget.farmName
                  : '${widget.farmName} · OpenStreetMap',
              onBack: context.pop,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Stack(
                  children: <Widget>[
                    if (_usesGoogleMapsWebView && !_failed)
                      WebViewWidget(controller: _controller),
                    if (!_usesGoogleMapsWebView)
                      FarmLocationMap(
                        latitude: widget.latitude,
                        longitude: widget.longitude,
                        expandToConstraints: true,
                      ),
                    if (_usesGoogleMapsWebView && _loading)
                      const ColoredBox(
                        color: Color(0xFFF1F3F6),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.ocean,
                            strokeWidth: 2.5,
                          ),
                        ),
                      ),
                    if (_usesGoogleMapsWebView && _failed)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                Icons.map_outlined,
                                color: AppColors.inkMuted,
                                size: 42,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Không thể tải Google Maps. Vui lòng kiểm tra kết nối mạng.',
                                textAlign: TextAlign.center,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _failed = false;
                                    _loading = true;
                                  });
                                  _controller.reload();
                                },
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('Thử lại'),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
