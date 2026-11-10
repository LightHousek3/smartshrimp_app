import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_substance.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ingredient_editor.dart';

import 'inventory_substance_test_data.dart';

void main() {
  test('rejects an unknown check verdict and an unbounded suggestion page', () {
    expect(
      () => InventorySubstanceCheck.parse({
        'status': 'safe',
        'message': 'OK',
        'matches': [],
      }),
      throwsException,
    );
    expect(
      () => InventorySubstancePage.parse(
        List.generate(6, (i) => testSubstance('$i', 'Name').toJson()),
        {'hasNextPage': false},
      ),
      throwsException,
    );
  });
  test(
    'rejects unknown catalog statuses, duplicate entries and unusable cursors',
    () {
      final entry = testSubstance('vit', 'Vitamin C').toJson();
      for (final data in [
        [
          {...entry, 'status': 'approved'},
        ],
        [entry, entry],
        [
          {...entry, 'appendix': 'I'},
        ],
      ]) {
        expect(
          () => InventorySubstancePage.parse(data, {'hasNextPage': false}),
          throwsException,
        );
      }
      for (final cursor in ['', '0', '-5', 'abc']) {
        expect(
          () => InventorySubstancePage.parse(
            [entry],
            {'hasNextPage': true, 'nextCursor': cursor},
          ),
          throwsException,
        );
      }
      expect(
        () => InventorySubstancePage.parse([], {
          'hasNextPage': true,
          'nextCursor': '5',
        }),
        throwsException,
      );
    },
  );
  test('rejects verdicts that contradict matched substances', () {
    final banned = testSubstance(
      'I-2',
      'Chloramphenicol',
      status: 'banned',
    ).copyWith(mention: 'present').toJson();
    for (final verdict in ['not_detected', 'needs_review']) {
      expect(
        () => InventorySubstanceCheck.parse({
          'status': verdict,
          'message': 'Result',
          'matches': [banned],
        }),
        throwsException,
      );
    }
    expect(
      () => InventorySubstanceCheck.parse({
        'status': 'blocked',
        'message': 'Result',
        'matches': [],
      }),
      throwsException,
    );
    expect(
      InventorySubstanceCheck.parse({
        'status': 'blocked',
        'message': 'Result',
        'matches': [banned],
      }).blocksUse,
      isTrue,
    );
  });
  Future<void> openEditor(
    WidgetTester tester,
    FakeInventorySubstanceRepository repository, {
    String value = '',
    ValueChanged<String?>? onChanged,
    bool reflectChanges = false,
  }) async {
    var currentValue = value;
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(_OwnerAuth()),
          inventorySubstanceRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: StatefulBuilder(
                  builder: (context, rebuild) => InventoryIngredientEditor(
                    farmId: 'farm-1',
                    value: currentValue,
                    onChanged: (next) {
                      onChanged?.call(next);
                      if (reflectChanges) {
                        rebuild(() => currentValue = next ?? '');
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  testWidgets('shows every ingredient while typing without rewriting input', (
    tester,
  ) async {
    final repository = FakeInventorySubstanceRepository();
    await openEditor(tester, repository);
    final input = find.byKey(const ValueKey('inventory-ingredients-text'));
    await tester.enterText(input, 'Furaltadone');
    await tester.pump();
    expect(find.byType(InputChip), findsOneWidget);
    await tester.enterText(input, 'Furaltadone, Teicoplanin');
    await tester.pump();
    expect(find.byType(InputChip), findsNWidgets(2));
    expect(find.text('Furaltadone'), findsOneWidget);
    const text = 'Furaltadone, Teicoplanin\nEtanidazole';
    await tester.enterText(input, text);
    await tester.pump();
    expect(
      tester
          .widget<ListView>(
            find.byKey(const ValueKey('inventory-ingredient-chips')),
          )
          .semanticChildCount,
      3,
    );
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    expect(
      tester
          .widget<ListView>(
            find.byKey(const ValueKey('inventory-ingredient-chips')),
          )
          .semanticChildCount,
      3,
    );
    final controller = tester.widget<TextFormField>(input).controller!;
    expect(controller.text, text);
    final firstChip = tester.widget<InputChip>(find.byType(InputChip).first);
    firstChip.onDeleted!();
    await tester.pump();
    expect(controller.text, ' Teicoplanin\nEtanidazole');
    expect(find.byType(InputChip), findsNWidgets(2));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump();
    expect(repository.checks.last, ' Teicoplanin\nEtanidazole');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'mobile composition keeps three separate deletable ingredients from the reported example',
    (tester) async {
      final repository = FakeInventorySubstanceRepository();
      String? changed;
      await openEditor(
        tester,
        repository,
        reflectChanges: true,
        onChanged: (text) => changed = text,
      );
      final input = find.byKey(const ValueKey('inventory-ingredients-text'));
      await tester.tap(input);
      const raw = 'cồn , Auramine , rượu';
      final editing = TextEditingValue(
        text: raw,
        selection: TextSelection.collapsed(offset: raw.length),
        composing: TextRange(start: raw.lastIndexOf('rượu'), end: raw.length),
      );
      tester.testTextInput.updateEditingValue(editing);
      await tester.pump();
      final controller = tester.widget<TextFormField>(input).controller!;
      expect(controller.value, editing);
      final chips = find.byKey(const ValueKey('inventory-ingredient-chips'));
      expect(tester.widget<ListView>(chips).semanticChildCount, 3);
      for (final name in ['cồn', 'Auramine', 'rượu']) {
        expect(find.byTooltip('Xóa $name'), findsOneWidget);
      }
      await tester.tap(find.byTooltip('Xóa Auramine'));
      await tester.pump();
      expect(controller.text, 'cồn , rượu');
      expect(changed, 'cồn , rượu');
      expect(tester.widget<ListView>(chips).semanticChildCount, 2);
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      expect(repository.checks.last, 'cồn , rượu');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'special chemical names retain their full text when viewing or deleting another ingredient',
    (tester) async {
      final repository = FakeInventorySubstanceRepository();
      const name = 'N,N-dimethylammonium chloride: 1,0 g';
      const raw = '$name, Auramine';
      await openEditor(tester, repository, value: raw);
      final input = find.byKey(const ValueKey('inventory-ingredients-text'));
      expect(
        tester
            .widget<ListView>(
              find.byKey(const ValueKey('inventory-ingredient-chips')),
            )
            .semanticChildCount,
        2,
      );
      await tester.tap(find.byType(InputChip).first);
      await tester.pumpAndSettle();
      expect(find.byType(SelectableText), findsOneWidget);
      expect(
        tester.widget<SelectableText>(find.byType(SelectableText)).data,
        name,
      );
      await tester.tap(find.text('Đóng'));
      await tester.pumpAndSettle();
      await tester.drag(
        find.byKey(const ValueKey('inventory-ingredient-chips')),
        const Offset(-300, 0),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Xóa Auramine'));
      await tester.pump();
      expect(tester.widget<TextFormField>(input).controller!.text, '$name,');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'programmatic comma-separated ingredients are separate chips and warning names remain visible',
    (tester) async {
      const warning =
          'Phát hiện chất cấm: Furaltadone, Teicoplanin, Etanidazole trong sản phẩm.';
      final repository = FakeInventorySubstanceRepository()
        ..onCheck = (_) async =>
            const InventorySubstanceCheck(status: 'blocked', message: warning);
      await openEditor(
        tester,
        repository,
        value: 'Furaltadone, Teicoplanin\nEtanidazole',
      );
      final chips = find.byKey(const ValueKey('inventory-ingredient-chips'));
      expect(tester.widget<ListView>(chips).semanticChildCount, 3);
      await tester.drag(chips, const Offset(-350, 0));
      await tester.pumpAndSettle();
      expect(find.text('Etanidazole'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      expect(find.text(warning), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'debounces search by 350ms and initially shows only five suggestions',
    (tester) async {
      final repository = FakeInventorySubstanceRepository();
      repository.onSearch = (_, _) async => InventorySubstancePage(
        items: List.generate(5, (i) => testSubstance('$i', 'Bacillus $i')),
        hasNextPage: true,
        nextCursor: '5',
      );
      await openEditor(tester, repository);
      final search = find.byKey(const ValueKey('inventory-ingredient-search'));
      await tester.tap(search);
      await tester.enterText(search, 'B');
      await tester.pump(const Duration(milliseconds: 200));
      await tester.enterText(search, 'Bac');
      await tester.pump(const Duration(milliseconds: 349));
      expect(repository.searches, isEmpty);
      await tester.pump(const Duration(milliseconds: 1));
      await tester.pump();
      expect(repository.searches, [(query: 'Bac', cursor: null)]);
      expect(find.byType(ListTile), findsNWidgets(5));
      expect(
        tester
            .getSize(
              find.byKey(const ValueKey('inventory-ingredient-suggestions')),
            )
            .height,
        lessThanOrEqualTo(302),
      );
    },
  );

  testWidgets(
    'scroll loads the next five without losing previously loaded entries',
    (tester) async {
      final repository = FakeInventorySubstanceRepository();
      repository.onSearch = (_, cursor) async => InventorySubstancePage(
        items: List.generate(
          5,
          (i) => testSubstance(
            '${i + (cursor == null ? 0 : 5)}',
            'Bacillus ${i + (cursor == null ? 0 : 5)}',
          ),
        ),
        hasNextPage: cursor == null,
        nextCursor: cursor == null ? '5' : null,
      );
      await openEditor(tester, repository);
      await tester.tap(
        find.byKey(const ValueKey('inventory-ingredient-search')),
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      await tester.drag(
        find.byKey(const ValueKey('inventory-ingredient-suggestions')),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      expect(repository.searches, [
        (query: '', cursor: null),
        (query: '', cursor: '5'),
      ]);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(InventoryIngredientEditor)),
      );
      expect(
        container
            .read(inventorySubstanceControllerProvider('farm-1'))
            .requireValue
            .items
            .length,
        10,
      );
    },
  );

  testWidgets(
    'selecting a suggestion appends a new ingredient and preserves label quantities',
    (tester) async {
      final repository = FakeInventorySubstanceRepository();
      repository.onSearch = (_, _) async => InventorySubstancePage(
        items: [testSubstance('bac', 'Bacillus subtilis')],
        hasNextPage: false,
      );
      String? changed;
      await openEditor(
        tester,
        repository,
        value: 'Vitamin C: 10 g/kg',
        onChanged: (value) => changed = value,
      );
      await tester.tap(
        find.byKey(const ValueKey('inventory-ingredient-search')),
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      await tester.tap(find.text('Bacillus subtilis'));
      await tester.pump();
      expect(changed, 'Vitamin C: 10 g/kg\nBacillus subtilis');
      final field = tester.widget<TextFormField>(
        find.byKey(const ValueKey('inventory-ingredients-text')),
      );
      expect(field.controller!.text, changed);
      expect(find.byType(InputChip), findsNWidgets(2));
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      expect(repository.checks.last, changed);
    },
  );

  testWidgets(
    'late search responses cannot replace results for a newer query',
    (tester) async {
      final repository = FakeInventorySubstanceRepository();
      final old = Completer<InventorySubstancePage>();
      repository.onSearch = (query, _) => query == 'Bac'
          ? old.future
          : Future.value(
              InventorySubstancePage(
                items: [testSubstance('vit', 'Vitamin C')],
                hasNextPage: false,
              ),
            );
      await openEditor(tester, repository);
      final search = find.byKey(const ValueKey('inventory-ingredient-search'));
      await tester.enterText(search, 'Bac');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.enterText(search, 'Vitamin');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      old.complete(
        InventorySubstancePage(
          items: [testSubstance('bac', 'Bacillus subtilis')],
          hasNextPage: false,
        ),
      );
      await tester.pump();
      expect(find.text('Vitamin C'), findsOneWidget);
      expect(find.text('Bacillus subtilis'), findsNothing);
    },
  );

  testWidgets(
    'a suggestion with a comma stays one deletable ingredient and is not added twice',
    (tester) async {
      final repository = FakeInventorySubstanceRepository()
        ..onSearch = (_, _) async => InventorySubstancePage(
          items: [testSubstance('formalin', 'Formalin, Formaldehyde')],
          hasNextPage: false,
        );
      String? changed;
      await openEditor(
        tester,
        repository,
        reflectChanges: true,
        onChanged: (text) => changed = text,
      );
      final search = find.byKey(const ValueKey('inventory-ingredient-search'));
      for (var attempt = 0; attempt < 2; attempt++) {
        await tester.tap(search);
        await tester.pump(const Duration(milliseconds: 350));
        await tester.pump();
        await tester.tap(find.text('Formalin, Formaldehyde'));
        await tester.pump();
        expect(changed, '"Formalin, Formaldehyde"');
        expect(
          tester
              .widget<ListView>(
                find.byKey(const ValueKey('inventory-ingredient-chips')),
              )
              .semanticChildCount,
          1,
        );
      }
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      expect(repository.checks.last, '"Formalin, Formaldehyde"');
    },
  );

  testWidgets(
    'checks manual changes, highlights banned ingredients and cancels pending work on disposal',
    (tester) async {
      final repository = FakeInventorySubstanceRepository();
      await openEditor(tester, repository);
      final text = find.byKey(const ValueKey('inventory-ingredients-text'));
      final check = find.byKey(const ValueKey('inventory-ingredient-check'));
      await tester.enterText(text, 'Vitamin C');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      expect(check, findsNothing);
      expect(find.textContaining('Chưa phát hiện'), findsNothing);
      await tester.enterText(text, 'Vitamin C\nChloramphenicol 1%');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      expect(find.textContaining('Phát hiện chất cấm:'), findsOneWidget);
      await tester.enterText(text, 'Vitamin C');
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump();
      expect(check, findsNothing);
      expect(find.textContaining('Chưa phát hiện'), findsNothing);
      await tester.enterText(text, 'Vitamin D');
      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 1));
      expect(repository.checks, [
        'Vitamin C',
        'Vitamin C\nChloramphenicol 1%',
        'Vitamin C',
      ]);
      expect(tester.takeException(), isNull);
    },
  );
}

class _OwnerAuth implements AuthRepository {
  @override
  Future<AuthAccount?> restoreSession() async => const AuthAccount(
    id: 'owner-1',
    email: 'owner@test.local',
    role: AccountRole.farmOwner,
    status: AccountStatus.active,
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
