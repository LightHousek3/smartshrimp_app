import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/cloudinary_image_storage.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/disease_case/domain/domain.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/pages/disease_case_form_page.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/widgets/case_evidence_picker.dart';
import 'package:smartshrimp_app/features/disease_case/presentation/widgets/case_ui.dart';

import '../../support/load_app_fonts.dart';
import 'disease_case_test.dart' show CaseFixtureRepository, showCase;

final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
);

class _Picker extends ImagePicker {
  final files = <XFile?>[];
  final sources = <ImageSource>[];
  final galleryLimits = <int?>[];
  int galleryCount = 1;

  void add(String name, {Uint8List? bytes}) =>
      files.add(XFile.fromData(bytes ?? _png, name: name, path: name));

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    sources.add(source);
    return files.removeAt(0);
  }

  @override
  Future<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    sources.add(ImageSource.gallery);
    galleryLimits.add(limit);
    return List.generate(
      galleryCount,
      (_) => files.removeAt(0),
    ).nonNulls.toList();
  }
}

class _Uploads {
  _Uploads() {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) async {
            final name =
                (request.data as FormData).files.single.value.filename!;
            names.add(name);
            if (pending != null) await pending!.future;
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: name == failure ? 400 : 200,
                data: name == failure
                    ? {
                        'error': {'message': 'Upload failed'},
                      }
                    : {'secure_url': 'https://images.test/$name'},
              ),
            );
          },
        ),
      );
    storage = CloudinaryImageStorage(
      dio,
      folder: 'case-evidence',
      validateBytes: DiseaseCaseRules.validateImage,
      cloudName: 'test',
      uploadPreset: 'test',
    );
  }

  late final CloudinaryImageStorage storage;
  final names = <String>[];
  String? failure;
  Completer<void>? pending;
}

class _Cases extends CaseFixtureRepository {
  List<String>? submittedAttachments;
  int uploadsAtCreate = -1;
  final _Uploads uploads;

  _Cases(this.uploads);

  @override
  Future<DiseaseCase> create(
    String seasonId,
    String title,
    String description,
    CaseSeverity severity, {
    List<String> attachments = const [],
    String? aiDiagnosisId,
    String? relatedCaseId,
  }) async {
    mutations++;
    uploadsAtCreate = uploads.names.length;
    submittedAttachments = [...attachments];
    if (mutationFailure != null) throw mutationFailure!;
    return item;
  }

  @override
  Future<DiseaseCase> respond(
    String seasonId,
    DiseaseCase value,
    CaseResponseType type,
    String message, {
    List<String> attachments = const [],
    String? replyToResponseId,
  }) {
    submittedAttachments = [...attachments];
    return super.respond(
      seasonId,
      value,
      type,
      message,
      attachments: attachments,
      replyToResponseId: replyToResponseId,
    );
  }
}

Future<void> _open(WidgetTester tester, _Cases repo, _Picker picker) async {
  await showCase(
    tester,
    repo,
    path: '/seasons/season/disease-cases/create',
    imagePicker: picker,
    evidenceStorage: repo.uploads.storage,
  );
}

Future<void> _pick(
  WidgetTester tester, {
  bool camera = false,
  String button = 'Thêm ảnh mẫu tôm / nhá',
}) async {
  final add = find.text(button);
  await tester.ensureVisible(add);
  await tester.tap(add);
  await tester.pumpAndSettle();
  await tester.tap(find.text(camera ? 'Chụp ảnh mới' : 'Chọn ảnh từ thiết bị'));
  await tester.pumpAndSettle();
}

Future<void> _fill(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).first, 'Tôm giảm ăn');
  await tester.enterText(find.byType(TextFormField).last, 'Dấu hiệu ở nhá');
}

Future<void> _showSend(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byType(CasePrimaryButton),
    200,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
}

