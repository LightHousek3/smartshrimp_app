import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/disease_case/domain/domain.dart';
import '../../support/load_app_fonts.dart';
import 'disease_case_test.dart' show CaseFixtureRepository, fixture, showCase;

void main() {
  setUpAll(loadAppFonts);
  testWidgets(
    'ordinary conversation has no request selector and repeated replies stay NORMAL',
    (tester) async {
      final request = CaseResponse(
        id: 'request-1',
        authorId: 'expert',
        responseType: CaseResponseType.requestInfo,
        message: 'Đo lại pH',
        createdAt: DateTime.utc(2026, 11, 13),
      );
      final repo = CaseFixtureRepository()
        ..item = fixture.copyWith(
          status: DiseaseCaseStatus.monitoring,
          responses: [request],
        );
      await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
      expect(
        find.byType(DropdownButtonFormField<CaseResponseType>),
        findsNothing,
      );
      for (final text in ['pH đo lại là 7,8', 'Tôm ăn tốt hơn']) {
        await tester.enterText(find.byType(TextFormField).first, text);
        await tester.tap(find.byKey(const ValueKey('case-send-response')));
        await tester.pumpAndSettle();
        expect(repo.sentType, CaseResponseType.normal);
        expect(repo.sentReplyToResponseId, isNull);
        expect(repo.sentMessage, text);
        expect(repo.item.status, DiseaseCaseStatus.monitoring);
      }
      expect(tester.takeException(), isNull);
    },
  );

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
            'exceededWaterMetrics': ['ph', 'no2MgL', 'nh3MgL'],
          },
        );
      await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
      expect(find.text('12.4'), findsNothing);
      expect(find.text('Hiện trạng khi mở ca'), findsNothing);
      await tester.tap(find.text('Dữ liệu lúc mở ca'));
      await tester.pumpAndSettle();
      expect(find.text('Hiện trạng khi mở ca'), findsOneWidget);
      expect(find.text('Nhật ký đo nước'), findsOneWidget);
      expect(find.text('Hao hụt'), findsOneWidget);
      expect(find.text('12.4'), findsOneWidget);
      expect(find.text('8,6'), findsOneWidget);
      expect(find.text('Cần chú ý'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Trò chuyện với chuyên gia'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Trò chuyện với chuyên gia'), findsOneWidget);
      expect(find.text('Trao đổi với chuyên gia'), findsNothing);
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'Tôm bắt mồi tốt hơn');
      await tester.tap(find.byKey(const ValueKey('case-send-response')));
      await tester.pumpAndSettle();
      expect(repo.sentType, CaseResponseType.normal);
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
    expect(find.text('Chưa có thông tin ghi nhận khi mở ca.'), findsNothing);
    await tester.tap(find.text('Dữ liệu lúc mở ca'));
    await tester.pumpAndSettle();
    expect(find.text('Chưa có thông tin ghi nhận khi mở ca.'), findsOneWidget);
    expect(find.text('12.4'), findsNothing);
  });

  testWidgets(
    'sending a chat reply clears the draft without showing a success notice',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 725);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      final repo = CaseFixtureRepository();
      await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
      await tester.tap(find.text('Dữ liệu lúc mở ca'));
      await tester.pumpAndSettle();
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await tester.pumpAndSettle();
      final send = find.byKey(const ValueKey('case-send-response'));
      final originalSendRect = tester.getRect(send);
      final originalContentRect = tester.getRect(find.byType(RefreshIndicator));
      final originalDescriptionRect = tester.getRect(
        find.text('Ghi chú: Tình trạng quan sát tại ao'),
      );
      await tester.enterText(find.byType(TextFormField), 'Thông tin mới');
      await tester.tap(send);
      await tester.pumpAndSettle();

      expect(repo.sentMessage, 'Thông tin mới');
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField))
            .controller!
            .text,
        isEmpty,
      );
      expect(find.byKey(const ValueKey('app_notice_success')), findsNothing);
      expect(find.byType(SnackBar), findsNothing);
      expect(tester.getRect(send), originalSendRect);
      expect(
        tester.getRect(find.byType(RefreshIndicator)),
        originalContentRect,
      );
      expect(
        tester.getRect(find.text('Ghi chú: Tình trạng quan sát tại ao')),
        originalDescriptionRect,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'opening data expands above the pinned composer and keeps the reply draft',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(320, 725);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      final repo = CaseFixtureRepository()
        ..item = fixture.copyWith(
          caseSnapshot: {
            ...fixture.caseSnapshot,
            'shrimpHealth': {'avgWeightG': '12.4', 'healthStatus': 'GOOD'},
          },
          statusHistory: [
            {'toStatus': 'OPEN', 'reason': 'KTV mở ca bệnh'},
          ],
        );
      await showCase(tester, repo, path: '/seasons/season/disease-cases/case');
      await tester.enterText(find.byType(TextFormField), 'Bản nháp đang nhập');
      tester.view.viewInsets = const FakeViewPadding(bottom: 260);
      await tester.pumpAndSettle();

      expect(find.text('Lịch sử trạng thái'), findsNothing);
      expect(find.text('12.4'), findsNothing);
      final header = find.text('Dữ liệu lúc mở ca');
      await tester.scrollUntilVisible(
        header,
        100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.tap(header);
      await tester.pumpAndSettle();
      expect(find.text('12.4'), findsOneWidget);
      expect(find.text('Tốt'), findsOneWidget);
      expect(find.text('Bản nháp đang nhập'), findsOneWidget);
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
