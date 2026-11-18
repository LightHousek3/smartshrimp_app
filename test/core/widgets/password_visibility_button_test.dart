import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/widgets/password_visibility_button.dart';

void main() {
  testWidgets(
    'hidden passwords show an open eye; visible passwords show a slashed eye',
    (tester) async {
      final controller = TextEditingController(text: 'Password123');
      addTearDown(controller.dispose);
      var obscure = true;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) => TextField(
                controller: controller,
                obscureText: obscure,
                decoration: InputDecoration(
                  suffixIcon: PasswordVisibilityButton(
                    obscureText: obscure,
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).obscureText,
        isTrue,
      );
      final eye = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(
        (eye.bytesLoader as SvgAssetLoader).assetName,
        'assets/icons/auth/eye.svg',
      );
      await tester.tap(find.byTooltip('Hiện mật khẩu'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).obscureText,
        isFalse,
      );
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(controller.text, 'Password123');
      await tester.tap(find.byTooltip('Ẩn mật khẩu'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField)).obscureText,
        isTrue,
      );
      expect(find.byType(SvgPicture), findsOneWidget);
    },
  );

  testWidgets('a disabled visibility button cannot change the password state', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: PasswordVisibilityButton(obscureText: true, onPressed: null),
          ),
        ),
      ),
    );
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).onPressed,
      isNull,
    );
    expect(tester.getSize(find.byType(IconButton)), const Size(44, 44));
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(find.byType(SvgPicture), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
