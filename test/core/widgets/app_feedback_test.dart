import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/app_feedback.dart';

void main() {
  testWidgets('renders the shared success toast with title and message', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () => AppFeedback.success(
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

    expect(find.byType(AppToast), findsOneWidget);
    expect(find.text('Tạo trang trại thành công'), findsOneWidget);
    expect(find.text('Trang trại mới đã sẵn sàng để quản lý.'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  });

  testWidgets('blocked confirm dialog lists blockers and hides delete action', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppConfirmDialog(
            entityLabel: 'trang trại',
            entityName: 'Trại Cà Mau',
            retentionMessage: 'Giữ lịch sử.',
            blockers: <String>['1 vụ nuôi đang mở.'],
          ),
        ),
      ),
    );

    expect(find.text('Chưa thể xóa trang trại'), findsOneWidget);
    expect(find.text('1 vụ nuôi đang mở.'), findsOneWidget);
    expect(find.text('Đã hiểu'), findsOneWidget);
    expect(find.text('Xác nhận xóa'), findsNothing);
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
