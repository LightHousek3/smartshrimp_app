import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/features/rag/presentation/pages/rag_conversations_page.dart';
import 'package:smartshrimp_app/features/rag/presentation/widgets/rag_history_widgets.dart';
import 'package:smartshrimp_app/features/rag/presentation/widgets/rag_answer_body.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/rag/domain/entities/rag_models.dart';
import 'package:smartshrimp_app/features/rag/domain/repositories/rag_repository.dart';
import 'package:smartshrimp_app/features/rag/presentation/pages/rag_chat_page.dart';
import 'package:smartshrimp_app/features/rag/presentation/view_models/rag_controller.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/repositories/assigned_season_repository.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  testWidgets(
    'answer renders Markdown and preserves ordinary technical symbols',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: const Scaffold(
            body: SizedBox(
              width: 288,
              child: RagAnswerBody(
                text:
                    '**Ao ương** là ao nuôi tôm giống.\n\n---\n\n* Giữ oxy ổn định\n* Theo dõi *độ mặn*\n\n1. Kiểm tra nước\n2. Cho ăn\n\n120–150 mg/L; 2 * 3 = 6.',
              ),
            ),
          ),
        ),
      );
      await tester.runAsync(() => GoogleFonts.pendingFonts());
      await tester.pumpAndSettle();
      final rendered = tester
          .widgetList<SelectableText>(find.byType(SelectableText))
          .map((text) => text.data ?? text.textSpan!.toPlainText())
          .join('\n');
      expect(rendered, contains('Ao ương'));
      expect(rendered, contains('Giữ oxy ổn định'));
      expect(rendered, contains('120–150 mg/L; 2 * 3 = 6.'));
      expect(rendered, isNot(contains('**')));
      expect(rendered, isNot(contains('---')));
      expect(rendered, isNot(contains('*độ mặn*')));
      final spans = <TextSpan>[];
      void collect(InlineSpan span) {
        if (span is TextSpan) {
          spans.add(span);
          for (final child in span.children ?? <InlineSpan>[]) {
            collect(child);
          }
        }
      }

      for (final text in tester.widgetList<SelectableText>(
        find.byType(SelectableText),
      )) {
        if (text.textSpan != null) collect(text.textSpan!);
      }
      expect(
        spans.any(
          (span) =>
              span.text == 'Ao ương' &&
              span.style?.fontWeight == FontWeight.w700,
        ),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    },
  );
  _historyTests();
  for (final width in [402.0, 320.0]) {
    testWidgets('Figma chat layout fits a $width pixel phone', (tester) async {
      tester.view.physicalSize = Size(width, 876);
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(top: 40);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);
      final repository = _Repository()
        ..previewQueries = [
          RagQuery(
            id: '1',
            conversationId: 'conversation',
            question:
                'NO2 trong ao 1.9 mg/L ở DOC 70 có nguy hiểm không và xử lý thế nào?',
            answer:
                'Ở giai đoạn DOC 70, NO2 ở mức 1.9 mg/L là cao và gây stress cho tôm. Nên: (1) thay 10–15% nước nếu nguồn nước tốt, (2) tăng cường quạt/oxy, (3) tạt Yucca và bổ sung men vi sinh xử lý đáy, (4) giảm 10–20% lượng ăn để giảm tải hữu cơ, (5) duy trì độ kiềm 120–150 mg/L. Theo dõi lại NO2 sau 6–12 giờ.',
            queryStatus: RagQueryStatus.answered,
            createdAt: DateTime(2026),
            retrievedChunks: [],
            feedback: const RagFeedback(id: 'f', rating: 5),
          ),
          RagQuery(
            id: '2',
            conversationId: 'conversation',
            question: 'Bao lâu nên chài kiểm tra sinh khối một lần?',
            answer:
                'Thông thường nên chài kiểm tra sinh khối định kỳ 7–10 ngày/lần sau khi tôm đạt ~30 ngày tuổi, và tăng tần suất khi điều chỉnh khẩu phần hoặc trước khi thu tỉa.',
            queryStatus: RagQueryStatus.answered,
            createdAt: DateTime(2026),
            retrievedChunks: [],
          ),
        ]
        ..seasonName = 'Vụ Đông Xuân 2025';
      final boundary = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(key: boundary, child: _app(repository)),
      );
      await tester.runAsync(() => GoogleFonts.pendingFonts());
      await tester.pumpAndSettle();
      expect(find.text('Hỏi chuyên gia AI'), findsOneWidget);
      expect(find.text('Ao A3'), findsOneWidget);
      expect(find.text('Trại Cửa Lấp  ›  Vụ Đông Xuân 2025'), findsOneWidget);
      expect(tester.takeException(), isNull);
      const assetWidths = {
        'assets/icons/rag/back.svg': 19.9863,
        'assets/icons/rag/location.svg': 13.9828,
        'assets/icons/rag/assistant.svg': 12.9854,
        'assets/icons/rag/star.svg': 15.9965,
        'assets/icons/rag/star_muted.svg': 15.9965,
        'assets/icons/rag/send.svg': 17.9914,
      };
      final renderedAssets = <String>{};
      for (final svg in tester.widgetList<SvgPicture>(
        find.byType(SvgPicture),
      )) {
        final asset = (svg.bytesLoader as SvgAssetLoader).assetName;
        renderedAssets.add(asset);
        expect(
          tester.getSize(find.byWidget(svg)).width,
          closeTo(assetWidths[asset]!, .02),
        );
      }
      expect(renderedAssets, containsAll(assetWidths.keys));
      final sendRect = tester.getRect(
        find.ancestor(
          of: find.byTooltip('Gửi câu hỏi'),
          matching: find.byType(IconButton),
        ),
      );
      expect(sendRect.width, 44);
      expect(sendRect.right, lessThanOrEqualTo(width - 12));
      if (width == 402) {
        await tester.runAsync(() async {
          final image =
              await (boundary.currentContext!.findRenderObject()!
                      as RenderRepaintBoundary)
                  .toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final output = File('build/rag-chat-preview.png');
          await output.parent.create(recursive: true);
          await output.writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
    });
  }
  testWidgets('shows warning and references, saves and edits feedback', (
    tester,
  ) async {
    final repository = _Repository();
    await tester.pumpWidget(_app(repository));
    await tester.pumpAndSettle();
    expect(find.textContaining('Cần kiểm chứng'), findsOneWidget);
    expect(find.text('Nguồn tham chiếu (1)'), findsOneWidget);
    await tester.tap(find.text('Đánh giá:'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<FilledButton>(
            find.widgetWithText(FilledButton, 'Lưu đánh giá'),
          )
          .onPressed,
      isNull,
    );
    await tester.tap(find.byTooltip('5 sao'));
    await tester.pump();
    await tester.tap(find.text('Lưu đánh giá'));
    await tester.pumpAndSettle();
    expect(repository.rating, 5);
    expect(find.byTooltip('Sửa đánh giá 5 sao'), findsOneWidget);
    await tester.tap(find.byTooltip('Sửa đánh giá 1 sao'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('1 sao'));
    await tester.pump();
    await tester.tap(find.text('Lưu đánh giá'));
    await tester.pumpAndSettle();
    expect(repository.rating, 1);
  });
  testWidgets('completed season has no composer and allows rating', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_Repository(canAsk: false)));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Gửi câu hỏi'), findsNothing);
    expect(find.text('Đánh giá:'), findsOneWidget);
  });
  testWidgets('new conversation shows thinking until the answer arrives', (
    tester,
  ) async {
    final repository = _Repository()..pending = Completer<RagQuery>();
    await tester.pumpWidget(_app(repository, conversationId: null));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Câu hỏi đầu tiên');
    await tester.tap(find.byTooltip('Gửi câu hỏi'));
    await tester.pump(const Duration(milliseconds: 250));
    expect(find.text('AI đang suy nghĩ…'), findsOneWidget);
    expect(find.text('Câu hỏi đầu tiên'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    expect(find.text('Gửi câu hỏi kỹ thuật về vụ nuôi này.'), findsNothing);
    repository.pending!.complete(
      repository.query.copyWith(question: 'Câu hỏi đầu tiên'),
    );
    await tester.pumpAndSettle();
    expect(find.text('AI đang suy nghĩ…'), findsNothing);
    expect(find.text('Câu trả lời'), findsOneWidget);
    expect(find.text('Câu hỏi đầu tiên'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'prevents duplicate submission and preserves question on failure',
    (tester) async {
      final repository = _Repository();
      repository.pending = Completer<RagQuery>();
      await tester.pumpWidget(_app(repository));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Câu hỏi mới');
      await tester.tap(find.byTooltip('Gửi câu hỏi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('AI đang suy nghĩ…'), findsOneWidget);
      expect(find.text('Câu hỏi mới'), findsOneWidget);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
      expect(
        tester
            .widget<IconButton>(
              find.ancestor(
                of: find.byTooltip('Gửi câu hỏi'),
                matching: find.byType(IconButton),
              ),
            )
            .onPressed,
        isNull,
      );
      repository.pending!.completeError(
        const ApiException('Lỗi gửi câu hỏi', statusCode: 409),
      );
      await tester.pumpAndSettle();
      expect(find.text('Câu hỏi mới'), findsOneWidget);
      expect(find.text('AI đang suy nghĩ…'), findsNothing);
      expect(find.text('Lỗi gửi câu hỏi'), findsOneWidget);
      expect(repository.askCount, 1);
    },
  );
}

Widget _app(
  _Repository repository, {
  String? conversationId = 'conversation',
}) => ProviderScope(
  overrides: [
    ragRepositoryProvider.overrideWithValue(repository),
    authRepositoryProvider.overrideWithValue(_Auth()),
    assignedSeasonRepositoryProvider.overrideWithValue(_Seasons()),
  ],
  child: MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    home: RagChatPage(seasonId: 'season', conversationId: conversationId),
  ),
);

final class _Auth implements AuthRepository {
  final account = const AuthAccount(
    id: 'me',
    email: 'a@b.test',
    role: AccountRole.technician,
    status: AccountStatus.active,
  );
  @override
  Future<AuthAccount?> restoreSession() async => account;
  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => account;
  @override
  Future<void> logout() async {}
}

final class _Seasons implements AssignedSeasonRepository {
  _Seasons({this.status = AssignedSeasonStatus.active});
  final AssignedSeasonStatus status;
  @override
  Future<AssignedSeasonDetail> getAssignedSeason(String id) async =>
      AssignedSeasonDetail(
        id: id,
        name: 'Vụ Đông Xuân 2025',
        status: status,
        shrimpType: 'WHITELEG',
        pondId: 'pond',
        pondName: 'Ao A3',
        pondType: 'AQUACULTURE',
        pondStatus: 'AVAILABLE',
        farmId: 'farm',
        farmName: 'Trại Cửa Lấp',
        personnel: [],
        otherAssignedSeasons: [],
        assignedAt: DateTime(2026),
      );
  @override
  Future<AssignedSeasonPage> getAssignedSeasons({
    AssignedSeasonStatus? status,
    String? search,
    String? farmId,
    String? cursor,
    int limit = 20,
  }) async => const AssignedSeasonPage(
    items: [],
    totalResults: 0,
    activeResults: 0,
    allResults: 0,
    hasNextPage: false,
  );
}

final class _Repository implements RagRepository {
  _Repository({this.canAsk = true});
  final bool canAsk;
  int? rating;
  int askCount = 0;
  Completer<RagQuery>? pending;
  List<RagQuery>? previewQueries;
  String seasonName = 'Vụ 1';
  List<RagConversationSummary> conversations = [];
  bool hasNextPage = false;
  bool failList = false;
  int listCalls = 0;
  final query = RagQuery(
    id: 'q',
    conversationId: 'conversation',
    question: 'Hỏi về ao nuôi',
    answer: 'Câu trả lời',
    warning: 'Cần kiểm chứng',
    queryStatus: RagQueryStatus.lowMatch,
    createdAt: DateTime(2026),
    retrievedChunks: [
      const RagChunk(
        sourceFile: 'guide.pdf',
        chunkIndex: 0,
        content: 'Nguồn',
        similarity: 0.3,
      ),
    ],
  );
  @override
  Future<RagChatState> detail(String conversationId, {int page = 1}) async =>
      RagChatState(
        seasonId: 'season',
        seasonName: seasonName,
        canAsk: canAsk,
        conversationId: conversationId,
        queries: previewQueries ?? [query],
      );
  @override
  Future<RagQuery> ask({
    required String seasonId,
    required String question,
    String? conversationId,
  }) async {
    askCount++;
    return pending?.future ?? query;
  }

  @override
  Future<RagFeedback> rate(String queryId, int rating, String? comment) async {
    this.rating = rating;
    return RagFeedback(id: 'f', rating: rating, comment: comment);
  }

  @override
  Future<RagConversationPage> list(String seasonId, {int page = 1}) async {
    listCalls++;
    if (failList) throw const ApiException('Không thể tải hội thoại');
    return RagConversationPage(
      items: page == 1 ? conversations : [],
      hasNextPage: page == 1 && hasNextPage,
      page: page,
      totalResults: conversations.length,
    );
  }
}

Widget _historyApp(
  _Repository repository, {
  AssignedSeasonStatus status = AssignedSeasonStatus.active,
}) {
  final router = GoRouter(
    initialLocation: '/seasons/season/rag',
    routes: [
      GoRoute(
        path: '/seasons/season/rag',
        builder: (_, _) => const RagConversationsPage(seasonId: 'season'),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => Scaffold(
              body: TextButton(
                onPressed: () => context.pop(),
                child: Text('Quay lại từ ${state.pathParameters['id']}'),
              ),
            ),
          ),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);
  return ProviderScope(
    overrides: [
      ragRepositoryProvider.overrideWithValue(repository),
      authRepositoryProvider.overrideWithValue(_Auth()),
      assignedSeasonRepositoryProvider.overrideWithValue(
        _Seasons(status: status),
      ),
    ],
    child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    ),
  );
}

List<RagConversationSummary> _previewConversations() => [
  for (final entry in [
    (
      'Xử lý NO₂ và kiểm tra sinh khối',
      'Bao lâu nên chài kiểm tra sinh khối một lần?',
      DateTime(2025, 9, 8, 6, 40),
      4,
    ),
    (
      'Tôm giảm ăn sau mưa',
      'Hãy kiểm tra ngay DO, pH, độ kiềm và độ mặn…',
      DateTime(2025, 9, 3, 15, 30),
      2,
    ),
    (
      'Điều chỉnh độ kiềm ao nuôi',
      'Nên nâng từ từ về khoảng 120–150 mg/L…',
      DateTime(2025, 8, 28, 7, 45),
      2,
    ),
    (
      'Khẩu phần khi trời âm u',
      'Giảm 10–20% khẩu phần và theo dõi nhá sát hơn…',
      DateTime(2025, 8, 20, 10, 10),
      2,
    ),
  ])
    RagConversationSummary(
      id: entry.$1,
      seasonId: 'season',
      title: entry.$1,
      lastMessagePreview: entry.$2,
      lastMessageAt: entry.$3,
      messageCount: entry.$4,
    ),
];

void _historyTests() {
  for (final width in [402.0, 320.0]) {
    testWidgets('Figma conversation history fits a $width pixel phone', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 876);
      tester.view.devicePixelRatio = 1;
      tester.view.padding = const FakeViewPadding(top: 40);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPadding);
      final repository = _Repository()..conversations = _previewConversations();
      final boundary = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(key: boundary, child: _historyApp(repository)),
      );
      await tester.runAsync(() => GoogleFonts.pendingFonts());
      await tester.pumpAndSettle();
      expect(find.text('Lịch sử trò chuyện'), findsOneWidget);
      await tester.runAsync(() => GoogleFonts.pendingFonts());
      await tester.pumpAndSettle();
      expect(find.text('4 cuộc trò chuyện'), findsOneWidget);
      expect(find.text('Ao A3'), findsOneWidget);
      expect(find.byType(RagConversationCard), findsNWidgets(4));
      expect(find.text('06:40 · 08-09  ·  4 tin nhắn'), findsOneWidget);
      expect(tester.takeException(), isNull);
      for (final svg in tester.widgetList<SvgPicture>(
        find.byType(SvgPicture),
      )) {
        final asset = (svg.bytesLoader as SvgAssetLoader).assetName;
        final nativeWidth = asset.endsWith('back.svg')
            ? 19.9863
            : asset.endsWith('location.svg')
            ? 13.9828
            : asset.endsWith('clock.svg')
            ? 12.9874
            : 17.9948;
        expect(
          tester.getSize(find.byWidget(svg)).width,
          closeTo(nativeWidth, .02),
        );
      }
      if (width == 402) {
        await tester.runAsync(() async {
          final image =
              await (boundary.currentContext!.findRenderObject()!
                      as RenderRepaintBoundary)
                  .toImage(pixelRatio: 2);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final file = File('build/rag-history-preview.png');
          await file.parent.create(recursive: true);
          await file.writeAsBytes(bytes!.buffer.asUint8List());
          image.dispose();
        });
      }
    });
  }
  testWidgets(
    'history opens existing and new conversations and refreshes after return',
    (tester) async {
      final repository = _Repository()..conversations = _previewConversations();
      await tester.pumpWidget(_historyApp(repository));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tôm giảm ăn sau mưa'));
      await tester.pumpAndSettle();
      expect(find.text('Quay lại từ Tôm giảm ăn sau mưa'), findsOneWidget);
      final beforeReturn = repository.listCalls;
      await tester.tap(find.text('Quay lại từ Tôm giảm ăn sau mưa'));
      await tester.pumpAndSettle();
      expect(repository.listCalls, greaterThan(beforeReturn));
      await tester.tap(find.text('Bắt đầu cuộc trò chuyện mới'));
      await tester.pumpAndSettle();
      expect(find.text('Quay lại từ new'), findsOneWidget);
    },
  );
  testWidgets('completed season keeps history and hides new conversation', (
    tester,
  ) async {
    await tester.pumpWidget(
      _historyApp(
        _Repository()..conversations = _previewConversations(),
        status: AssignedSeasonStatus.completed,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Bắt đầu cuộc trò chuyện mới'), findsNothing);
    expect(find.textContaining('Vụ nuôi đã kết thúc'), findsOneWidget);
    await tester.tap(find.text('Tôm giảm ăn sau mưa'));
    await tester.pumpAndSettle();
    expect(find.text('Quay lại từ Tôm giảm ăn sau mưa'), findsOneWidget);
  });
  testWidgets('history recovers from loading error and keeps pagination', (
    tester,
  ) async {
    final repository = _Repository()..failList = true;
    await tester.pumpWidget(_historyApp(repository));
    await tester.pumpAndSettle();
    expect(find.text('Không thể tải hội thoại'), findsOneWidget);
    repository
      ..failList = false
      ..hasNextPage = true;
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.text('Trang 1'), findsOneWidget);
    await tester.tap(find.byTooltip('Trang sau'));
    await tester.pumpAndSettle();
    expect(find.text('Trang 2'), findsOneWidget);
    expect(find.text('Chưa có hội thoại.'), findsOneWidget);
    await tester.tap(find.byTooltip('Trang trước'));
    await tester.pumpAndSettle();
    expect(find.text('Trang 1'), findsOneWidget);
  });
}
