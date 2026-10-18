import 'dart:io';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_image_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_product_image.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/supplier_repository.dart';
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_suppliers_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_supplier_form_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/supplier_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart'
    as domain;
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_adjustment_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_detail_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_history_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_product_form_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_stock_in_page.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_stock_out_lot_picker.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import '../../support/farm_context_repository.dart';

void main() {
  Widget buildTestableWidget(Widget child, {_SupplierRepository? suppliers}) =>
      ProviderScope(
        overrides: [
          farmRepositoryProvider.overrideWithValue(FarmContextRepository()),
          authRepositoryProvider.overrideWithValue(
            const _OwnerAuthRepository(),
          ),
          supplierRepositoryProvider.overrideWithValue(
            suppliers ?? _SupplierRepository(),
          ),
          inventoryRepositoryProvider.overrideWithValue(
            _InventoryRepository(product: _product(), history: _history()),
          ),
        ],
        child: RepaintBoundary(
          child: MaterialApp(theme: AppTheme.light, home: child),
        ),
      );

  void configureMobileViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> openForm(
    WidgetTester tester,
    Widget child,
    _InventoryRepository repository, {
    _SupplierRepository? suppliers,
    ImagePicker? picker,
    InventoryImageStorage? storage,
  }) async {
    configureMobileViewport(tester);
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => context.push('/form'),
                child: const Text('Open inventory form'),
              ),
            ),
          ),
        ),
        GoRoute(path: '/form', builder: (_, _) => child),
        GoRoute(
          path: '/farms/:farmId/inventory/:productId/edit',
          builder: (_, state) => InventoryProductFormPage.edit(
            farmId: state.pathParameters['farmId']!,
            productId: state.pathParameters['productId']!,
            photoReplacement: state.extra as InventoryPhotoReplacement?,
          ),
        ),
        GoRoute(
          path: '/farms/:farmId/inventory/:productId/stock-out/:balanceId',
          builder: (_, state) => InventoryAdjustmentPage(
            farmId: state.pathParameters['farmId']!,
            productId: state.pathParameters['productId']!,
            balanceId: state.pathParameters['balanceId']!,
            isStockOut: true,
          ),
        ),
        GoRoute(
          path: '/farms/:farmId/inventory/suppliers/new',
          builder: (_, state) => InventorySupplierFormPage(
            farmId: state.pathParameters['farmId']!,
          ),
        ),
        GoRoute(
          path: '/farms/:farmId/inventory/suppliers/:supplierId/edit',
          builder: (_, state) => InventorySupplierFormPage(
            farmId: state.pathParameters['farmId']!,
            supplierId: state.pathParameters['supplierId']!,
            initialSupplier: state.extra as InventorySupplier?,
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            const _OwnerAuthRepository(),
          ),
          inventoryRepositoryProvider.overrideWithValue(repository),
          if (storage != null)
            inventoryImageStorageProvider.overrideWithValue(storage),
          if (picker != null)
            inventoryImagePickerProvider.overrideWithValue(picker),
          supplierRepositoryProvider.overrideWithValue(
            suppliers ?? _SupplierRepository(),
          ),
        ],
        child: RepaintBoundary(
          child: MaterialApp.router(
            theme: AppTheme.light,
            routerConfig: router,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open inventory form'));
    await tester.pumpAndSettle();
  }

  Future<void> enterField(
    WidgetTester tester,
    String label,
    String value,
  ) async {
    final field = find.descendant(
      of: find.byWidgetPredicate(
        (widget) => widget is InventoryField && widget.label.startsWith(label),
      ),
      matching: find.byType(TextFormField),
    );
    await tester.ensureVisible(field);
    await tester.enterText(field, value);
    await tester.pump();
  }

  Future<void> submitForm(WidgetTester tester, String label) async {
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text(label),
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  Future<void> capture(
    WidgetTester tester,
    String name, {
    bool waitForFonts = true,
  }) async {
    if (!const bool.fromEnvironment('INVENTORY_SCREENSHOTS')) return;
    await tester.runAsync(() async {
      if (waitForFonts) await GoogleFonts.pendingFonts();
      final icons = FontLoader('MaterialIcons')
        ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
      await icons.load();
      final fallback = FontLoader('Sora')
        ..addFont(
          rootBundle.load('assets/fonts/google_fonts/PlusJakartaSans-Bold.ttf'),
        );
      await fallback.load();
    });
    await tester.pumpAndSettle();
    final boundary = tester.firstRenderObject<RenderRepaintBoundary>(
      find.byType(RepaintBoundary),
    );
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final directory = Directory('../.tmp/inventory-ui');
      await directory.create(recursive: true);
      await File(
        '${directory.path}/$name.png',
      ).writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
  }

  testWidgets('photo gallery selects thumbnails and keeps FIFO lots visible', (
    tester,
  ) async {
    configureMobileViewport(tester);
    final product = _product().copyWith(
      name: 'Thức ăn CP 9004 (40% đạm)',
      currentStock: 580,
      minAlertQuantity: 200,
      inventoryValue: 20600000,
      isLowStock: false,
      description: 'Thức ăn tôm giai đoạn lớn (cỡ 2–3).',
      imageUrls: [
        'https://example.com/front.png',
        'https://example.com/back.png',
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            const _OwnerAuthRepository(),
          ),
          inventoryRepositoryProvider.overrideWithValue(
            _InventoryRepository(product: product, history: _history()),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          home: const RepaintBoundary(
            child: InventoryDetailPage(
              farmId: 'farm-1',
              productId: 'product-1',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1/2'), findsOneWidget);
    await capture(tester, 'detail');
    await tester.tap(find.bySemanticsLabel('Xem ảnh vật tư 2'));
    await tester.pumpAndSettle();
    expect(find.text('2/2'), findsOneWidget);
    expect(find.text('● Xuất trước'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'selecting an existing photo waits for the change button and replaces only that side',
    (tester) async {
      final photos = [
        'https://example.com/front.png',
        'https://example.com/back.png',
      ];
      final repository = _InventoryRepository(
        product: _product().copyWith(imageUrls: photos),
        history: _history(),
      );
      final picker = _FileImagePicker();
      final storage = _ImageStorage();
      await openForm(
        tester,
        const InventoryProductFormPage.edit(
          farmId: 'farm-1',
          productId: 'product-1',
        ),
        repository,
        picker: picker,
        storage: storage,
      );
      await tester.ensureVisible(
        find.byKey(const ValueKey('inventory-photo-1')),
      );
      await tester.tap(find.byKey(const ValueKey('inventory-photo-1')));
      await tester.pumpAndSettle();
      expect(picker.calls, 0);
      expect(find.text('Đã chọn: Mặt sau'), findsOneWidget);
      await capture(tester, 'replace-photo-selected');
      await tester.ensureVisible(find.text('Đổi ảnh'));
      await tester.tap(find.text('Đổi ảnh'));
      await tester.pumpAndSettle();
      expect(picker.lastSource, ImageSource.gallery);
      expect(repository.updateCalls, 0);
      await submitForm(tester, 'Lưu thay đổi');
      expect(repository.updatedImageUrls, [
        photos.first,
        'https://example.com/upload-1.png',
      ]);
      expect(storage.calls, 1);
    },
  );

  testWidgets(
    'gallery change opens the file picker and passes the selected side into the edit preview',
    (tester) async {
      final photos = [
        'https://example.com/front.png',
        'https://example.com/back.png',
      ];
      final repository = _InventoryRepository(
        product: _product().copyWith(imageUrls: photos),
        history: _history(),
      );
      final picker = _FileImagePicker();
      final storage = _ImageStorage();
      await openForm(
        tester,
        const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
        repository,
        picker: picker,
        storage: storage,
      );
      await tester.ensureVisible(find.bySemanticsLabel('Xem ảnh vật tư 2'));
      await tester.tap(find.bySemanticsLabel('Xem ảnh vật tư 2'));
      await tester.pumpAndSettle();
      expect(picker.calls, 0);
      await tester.ensureVisible(find.text('Đổi ảnh'));
      await tester.tap(find.text('Đổi ảnh'));
      await tester.pumpAndSettle();
      expect(picker.calls, 1);
      expect(find.text('Chỉnh sửa vật tư'), findsOneWidget);
      expect(find.text('Đã chọn: Mặt sau'), findsOneWidget);
      expect(repository.updateCalls, 0);
      await submitForm(tester, 'Lưu thay đổi');
      expect(repository.updatedImageUrls, [
        photos.first,
        'https://example.com/upload-1.png',
      ]);
      expect(storage.calls, 1);
      expect(find.text('2/2'), findsOneWidget);
      final displayed = tester.widget<InventoryProductImage>(
        find.byWidgetPredicate(
          (widget) => widget is InventoryProductImage && widget.height == 176,
        ),
      );
      expect(displayed.url, 'https://example.com/upload-1.png');
    },
  );

  testWidgets('cancelling the change picker preserves the existing gallery', (
    tester,
  ) async {
    final repository = _InventoryRepository(
      product: _product().copyWith(
        imageUrls: [
          'https://example.com/front.png',
          'https://example.com/back.png',
        ],
      ),
      history: _history(),
    );
    final picker = _FileImagePicker(cancelSingle: true);
    await openForm(
      tester,
      const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
      repository,
      picker: picker,
    );
    await tester.ensureVisible(find.text('Đổi ảnh'));
    await tester.tap(find.text('Đổi ảnh'));
    await tester.pumpAndSettle();
    expect(find.text('Chỉnh sửa vật tư'), findsNothing);
    expect(find.text('1/2'), findsOneWidget);
    expect(repository.updateCalls, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'lot detail shows actual usage and remaining value without an adjustment button',
    (tester) async {
      final product = _product();
      final repository = _InventoryRepository(
        product: product.copyWith(
          lots: [
            product.lots.first.copyWith(
              receivedQuantity: 100,
              quantity: 51,
              inventoryValue: 1785000,
            ),
          ],
        ),
        history: _history(),
      );
      await openForm(
        tester,
        const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
        repository,
      );
      await tester.scrollUntilVisible(
        find.text('Đã sử dụng 49%'),
        250,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text('Điều chỉnh'), findsNothing);
      final progress = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progress.value, 0.49);
      expect(find.textContaining('Giá trị còn'), findsOneWidget);
      await capture(tester, 'usage-progress');
    },
  );

  testWidgets(
    'edit removes one photo and preserves the remaining photo on save',
    (tester) async {
      final photos = [
        'https://example.com/front.png',
        'https://example.com/back.png',
      ];
      final repository = _InventoryRepository(
        product: _product().copyWith(imageUrls: photos),
        history: _history(),
      );
      await openForm(
        tester,
        const RepaintBoundary(
          child: InventoryProductFormPage.edit(
            farmId: 'farm-1',
            productId: 'product-1',
          ),
        ),
        repository,
      );
      await capture(tester, 'edit');
      await tester.ensureVisible(find.byTooltip('Gỡ ảnh 2'));
      await tester.tap(find.byTooltip('Gỡ ảnh 2'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Gỡ ảnh 2'), findsNothing);
      await submitForm(tester, 'Lưu thay đổi');
      expect(repository.updatedImageUrls, [photos.first]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('add photos opens the multi-file picker without a camera menu', (
    tester,
  ) async {
    final picker = _FileImagePicker();
    await openForm(
      tester,
      const InventoryProductFormPage.create(farmId: 'farm-1'),
      _InventoryRepository(product: _product(), history: _history()),
      picker: picker,
    );
    await tester.ensureVisible(find.text('Chọn nhiều ảnh'));
    await tester.tap(find.text('Chọn nhiều ảnh'));
    await tester.pumpAndSettle();
    expect(picker.calls, 1);
    expect(find.byTooltip('Gỡ ảnh 1'), findsOneWidget);
    expect(find.byTooltip('Gỡ ảnh 2'), findsOneWidget);
    expect(find.text('Chụp ảnh'), findsNothing);
    expect(find.text('Đã đủ 2 ảnh'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('rejects selecting a third photo before adding any files', (
    tester,
  ) async {
    final picker = _FileImagePicker(fileCount: 3);
    await openForm(
      tester,
      const InventoryProductFormPage.create(farmId: 'farm-1'),
      _InventoryRepository(product: _product(), history: _history()),
      picker: picker,
    );
    await tester.ensureVisible(find.text('Chọn nhiều ảnh'));
    await tester.tap(find.text('Chọn nhiều ảnh'));
    await tester.pumpAndSettle();
    expect(
      find.text('Mỗi vật tư có tối đa 2 ảnh: mặt trước và mặt sau.'),
      findsOneWidget,
    );
    expect(find.byTooltip('Gỡ ảnh 1'), findsNothing);
    expect(find.byTooltip('Gỡ ảnh 2'), findsNothing);
  });

  testWidgets(
    'removing the front keeps the back in its own slot until the front is replaced',
    (tester) async {
      final repository = _InventoryRepository(
        product: _product().copyWith(
          imageUrls: [
            'https://example.com/front.png',
            'https://example.com/back.png',
          ],
        ),
        history: _history(),
      );
      final picker = _FileImagePicker();
      final storage = _ImageStorage();
      await openForm(
        tester,
        const InventoryProductFormPage.edit(
          farmId: 'farm-1',
          productId: 'product-1',
        ),
        repository,
        picker: picker,
        storage: storage,
      );
      await tester.ensureVisible(find.byTooltip('Gỡ ảnh 1'));
      await tester.tap(find.byTooltip('Gỡ ảnh 1'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Gỡ ảnh 2'), findsOneWidget);
      await submitForm(tester, 'Lưu thay đổi');
      expect(repository.updateCalls, 0);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const ValueKey('inventory-photo-0')),
      );
      await tester.tap(find.byKey(const ValueKey('inventory-photo-0')));
      await tester.pumpAndSettle();
      expect(picker.lastSource, ImageSource.gallery);
      await submitForm(tester, 'Lưu thay đổi');
      expect(repository.updatedImageUrls, [
        'https://example.com/upload-1.png',
        'https://example.com/back.png',
      ]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'retry keeps uploaded URLs and saves all photos without uploading twice',
    (tester) async {
      final repository = _InventoryRepository(
        product: _product(),
        history: _history(),
      )..failUpdateOnce = true;
      final storage = _ImageStorage();
      await openForm(
        tester,
        const InventoryProductFormPage.edit(
          farmId: 'farm-1',
          productId: 'product-1',
        ),
        repository,
        picker: _FileImagePicker(),
        storage: storage,
      );
      await tester.ensureVisible(find.text('Chọn nhiều ảnh'));
      await tester.tap(find.text('Chọn nhiều ảnh'));
      await tester.pumpAndSettle();
      await submitForm(tester, 'Lưu thay đổi');
      expect(repository.updateCalls, 1);
      expect(storage.calls, 2);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      await submitForm(tester, 'Lưu thay đổi');
      expect(repository.updateCalls, 2);
      expect(storage.calls, 2);
      expect(repository.updatedImageUrls, [
        'https://example.com/upload-1.png',
        'https://example.com/upload-2.png',
      ]);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'detail opens stock-out and prevents exporting more than the selected lot',
    (tester) async {
      final repository = _InventoryRepository(
        product: _product(),
        history: _history(),
      );
      await openForm(
        tester,
        const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
        repository,
      );
      expect(find.text('Nhập kho'), findsOneWidget);
      expect(find.text('Xuất kho'), findsOneWidget);
      await tester.tap(find.text('Xuất kho'));
      await tester.pumpAndSettle();
      expect(find.text('Tăng tồn'), findsNothing);
      await capture(tester, 'stock-out');
      await enterField(tester, 'Số lượng', '81');
      await submitForm(tester, 'Xác nhận xuất kho');
      expect(repository.stockOutPayload, isNull);
      expect(find.text('Không thể xuất quá số lượng đang tồn'), findsOneWidget);
      await enterField(tester, 'Số lượng', '80');
      await submitForm(tester, 'Xác nhận xuất kho');
      expect(repository.stockOutPayload!['quantity'], 80);
      expect(repository.stockOutPayload!['inventoryBalanceId'], 'lot-1');
      expect(repository.adjustmentCalls, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'stock-out lot picker preserves FIFO and exports the chosen lot',
    (tester) async {
      final base = _product();
      final earlier = base.lots.single;
      final later = earlier.copyWith(
        id: 'lot-2',
        lotNumber: 'LOT-002',
        receivedAt: DateTime.utc(2026, 10, 4),
        quantity: 20,
        supplierName: 'Cửa hàng An Phú',
      );
      final empty = earlier.copyWith(id: 'empty-lot', quantity: 0);
      final repository = _InventoryRepository(
        product: base.copyWith(
          lots: [later, empty, earlier],
          currentStock: 100,
          activeLotCount: 2,
        ),
        history: _history(),
      );
      await openForm(
        tester,
        const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
        repository,
      );
      await tester.tap(find.text('Xuất kho'));
      await tester.pumpAndSettle();
      final picker = find.byType(InventoryStockOutLotPicker);
      expect(picker, findsOneWidget);
      final first = find.byKey(const ValueKey('stock-out-lot-lot-1'));
      final second = find.byKey(const ValueKey('stock-out-lot-lot-2'));
      expect(
        find.byKey(const ValueKey('stock-out-lot-empty-lot')),
        findsNothing,
      );
      expect(
        tester.getTopLeft(first).dy,
        lessThan(tester.getTopLeft(second).dy),
      );
      expect(
        find.descendant(
          of: first,
          matching: find.byKey(const ValueKey('stock-out-first-lot')),
        ),
        findsOneWidget,
      );
      await capture(tester, 'stock-out-lot-picker', waitForFonts: false);
      await tester.tap(second);
      await tester.pumpAndSettle();
      expect(picker, findsNothing);
      await enterField(tester, 'Số lượng', '5');
      await submitForm(tester, 'Xác nhận xuất kho');
      expect(repository.stockOutPayload?['inventoryBalanceId'], 'lot-2');
      expect(repository.stockOutPayload?['quantity'], 5);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('stock-out lot picker scrolls many lots and cancels on mobile', (
    tester,
  ) async {
    final base = _product();
    final lots = List.generate(
      14,
      (index) => base.lots.single.copyWith(
        id: 'lot-$index',
        lotNumber: 'DEMO-EXPERT-20261009-LO-HANG-CO-MA-DAI-$index',
        receivedAt: DateTime.utc(2026, 9, index + 1),
      ),
    );
    final repository = _InventoryRepository(
      product: base.copyWith(lots: lots.reversed.toList()),
      history: _history(),
    );
    await openForm(
      tester,
      const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
      repository,
    );
    tester.view.physicalSize = const Size(320, 568);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Xuất kho'));
    await tester.pumpAndSettle();
    final picker = find.byType(InventoryStockOutLotPicker);
    final list = find.descendant(of: picker, matching: find.byType(Scrollable));
    final last = find.byKey(const ValueKey('stock-out-lot-lot-13'));
    await tester.scrollUntilVisible(last, 250, scrollable: list);
    await tester.tap(find.byTooltip('Đóng chọn lô'));
    await tester.pumpAndSettle();
    expect(picker, findsNothing);
    expect(repository.stockOutPayload, isNull);
    expect(find.text('Xuất kho'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'delete button stays visible while remaining stock blocks confirmation',
    (tester) async {
      final repository = _InventoryRepository(
        product: _product().copyWith(canArchive: true),
        history: _history(),
      );
      await openForm(
        tester,
        const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
        repository,
      );
      final deleteButton = find.widgetWithText(OutlinedButton, 'Xóa vật tư');
      await tester.scrollUntilVisible(
        deleteButton,
        250,
        scrollable: find.byType(Scrollable).last,
      );
      await capture(tester, 'detail-actions');
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      expect(find.text('Chưa thể xóa vật tư'), findsOneWidget);
      expect(find.text('Kho vẫn còn 80 kg'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Xóa vật tư'), findsNothing);
      await capture(tester, 'cannot-delete-stock');
      expect(repository.deleteCalls, 0);
      await tester.tap(find.text('Đã hiểu'));
      await tester.pumpAndSettle();
      expect(find.text('Chưa thể xóa vật tư'), findsNothing);
    },
  );

  testWidgets('planned use also blocks deletion with an acknowledgement', (
    tester,
  ) async {
    final repository = _InventoryRepository(
      product: _product().copyWith(
        currentStock: 0,
        plannedUseCount: 2,
        canArchive: false,
      ),
      history: _history(),
    );
    await openForm(
      tester,
      const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
      repository,
    );
    final deleteButton = find.widgetWithText(OutlinedButton, 'Xóa vật tư');
    await tester.scrollUntilVisible(
      deleteButton,
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    expect(find.text('Chưa thể xóa vật tư'), findsOneWidget);
    expect(find.textContaining('2 lịch vận hành dự kiến'), findsOneWidget);
    expect(repository.deleteCalls, 0);
    await tester.tap(find.text('Đã hiểu'));
    await tester.pumpAndSettle();
  });

  testWidgets(
    'deleting an empty material requires confirmation and returns to the list',
    (tester) async {
      final repository = _InventoryRepository(
        product: _product().copyWith(
          currentStock: 0,
          inventoryValue: 0,
          lots: [],
          canArchive: true,
          plannedUseCount: 0,
        ),
        history: _history(),
      );
      await openForm(
        tester,
        const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
        repository,
      );
      final deleteButton = find.widgetWithText(OutlinedButton, 'Xóa vật tư');
      await tester.scrollUntilVisible(
        deleteButton,
        250,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      expect(repository.deleteCalls, 0);
      await tester.tap(find.widgetWithText(FilledButton, 'Xóa vật tư'));
      await tester.pumpAndSettle();
      expect(repository.deleteCalls, 1);
      expect(find.text('Open inventory form'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'supplier directory displays details and confirms soft deletion',
    (tester) async {
      configureMobileViewport(tester);
      final suppliers = _SupplierRepository();
      await tester.pumpWidget(
        buildTestableWidget(
          const InventorySuppliersPage(farmId: 'farm-1'),
          suppliers: suppliers,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nhà cung cấp B'));
      await tester.pumpAndSettle();
      expect(find.text('Cửa hàng phân phối'), findsOneWidget);
      expect(find.text('Anh Bình'), findsWidgets);
      expect(find.text('Cần Thơ'), findsWidgets);
      expect(suppliers.listCalls, 1);
      expect(suppliers.detailCalls, 0);
      await tester.tap(find.text('Xóa'));
      await tester.pumpAndSettle();
      expect(suppliers.deleted, 0);
      await tester.tap(find.text('Xóa nhà cung cấp'));
      await tester.pumpAndSettle();
      expect(suppliers.deleted, 1);
      expect(suppliers.listCalls, 1);
      expect(suppliers.detailCalls, 0);
      expect(find.text('Chưa có nhà cung cấp.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'supplier search and repeated popups reuse the loaded directory',
    (tester) async {
      configureMobileViewport(tester);
      final suppliers = _SupplierRepository();
      await tester.pumpWidget(
        buildTestableWidget(
          const InventorySuppliersPage(farmId: 'farm-1'),
          suppliers: suppliers,
        ),
      );
      await tester.pumpAndSettle();
      await capture(tester, 'supplier-directory', waitForFonts: false);
      expect(suppliers.listCalls, 1);
      await tester.enterText(find.byType(TextField), 'không tồn tại');
      await tester.pumpAndSettle();
      expect(find.text('Không tìm thấy nhà cung cấp phù hợp.'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Cần Thơ');
      await tester.pumpAndSettle();
      expect(find.text('Nhà cung cấp B'), findsOneWidget);
      for (var i = 0; i < 2; i++) {
        await tester.tap(
          find.byKey(const ValueKey('supplier-card-supplier-1')),
        );
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('sales@example.com'), findsOneWidget);
        if (i == 0) {
          await capture(tester, 'supplier-details-popup', waitForFonts: false);
        }
        await tester.tap(find.text('Đóng'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
      }
      expect(suppliers.listCalls, 1);
      expect(suppliers.detailCalls, 0);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('editing from a supplier popup reuses and updates cached data', (
    tester,
  ) async {
    final suppliers = _SupplierRepository();
    await openForm(
      tester,
      const InventorySuppliersPage(farmId: 'farm-1'),
      _InventoryRepository(product: _product(), history: _history()),
      suppliers: suppliers,
    );
    await tester.tap(find.text('Nhà cung cấp B'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Chỉnh sửa'));
    await tester.pumpAndSettle();
    expect(find.text('Anh Bình'), findsOneWidget);
    expect(suppliers.listCalls, 1);
    expect(suppliers.detailCalls, 0);
    await enterField(tester, 'Tên nhà cung cấp', 'Cửa hàng An Phú');
    await submitForm(tester, 'Lưu nhà cung cấp');
    expect(find.text('Cửa hàng An Phú'), findsOneWidget);
    expect(suppliers.saved?.id, 'supplier-1');
    await tester.tap(find.text('Cửa hàng An Phú'));
    await tester.pumpAndSettle();
    expect(find.text('Cửa hàng phân phối'), findsOneWidget);
    expect(suppliers.listCalls, 1);
    expect(suppliers.detailCalls, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supplier popup fits small screens and missing optional fields', (
    tester,
  ) async {
    configureMobileViewport(tester);
    tester.view.physicalSize = const Size(320, 568);
    final suppliers = _SupplierRepository();
    suppliers.items = [
      suppliers.items.single.copyWith(
        name: 'Cửa hàng Thiết bị và Vật tư Thủy sản Phú Thịnh',
        contactName: null,
        phone: null,
        email: null,
        address: null,
        note: null,
      ),
    ];
    await tester.pumpWidget(
      buildTestableWidget(
        const InventorySuppliersPage(farmId: 'farm-1'),
        suppliers: suppliers,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('supplier-card-supplier-1')));
    await tester.pumpAndSettle();
    expect(find.text('Chưa cập nhật'), findsNWidgets(5));
    await tester.tap(find.text('Đóng'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(suppliers.detailCalls, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('supplier popup scrolls long notes without hiding its actions', (
    tester,
  ) async {
    configureMobileViewport(tester);
    tester.view.physicalSize = const Size(320, 568);
    final suppliers = _SupplierRepository();
    suppliers.items = [
      suppliers.items.single.copyWith(
        name: 'Cửa hàng Chế phẩm Sinh học Minh Tâm',
        note: List.filled(
          40,
          'Giao hàng theo lịch, kiểm tra hạn sử dụng.',
        ).join(' '),
      ),
    ];
    await tester.pumpWidget(
      buildTestableWidget(
        const InventorySuppliersPage(farmId: 'farm-1'),
        suppliers: suppliers,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('supplier-card-supplier-1')));
    await tester.pumpAndSettle();
    expect(find.text('Đóng').hitTestable(), findsOneWidget);
    expect(find.text('Chỉnh sửa').hitTestable(), findsOneWidget);
    final dialogScroll = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.byType(SingleChildScrollView),
    );
    await tester.drag(dialogScroll, const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(find.text('Đóng').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Đóng'));
    await tester.pumpAndSettle();
    expect(suppliers.listCalls, 1);
    expect(suppliers.detailCalls, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'supplier conflict reload explicitly bypasses the cached record',
    (tester) async {
      final suppliers = _SupplierRepository();
      await openForm(
        tester,
        const InventorySuppliersPage(farmId: 'farm-1'),
        _InventoryRepository(product: _product(), history: _history()),
        suppliers: suppliers,
      );
      await tester.tap(find.text('Nhà cung cấp B'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chỉnh sửa'));
      await tester.pumpAndSettle();
      final latest = suppliers.items.single.copyWith(
        contactName: 'Người liên hệ mới',
        updatedAt: DateTime.utc(2026, 10, 15),
      );
      suppliers.items = [latest];
      suppliers.failNextSaveWithConflict = true;
      await submitForm(tester, 'Lưu nhà cung cấp');
      expect(suppliers.detailCalls, 0);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tải lại dữ liệu mới nhất'));
      await tester.pumpAndSettle();
      expect(find.text('Người liên hệ mới'), findsOneWidget);
      expect(suppliers.detailCalls, 1);
      await submitForm(tester, 'Lưu nhà cung cấp');
      expect(suppliers.lastExisting?.updatedAt, latest.updatedAt);
      expect(suppliers.saved?.contactName, 'Người liên hệ mới');
      expect(suppliers.listCalls, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'supplier form validates contact fields then saves basic information',
    (tester) async {
      final suppliers = _SupplierRepository();
      await openForm(
        tester,
        const InventorySupplierFormPage(farmId: 'farm-1'),
        _InventoryRepository(product: _product(), history: _history()),
        suppliers: suppliers,
      );
      await enterField(tester, 'Tên nhà cung cấp', 'Đại lý mới');
      await enterField(tester, 'Điện thoại', 'invalid');
      await submitForm(tester, 'Lưu nhà cung cấp');
      expect(suppliers.saved, isNull);
      await enterField(tester, 'Điện thoại', '0909876543');
      await enterField(tester, 'Email', 'sales@example.com');
      await enterField(tester, 'Địa chỉ', 'Sóc Trăng');
      await submitForm(tester, 'Lưu nhà cung cấp');
      expect(suppliers.saved?.name, 'Đại lý mới');
      expect(suppliers.saved?.phone, '0909876543');
      expect(suppliers.saved?.address, 'Sóc Trăng');
      expect(find.text('Open inventory form'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'supplier edit loads persisted fields and updates the same record',
    (tester) async {
      final suppliers = _SupplierRepository();
      await openForm(
        tester,
        const InventorySupplierFormPage(
          farmId: 'farm-1',
          supplierId: 'supplier-1',
        ),
        _InventoryRepository(product: _product(), history: _history()),
        suppliers: suppliers,
      );
      expect(find.text('Anh Bình'), findsOneWidget);
      expect(suppliers.detailCalls, 1);
      await enterField(tester, 'Tên nhà cung cấp', 'Tên mới');
      await submitForm(tester, 'Lưu nhà cung cấp');
      expect(suppliers.saved?.id, 'supplier-1');
      expect(suppliers.saved?.name, 'Tên mới');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'quick supplier creation returns to stock-in with the new supplier selected',
    (tester) async {
      final suppliers = _SupplierRepository();
      final repository = _InventoryRepository(
        product: _product(),
        history: _history(),
      );
      await openForm(
        tester,
        const InventoryStockInPage(farmId: 'farm-1', productId: 'product-1'),
        repository,
        suppliers: suppliers,
      );
      final add = find.text('Thêm nhà cung cấp');
      await tester.ensureVisible(add);
      await tester.tap(add);
      await tester.pumpAndSettle();
      await enterField(tester, 'Tên nhà cung cấp', 'Đại lý mới');
      await submitForm(tester, 'Lưu nhà cung cấp');
      expect(find.text('Đại lý mới'), findsOneWidget);
      // Let the success notice dismiss before interacting with the receipt CTA.
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
      await enterField(tester, 'Mã lô', 'LOT-QUICK');
      await enterField(tester, 'Số lượng nhập', '10');
      await enterField(tester, 'Đơn giá', '1000');
      await submitForm(tester, 'Xác nhận nhập kho');
      expect(repository.stockInPayload?['supplierId'], 'created-supplier');
      expect(repository.stockInPayload?['supplierName'], 'Đại lý mới');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('removing an existing product photo saves null', (tester) async {
    final repository = _InventoryRepository(
      product: _product().copyWith(imageUrl: 'https://example.com/photo.jpg'),
      history: _history(),
    );
    await openForm(
      tester,
      const InventoryProductFormPage.edit(
        farmId: 'farm-1',
        productId: 'product-1',
      ),
      repository,
    );
    await tester.ensureVisible(find.byTooltip('Gỡ ảnh 1'));
    await tester.tap(find.byTooltip('Gỡ ảnh 1'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Gỡ ảnh 1'), findsNothing);
    await submitForm(tester, 'Lưu thay đổi');
    expect(repository.updateCalls, 1);
    expect(repository.updatedImageUrls, isEmpty);
    expect(tester.takeException(), isNull);
  });

  group('Inventory UI', () {
    testWidgets('all inventory screens fit a narrow mobile viewport', (
      tester,
    ) async {
      configureMobileViewport(tester);
      tester.view.physicalSize = const Size(360, 800);
      const pages = <Widget>[
        InventoryPage(farmId: 'farm-1'),
        InventorySuppliersPage(farmId: 'farm-1'),
        InventorySupplierFormPage(farmId: 'farm-1'),
        InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
        InventoryProductFormPage.create(farmId: 'farm-1'),
        InventoryStockInPage(farmId: 'farm-1', productId: 'product-1'),
        InventoryAdjustmentPage(
          farmId: 'farm-1',
          productId: 'product-1',
          balanceId: 'lot-1',
        ),
        InventoryHistoryPage(farmId: 'farm-1'),
      ];
      for (final page in pages) {
        await tester.pumpWidget(buildTestableWidget(page));
        await tester.pumpAndSettle();
        expect(find.byType(InventoryPageFrame), findsOneWidget);
        expect(tester.takeException(), isNull, reason: '${page.runtimeType}');
      }
    });

    for (final pointerKind in [
      ui.PointerDeviceKind.touch,
      ui.PointerDeviceKind.mouse,
    ]) {
      testWidgets('category filters scroll and select with $pointerKind', (
        tester,
      ) async {
        configureMobileViewport(tester);
        tester.view.physicalSize = const Size(320, 800);
        await tester.pumpWidget(
          buildTestableWidget(const InventoryPage(farmId: 'farm-1')),
        );
        await tester.pumpAndSettle();
        final filters = find.byKey(
          const ValueKey('inventory-category-filters'),
        );
        await tester.drag(filters, const Offset(-500, 0), kind: pointerKind);
        await tester.pumpAndSettle();
        expect(find.text('Khác').hitTestable(), findsOneWidget);
        await tester.tap(find.text('Khác'));
        await tester.pumpAndSettle();
        expect(find.text('Thức ăn CP 9004'), findsNothing);
        expect(find.text('0 sản phẩm'), findsOneWidget);

        await tester.drag(filters, const Offset(500, 0), kind: pointerKind);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Tất cả').hitTestable());
        await tester.pumpAndSettle();
        expect(find.text('Thức ăn CP 9004'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('category arrows reach both ends on a small screen', (
      tester,
    ) async {
      configureMobileViewport(tester);
      tester.view.physicalSize = const Size(320, 800);
      await tester.pumpWidget(
        buildTestableWidget(
          const RepaintBoundary(child: InventoryPage(farmId: 'farm-1')),
        ),
      );
      await tester.pumpAndSettle();
      final previous = find.byWidgetPredicate(
        (widget) => widget is IconButton && widget.tooltip == 'Danh mục trước',
      );
      final next = find.byWidgetPredicate(
        (widget) =>
            widget is IconButton && widget.tooltip == 'Danh mục tiếp theo',
      );
      expect(tester.widget<IconButton>(previous).onPressed, isNull);
      for (var i = 0; i < 5; i++) {
        if (tester.widget<IconButton>(next).onPressed == null) break;
        await tester.tap(next);
        await tester.pumpAndSettle();
      }
      expect(find.text('Khác').hitTestable(), findsOneWidget);
      expect(tester.widget<IconButton>(next).onPressed, isNull);
      await tester.tap(find.text('Khác'));
      await tester.pumpAndSettle();
      expect(find.text('0 sản phẩm'), findsOneWidget);
      for (var i = 0; i < 5; i++) {
        if (tester.widget<IconButton>(previous).onPressed == null) break;
        await tester.tap(previous);
        await tester.pumpAndSettle();
      }
      expect(find.text('Tất cả').hitTestable(), findsOneWidget);
      expect(tester.widget<IconButton>(previous).onPressed, isNull);
      await tester.tap(find.text('Tất cả'));
      await tester.pumpAndSettle();
      expect(find.text('Thức ăn CP 9004'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('list renders API-backed summary, filters and products', (
      tester,
    ) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        buildTestableWidget(const InventoryPage(farmId: 'farm-1')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Kho vật tư'), findsOneWidget);
      expect(find.text('VẬT TƯ'), findsOneWidget);
      expect(find.text('SẮP HẾT'), findsOneWidget);
      expect(find.text('GIÁ TRỊ TỒN'), findsOneWidget);
      expect(find.text('Thức ăn CP 9004'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(tester.getSize(find.byType(TextField)).height, 52);
      expect(
        tester.widget<TextField>(find.byType(TextField)).textAlignVertical,
        TextAlignVertical.center,
      );
      for (final label in <String>['Tất cả', 'Thức ăn']) {
        final chip = find.ancestor(
          of: find.text(label),
          matching: find.byType(AnimatedContainer),
        );
        final text = find.descendant(of: chip, matching: find.text(label));
        expect(
          tester.getCenter(text).dy,
          closeTo(tester.getCenter(chip).dy, 0.5),
        );
        expect(
          tester.getCenter(text).dx,
          closeTo(tester.getCenter(chip).dx, 0.5),
        );
      }
      for (final label in <String>['Đang dùng', 'Đã lưu trữ']) {
        final chip = find.ancestor(
          of: find.text(label),
          matching: find.byType(InventoryFilterChip),
        );
        expect(
          tester.getCenter(find.text(label)).dx,
          closeTo(tester.getCenter(chip).dx, 0.5),
        );
        expect(
          tester.getCenter(find.text(label)).dy,
          closeTo(tester.getCenter(chip).dy, 0.5),
        );
      }
      for (final label in <String>['Tất cả (1)', 'Sắp hết (1)']) {
        final segment = find.ancestor(
          of: find.text(label),
          matching: find.byType(InkWell),
        );
        expect(
          tester.getCenter(find.text(label)).dx,
          closeTo(tester.getCenter(segment).dx, 0.5),
        );
        expect(
          tester.getCenter(find.text(label)).dy,
          closeTo(tester.getCenter(segment).dy, 0.5),
        );
      }
      final stats = find.byWidgetPredicate(
        (widget) => widget is Container && widget.constraints?.maxHeight == 61,
      );
      expect(stats, findsNWidgets(3));
      expect(
        tester.getTopLeft(stats.at(0)).dy,
        tester.getTopLeft(stats.at(1)).dy,
      );
      expect(
        tester.getTopLeft(stats.at(1)).dy,
        tester.getTopLeft(stats.at(2)).dy,
      );
      expect(
        tester.getTopLeft(stats.at(0)).dx,
        lessThan(tester.getTopLeft(stats.at(1)).dx),
      );
      expect(
        tester.getTopLeft(stats.at(1)).dx,
        lessThan(tester.getTopLeft(stats.at(2)).dx),
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('search applies only after 350ms and clearing restores items', (
      tester,
    ) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        buildTestableWidget(const InventoryPage(farmId: 'farm-1')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'not-in-stock');
      await tester.pump(const Duration(milliseconds: 349));
      expect(find.text('Thức ăn CP 9004'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1));
      expect(find.text('Thức ăn CP 9004'), findsNothing);
      expect(find.text('Không tìm thấy vật tư'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '');
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('Thức ăn CP 9004'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('rapid typing cancels the previous pending search', (
      tester,
    ) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        buildTestableWidget(const InventoryPage(farmId: 'farm-1')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'not-in-stock');
      await tester.pump(const Duration(milliseconds: 200));
      await tester.enterText(find.byType(TextField), '  CP 9004  ');
      await tester.pump(const Duration(milliseconds: 150));
      expect(find.text('Thức ăn CP 9004'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Thức ăn CP 9004'), findsOneWidget);
      expect(find.text('Không tìm thấy vật tư'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('changing a filter does not apply a pending search early', (
      tester,
    ) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        buildTestableWidget(const InventoryPage(farmId: 'farm-1')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'not-in-stock');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(
        find.ancestor(
          of: find.text('Thức ăn'),
          matching: find.byType(AnimatedContainer),
        ),
      );
      await tester.pump();
      expect(find.text('Thức ăn CP 9004'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 250));
      expect(find.text('Thức ăn CP 9004'), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('leaving the page cancels a pending search timer', (
      tester,
    ) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        buildTestableWidget(const InventoryPage(farmId: 'farm-1')),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'pending search');
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpWidget(const SizedBox.shrink());
      expect(tester.takeException(), isNull);
    });

    testWidgets('detail renders product and active lot from repository', (
      tester,
    ) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        buildTestableWidget(
          const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Thức ăn CP 9004'), findsWidgets);
      expect(find.text('TỒN KHO HIỆN TẠI'), findsOneWidget);
      expect(find.text('Tồn kho theo lô'), findsOneWidget);
      expect(find.text('Lô LOT-001'), findsOneWidget);
      expect(find.text('80 kg'), findsWidgets);
      expect(find.text('Nhập kho', skipOffstage: false), findsOneWidget);
    });

    testWidgets('create form renders product business fields', (tester) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        buildTestableWidget(
          const InventoryProductFormPage.create(farmId: 'farm-1'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Thêm vật tư'), findsOneWidget);
      expect(find.text('Tên vật tư *'), findsOneWidget);
      expect(find.text('Danh mục *'), findsOneWidget);
      expect(find.text('Đơn vị *'), findsOneWidget);
      expect(find.text('Lưu vật tư', skipOffstage: false), findsOneWidget);
    });

    testWidgets('stock-in form requires lot and supplier metadata', (
      tester,
    ) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        buildTestableWidget(
          const InventoryStockInPage(farmId: 'farm-1', productId: 'product-1'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nhập kho'), findsOneWidget);
      expect(find.text('Mã lô *'), findsOneWidget);
      expect(find.text('Số lượng nhập *'), findsOneWidget);
      expect(find.text('Ngày nhập *'), findsOneWidget);
      expect(find.text('Nhà cung cấp *'), findsOneWidget);
    });

    testWidgets('adjustment form shows immutable ledger guidance', (
      tester,
    ) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        buildTestableWidget(
          const InventoryAdjustmentPage(
            farmId: 'farm-1',
            productId: 'product-1',
            balanceId: 'lot-1',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Điều chỉnh tồn kho'), findsOneWidget);
      expect(find.text('Tăng tồn'), findsOneWidget);
      expect(find.text('Giảm tồn'), findsOneWidget);
      expect(find.text('Lý do điều chỉnh *'), findsOneWidget);
      expect(
        find.text(
          'Mọi điều chỉnh đều được ghi vào lịch sử và không thể xóa.',
          skipOffstage: false,
        ),
        findsOneWidget,
      );
    });

    testWidgets('history renders transaction and backend summary', (
      tester,
    ) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        buildTestableWidget(const InventoryHistoryPage(farmId: 'farm-1')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Lịch sử kho'), findsOneWidget);
      expect(find.text('Giao dịch'), findsOneWidget);
      expect(find.text('Giá trị nhập'), findsOneWidget);
      expect(find.text('Thức ăn CP 9004'), findsOneWidget);
      expect(find.text('Nhập kho'), findsWidgets);
    });

    testWidgets(
      'alert unit follows bottle conversion and switching to unpackaged units',
      (tester) async {
        final repository = _InventoryRepository(
          product: _product(),
          history: _history(),
        );
        await openForm(
          tester,
          const InventoryProductFormPage.create(farmId: 'farm-1'),
          repository,
        );
        await enterField(tester, 'Tên vật tư', 'Chế phẩm 1500');
        await tester.ensureVisible(find.text('Thức ăn'));
        await tester.tap(find.text('Thức ăn'));
        await tester.ensureVisible(find.text('chai'));
        await tester.tap(find.text('chai'));
        await tester.pumpAndSettle();
        expect(
          find.text('Ngưỡng cảnh báo tồn kho tối thiểu (đơn vị quy đổi)'),
          findsOneWidget,
        );
        await enterField(tester, 'Quy đổi mỗi chai', '1500');
        final dropdown = find.byType(
          DropdownButtonFormField<domain.InventoryConversionUnit>,
        );
        await tester.ensureVisible(dropdown);
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text('ml').last);
        await tester.pumpAndSettle();
        expect(
          find.text('Ngưỡng cảnh báo tồn kho tối thiểu (ml)'),
          findsOneWidget,
        );
        await enterField(tester, 'Ngưỡng cảnh báo', '1000');
        await tester.ensureVisible(dropdown);
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text('g').last);
        await tester.pumpAndSettle();
        expect(
          find.text('Ngưỡng cảnh báo tồn kho tối thiểu (g)'),
          findsOneWidget,
        );
        await tester.ensureVisible(find.text('kg').first);
        await tester.tap(find.text('kg').first);
        await tester.pumpAndSettle();
        expect(
          find.text('Ngưỡng cảnh báo tồn kho tối thiểu (kg)'),
          findsOneWidget,
        );
        await tester.ensureVisible(find.text('chai'));
        await tester.tap(find.text('chai'));
        await tester.pumpAndSettle();
        await enterField(tester, 'Quy đổi mỗi chai', '1500');
        await tester.ensureVisible(dropdown);
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text('ml').last);
        await tester.pumpAndSettle();
        await submitForm(tester, 'Lưu vật tư');
        expect(repository.createdProduct?['minAlertQuantity'], 1000);
        expect(
          repository.createdProduct?['unit'],
          domain.InventoryProductUnit.bottle,
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('creates a product and returns to the previous route', (
      tester,
    ) async {
      final repository = _InventoryRepository(
        product: _product(),
        history: _history(),
      );
      await openForm(
        tester,
        const InventoryProductFormPage.create(farmId: 'farm-1'),
        repository,
      );
      await enterField(tester, 'Tên vật tư', 'Thức ăn mới');
      await tester.ensureVisible(find.text('Thức ăn'));
      await tester.tap(find.text('Thức ăn'));
      await tester.ensureVisible(find.text('kg'));
      await tester.tap(find.text('kg'));
      await enterField(tester, 'Ngưỡng cảnh báo', '100,5');
      await submitForm(tester, 'Lưu vật tư');

      expect(repository.createdProduct, <String, Object?>{
        'farmId': 'farm-1',
        'name': 'Thức ăn mới',
        'category': domain.InventoryProductCategory.feed,
        'unit': domain.InventoryProductUnit.kg,
        'minAlertQuantity': 100.5,
      });
      expect(find.text('Open inventory form'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'submits decimal stock-in quantity and price without data loss',
      (tester) async {
        final repository = _InventoryRepository(
          product: _product(),
          history: _history(),
        );
        await openForm(
          tester,
          const InventoryStockInPage(farmId: 'farm-1', productId: 'product-1'),
          repository,
        );
        await enterField(tester, 'Mã lô', 'LOT-002');
        await enterField(tester, 'Số lượng nhập', '12,5');
        await enterField(tester, 'Đơn giá', '35000,25');
        final supplierField = find.descendant(
          of: find.byWidgetPredicate(
            (w) => w is InventoryField && w.label == 'Nhà cung cấp *',
          ),
          matching: find.byType(TextFormField),
        );
        await tester.ensureVisible(supplierField);
        await tester.tap(supplierField);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Nhà cung cấp B'));
        await tester.pumpAndSettle();
        await submitForm(tester, 'Xác nhận nhập kho');

        expect(repository.stockInPayload, <String, Object?>{
          'farmId': 'farm-1',
          'productId': 'product-1',
          'lotNumber': 'LOT-002',
          'quantity': 12.5,
          'unitPrice': 35000.25,
          'supplierName': 'Nhà cung cấp B',
          'supplierId': 'supplier-1',
        });
        expect(find.text('Open inventory form'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'rejects an adjustment exceeding lot stock before calling API',
      (tester) async {
        final repository = _InventoryRepository(
          product: _product(),
          history: _history(),
        );
        await openForm(
          tester,
          const InventoryAdjustmentPage(
            farmId: 'farm-1',
            productId: 'product-1',
            balanceId: 'lot-1',
          ),
          repository,
        );
        await tester.tap(find.text('Giảm tồn'));
        await enterField(tester, 'Số lượng', '81');
        await enterField(tester, 'Lý do điều chỉnh', 'Kiểm kê thực tế');
        await submitForm(tester, 'Xác nhận điều chỉnh');

        expect(repository.adjustmentCalls, 0);
        expect(
          find.text('Không thể giảm quá số lượng đang tồn'),
          findsOneWidget,
        );
        expect(find.text('Điều chỉnh tồn kho'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  });
}

domain.InventoryProduct _product() {
  final lot = domain.InventoryLot(
    id: 'lot-1',
    productId: 'product-1',
    lotNumber: 'LOT-001',
    receivedAt: DateTime.utc(2026, 10, 1),
    quantity: 80,
    unitPrice: 35000,
    supplierName: 'Nhà cung cấp A',
    inventoryValue: 2800000,
    createdAt: DateTime.utc(2026, 10, 1),
    updatedAt: DateTime.utc(2026, 10, 1),
  );
  return domain.InventoryProduct(
    id: 'product-1',
    farmId: 'farm-1',
    name: 'Thức ăn CP 9004',
    category: domain.InventoryProductCategory.feed,
    unit: domain.InventoryProductUnit.kg,
    minAlertQuantity: 100,
    description: 'Thức ăn cho tôm.',
    isArchived: false,
    isDeleted: false,
    createdAt: DateTime.utc(2026, 10, 1),
    updatedAt: DateTime.utc(2026, 10, 1),
    currentStock: 80,
    inventoryValue: 2800000,
    activeLotCount: 1,
    isLowStock: true,
    lots: <domain.InventoryLot>[lot],
    plannedUseCount: 0,
    canArchive: false,
  );
}

domain.InventoryHistoryPage _history() {
  final product = _product();
  return domain.InventoryHistoryPage(
    items: <domain.InventoryTransaction>[
      domain.InventoryTransaction(
        id: 'transaction-1',
        transactionGroupId: 'group-1',
        productId: product.id,
        inventoryBalanceId: product.lots.single.id,
        transactionType: domain.InventoryTransactionType.stockIn,
        quantity: 80,
        unitSnapshot: domain.InventoryProductUnit.kg,
        totalAmount: 2800000,
        reason: 'Nhập hàng đầu vụ',
        performedBy: 'owner-1',
        createdAt: DateTime.utc(2026, 10, 1),
        product: const domain.InventoryTransactionProduct(
          id: 'product-1',
          name: 'Thức ăn CP 9004',
          category: domain.InventoryProductCategory.feed,
          unit: domain.InventoryProductUnit.kg,
          isDeleted: false,
        ),
        inventoryBalance: product.lots.single,
        performer: const domain.InventoryTransactionPerformer(
          id: 'owner-1',
          fullName: 'Chủ trại',
          email: 'owner@smartshrimp.vn',
        ),
      ),
    ],
    limit: 100,
    totalResults: 1,
    hasNextPage: false,
    summary: const domain.InventoryHistorySummary(
      totalInboundValue: 2800000,
      totalOutboundValue: 0,
    ),
  );
}

final class _OwnerAuthRepository implements AuthRepository {
  const _OwnerAuthRepository();

  static const account = AuthAccount(
    id: 'owner-1',
    email: 'owner@smartshrimp.vn',
    role: AccountRole.farmOwner,
    status: AccountStatus.active,
  );

  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => account;

  @override
  Future<void> logout() async {}

  @override
  Future<AuthAccount?> restoreSession() async => account;
}

class _ImageStorage implements InventoryImageStorage {
  int calls = 0;
  @override
  Future<String> upload({
    required Uint8List bytes,
    required String fileName,
  }) async {
    calls++;
    return 'https://example.com/upload-$calls.png';
  }
}

class _FileImagePicker extends ImagePicker {
  _FileImagePicker({this.fileCount = 2, this.cancelSingle = false});
  final int fileCount;
  final bool cancelSingle;
  ImageSource? lastSource;
  int calls = 0;
  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    lastSource = source;
    if (cancelSingle) {
      calls++;
      return null;
    }
    return (await pickMultiImage()).first;
  }

  @override
  Future<List<XFile>> pickMultiImage({
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    int? limit,
    bool requestFullMetadata = true,
  }) async {
    calls++;
    final bytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
    );
    return List.generate(
      fileCount,
      (index) => XFile.fromData(bytes, name: 'photo-$index.png'),
    );
  }
}

final class _InventoryRepository implements InventoryRepository {
  int deleteCalls = 0;
  Map<String, Object?>? stockOutPayload;
  @override
  Future<void> deleteProduct({
    required String farmId,
    required String productId,
  }) async {
    deleteCalls++;
  }

  @override
  Future<domain.InventoryStockResult> recordStockOut({
    required String farmId,
    required String productId,
    required String inventoryBalanceId,
    required double quantity,
    String? reason,
  }) async {
    stockOutPayload = {
      'productId': productId,
      'inventoryBalanceId': inventoryBalanceId,
      'quantity': quantity,
      'reason': reason,
    };
    return domain.InventoryStockResult(
      transactionId: 'stock-out-1',
      balance: product.lots.first,
      currentStock: product.currentStock - quantity,
      idempotentReplay: false,
    );
  }

  int updateCalls = 0;
  bool failUpdateOnce = false;
  String? updatedImageUrl;
  List<String>? updatedImageUrls;
  _InventoryRepository({required this.product, required this.history});

  domain.InventoryProduct product;
  final domain.InventoryHistoryPage history;
  Map<String, Object?>? createdProduct;
  Map<String, Object?>? stockInPayload;
  int adjustmentCalls = 0;

  @override
  Future<domain.InventoryProductPage> getProducts({
    required String farmId,
    int page = 1,
    int limit = 100,
    String? search,
    domain.InventoryProductCategory? category,
    bool lowStockOnly = false,
    domain.InventoryArchiveStatus archiveStatus =
        domain.InventoryArchiveStatus.active,
  }) async => domain.InventoryProductPage(
    items: <domain.InventoryProduct>[product],
    page: 1,
    limit: limit,
    totalResults: 1,
    totalPages: 1,
    hasNextPage: false,
    summary: const domain.InventorySummary(
      totalProducts: 1,
      lowStockCount: 1,
      inventoryValue: 2800000,
    ),
  );

  @override
  Future<domain.InventoryProduct> getProduct({
    required String farmId,
    required String productId,
  }) async => product;

  @override
  Future<domain.InventoryHistoryPage> getHistory({
    required String farmId,
    String? cursor,
    int limit = 100,
    String? productId,
    domain.InventoryTransactionType? transactionType,
    String? seasonId,
    DateTime? createdFrom,
    DateTime? createdTo,
  }) async => history;

  @override
  Future<domain.InventoryProduct> createProduct({
    required String farmId,
    required String name,
    required domain.InventoryProductCategory category,
    required domain.InventoryProductUnit unit,
    double? conversionQuantity,
    domain.InventoryConversionUnit? conversionUnit,
    required double minAlertQuantity,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
  }) async {
    createdProduct = <String, Object?>{
      'farmId': farmId,
      'name': name,
      'category': category,
      'unit': unit,
      'minAlertQuantity': minAlertQuantity,
    };
    return product;
  }

  @override
  Future<domain.InventoryProduct> updateProduct({
    required String farmId,
    required domain.InventoryProduct product,
    required String name,
    required domain.InventoryProductCategory category,
    required domain.InventoryProductUnit unit,
    double? conversionQuantity,
    domain.InventoryConversionUnit? conversionUnit,
    required double minAlertQuantity,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
  }) async {
    updateCalls++;
    if (failUpdateOnce && updateCalls == 1) {
      throw const ApiException('Thử lưu lại');
    }
    updatedImageUrl = imageUrl;
    updatedImageUrls = imageUrls;
    this.product = product.copyWith(
      imageUrl: imageUrl,
      imageUrls: imageUrls ?? const [],
    );
    return this.product;
  }

  @override
  Future<domain.InventoryProduct> archiveProduct({
    required String farmId,
    required String productId,
  }) async => product.copyWith(isArchived: true);

  @override
  Future<domain.InventoryProduct> restoreProduct({
    required String farmId,
    required String productId,
  }) async => product;

  @override
  Future<domain.InventoryStockResult> recordStockIn({
    required String farmId,
    required String productId,
    required String lotNumber,
    required DateTime receivedAt,
    required double quantity,
    required double unitPrice,
    required String supplierName,
    String? supplierId,
    String? reason,
  }) async {
    stockInPayload = <String, Object?>{
      'farmId': farmId,
      'productId': productId,
      'lotNumber': lotNumber,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'supplierName': supplierName,
      'supplierId': supplierId,
    };
    return domain.InventoryStockResult(
      transactionId: 'transaction-2',
      balance: product.lots.single,
      currentStock: product.currentStock + quantity,
      idempotentReplay: false,
    );
  }

  @override
  Future<domain.InventoryStockResult> recordAdjustment({
    required String farmId,
    required String productId,
    required String inventoryBalanceId,
    required bool increase,
    required double quantity,
    required String reason,
  }) async {
    adjustmentCalls++;
    return domain.InventoryStockResult(
      transactionId: 'transaction-3',
      balance: product.lots.single,
      currentStock: product.currentStock,
      idempotentReplay: false,
    );
  }
}

final class _SupplierRepository implements SupplierRepository {
  List<InventorySupplier> items = [
    InventorySupplier(
      id: 'supplier-1',
      farmId: 'farm-1',
      name: 'Nhà cung cấp B',
      phone: '0901234567',
      contactName: 'Anh Bình',
      email: 'sales@example.com',
      address: 'Cần Thơ',
      note: 'Giao buổi sáng',
      createdAt: DateTime.utc(2026, 10, 1),
      updatedAt: DateTime.utc(2026, 10, 1),
    ),
  ];
  InventorySupplier? saved;
  InventorySupplier? lastExisting;
  bool failNextSaveWithConflict = false;
  int deleted = 0;
  int listCalls = 0;
  int detailCalls = 0;
  @override
  Future<List<InventorySupplier>> getSuppliers(String farmId) async {
    listCalls++;
    return List.of(items);
  }

  @override
  Future<InventorySupplier> getSupplier(
    String farmId,
    String supplierId,
  ) async {
    detailCalls++;
    return items.firstWhere((s) => s.id == supplierId);
  }

  @override
  Future<InventorySupplier> saveSupplier({
    required String farmId,
    InventorySupplier? existing,
    required String name,
    String? contactName,
    String? phone,
    String? email,
    String? address,
    String? note,
  }) async {
    lastExisting = existing;
    if (failNextSaveWithConflict) {
      failNextSaveWithConflict = false;
      throw const ApiException('Dữ liệu đã thay đổi.', statusCode: 409);
    }
    final value = InventorySupplier(
      id: existing?.id ?? 'created-supplier',
      farmId: farmId,
      name: name,
      contactName: contactName,
      phone: phone,
      email: email,
      address: address,
      note: note,
      createdAt: existing?.createdAt ?? DateTime.utc(2026, 10, 15),
      updatedAt: DateTime.utc(2026, 10, 15),
    );
    saved = value;
    items = [...items.where((s) => s.id != value.id), value];
    return value;
  }

  @override
  Future<void> deleteSupplier(String farmId, String supplierId) async {
    deleted++;
    items = items.where((s) => s.id != supplierId).toList();
  }
}
