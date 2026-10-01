import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';

void main() {
  testWidgets('confirm dialog uses the shared compact layout', (tester) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AppConfirmDialog(
                    title: 'Kích hoạt vụ nuôi?',
                    description:
                        'Kiểm tra thông tin trước khi bắt đầu vận hành.',
                    confirmLabel: 'Kích hoạt',
                    cancelLabel: 'Để sau',
                    level: AppNoticeLevel.warning,
                    content: const Text('Thông tin vụ nuôi'),
                    onConfirm: () => Navigator.of(dialogContext).pop(true),
                  ),
                );
              },
              child: const Text('Mở dialog'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mở dialog'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('app_dialog_warning')),
      findsOneWidget,
    );
    expect(find.text('Kích hoạt vụ nuôi?'), findsOneWidget);
    expect(find.text('Thông tin vụ nuôi'), findsOneWidget);
    expect(find.byKey(const Key('app_confirm_dialog_cancel')), findsOneWidget);
    expect(find.byKey(const Key('app_confirm_dialog_confirm')), findsOneWidget);

    await tester.tap(find.byKey(const Key('app_confirm_dialog_confirm')));
    await tester.pumpAndSettle();

    expect(result, isTrue);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('destructive dialog supports vertical header and action panel', (
    tester,
  ) async {
    String? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                result = await showDialog<String>(
                  context: context,
                  builder: (dialogContext) => AppConfirmDialog(
                    title: 'Hủy vụ nuôi?',
                    description: 'Vụ nuôi sẽ được giữ lại trong lịch sử.',
                    confirmLabel: 'Xác nhận hủy',
                    level: AppNoticeLevel.danger,
                    destructive: true,
                    icon: Icons.close_rounded,
                    verticalHeader: true,
                    separatedActions: true,
                    onCancel: () => Navigator.of(dialogContext).pop(),
                    content: const TextField(
                      maxLines: 3,
                      decoration: InputDecoration(hintText: 'Nhập lý do'),
                    ),
                    onConfirm: () => Navigator.of(dialogContext).pop('reason'),
                  ),
                );
              },
              child: const Text('Mở dialog hủy'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Mở dialog hủy'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(find.text('Hủy vụ nuôi?'), findsOneWidget);
    expect(find.text('Xác nhận hủy'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('app_confirm_dialog_cancel')));
    await tester.pumpAndSettle();

    expect(result, isNull);
    expect(find.byType(AlertDialog), findsNothing);
  });
}
