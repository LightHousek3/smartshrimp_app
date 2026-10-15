import 'package:flutter/material.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

/// Refresh only the visible water screen on resume, coalescing lifecycle events.
class WaterLogRefreshBoundary extends StatefulWidget {
  const WaterLogRefreshBoundary({
    required this.onRefresh,
    required this.child,
    super.key,
  });
  final Future<void> Function() onRefresh;
  final Widget child;
  @override
  State<WaterLogRefreshBoundary> createState() =>
      _WaterLogRefreshBoundaryState();
}

class _WaterLogRefreshBoundaryState extends State<WaterLogRefreshBoundary> {
  late final AppLifecycleListener _listener;
  bool _refreshing = false;
  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(onResume: _refresh);
  }

  Future<void> _refresh() async {
    if (!mounted || _refreshing || ModalRoute.of(context)?.isCurrent == false) {
      return;
    }
    _refreshing = true;
    try {
      await widget.onRefresh();
    } on Object catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            error is AppException
                ? error.message
                : 'Không thể làm mới dữ liệu. Vui lòng thử lại.',
          ),
        ),
      );
    } finally {
      _refreshing = false;
    }
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
