import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/disease_case/domain/domain.dart';
import '../../support/load_app_fonts.dart';
import 'disease_case_test.dart' show CaseFixtureRepository, fixture, showCase;

void main() {
  setUpAll(loadAppFonts);

  for (final width in [320.0, 390.0]) {
    testWidgets(
      'B: list and create fit a $width px phone and submit selected AI',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 725);
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final repo = CaseFixtureRepository()
          ..item = fixture.copyWith(
            expert: {'fullName': 'TS. Phạm Hải Đăng'},
            counts: {'responses': 4},
          )
          ..options = const CaseCreationOptions(
            aiDiagnoses: [
              {
                'id': 'ai',
                'predictedLabel': 'Đốm trắng',
                'recognitionStatus': 'RECOGNIZED',
                'confidence': '0.91',
                'createdAt': '2026-11-10T10:05:00Z',
              },
            ],
          );
        await showCase(tester, repo);
        expect(find.text('Ao 1 · Vụ 1'), findsOneWidget);
        expect(find.textContaining('4 phản hồi'), findsOneWidget);
        expect(find.text('Đang xử lý (21)'), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.tap(find.text('Tạo ca bệnh'));
        await tester.pumpAndSettle();
        for (final label in ['Nhẹ', 'Trung bình', 'Cao', 'Nguy cấp']) {
          expect(find.text(label), findsOneWidget);
        }
        await tester.enterText(find.byType(TextFormField).first, 'Ca thử');
        await tester.enterText(
          find.byType(TextFormField).last,
          'Dấu hiệu ở nhá',
        );
        await tester.ensureVisible(find.text('Đốm trắng'));
        await tester.tap(find.text('Đốm trắng'));
        await tester.pumpAndSettle();
        expect(find.textContaining('91%'), findsOneWidget);
        await tester.ensureVisible(find.text('Gửi cho chuyên gia'));
        await tester.tap(find.text('Gửi cho chuyên gia'));
        await tester.pumpAndSettle();
        expect(repo.selectedAi, 'ai');
        expect(repo.mutations, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('AI is optional when no inference exists or options fail', (
    tester,
  ) async {
    final repo = CaseFixtureRepository()
      ..optionsFailure = const ApiException('Không thể tải AI');
    await showCase(tester, repo, path: '/seasons/season/disease-cases/create');
    await tester.enterText(find.byType(TextFormField).first, 'Ca mới');
    await tester.enterText(find.byType(TextFormField).last, 'Tôm giảm ăn');
    await tester.ensureVisible(find.text('Thử lại'));
    await tester.pumpAndSettle();
    repo.optionsFailure = null;
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.text('Chưa có kết quả AI trong vụ này.'), findsOneWidget);
    expect(find.text('Ca mới'), findsOneWidget);
    await tester.ensureVisible(find.text('Gửi cho chuyên gia'));
    await tester.tap(find.text('Gửi cho chuyên gia'));
    await tester.pumpAndSettle();
    expect(repo.selectedAi, isNull);
    expect(repo.mutations, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'AI detail navigation preserves the draft and the selected link',
    (tester) async {
      final repo = CaseFixtureRepository()
        ..options = const CaseCreationOptions(
          aiDiagnoses: [
            {
              'id': 'ai',
              'recognitionStatus': 'UNRECOGNIZED',
              'predictedLabel': null,
              'confidence': 0.799999,
              'createdAt': '2026-11-10T10:05:00Z',
            },
          ],
        );
      await showCase(
        tester,
        repo,
        path: '/seasons/season/disease-cases/create',
        additionalRoutes: [
          GoRoute(
            path: '/seasons/season/ai-diagnoses/ai',
            builder: (context, _) => Scaffold(
              body: TextButton(
                onPressed: () => context.pop(),
                child: const Text('Đóng chi tiết AI'),
              ),
            ),
          ),
        ],
      );
      await tester.enterText(find.byType(TextFormField).first, 'Ca đang soạn');
      await tester.enterText(find.byType(TextFormField).last, 'Tôm giảm ăn');
      await tester.ensureVisible(find.text('Chưa thể nhận diện'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chưa thể nhận diện'));
      expect(find.textContaining('79,99%'), findsOneWidget);
      await tester.tap(find.byTooltip('Xem chi tiết kết quả AI'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Đóng chi tiết AI'));
      await tester.pumpAndSettle();
      expect(find.text('Ca đang soạn'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      await tester.ensureVisible(find.text('Gửi cho chuyên gia'));
      await tester.tap(find.text('Gửi cho chuyên gia'));
      await tester.pumpAndSettle();
      expect(repo.selectedAi, 'ai');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'B: captured values and pinned composer fit with the phone keyboard',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(343, 725);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      final repo = CaseFixtureRepository()
        ..item = fixture.copyWith(
          title: 'Nghi phân trắng & mềm vỏ — Ao A3',
          status: DiseaseCaseStatus.inTreatment,
          expert: {'fullName': 'TS. Phạm Hải Đăng'},
          caseSnapshot: {
            'pondName': 'Ao A3',
            'seasonName': 'Vụ Đông Xuân 2025',
            'avgWeightG': '12.4',
            'mortalityCount': '340',
            'estimatedBiomassKg': '4851',
            'ph': '8.6',
            'doMgL': '4.1',
            'nh3MgL': '0.32',
            'no2MgL': '1.9',
            'healthStatus': 'WARNING',
          },
        );
      await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
      expect(find.text('12.4'), findsOneWidget);
      expect(find.text('8.6'), findsOneWidget);
      expect(find.text('Cần chú ý'), findsOneWidget);
      expect(find.text('Kết quả điều trị'), findsOneWidget);
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Tôm bắt mồi tốt hơn');
      await tester.tap(find.byKey(const ValueKey('case-send-response')));
      await tester.pumpAndSettle();
      expect(repo.sentType, CaseResponseType.treatmentResult);
      expect(repo.sentMessage, 'Tôm bắt mồi tốt hơn');
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField))
            .controller!
            .text,
        isEmpty,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('B: old snapshot shows missing facts explicitly', (tester) async {
    await showCase(
      tester,
      CaseFixtureRepository(),
      path: '/seasons/season/disease-cases/case',
    );
    expect(find.text('—'), findsNWidgets(7));
    expect(
      find.text('Hồ sơ chưa có số liệu được lưu tại thời điểm mở ca.'),
      findsOneWidget,
    );
    expect(find.text('12.4'), findsNothing);
  });

  testWidgets(
    'floating response success stays below the header without moving page content',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 725);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      await showCase(
        tester,
        CaseFixtureRepository(),
        path: '/seasons/season/disease-cases/case',
      );
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await tester.pumpAndSettle();
      final send = find.byKey(const ValueKey('case-send-response'));
      final originalSendRect = tester.getRect(send);
      final originalContentRect = tester.getRect(find.byType(RefreshIndicator));
      final originalDescriptionRect = tester.getRect(
        find.text('Tình trạng quan sát tại ao'),
      );
      await tester.enterText(find.byType(TextFormField), 'Thông tin mới');
      await tester.tap(send);
      await tester.pumpAndSettle();

      final notice = find.byKey(const ValueKey('case-response-success'));
      expect(find.text('Đã gửi phản hồi.'), findsOneWidget);
      expect(find.byKey(const ValueKey('app_notice_success')), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
      expect(
        tester.getRect(notice).top,
        greaterThanOrEqualTo(tester.getRect(find.byType(PageHeaderBar)).bottom),
      );
      expect(
        tester.getRect(notice).bottom,
        lessThan(tester.getTopLeft(send).dy),
      );
      expect(tester.getRect(send), originalSendRect);
      expect(
        tester.getRect(find.byType(RefreshIndicator)),
        originalContentRect,
      );
      expect(
        tester.getRect(find.text('Tình trạng quan sát tại ao')),
        originalDescriptionRect,
      );
      await tester.pump(const Duration(seconds: 2));
      await tester.enterText(find.byType(TextFormField), 'Bổ sung tiếp');
      await tester.tap(send);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      expect(notice, findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1300));
      expect(notice, findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'expanded status history stays above the pinned response composer',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 725);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final repo = CaseFixtureRepository()
        ..item = fixture.copyWith(
          statusHistory: [
            {'toStatus': 'OPEN', 'reason': 'KTV mở ca bệnh'},
            {'toStatus': 'MONITORING', 'reason': 'Chuyên gia yêu cầu theo dõi'},
          ],
        );
      await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
      final header = find.text('Lịch sử trạng thái');
      await tester.scrollUntilVisible(
        header,
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await Scrollable.ensureVisible(tester.element(header), alignment: 1);
      await tester.pumpAndSettle();
      await tester.tap(header);
      await tester.pumpAndSettle();

      final scrollable = find
          .ancestor(of: header, matching: find.byType(Scrollable))
          .first;
      final viewport = tester.getRect(scrollable);
      for (final reason in ['KTV mở ca bệnh', 'Chuyên gia yêu cầu theo dõi']) {
        final event = find.text(reason);
        expect(event.hitTestable(), findsOneWidget);
        expect(
          tester.getRect(event).bottom,
          lessThanOrEqualTo(viewport.bottom),
        );
      }
      expect(
        find.byKey(const ValueKey('case-send-response')).hitTestable(),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'long history remains scrollable with the keyboard and preserves the reply draft',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 725);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      final repo = CaseFixtureRepository()
        ..item = fixture.copyWith(
          statusHistory: List.generate(
            12,
            (index) => {
              'toStatus': 'MONITORING',
              'reason': 'Bước xử lý ${index + 1}',
            },
          ),
        );
      await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
      await tester.enterText(find.byType(TextFormField), 'Bản nháp đang nhập');
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await tester.pumpAndSettle();
      final header = find.text('Lịch sử trạng thái');
      await tester.scrollUntilVisible(
        header,
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(header);
      await tester.pumpAndSettle();
      expect(tester.testTextInput.isVisible, isFalse);
      expect(find.text('Bản nháp đang nhập'), findsOneWidget);
      final finalEvent = find.text('Bước xử lý 12');
      await tester.scrollUntilVisible(
        finalEvent,
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(finalEvent.hitTestable(), findsOneWidget);
      expect(
        find.byKey(const ValueKey('case-send-response')).hitTestable(),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'A: emergency conflict keeps both drafts and retries with refreshed version',
    (tester) async {
      final repo = CaseFixtureRepository();
      await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
      await tester.enterText(find.byType(TextFormField), 'Bản nháp thường');
      await tester.tap(find.byKey(const ValueKey('case-emergency-alert')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byType(TextFormField).last,
        'Tình huống khẩn',
      );
      repo.item = fixture.copyWith(
        updatedAt: fixture.updatedAt.add(const Duration(seconds: 1)),
      );
      repo.mutationFailure = const ApiException(
        'Gửi thất bại',
        statusCode: 409,
      );
      await tester.tap(find.text('Gửi cảnh báo khẩn'));
      await tester.pumpAndSettle();
      expect(find.text('Gửi thất bại'), findsOneWidget);
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).last)
            .controller!
            .text,
        'Tình huống khẩn',
      );
      repo.mutationFailure = null;
      await tester.tap(find.text('Gửi cảnh báo khẩn'));
      await tester.pumpAndSettle();
      expect(repo.mutations, 2);
      expect(repo.sentVersion, repo.item.updatedAt);
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField))
            .controller!
            .text,
        'Bản nháp thường',
      );
    },
  );
}
