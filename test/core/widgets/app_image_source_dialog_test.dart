import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/core/widgets/app_image_source_dialog.dart';
import '../../support/load_app_fonts.dart';

void main() {
  setUpAll(loadAppFonts);
  for (final source in ImageSource.values) {
    testWidgets('returns the selected ${source.name} source', (tester) async {
      ImageSource? selected;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextButton(
              onPressed: () async => selected = await showAppImageSourceDialog(
                tester.element(find.text('Mở')),
                remaining: 3,
              ),
              child: const Text('Mở'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Mở'));
      await tester.pumpAndSettle();
      expect(find.text('Thêm ảnh'), findsOneWidget);
      expect(
        find.text('Chọn tối đa 3 ảnh hoặc chụp một ảnh mới.'),
        findsOneWidget,
      );
      await tester.tap(
        find.text(
          source == ImageSource.camera
              ? 'Chụp ảnh mới'
              : 'Chọn ảnh từ thiết bị',
        ),
      );
      await tester.pumpAndSettle();
      expect(selected, source);
    });
  }
  testWidgets('cancel on a narrow phone with enlarged text returns no source', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    ImageSource? selected;
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.5)),
          child: child!,
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async => selected = await showAppImageSourceDialog(
                context,
                remaining: 1,
              ),
              child: const Text('Mở'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Mở'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Hủy'));
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    expect(selected, isNull);
    expect(tester.takeException(), isNull);
  });
}
