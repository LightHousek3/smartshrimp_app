import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/app_image_viewer.dart';
import '../../support/load_app_fonts.dart';

Widget _photo(int index, BoxFit fit) => ColoredBox(
  color: Colors.blue.shade50,
  child: Center(child: Text('photo-$index-${fit.name}')),
);

void main() {
  setUpAll(loadAppFonts);

  testWidgets(
    'opens the selected photo, switches thumbnails, resets zoom and closes',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showAppImageViewer(
                  context,
                  builder: (_) => AppImageViewer(
                    itemCount: 3,
                    initialIndex: 1,
                    imageBuilder: _photo,
                  ),
                ),
                child: const Text('Mở ảnh'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Mở ảnh'));
      await tester.pumpAndSettle();
      expect(find.text('Ảnh 2/3'), findsOneWidget);
      expect(find.text('photo-1-contain'), findsOneWidget);
      expect(
        tester
            .widget<InteractiveViewer>(find.byType(InteractiveViewer))
            .maxScale,
        4,
      );
      final originalZoom = tester.state(find.byType(InteractiveViewer));
      await tester.tap(
        find.bySemanticsLabel(RegExp(r'^Xem ảnh 3 trong thư viện')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Ảnh 3/3'), findsOneWidget);
      expect(find.text('photo-2-contain'), findsOneWidget);
      expect(
        tester.state(find.byType(InteractiveViewer)),
        isNot(same(originalZoom)),
      );
      await tester.tap(find.byTooltip('Đóng'));
      await tester.pumpAndSettle();
      expect(find.byType(AppImageViewer), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'photo refresh keeps the selection in range and handles an empty gallery',
    (tester) async {
      final count = ValueNotifier(3);
      addTearDown(count.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueListenableBuilder<int>(
              valueListenable: count,
              builder: (_, value, _) => AppImageViewer(
                itemCount: value,
                initialIndex: 2,
                imageBuilder: _photo,
              ),
            ),
          ),
        ),
      );
      expect(find.text('Ảnh 3/3'), findsOneWidget);
      count.value = 1;
      await tester.pumpAndSettle();
      expect(find.text('Ảnh 1/1'), findsOneWidget);
      expect(find.text('photo-0-contain'), findsOneWidget);
      count.value = 0;
      await tester.pumpAndSettle();
      expect(find.text('Không có ảnh'), findsOneWidget);
      expect(find.text('Không tải được ảnh.'), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('gallery supports a narrow screen with enlarged text', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(320, 700),
            textScaler: TextScaler.linear(1.5),
          ),
          child: Scaffold(
            body: AppImageViewer(
              itemCount: 5,
              initialIndex: 4,
              imageBuilder: _photo,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Ảnh 5/5'), findsOneWidget);
    expect(find.text('photo-4-contain'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
