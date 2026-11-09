import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/rag/domain/entities/rag_models.dart';
import 'package:smartshrimp_app/features/rag/presentation/widgets/rag_answer_body.dart';
import 'package:smartshrimp_app/features/rag/presentation/widgets/rag_chat_widgets.dart';

const _noSourceWarning =
    'Chưa tìm thấy nguồn tham chiếu. Vui lòng kiểm chứng câu trả lời trước khi áp dụng.';
const _lowMatchWarning =
    'Nguồn tham chiếu có độ liên quan thấp. Vui lòng kiểm chứng câu trả lời trước khi áp dụng.';
const _fallbackError = 'AI chưa thể tạo câu trả lời. Vui lòng thử lại.';
const _answer = '**Giữ oxy ổn định**\n\n120–150 mg/L; 2 * 3 = 6.';
const _chunk = RagChunk(
  sourceFile: 'huong-dan.pdf',
  chunkIndex: 2,
  similarity: .325,
  content: 'Nội dung nguồn gốc: 120–150 mg/L.',
);

RagQuery _query(RagQueryStatus status) => RagQuery(
  id: 'query',
  conversationId: 'conversation',
  question: 'Chăm sóc ao thế nào?',
  queryStatus: status,
  createdAt: DateTime(2026),
  answer: status == RagQueryStatus.error ? null : _answer,
  errorMessage: status == RagQueryStatus.error
      ? 'Máy chủ không xử lý được.'
      : null,
  retrievedChunks: [
    if (status == RagQueryStatus.answered || status == RagQueryStatus.lowMatch)
      _chunk,
  ],
);

Future<void> _pump(
  WidgetTester tester,
  RagQuery query, {
  double width = 320,
  double textScale = 1,
}) async {
  tester.view.physicalSize = Size(width, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.ocean,
          error: AppColors.error,
        ),
      ),
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: RagMessagePair(query: query, busy: false, onRate: (_) {}),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final (status, label, color, warning) in [
    (RagQueryStatus.answered, 'Đã trả lời', AppColors.inkMuted, null),
    (
      RagQueryStatus.noSource,
      'Không tìm thấy nguồn',
      const Color(0xFF99631A),
      _noSourceWarning,
    ),
    (
      RagQueryStatus.lowMatch,
      'Nguồn ít phù hợp',
      const Color(0xFF99631A),
      _lowMatchWarning,
    ),
    (RagQueryStatus.error, 'Lỗi xử lý', AppColors.error, null),
  ]) {
    for (final (width, scale) in [(402.0, 1.0), (320.0, 1.0), (320.0, 2.0)]) {
      testWidgets('$status at width $width and text scale $scale', (
        tester,
      ) async {
        final query = _query(status);
        await _pump(tester, query, width: width, textScale: scale);
        expect(find.text('Trợ lý AI'), findsOneWidget);
        expect(find.text(label), findsOneWidget);
        expect(tester.widget<Text>(find.text(label)).style!.color, color);
        expect(
          find.text('Đánh giá:'),
          status == RagQueryStatus.error ? findsNothing : findsOneWidget,
        );
        expect(
          find.byIcon(Icons.error_outline),
          status == RagQueryStatus.error ? findsOneWidget : findsNothing,
        );
        if (status == RagQueryStatus.error) {
          expect(
            tester.widget<Icon>(find.byIcon(Icons.error_outline)).color,
            AppColors.error,
          );
        }
        expect(
          tester.widget<RagAnswerBody>(find.byType(RagAnswerBody)).text,
          status == RagQueryStatus.error ? query.errorMessage : _answer,
        );
        if (warning != null) {
          expect(find.text(warning), findsOneWidget);
          expect(
            tester.widget<Text>(find.text(warning)).style!.color,
            const Color(0xFF99631A),
          );
        } else {
          expect(find.text(_noSourceWarning), findsNothing);
          expect(find.text(_lowMatchWarning), findsNothing);
        }
        if (query.retrievedChunks.isEmpty) {
          expect(find.text('Không có nguồn tham chiếu.'), findsOneWidget);
          expect(find.byType(ExpansionTile), findsNothing);
        } else {
          expect(find.text('Không có nguồn tham chiếu.'), findsNothing);
          await tester.ensureVisible(find.text('Nguồn tham chiếu (1)'));
          await tester.tap(find.text('Nguồn tham chiếu (1)'));
          await tester.pumpAndSettle();
          expect(find.text('huong-dan.pdf · Phần 3'), findsOneWidget);
          expect(
            find.text('32.5% tương đồng\n${_chunk.content}'),
            findsOneWidget,
          );
        }
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final (status, fallback) in [
    (RagQueryStatus.noSource, _noSourceWarning),
    (RagQueryStatus.lowMatch, _lowMatchWarning),
  ]) {
    testWidgets('$status preserves server warning instead of fallback', (
      tester,
    ) async {
      const serverWarning = 'Cảnh báo nguyên văn từ máy chủ.';
      await _pump(tester, _query(status).copyWith(warning: serverWarning));
      expect(find.text(serverWarning), findsOneWidget);
      expect(find.text(fallback), findsNothing);
    });
    testWidgets('$status shows matching server warning only once', (
      tester,
    ) async {
      await _pump(tester, _query(status).copyWith(warning: fallback));
      expect(find.text(fallback), findsOneWidget);
    });
  }

  testWidgets('ERROR uses server error text even if an answer is present', (
    tester,
  ) async {
    const errorMessage = '**Lỗi từ máy chủ**: vui lòng thử lại.';
    await _pump(
      tester,
      _query(
        RagQueryStatus.error,
      ).copyWith(answer: _answer, errorMessage: errorMessage),
    );
    expect(
      tester.widget<RagAnswerBody>(find.byType(RagAnswerBody)).text,
      errorMessage,
    );
    expect(find.text('Đánh giá:'), findsNothing);
  });

  testWidgets('ERROR without errorMessage keeps the existing fallback', (
    tester,
  ) async {
    await _pump(
      tester,
      _query(
        RagQueryStatus.error,
      ).copyWith(answer: _answer, errorMessage: null),
    );
    expect(
      tester.widget<RagAnswerBody>(find.byType(RagAnswerBody)).text,
      _fallbackError,
    );
    expect(find.text('Đánh giá:'), findsNothing);
  });

  testWidgets('null answer remains ineligible for rating', (tester) async {
    await _pump(tester, _query(RagQueryStatus.answered).copyWith(answer: null));
    expect(find.text('Đánh giá:'), findsNothing);
  });
}
