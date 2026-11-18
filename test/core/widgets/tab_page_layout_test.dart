import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/tab_page_layout.dart';

import '../../support/load_app_fonts.dart';

void main() {
  testWidgets(
    'tab header follows task typography and stays fixed while the body scrolls',
    (tester) async {
      await loadAppFonts();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TabPageLayout(
              title: 'Nhiệm vụ',
              subtitle: 'Công việc Chủ trang trại giao cho bạn',
              child: ListView(
                children: [
                  for (var i = 0; i < 40; i++)
                    SizedBox(height: 60, child: Text('row $i')),
                ],
              ),
            ),
          ),
        ),
      );
      final title = find.text('Nhiệm vụ');
      final heading = tester.widget<Text>(title);
      expect(heading.style!.fontSize, 22);
      expect(heading.style!.fontWeight, FontWeight.w800);
      expect(heading.style!.letterSpacing, -.55);
      expect(find.byType(AppGradientBackground), findsOneWidget);
      final position = tester.getTopLeft(title);
      expect(position, const Offset(16, 28));
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(title), position);
      expect(find.text('row 0'), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('loading and loaded subtitles preserve the header position', (
    tester,
  ) async {
    await loadAppFonts();
    Future<void> show(String? subtitle) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TabPageLayout(
            title: 'Xin chào',
            subtitle: subtitle,
            child: const SizedBox.expand(key: Key('tab_body')),
          ),
        ),
      ),
    );
    await show(null);
    final before = tester.getRect(find.byKey(const Key('tab_body')));
    await show('Thứ Tư, 18/11/2026');
    expect(tester.getRect(find.byKey(const Key('tab_body'))), before);
  });

  for (final scale in [1.0, 1.5, 2.0]) {
    testWidgets(
      'actions and filters remain usable at width 320 and scale $scale',
      (tester) async {
        await loadAppFonts();
        tester.view.physicalSize = const Size(320, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        var actions = 0;
        var filters = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(
                textScaler: TextScaler.linear(scale),
                padding: const EdgeInsets.only(top: 24),
              ),
              child: Scaffold(
                body: TabPageLayout(
                  title: 'Thông báo',
                  subtitle: '1.234 thông báo chưa đọc',
                  trailing: TextButton(
                    onPressed: () => actions++,
                    child: const Text('Đọc tất cả'),
                  ),
                  headerBottom: SizedBox(
                    height: 60,
                    child: TextButton(
                      onPressed: () => filters++,
                      child: const Text('Tất cả'),
                    ),
                  ),
                  child: const SizedBox.expand(key: Key('tab_body')),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Đọc tất cả'));
        await tester.tap(find.text('Tất cả'));
        expect(actions, 1);
        expect(filters, 1);
        expect(tester.getTopLeft(find.text('Thông báo')).dy, 52);
        expect(
          tester.getSize(find.byKey(const Key('tab_body'))).height,
          greaterThan(0),
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
}
