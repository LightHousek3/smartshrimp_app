import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_image_viewer.dart';
import 'package:smartshrimp_app/features/disease_case/domain/entities/owner_disease_case.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/widgets/case_evidence.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/widgets/disease_case_detail_sections.dart'
    show CaseTimeline;
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

  testWidgets('owner timeline opens technician photos from their response', (
    tester,
  ) async {
    const first = 'https://images.test/response-1.jpg';
    const second = 'https://images.test/upload/response-2';
    await cachePhoto(tester, first, Colors.teal);
    await cachePhoto(tester, second, Colors.amber);
    addTearDown(imageCache.clear);
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final at = DateTime.utc(2026, 11, 27, 8, 58);
    final technicianReply =
        DiseaseCaseEvent.fromJson({
              'kind': 'response',
              'at': at.toIso8601String(),
              'authorName': 'Liễu Tấn Đạt',
              'authorRole': 'TECHNICIAN',
              'responseType': 'NORMAL',
              'message': 'Tôm có dấu hiệu bất thường.',
              'attachments': [first, second],
            })
            as DiseaseCaseResponse;
    final olderExpertReply =
        DiseaseCaseEvent.fromJson({
              'kind': 'response',
              'at': at.add(const Duration(minutes: 1)).toIso8601String(),
              'authorName': 'TS. Kim Soàn',
              'authorRole': 'EXPERT',
              'responseType': 'NORMAL',
              'message': 'Đã nhận thông tin.',
            })
            as DiseaseCaseResponse;
    expect(technicianReply.attachments, [first, second]);
    expect(olderExpertReply.attachments, isEmpty);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              CaseTimeline(
                events: [
                  DiseaseCaseEvent.status(
                    at: at.subtract(const Duration(minutes: 1)),
                    authorName: 'Hệ thống',
                    toStatus: DiseaseCaseStatus.open,
                  ),
                  technicianReply,
                  olderExpertReply,
                ],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final strip = find.byType(CaseAttachmentStrip);
    expect(strip, findsOneWidget);
    expect(tester.widget<CaseAttachmentStrip>(strip).urls, [first, second]);
    final previews = find.descendant(
      of: strip,
      matching: find.byType(RawImage),
    );
    expect(previews, findsNWidgets(2));
    for (final element in previews.evaluate()) {
      expect((element.widget as RawImage).image, isNotNull);
    }
    expect(
      tester.getTopLeft(strip).dy,
      greaterThan(tester.getTopLeft(find.text(technicianReply.message)).dy),
    );

    await tester.tap(find.bySemanticsLabel(RegExp('^Xem ảnh minh chứng 2')));
    await tester.pumpAndSettle();
    expect(find.text('Ảnh 2/2'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Xem ảnh 1 trong thư viện'));
    await tester.pumpAndSettle();
    expect(find.text('Ảnh 1/2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

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
