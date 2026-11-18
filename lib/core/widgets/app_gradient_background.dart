import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

class AppGradientBackground extends StatelessWidget {
  const AppGradientBackground({
    required this.child,
    this.colors = const [
      AppColors.backgroundTop,
      Color(0xFFD8EAF0),
      AppColors.backgroundBottom,
    ],
    this.stops = const [0, 0.54, 1],
    super.key,
  });

  final Widget child;
  final List<Color> colors;
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
      stops: stops,
    );
    return _GradientScope(
      gradient: gradient,
      child: _GradientBounds(
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: gradient),
          child: child,
        ),
      ),
    );
  }
}

/// Paint the underlying screen background without revealing scrolling content.
class AppBackgroundSurface extends SingleChildRenderObjectWidget {
  const AppBackgroundSurface({this.color, required super.child, super.key});

  final Color? color;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderBackgroundSurface(color, _GradientScope.of(context));

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderBackgroundSurface)
      ..color = color
      ..gradient = _GradientScope.of(context);
  }
}

class _GradientBounds extends SingleChildRenderObjectWidget {
  const _GradientBounds({required super.child});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderGradientBounds();
}

class _GradientScope extends InheritedWidget {
  const _GradientScope({required this.gradient, required super.child});
  final LinearGradient gradient;

  static LinearGradient? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_GradientScope>()?.gradient;

  @override
  bool updateShouldNotify(_GradientScope oldWidget) =>
      gradient != oldWidget.gradient;
}

class _RenderGradientBounds extends RenderProxyBox {}

class _RenderBackgroundSurface extends RenderProxyBox {
  _RenderBackgroundSurface(this._color, this._gradient);
  Color? _color;
  LinearGradient? _gradient;

  set gradient(LinearGradient? value) {
    if (value == _gradient) return;
    _gradient = value;
    markNeedsPaint();
  }

  set color(Color? value) {
    if (value == _color) return;
    _color = value;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final paint = Paint();
    if (_color != null) {
      paint.color = _color!;
      context.canvas.drawRect(offset & size, paint);
    } else {
      RenderObject? background = parent;
      while (background != null && background is! _RenderGradientBounds) {
        background = background.parent;
      }
      if (background is _RenderGradientBounds && _gradient != null) {
        // Use screen coordinates so the gradient does not restart at each header.
        final position = MatrixUtils.transformPoint(
          getTransformTo(background),
          Offset.zero,
        );
        paint.shader = _gradient!.createShader(
          (offset - position) & background.size,
        );
        context.canvas.drawRect(offset & size, paint);
      }
    }
    super.paint(context, offset);
  }
}
