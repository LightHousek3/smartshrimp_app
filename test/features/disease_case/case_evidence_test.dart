import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_image_viewer.dart';
import 'package:smartshrimp_app/features/disease_case/domain/entities/owner_disease_case.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/widgets/case_evidence.dart';
import '../../support/load_app_fonts.dart';

DiseaseCaseAttachment attachment(String url, {String? type, String? caption}) =>
    DiseaseCaseAttachment(
      fileUrl: url,
      mediaType: type,
      caption: caption,
      uploaderName: 'Liễu Tấn Đạt',
      createdAt: DateTime(2026, 11, 13, 5, 13),
    );

Future<void> cachePhoto(WidgetTester tester, String url, Color color) async {
  await tester.runAsync(() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..drawColor(color, BlendMode.src);
    canvas.drawCircle(
      const Offset(130, 90),
      50,
      Paint()..color = Colors.white.withValues(alpha: .35),
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(320, 200);
    picture.dispose();
    for (final width in [600, 2048]) {
      final provider = ResizeImage.resizeIfNeeded(
        width,
        null,
        NetworkImage(url),
      );
      final key = await provider.obtainKey(ImageConfiguration.empty);
      imageCache.putIfAbsent(
        key,
        () => OneFrameImageStreamCompleter(
          Future.value(ImageInfo(image: image.clone())),
        ),
      );
    }
    image.dispose();
  });
}

Future<void> openEvidence(
  WidgetTester tester,
  List<DiseaseCaseAttachment> items, {
  double scale = 1,
  Size size = const Size(402, 874),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(imageCache.clear);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: MediaQuery(
        data: MediaQueryData(size: size, textScaler: TextScaler.linear(scale)),
        child: Scaffold(
          backgroundColor: const Color(0xFFE6EFF3),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: CaseEvidence(attachments: items),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets(
    'N: legacy URLs without MIME show real thumbnails and use the shared zoom gallery',
    (tester) async {
      const first = 'https://images.test/report.jpg?version=1';
      const second = 'https://images.test/upload/opaque-image-id';
      const third = 'https://images.test/sample-3.jpg';
      const fourth = 'https://images.test/sample-4.jpg';
      const fifth = 'https://images.test/sample-5.jpg';
      await cachePhoto(tester, first, const Color(0xFF5EAFBA));
      await cachePhoto(tester, second, const Color(0xFFBBA677));
      await cachePhoto(tester, third, Colors.teal);
      await cachePhoto(tester, fourth, Colors.lightBlue);
      await cachePhoto(tester, fifth, Colors.indigo);
      await openEvidence(tester, [
        attachment(first, caption: 'Ảnh tôm khi mở ca'),
        attachment(second),
        attachment(third),
        attachment(fourth),
        attachment(fifth),
      ]);
      expect(find.text('5 ảnh'), findsOneWidget);
      expect(find.text('Tệp đính kèm'), findsNothing);
      expect(find.byType(Image), findsNWidgets(5));
      final firstTop = tester.getTopLeft(find.text('Minh chứng 1')).dy;
      expect(tester.getTopLeft(find.text('Minh chứng 3')).dy, firstTop);
      expect(
        tester.getTopLeft(find.text('Minh chứng 4')).dy,
        greaterThan(firstTop),
      );
      for (final element in find.byType(RawImage).evaluate()) {
        expect((element.widget as RawImage).image, isNotNull);
      }
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/owner_case_initial_photos.png'),
      );
      await tester.tap(find.byKey(const ValueKey('case-evidence-image-1')));
      await tester.pumpAndSettle();
      expect(find.byType(AppImageViewer), findsOneWidget);
      expect(find.text('Ảnh 2/5'), findsOneWidget);
      expect(
        tester
            .widget<InteractiveViewer>(find.byType(InteractiveViewer))
            .maxScale,
        4,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/owner_case_photo_viewer.png'),
      );
      await tester.tap(
        find.bySemanticsLabel(RegExp('^Xem ảnh 1 trong thư viện')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Ảnh 1/5'), findsOneWidget);
      expect(find.text('Ảnh tôm khi mở ca'), findsOneWidget);
      await tester.tap(find.byTooltip('Đóng'));
      await tester.pumpAndSettle();
      expect(find.byType(AppImageViewer), findsNothing);
      expect(
        find.byKey(const ValueKey('case-evidence-image-1')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'N/B: image MIME and binary legacy photos coexist with explicit historical files',
    (tester) async {
      const first = 'https://images.test/opaque-photo';
      const second = 'https://images.test/binary-photo';
      await cachePhoto(tester, first, Colors.teal);
      await cachePhoto(tester, second, Colors.amber);
      await openEvidence(tester, [
        attachment(first, type: 'image/jpeg'),
        attachment(
          'https://images.test/lab.pdf',
          type: 'application/pdf',
          caption: 'Kết quả xét nghiệm',
        ),
        attachment(second, type: 'application/octet-stream'),
      ]);
      expect(find.text('2 ảnh · 1 tệp'), findsOneWidget);
      expect(find.text('Kết quả xét nghiệm'), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(2));
      await tester.tap(find.byKey(const ValueKey('case-evidence-image-1')));
      await tester.pumpAndSettle();
      expect(find.text('Ảnh 2/2'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'A/B: failed photo loads can retry without opening an external browser',
    (tester) async {
      await openEvidence(
        tester,
        [attachment('https://images.test/unavailable.jpg')],
        size: const Size(320, 700),
        scale: 1.5,
      );
      expect(find.text('1 ảnh'), findsOneWidget);
      expect(find.text('Tải lại ảnh'), findsOneWidget);
      await tester.tap(find.text('Tải lại ảnh'));
      await tester.pumpAndSettle();
      expect(find.text('Tải lại ảnh'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
