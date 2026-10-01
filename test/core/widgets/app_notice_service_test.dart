import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';

void main() {
  tearDown(AppNoticeService.hide);

  testWidgets('renders a styled success notice with title and message', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () => AppNoticeService.success(
                context,
                'Trang trại mới đã sẵn sàng để quản lý.',
                title: 'Tạo trang trại thành công',
              ),
              child: const Text('Hiện thông báo'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Hiện thông báo'));
    await tester.pump();

    expect(find.byKey(const ValueKey('app_notice_success')), findsOneWidget);
    expect(find.text('Tạo trang trại thành công'), findsOneWidget);
    expect(find.text('Trang trại mới đã sẵn sàng để quản lý.'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('blocked confirm helper lists blockers and prevents deletion', (
    tester,
  ) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: FilledButton(
              onPressed: () async {
                result = await showAppConfirmDialog(
                  context,
                  entityLabel: 'trang trại',
                  entityName: 'Trại Cà Mau',
                  retentionMessage: 'Giữ lịch sử.',
                  blockers: const <String>['1 vụ nuôi đang mở.'],
                );
              },
              child: const Text('Mở xác nhận'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mở xác nhận'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('app_dialog_warning')),
      findsOneWidget,
    );
    expect(find.text('Chưa thể xóa trang trại'), findsOneWidget);
    expect(find.text('1 vụ nuôi đang mở.'), findsOneWidget);
    expect(find.text('Đã hiểu'), findsOneWidget);
    expect(find.text('Xác nhận xóa'), findsNothing);

    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('danger form banner constrains long content', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppFormErrorBanner(
            message:
                'Nội dung lỗi rất dài để xác minh widget không làm vỡ bố cục trên màn hình nhỏ.',
          ),
        ),
      ),
    );

    final message = tester.widget<Text>(
      find.text(
        'Nội dung lỗi rất dài để xác minh widget không làm vỡ bố cục trên màn hình nhỏ.',
      ),
    );
    expect(message.maxLines, 4);
    expect(message.overflow, TextOverflow.ellipsis);
  });
}
