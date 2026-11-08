import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:smartshrimp_app/core/widgets/app_select_field.dart';
import '../../support/load_app_fonts.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets(
    'Figma geometry remains stable with labels, validation and selection',
    (tester) async {
      final form = GlobalKey<FormState>();
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 370.435,
                child: Form(
                  key: form,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AppFieldLabel('Tiêu đề nhiệm vụ *'),
                      const SizedBox(height: AppFormMetrics.labelGap),
                      AppTextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: 'VD: Kiểm tra & xử lý NO2 cao tại Ao A3',
                        ),
                        validator: (text) => text!.isEmpty
                            ? 'Tiêu đề nhiệm vụ không được để trống.'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      const AppFieldLabel('Trang trại *'),
                      const SizedBox(height: AppFormMetrics.labelGap),
                      AppSelectField<String>(
                        value: 'farm',
                        items: const [
                          DropdownMenuItem(
                            value: 'farm',
                            child: Text('Trang trại Cửa Lấp'),
                          ),
                        ],
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final input = find.byType(AppTextField);
      final editable = find.byType(EditableText);
      final select = find.byType(AppSelectField<String>);
      RenderBox inputBox() =>
          InputDecorator.containerOf(tester.element(editable))!;
      expect(inputBox().size.height, closeTo(43.373, .001));
      expect(tester.getSize(select).height, closeTo(38, .001));
      expect(tester.getSize(input).width, closeTo(370.435, .001));
      expect(
        tester.getTopLeft(input).dy -
            tester.getBottomLeft(find.text('Tiêu đề nhiệm vụ *')).dy,
        closeTo(6, .001),
      );
      expect(
        tester.getTopLeft(select).dy -
            tester.getBottomLeft(find.text('Trang trại *')).dy,
        closeTo(6, .001),
      );
      final decorator = tester.widget<InputDecorator>(
        find.descendant(of: input, matching: find.byType(InputDecorator)),
      );
      expect(
        (decorator.decoration.enabledBorder! as OutlineInputBorder)
            .borderRadius,
        BorderRadius.circular(12),
      );
      expect(
        (decorator.decoration.enabledBorder! as OutlineInputBorder)
            .borderSide
            .width,
        closeTo(1.208, .001),
      );
      expect(form.currentState!.validate(), isFalse);
      await tester.pumpAndSettle();
      final error = find.text('Tiêu đề nhiệm vụ không được để trống.');
      expect(
        tester.getTopLeft(error).dx,
        closeTo(inputBox().localToGlobal(Offset.zero).dx, .001),
      );
      expect(
        tester.getTopLeft(error).dy -
            inputBox().localToGlobal(Offset(0, inputBox().size.height)).dy,
        closeTo(0, .001),
      );
      expect(tester.widget<Text>(error).style!.fontSize, 11);
      expect(tester.widget<Text>(error).style!.fontWeight, FontWeight.w600);
      expect(inputBox().size.height, closeTo(43.373, .001));
      await tester.enterText(input, 'Nhiệm vụ mới');
      expect(form.currentState!.validate(), isTrue);
      await tester.pumpAndSettle();
      expect(error, findsNothing);
      form.currentState!.reset();
      await tester.pump();
      expect(controller.text, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'controller replacement and local editing preserve values and callbacks',
    (tester) async {
      final first = TextEditingController(text: 'Một');
      final second = TextEditingController(text: 'Hai');
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      TextEditingController? selected = first;
      late StateSetter rebuild;
      String? changed, saved;
      final form = GlobalKey<FormState>();
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return Scaffold(
                body: Form(
                  key: form,
                  child: AppTextField(
                    key: const Key('shared'),
                    controller: selected,
                    onChanged: (text) => changed = text,
                    onSaved: (text) => saved = text,
                  ),
                ),
              );
            },
          ),
        ),
      );
      await tester.enterText(find.byKey(const Key('shared')), 'Sửa');
      expect(first.text, 'Sửa');
      expect(changed, 'Sửa');
      rebuild(() => selected = second);
      await tester.pump();
      expect(find.text('Hai'), findsOneWidget);
      rebuild(() => selected = null);
      await tester.pump();
      expect(find.text('Hai'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('shared')), 'Cục bộ');
      form.currentState!.save();
      expect(saved, 'Cục bộ');
      expect(second.text, 'Hai');
      rebuild(() => selected = first);
      await tester.pump();
      expect(find.text('Sửa'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
