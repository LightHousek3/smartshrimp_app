import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';

Future<Uint8List> _pixels(WidgetTester tester) async =>
    (await tester.runAsync(() async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const Key('capture')),
      );
      final image = await boundary.toImage();
      final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      final result = Uint8List.fromList(bytes!.buffer.asUint8List());
      image.dispose();
      return result;
    }))!;

List<int> _pixel(Uint8List pixels, int x, int y) =>
    pixels.sublist((y * 400 + x) * 4, (y * 400 + x) * 4 + 4);

void _expectSamePixel(List<int> actual, List<int> expected) {
  for (var channel = 0; channel < 4; channel++) {
    expect(actual[channel], closeTo(expected[channel], 1));
  }
}

void main() {
  testWidgets(
    'static headers match screen coordinates after background changes and resize',
    (tester) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      const content = Row(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 32),
                PageHeaderBar(title: 'Chi tiết', showBack: false),
                Expanded(child: SizedBox()),
              ],
            ),
          ),
          Expanded(child: SizedBox.expand()),
        ],
      );
      Future<void> show(List<Color> colors) => tester.pumpWidget(
        MaterialApp(
          home: RepaintBoundary(
            key: const Key('capture'),
            child: AppGradientBackground(
              colors: colors,
              stops: const [0, 1],
              child: content,
            ),
          ),
        ),
      );
      await show([Colors.blue, Colors.white]);
      var pixels = await _pixels(tester);
      final before = _pixel(pixels, 2, 80);
      _expectSamePixel(before, _pixel(pixels, 302, 80));
      await show([Colors.green, Colors.yellow]);
      pixels = await _pixels(tester);
      _expectSamePixel(_pixel(pixels, 2, 80), _pixel(pixels, 302, 80));
      expect(_pixel(pixels, 2, 80), isNot(before));
      tester.view.physicalSize = const Size(400, 800);
      await tester.pump();
      pixels = await _pixels(tester);
      _expectSamePixel(_pixel(pixels, 2, 80), _pixel(pixels, 302, 80));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'a pinned header and its filters cover scrolling rows with the screen background',
    (tester) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: RepaintBoundary(
            key: const Key('capture'),
            child: AppGradientBackground(
              child: CustomScrollView(
                slivers: [
                  const StickyPageHeader(
                    title: 'Danh sách',
                    subtitle: 'Bộ lọc',
                    showBack: false,
                    bottomHeight: 52,
                    bottom: Center(child: Text('Lọc')),
                  ),
                  SliverFixedExtentList(
                    itemExtent: 60,
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const ColoredBox(color: Colors.red),
                      childCount: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      final before = await _pixels(tester);
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -450));
      await tester.pumpAndSettle();
      final after = await _pixels(tester);
      expect(_pixel(after, 2, 10), _pixel(before, 2, 10));
      expect(_pixel(after, 2, 100), _pixel(before, 2, 100));
      expect(_pixel(after, 2, 150), [244, 67, 54, 255]);
      expect(tester.takeException(), isNull);
    },
  );
}
