import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';

void main() {
  tearDown(AppNoticeService.hide);

  testWidgets('renders every notice level with the shared card layout', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SizedBox.expand())),
    );
    final context = tester.element(find.byType(Scaffold));
    final cases = <(AppNoticeLevel, String, void Function(BuildContext))>[
      (
        AppNoticeLevel.success,
        'Thành công',
        (context) => AppNoticeService.success(context, 'Đã lưu dữ liệu.'),
      ),
      (
        AppNoticeLevel.info,
        'Thông tin',
        (context) => AppNoticeService.info(context, 'Thông tin tham khảo.'),
      ),
      (
        AppNoticeLevel.warning,
        'Cảnh báo',
        (context) => AppNoticeService.warning(context, 'Cần kiểm tra lại.'),
      ),
      (
        AppNoticeLevel.danger,
        'Có lỗi xảy ra',
        (context) => AppNoticeService.danger(context, 'Không thể lưu dữ liệu.'),
      ),
    ];

    for (final (level, title, showNotice) in cases) {
      showNotice(context);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byKey(ValueKey('app_notice_${level.name}')), findsOneWidget);
      expect(find.text(title), findsOneWidget);

      AppNoticeService.hide();
      await tester.pumpAndSettle();
    }
  });

  testWidgets('notice animates out after its display duration', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: SizedBox.expand())),
    );
    final context = tester.element(find.byType(Scaffold));

    AppNoticeService.show(
      context,
      title: 'Thành công',
      message: 'Vụ nuôi đã được hủy và giữ lại trong lịch sử.',
      level: AppNoticeLevel.success,
      duration: const Duration(milliseconds: 500),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byKey(const ValueKey('app_notice_success')), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.byKey(const ValueKey('app_notice_success')), findsNothing);
  });
}