Future<void> _send(WidgetTester tester) async {
  await _showSend(tester);
  final dynamic submit = tester
      .widget<CasePrimaryButton>(find.byType(CasePrimaryButton))
      .onPressed!;
  await tester.runAsync(() async => await submit());
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(loadAppFonts);

  testWidgets('gallery and camera photos preview locally until valid submit', (
    tester,
  ) async {
    final uploads = _Uploads();
    final repo = _Cases(uploads);
    final picker = _Picker()
      ..add('gallery.png')
      ..add('camera.png');
    await _open(tester, repo, picker);
    await _pick(tester);
    await _pick(tester, camera: true);
    expect(uploads.names, isEmpty);
    expect(repo.mutations, 0);
    expect(picker.sources, [ImageSource.gallery, ImageSource.camera]);
    expect(find.byTooltip('Bỏ ảnh minh chứng'), findsNWidgets(2));
    for (final image in tester.widgetList<Image>(find.byType(Image))) {
      expect(image.image, isA<MemoryImage>());
    }
    await _send(tester);
    expect(uploads.names, isEmpty);
    expect(repo.mutations, 0);
    await _fill(tester);
    await _send(tester);
    expect(uploads.names, ['gallery.png', 'camera.png']);
    expect(repo.uploadsAtCreate, 2);
    expect(repo.submittedAttachments, [
      'https://images.test/gallery.png',
      'https://images.test/camera.png',
    ]);
    expect(find.byType(DiseaseCaseFormPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('removing a preview and leaving the form never uploads photos', (
    tester,
  ) async {
    final uploads = _Uploads();
    final repo = _Cases(uploads);
    final picker = _Picker()
      ..add('removed.png')
      ..add('abandoned.png');
    await _open(tester, repo, picker);
    await _pick(tester);
    await tester.tap(find.byTooltip('Bỏ ảnh minh chứng'));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsNothing);
    await _pick(tester);
    GoRouter.of(tester.element(find.byType(DiseaseCaseFormPage))).go('/cases');
    await tester.pumpAndSettle();
    expect(uploads.names, isEmpty);
    expect(repo.mutations, 0);
  });

  testWidgets('only retained photos upload when submitting the case', (
    tester,
  ) async {
    final uploads = _Uploads();
    final repo = _Cases(uploads);
    final picker = _Picker()
      ..add('removed.png')
      ..add('retained.png');
    await _open(tester, repo, picker);
    await _pick(tester);
    await _pick(tester);
    await tester.tap(find.byTooltip('Bỏ ảnh minh chứng').first);
    await tester.pumpAndSettle();
    await _fill(tester);
    await _send(tester);
    expect(uploads.names, ['retained.png']);
    expect(repo.submittedAttachments, ['https://images.test/retained.png']);
  });

  testWidgets(
    'upload failure preserves previews and retries unfinished photos',
    (tester) async {
      final uploads = _Uploads()..failure = 'second.png';
      final repo = _Cases(uploads);
      final picker = _Picker()
        ..add('first.png')
        ..add('second.png');
      await _open(tester, repo, picker);
      await _fill(tester);
      await _pick(tester);
      await _pick(tester);
      await _send(tester);
      expect(repo.mutations, 0);
      await tester.ensureVisible(find.byType(CaseEvidencePicker));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Bỏ ảnh minh chứng'), findsNWidgets(2));
      expect(find.text('Tôm giảm ăn'), findsOneWidget);
      uploads.failure = null;
      await _send(tester);
      expect(uploads.names, ['first.png', 'second.png', 'second.png']);
      expect(repo.submittedAttachments, [
        'https://images.test/first.png',
        'https://images.test/second.png',
      ]);
      expect(repo.mutations, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('case creation failure retries without uploading photos again', (
    tester,
  ) async {
    final uploads = _Uploads();
    final repo = _Cases(uploads)
      ..mutationFailure = const ApiException('Không thể tạo ca bệnh.');
    await _open(tester, repo, _Picker()..add('evidence.png'));
    await _fill(tester);
    await _pick(tester);
    await _send(tester);
    expect(repo.mutations, 1);
    repo.mutationFailure = null;
    await _send(tester);
    expect(uploads.names, ['evidence.png']);
    expect(repo.mutations, 2);
    expect(repo.submittedAttachments, ['https://images.test/evidence.png']);
  });

  testWidgets('submission stays locked while evidence uploads', (tester) async {
    final uploads = _Uploads()..pending = Completer<void>();
    final repo = _Cases(uploads);
    await _open(tester, repo, _Picker()..add('evidence.png'));
    await _fill(tester);
    await _pick(tester);
    await _showSend(tester);
    final submit = tester
        .widget<CasePrimaryButton>(find.byType(CasePrimaryButton))
        .onPressed!;
    submit();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    submit();
    await tester.pump();
    expect(uploads.names, ['evidence.png']);
    expect(repo.mutations, 0);
    expect(
      tester.widget<CasePrimaryButton>(find.byType(CasePrimaryButton)).busy,
      isTrue,
    );
    uploads.pending!.complete();
    await tester.pumpAndSettle();
    expect(repo.mutations, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('invalid files and files over 5 MB stay out of the local draft', (
    tester,
  ) async {
    final uploads = _Uploads();
    final repo = _Cases(uploads);
    final picker = _Picker()
      ..add('invalid.txt', bytes: Uint8List.fromList([1, 2, 3]))
      ..add(
        'oversize.png',
        bytes: Uint8List(DiseaseCaseRules.maxImageBytes + 1),
      );
    await _open(tester, repo, picker);
    await _pick(tester);
    expect(find.text('Chọn ảnh JPG, PNG hoặc WebP.'), findsOneWidget);
    await _pick(tester);
    expect(find.text('Ảnh tối đa 5 MB.'), findsOneWidget);
    expect(find.byTooltip('Bỏ ảnh minh chứng'), findsNothing);
    expect(uploads.names, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('gallery batches fill the local draft up to five photos', (
    tester,
  ) async {
    final uploads = _Uploads();
    final repo = _Cases(uploads);
    final picker = _Picker()..files.add(null);
    for (var i = 0; i < 6; i++) {
      picker.add('$i.png');
    }
    await _open(tester, repo, picker);
    await _pick(tester);
    expect(find.byTooltip('Bỏ ảnh minh chứng'), findsNothing);
    picker.galleryCount = 3;
    await _pick(tester);
    expect(find.byTooltip('Bỏ ảnh minh chứng'), findsNWidgets(3));
    picker.galleryCount = 2;
    await _pick(tester);
    expect(picker.galleryLimits, [5, 5, 2]);
    final add = find.widgetWithText(TextButton, 'Thêm ảnh mẫu tôm / nhá');
    expect(tester.widget<TextButton>(add).onPressed, isNull);
    expect(find.byTooltip('Bỏ ảnh minh chứng'), findsNWidgets(5));
    await tester.tap(find.byTooltip('Bỏ ảnh minh chứng').first);
    await tester.pumpAndSettle();
    await _pick(tester);
    expect(find.byTooltip('Bỏ ảnh minh chứng'), findsNWidgets(5));
    expect(picker.galleryLimits, [5, 5, 2]);
    expect(uploads.names, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'a reply previews locally until sending and reuses uploads after failure',
    (tester) async {
      final uploads = _Uploads()..failure = 'second.png';
      final repo = _Cases(uploads);
      final picker = _Picker()
        ..galleryCount = 2
        ..add('first.png')
        ..add('second.png');
      await showCase(
        tester,
        repo,
        path: '/seasons/season/disease-cases/case',
        imagePicker: picker,
        evidenceStorage: uploads.storage,
      );
      await _pick(tester, button: 'Đính kèm ảnh (0/5)');
      expect(picker.galleryLimits, [5]);
      expect(uploads.names, isEmpty);
      expect(find.text('Đính kèm ảnh (2/5)'), findsOneWidget);
      expect(find.byTooltip('Bỏ ảnh minh chứng'), findsNWidgets(2));

      final send = find.byKey(const ValueKey('case-send-response'));
      await tester.tap(send);
      await tester.pumpAndSettle();
      expect(find.text('Vui lòng nhập nội dung.'), findsOneWidget);
      expect(uploads.names, isEmpty);

      await tester.enterText(find.byType(TextFormField), 'Bổ sung tình trạng');
      await tester.tap(send);
      await tester.pumpAndSettle();
      expect(uploads.names, ['first.png', 'second.png']);
      expect(repo.mutations, 0);
      expect(find.text('Bổ sung tình trạng'), findsOneWidget);
      expect(find.text('Đính kèm ảnh (2/5)'), findsOneWidget);
      AppNoticeService.hide();
      await tester.pumpAndSettle();

      uploads.failure = null;
      await tester.tap(send);
      await tester.pumpAndSettle();
      expect(uploads.names, ['first.png', 'second.png', 'second.png']);
      expect(repo.submittedAttachments, [
        'https://images.test/first.png',
        'https://images.test/second.png',
      ]);
      expect(find.text('Đính kèm ảnh (0/5)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
