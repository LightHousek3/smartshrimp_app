import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';

/// Presents a failed read in the space normally occupied by its content.
class AppErrorState extends StatefulWidget {
  const AppErrorState({
    this.error,
    this.message,
    this.onRetry,
    this.actionLabel = 'Thử lại',
    this.actionIcon = Icons.refresh_rounded,
    this.compact = false,
    super.key,
  });

  final Object? error;
  final String? message;
  final FutureOr<void> Function()? onRetry;
  final String actionLabel;
  final IconData actionIcon;
  final bool compact;

  @override
  State<AppErrorState> createState() => _AppErrorStateState();
}

class _AppErrorStateState extends State<AppErrorState> {
  bool _retrying = false;
  Object? _retryError;

  @override
  void didUpdateWidget(covariant AppErrorState oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.error != widget.error ||
        oldWidget.message != widget.message) {
      _retryError = null;
    }
  }

  Future<void> _retry() async {
    final retry = widget.onRetry;
    if (_retrying || retry == null) return;
    setState(() {
      _retrying = true;
      _retryError = null;
    });
    try {
      await retry();
    } on Object catch (error) {
      if (mounted) _retryError = error;
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final message = ErrorMapper.displayMessage(
      _retryError ?? widget.error,
      fallback: widget.message,
    );
    if (widget.compact) {
      return Row(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 18, color: AppColors.ink),
          const SizedBox(width: 8),
          Expanded(child: Semantics(liveRegion: true, child: Text(message))),
          if (widget.onRetry != null)
            TextButton(
              onPressed: _retrying ? null : _retry,
              child: Text(widget.actionLabel),
            ),
        ],
      );
    }
    return Center(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppColors.ink,
              ),
              const SizedBox(height: 12),
              Semantics(
                liveRegion: true,
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.inkSoft),
                ),
              ),
              if (widget.onRetry != null) ...[
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _retrying ? null : _retry,
                  icon: _retrying
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(widget.actionIcon),
                  label: Text(widget.actionLabel),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
