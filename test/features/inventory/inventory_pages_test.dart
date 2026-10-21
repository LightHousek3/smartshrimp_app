import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_directory_ui.dart';
import 'package:smartshrimp_app/features/inventory/presentation/pages/inventory_supplier_detail_page.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:convert';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_image_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_supplier_dialog.dart';
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
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: child,
          ),
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
    bool chooseManufacturer = true,
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
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: router,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Open inventory form'));
    await tester.pumpAndSettle();
    if (chooseManufacturer &&
        child is InventoryProductFormPage &&
        child.productId == null) {
      final makerField = find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is InventoryField && w.label == 'Nhà sản xuất *',
        ),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      await tester.ensureVisible(makerField);
      await tester.pumpAndSettle();
      await tester.tap(makerField);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nhà cung cấp B'));
      await tester.pumpAndSettle();
    }
  }

  Future<void> selectPhoto(WidgetTester tester, int index) async {
    final photo = find.byKey(ValueKey('inventory-photo-$index'));
    await tester.ensureVisible(photo);
    await tester.pumpAndSettle();
    await tester.tap(photo);
    await tester.pumpAndSettle();
  }

  String thresholdUnit(WidgetTester tester) => tester
      .widget<EditableText>(
        find
            .descendant(
              of: find.byWidgetPredicate(
                (widget) =>
                    widget is InventoryField &&
                    widget.label == 'Ngưỡng cảnh báo tồn kho tối thiểu',
              ),
              matching: find.byType(EditableText),
            )
            .last,
      )
      .controller
      .text;

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
    await tester.ensureVisible(field.first);
    await tester.pumpAndSettle();
    await tester.enterText(field.first, value);
    await tester.pump();
  }

  Future<void> submitForm(WidgetTester tester, String label) async {
    if (label == 'Xác nhận xuất kho') {
      await enterField(tester, 'Lý do xuất kho', 'Xuất hủy theo kiểm kê');
    }
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text(label),
      250,
      scrollable: find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .first,
    );
    await tester.pumpAndSettle();
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
      for (final font in <String, String>{
        'PlusJakartaSans': 'PlusJakartaSans-Regular.ttf',
        'PlusJakartaSans_regular': 'PlusJakartaSans-Regular.ttf',
        'PlusJakartaSans_500': 'PlusJakartaSans-Medium.ttf',
        'PlusJakartaSans_600': 'PlusJakartaSans-SemiBold.ttf',
        'PlusJakartaSans_700': 'PlusJakartaSans-Bold.ttf',
        'PlusJakartaSans_800': 'PlusJakartaSans-ExtraBold.ttf',
        'Sora_700': 'Sora-Bold.ttf',
        'Sora_800': 'Sora-ExtraBold.ttf',
      }.entries) {
        await (FontLoader(font.key)..addFont(
              rootBundle.load('assets/fonts/google_fonts/${font.value}'),
            ))
            .load();
      }
      final fallback = FontLoader('Sora')
        ..addFont(rootBundle.load('assets/fonts/google_fonts/Sora-Bold.ttf'));
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
      final assets = <Map<String, Object>>[];
      for (final element
          in find
              .byWidgetPredicate(
                (widget) =>
                    widget is InventorySvgIcon &&
                    widget.asset.contains('/form_'),
              )
              .evaluate()) {
        final icon = element.widget as InventorySvgIcon;
        final box = element.findRenderObject();
        if (box is RenderBox && box.hasSize) {
          assets.add({
            'asset': icon.asset,
            'width': box.size.width,
            'height': box.size.height,
          });
        }
      }
      await File(
        '${directory.path}/$name-assets.json',
      ).writeAsString(const JsonEncoder.withIndent('  ').convert(assets));
      image.dispose();
    });
  }

  testWidgets(
    'manufacturer selection excludes distributors and inactive entries and accepts both-role manufacturers',
    (tester) async {
      final suppliers = _SupplierRepository();
      final maker = suppliers.items.first;
      suppliers.items = [
        maker,
        maker.copyWith(
          id: 'maker-both',
          name: 'Nhà sản xuất kiêm phân phối',
          supplierType: 'BOTH',
        ),
        maker.copyWith(
          id: 'seller-only',
          name: 'Đại lý không sản xuất',
          supplierType: 'DISTRIBUTOR',
        ),
        maker.copyWith(
          id: 'inactive-maker',
          name: 'Nhà sản xuất tạm ngưng',
          status: 'INACTIVE',
        ),
      ];
      final inventory = _InventoryRepository(
        product: _product(),
        history: _history(),
      );
      await openForm(
        tester,
        const InventoryProductFormPage.create(farmId: 'farm-1'),
        inventory,
        suppliers: suppliers,
        chooseManufacturer: false,
      );
      final field = find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is InventoryField && w.label == 'Nhà sản xuất *',
        ),
        matching: find.byType(DropdownButtonFormField<String>),
      );
      await tester.ensureVisible(field);
      await tester.tap(field);
      await tester.pumpAndSettle();
      expect(find.text(maker.name), findsOneWidget);
      expect(find.text('Đại lý không sản xuất'), findsNothing);
      expect(find.text('Nhà sản xuất kiêm phân phối'), findsOneWidget);
      expect(find.text('Nhà sản xuất tạm ngưng'), findsNothing);
      await tester.tap(find.text('Nhà sản xuất kiêm phân phối'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<DropdownButtonFormField<String>>(field).initialValue,
        'maker-both',
      );
      await enterField(tester, 'Tên vật tư', 'Thức ăn của nhà sản xuất');
      await tester.ensureVisible(find.text('Thức ăn'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thức ăn'));
      await tester.ensureVisible(find.text('kg'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('kg'));
      await submitForm(tester, 'Thêm vào kho');
      expect(inventory.createdManufacturerId, 'maker-both');
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'hidden additional fields retain saved evidence when label facts are edited',
    (tester) async {
      final inventory = _InventoryRepository(
        product: _product().copyWith(
          compliance: const domain.InventoryCompliance(
            registrationNumber: 'REG-OLD',
            evidenceUrls: ['https://example.com/evidence.pdf'],
          ),
        ),
        history: _history(),
      );
      await openForm(
        tester,
        const InventoryProductFormPage.edit(
          farmId: 'farm-1',
          productId: 'product-1',
        ),
        inventory,
      );
      expect(find.text('Thông tin bổ sung'), findsNothing);
      expect(find.text('Số đăng ký / mã tiếp nhận'), findsNothing);
      expect(find.text('Liên kết bằng chứng'), findsNothing);
      expect(find.text('Loại sản phẩm *'), findsOneWidget);
      await enterField(
        tester,
        'Thành phần / hoạt chất',
        'Thành phần theo nhãn',
      );
      await submitForm(tester, 'Lưu thay đổi');
      expect(
        inventory.updatedCompliance,
        containsPair('registrationNumber', 'REG-OLD'),
      );
      expect(
        inventory.updatedCompliance,
        containsPair('evidenceUrls', ['https://example.com/evidence.pdf']),
      );
      expect(
        inventory.updatedCompliance,
        containsPair('ingredientsText', 'Thành phần theo nhãn'),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'V2 referenced suppliers hide deletion while keeping editing available',
    (tester) async {
      final supplier = _SupplierRepository().items.first.copyWith(
        canDelete: false,
      );
      await tester.pumpWidget(
        buildTestableWidget(InventorySupplierDialog(supplier: supplier)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Xóa'), findsNothing);
      expect(find.text('Chỉnh sửa'), findsOneWidget);
    },
  );

  testWidgets(
    'V2 filling expiry validates the calendar date and refreshes the lot',
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
      await tester.scrollUntilVisible(
        find.text('Bổ sung hạn dùng'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.tap(find.text('Bổ sung hạn dùng'));
      await tester.pumpAndSettle();
      final field = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextFormField),
      );
      await tester.enterText(field, '2027-02-30');
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();
      expect(find.text('Nhập ngày hợp lệ theo yyyy-MM-dd'), findsOneWidget);
      await tester.enterText(field, '2027-02-28');
      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();
      expect(repository.product.lots.first.expiryDate, DateTime(2027, 2, 28));
      expect(tester.takeException(), isNull);
    },
  );

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
    expect(find.text('Đổi ảnh'), findsNothing);
    expect(find.byTooltip('Đổi ảnh'), findsNothing);
    await capture(tester, 'detail');
    await tester.tap(find.bySemanticsLabel('Xem ảnh vật tư 2'));
    await tester.pumpAndSettle();
    expect(find.text('2/2'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('● Xuất trước'),
      200,
      scrollable: find
          .byWidgetPredicate(
            (widget) =>
                widget is Scrollable &&
                widget.axisDirection == AxisDirection.down,
          )
          .first,
    );
    expect(find.text('● Xuất trước'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('photo selection and preview do not replace existing images', (
    tester,
  ) async {
    final photos = [
      'https://example.com/front.png',
      'https://example.com/back.png',
    ];
    final inventory = _InventoryRepository(
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
      inventory,
      picker: picker,
      storage: storage,
    );
    await selectPhoto(tester, 1);
    expect(find.text('Đã chọn: Mặt sau'), findsOneWidget);
    expect(find.text('Đổi ảnh'), findsNothing);
    expect(find.byTooltip('Đổi ảnh'), findsNothing);
    final preview = find.byKey(const ValueKey('inventory-photo-preview'));
    await tester.ensureVisible(preview);
    await tester.pumpAndSettle();
    await tester.tap(preview);
    await tester.pumpAndSettle();
    expect(picker.calls, 0);
    expect(inventory.updateCalls, 0);
    await submitForm(tester, 'Lưu thay đổi');
    expect(inventory.updatedImageUrls, photos);
    expect(storage.calls, 0);
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
      await selectPhoto(tester, 1);
      await tester.ensureVisible(find.byTooltip('Gỡ ảnh 2'));
      await tester.pumpAndSettle();
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
    await tester.ensureVisible(find.text('Thêm ảnh'));
    await tester.tap(find.text('Thêm ảnh'));
    await tester.pumpAndSettle();
    expect(picker.calls, 1);
    expect(find.byKey(const ValueKey('inventory-photo-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('inventory-photo-1')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('inventory-photo-preview')),
      findsOneWidget,
    );
    expect(find.text('Chụp ảnh'), findsNothing);
    expect(find.byKey(const ValueKey('inventory-photo-2')), findsNothing);
    expect(find.text('Thêm ảnh khác'), findsOneWidget);
    await capture(tester, 'create-material-with-photos');
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'accepts three photos and preserves the third slot after removal',
    (tester) async {
      final picker = _FileImagePicker(fileCount: 3);
      await openForm(
        tester,
        const InventoryProductFormPage.create(farmId: 'farm-1'),
        _InventoryRepository(product: _product(), history: _history()),
        picker: picker,
      );
      await tester.ensureVisible(find.text('Thêm ảnh'));
      await tester.tap(find.text('Thêm ảnh'));
      await tester.pumpAndSettle();
      expect(find.text('Đã đủ 3 ảnh'), findsOneWidget);
      await selectPhoto(tester, 2);
      await tester.ensureVisible(find.byTooltip('Gỡ ảnh 3'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Gỡ ảnh 3'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Gỡ ảnh 3'), findsNothing);
      await tester.ensureVisible(find.text('Thêm ảnh khác'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Thêm ảnh khác'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Gỡ ảnh 3'), findsOneWidget);
      expect(find.text('Đã đủ 3 ảnh'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('rejects selecting a fourth photo before adding any files', (
    tester,
  ) async {
    final picker = _FileImagePicker(fileCount: 4);
    await openForm(
      tester,
      const InventoryProductFormPage.create(farmId: 'farm-1'),
      _InventoryRepository(product: _product(), history: _history()),
      picker: picker,
    );
    await tester.ensureVisible(find.text('Thêm ảnh'));
    await tester.tap(find.text('Thêm ảnh'));
    await tester.pumpAndSettle();
    expect(find.text('Mỗi vật tư có tối đa 3 ảnh.'), findsOneWidget);
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
      await tester.pumpAndSettle();
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
      await tester.ensureVisible(find.text('Thêm ảnh'));
      await tester.tap(find.text('Thêm ảnh'));
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

  testWidgets('products expose pause and never expose deletion', (
    tester,
  ) async {
    await openForm(
      tester,
      const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
      _InventoryRepository(product: _product(), history: _history()),
    );
    expect(find.text('Xóa vật tư'), findsNothing);
    final pause = find.widgetWithText(OutlinedButton, 'Tạm ngưng vật tư');
    await tester.scrollUntilVisible(
      pause,
      250,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(pause);
    await tester.pumpAndSettle();
    expect(find.text('Tạm ngưng vật tư?'), findsOneWidget);
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    expect(find.text('Tạm ngưng vật tư?'), findsNothing);
  });

  testWidgets(
    'supplier detail deletes only unreferenced entries after confirmation',
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
      await tester.tap(find.byKey(const ValueKey('supplier-card-supplier-1')));
      await tester.pumpAndSettle();
      expect(find.byType(InventorySupplierDetailPage), findsOneWidget);
      expect(find.text('Anh Bình'), findsOneWidget);
      expect(suppliers.detailCalls, 1);
      final remove = find.widgetWithText(OutlinedButton, 'Xóa nhà cung cấp');
      await tester.ensureVisible(remove);
      expect(
        tester.getSize(remove),
        tester.getSize(find.widgetWithText(OutlinedButton, 'Ngừng giao dịch')),
      );
      await tester.tap(remove);
      await tester.pumpAndSettle();
      expect(suppliers.deleted, 0);
      await tester.tap(find.text('Xóa nhà cung cấp'));
      await tester.pumpAndSettle();
      expect(suppliers.deleted, 1);
      expect(suppliers.listCalls, 2);
      expect(find.text('Chưa có nhà cung cấp'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'supplier search is local and detail loads current references when opened',
    (tester) async {
      configureMobileViewport(tester);
      final suppliers = _SupplierRepository();
      suppliers.items = [
        suppliers.items.single.copyWith(
          supplierType: 'BOTH',
          canDelete: false,
          manufacturedProductCount: 2,
          receiptCount: 2,
          manufacturedProducts: [
            {
              'id': 'material-1',
              'name': 'Chế phẩm xử lý nước Nitrosomonas/Nitrobacter',
              'farmId': 'farm-1',
              'farmName': 'Trang trại Cửa Lấp',
            },
            {
              'id': 'material-2',
              'name': 'Khoáng tổng hợp Sea-Min',
              'farmId': 'farm-2',
              'farmName': 'Trang trại Đông Hải',
            },
          ],
          receipts: [
            {
              'id': 'receipt-1',
              'productId': 'material-3',
              'productName': 'Doxycycline 98% (trộn thức ăn)',
              'farmId': 'farm-1',
              'farmName': 'Trang trại Cửa Lấp',
              'lotNumber': 'Lô L-240904',
              'quantityExact': '8',
              'receivedAt': '2026-07-01T00:00:00Z',
            },
            {
              'id': 'receipt-2',
              'productId': 'material-1',
              'productName': 'Chế phẩm xử lý nước Nitrosomonas/Nitrobacter',
              'farmId': 'farm-1',
              'farmName': 'Trang trại Cửa Lấp',
              'lotNumber': 'Lô L-240903',
              'quantityExact': '45',
              'receivedAt': '2026-06-22T00:00:00Z',
            },
          ],
        ),
      ];
      await tester.pumpWidget(
        buildTestableWidget(
          const InventorySuppliersPage(farmId: 'farm-1'),
          suppliers: suppliers,
        ),
      );
      await tester.pumpAndSettle();
      await capture(tester, 'supplier-directory', waitForFonts: false);
      await tester.enterText(find.byType(TextField), 'không tồn tại');
      await tester.pumpAndSettle();
      expect(find.text('Không tìm thấy nhà cung cấp'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Cần Thơ');
      await tester.pumpAndSettle();
      for (var i = 0; i < 2; i++) {
        final card = find.byKey(const ValueKey('supplier-card-supplier-1'));
        expect(find.text('Xem chi tiết'), findsNothing);
        await tester.tap(
          i == 0
              ? find.descendant(
                  of: card,
                  matching: find.text(suppliers.items.single.name),
                )
              : find.descendant(
                  of: card,
                  matching: find.byType(InventorySvgIcon),
                ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(InventorySupplierDetailPage), findsOneWidget);
        expect(find.text('sales@example.com'), findsOneWidget);
        if (i == 0) {
          await capture(tester, 'supplier-details', waitForFonts: false);
        }
        Navigator.of(
          tester.element(find.byType(InventorySupplierDetailPage)),
        ).pop();
        await tester.pumpAndSettle();
      }
      expect(suppliers.listCalls, 1);
      expect(suppliers.detailCalls, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'editing from supplier detail uses the current version and refreshes the directory',
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
      await tester.tap(find.byTooltip('Chỉnh sửa'));
      await tester.pumpAndSettle();
      expect(find.text('Anh Bình'), findsOneWidget);
      expect(suppliers.detailCalls, 1);
      await enterField(tester, 'Tên nhà cung cấp', 'Cửa hàng An Phú');
      await submitForm(tester, 'Lưu nhà cung cấp');
      expect(suppliers.saved?.id, 'supplier-1');
      expect(find.text('Cửa hàng An Phú'), findsOneWidget);
      expect(suppliers.listCalls, 2);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'supplier detail fits small screens and disables absent contact actions',
    (tester) async {
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
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Gọi'))
            .onPressed,
        isNull,
      );
      expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Email'))
            .onPressed,
        isNull,
      );
      expect(find.byTooltip('Chỉnh sửa').hitTestable(), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'long supplier notes scroll while the edit action stays available',
    (tester) async {
      configureMobileViewport(tester);
      tester.view.physicalSize = const Size(320, 568);
      final suppliers = _SupplierRepository();
      suppliers.items = [
        suppliers.items.single.copyWith(
          note: List.filled(
            40,
            'Giao hàng theo lịch, kiểm tra hạn sử dụng.',
          ).join(' '),
          canDelete: false,
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
      await tester.drag(find.byType(ListView).last, const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Chỉnh sửa').hitTestable(), findsOneWidget);
      expect(
        find.widgetWithText(OutlinedButton, 'Xóa nhà cung cấp'),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'supplier role and status filters combine without more API requests',
    (tester) async {
      configureMobileViewport(tester);
      final suppliers = _SupplierRepository();
      final first = suppliers.items.single;
      suppliers.items = [
        first,
        first.copyWith(
          id: 'distributor',
          name: 'Đại lý mới',
          supplierType: 'DISTRIBUTOR',
        ),
        first.copyWith(
          id: 'inactive',
          name: 'Đại lý cũ',
          supplierType: 'DISTRIBUTOR',
          status: 'INACTIVE',
        ),
      ];
      await tester.pumpWidget(
        buildTestableWidget(
          const InventorySuppliersPage(farmId: 'farm-1'),
          suppliers: suppliers,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Lọc vai trò nhà cung cấp'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nhà phân phối').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Lọc trạng thái nhà cung cấp'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ngừng giao dịch').last);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('supplier-card-inactive')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('supplier-card-distributor')),
        findsNothing,
      );
      await tester.tap(find.text('Xóa bộ lọc'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('supplier-card-distributor')),
        findsOneWidget,
      );
      expect(suppliers.listCalls, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('supplier status action persists and refreshes detail', (
    tester,
  ) async {
    configureMobileViewport(tester);
    final suppliers = _SupplierRepository();
    await tester.pumpWidget(
      buildTestableWidget(
        const InventorySuppliersPage(farmId: 'farm-1'),
        suppliers: suppliers,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('supplier-card-supplier-1')));
    await tester.pumpAndSettle();
    final stop = find.widgetWithText(OutlinedButton, 'Ngừng giao dịch');
    await tester.ensureVisible(stop);
    await tester.tap(stop);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ngừng giao dịch').last);
    await tester.pumpAndSettle();
    expect(suppliers.saved?.status, 'INACTIVE');
    expect(
      find.widgetWithText(OutlinedButton, 'Tiếp tục giao dịch'),
      findsOneWidget,
    );
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
      await tester.tap(find.byTooltip('Chỉnh sửa'));
      await tester.pumpAndSettle();
      final latest = suppliers.items.single.copyWith(
        contactName: 'Người liên hệ mới',
        updatedAt: DateTime.utc(2026, 10, 15),
      );
      suppliers.items = [latest];
      suppliers.failNextSaveWithConflict = true;
      await submitForm(tester, 'Lưu nhà cung cấp');
      expect(suppliers.detailCalls, 1);
      await tester.pump(const Duration(seconds: 6));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tải lại dữ liệu mới nhất'));
      await tester.pumpAndSettle();
      expect(find.text('Người liên hệ mới'), findsOneWidget);
      expect(suppliers.detailCalls, 2);
      await submitForm(tester, 'Lưu nhà cung cấp');
      expect(suppliers.lastExisting?.updatedAt, latest.updatedAt);
      expect(suppliers.saved?.contactName, 'Người liên hệ mới');
      expect(suppliers.listCalls, 2);
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
    testWidgets(
      'upgraded used product permits initial manufacturer completion',
      (tester) async {
        await openForm(
          tester,
          const InventoryProductFormPage.edit(
            farmId: 'farm-1',
            productId: 'product-1',
          ),
          _InventoryRepository(
            product: _product().copyWith(
              manufacturerId: '',
              manufacturer: {},
              metadataLocked: true,
            ),
            history: _history(),
          ),
        );
        expect(find.text('Bổ sung nhà sản xuất'), findsOneWidget);
        expect(find.text('Lưu thay đổi'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets(
      'legacy product detail shows actual stock and disables all writes',
      (tester) async {
        await openForm(
          tester,
          const InventoryDetailPage(farmId: 'farm-1', productId: 'product-1'),
          _InventoryRepository(
            product: _product().copyWith(
              readOnly: true,
              manufacturerId: '',
              manufacturer: {},
              metadataLocked: true,
              canDelete: false,
            ),
            history: _history(),
          ),
        );
        expect(find.textContaining('Kho tạm thời chỉ xem'), findsOneWidget);
        expect(find.bySemanticsLabel('Chỉnh sửa vật tư'), findsNothing);
        expect(find.text('Nhập kho'), findsNothing);
        expect(find.text('Xuất kho'), findsNothing);
        expect(
          tester
              .widget<OutlinedButton>(
                find.widgetWithText(OutlinedButton, 'Tạm ngưng vật tư'),
              )
              .onPressed,
          isNull,
        );
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets(
      'legacy catalog keeps navigation but disables new material creation',
      (tester) async {
        await openForm(
          tester,
          const InventoryPage(farmId: 'farm-1', farmName: 'Trại kiểm thử'),
          _InventoryRepository(
            product: _product().copyWith(
              readOnly: true,
              manufacturerId: '',
              manufacturer: {},
            ),
            history: _history(),
          ),
        );
        expect(find.textContaining('Kho tạm thời chỉ xem'), findsOneWidget);
        expect(
          tester
              .widget<TextButton>(
                find.widgetWithText(TextButton, 'Thêm vật tư'),
              )
              .onPressed,
          isNull,
        );
        expect(find.text('Thức ăn CP 9004'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets(
      'legacy supplier detail keeps contact data without offering role edits',
      (tester) async {
        configureMobileViewport(tester);
        final suppliers = _SupplierRepository();
        suppliers.items = [
          suppliers.items.single.copyWith(
            readOnly: true,
            supplierType: 'UNKNOWN',
            canDelete: false,
          ),
        ];
        await tester.pumpWidget(
          buildTestableWidget(
            const InventorySuppliersPage(farmId: 'farm-1'),
            suppliers: suppliers,
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<TextButton>(
                find.widgetWithText(TextButton, 'Thêm nhà cung cấp'),
              )
              .onPressed,
          isNull,
        );
        await tester.tap(
          find.byKey(const ValueKey('supplier-card-supplier-1')),
        );
        await tester.pumpAndSettle();
        expect(find.text('Anh Bình'), findsOneWidget);
        expect(
          tester
              .widget<IconButton>(
                find.byWidgetPredicate(
                  (widget) =>
                      widget is IconButton && widget.tooltip == 'Chỉnh sửa',
                ),
              )
              .onPressed,
          isNull,
        );
        expect(
          tester
              .widget<OutlinedButton>(
                find.widgetWithText(OutlinedButton, 'Ngừng giao dịch'),
              )
              .onPressed,
          isNull,
        );
        expect(tester.takeException(), isNull);
      },
    );
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

    testWidgets(
      'dropdown filters combine and all resets them on a small screen',
      (tester) async {
        configureMobileViewport(tester);
        tester.view.physicalSize = const Size(320, 800);
        await tester.pumpWidget(
          buildTestableWidget(const InventoryPage(farmId: 'farm-1')),
        );
        await tester.pumpAndSettle();
        await capture(tester, 'catalog-filters', waitForFonts: false);
        await tester.tap(find.byTooltip('Lọc loại vật tư'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Khác'));
        await tester.pumpAndSettle();
        expect(find.text('0 vật tư'), findsOneWidget);
        expect(find.text('Không tìm thấy vật tư'), findsOneWidget);
        await capture(tester, 'catalog-empty', waitForFonts: false);
        await tester.tap(find.text('Xóa bộ lọc'));
        await tester.pumpAndSettle();
        expect(find.text('Thức ăn CP 9004'), findsOneWidget);
        await tester.tap(find.byTooltip('Lọc trạng thái'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ngừng sử dụng').last);
        await tester.pumpAndSettle();
        expect(find.text('0 vật tư'), findsOneWidget);
        await tester.tap(find.text('Xóa bộ lọc'));
        await tester.pumpAndSettle();
        expect(find.text('Thức ăn CP 9004'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('list renders API-backed summary, filters and products', (
      tester,
    ) async {
      configureMobileViewport(tester);
      await tester.pumpWidget(
        buildTestableWidget(const InventoryPage(farmId: 'farm-1')),
      );
      await tester.pumpAndSettle();

      await capture(tester, 'catalog', waitForFonts: false);
      expect(find.text('Kho vật tư'), findsOneWidget);
      expect(find.text('VẬT TƯ'), findsOneWidget);
      expect(find.text('SẮP HẾT'), findsOneWidget);
      expect(find.text('GIÁ TRỊ TỒN'), findsOneWidget);
      expect(find.text('Thức ăn CP 9004'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(tester.getSize(find.byType(TextField)).height, 40);
      for (final label in ['Sắp hết (1)', 'Trạng thái', 'Danh mục']) {
        expect(find.text(label), findsOneWidget);
      }
      final stats = find.byType(InventorySummaryCard);
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
        find.byKey(const ValueKey('inventory-low-stock-filter')),
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

      expect(find.text('Thêm vật tư mới'), findsOneWidget);
      expect(find.text('Tên vật tư *'), findsOneWidget);
      expect(find.text('Danh mục *'), findsOneWidget);
      expect(find.text('Đơn vị *'), findsOneWidget);
      expect(find.text('Nhãn & hồ sơ tuân thủ'), findsOneWidget);
      expect(find.text('Thành phần / hoạt chất *'), findsOneWidget);
      expect(find.text('Hướng dẫn sử dụng *'), findsOneWidget);
      expect(find.text('Mô tả (tùy chọn · 0/500)'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Tên vật tư *')).dy,
        lessThan(tester.getTopLeft(find.text('Nhà sản xuất *')).dy),
      );
      await capture(tester, 'create-material-top');
      await tester.ensureVisible(find.text('Nhãn & hồ sơ tuân thủ'));
      await tester.pumpAndSettle();
      await capture(tester, 'create-material-label');
      await enterField(tester, 'Mô tả', 'Ghi chú theo nhãn');
      await tester.pumpAndSettle();
      expect(find.text('Mô tả (tùy chọn · 17/500)'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Thêm vào kho'),
        250,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Thêm vào kho'), findsOneWidget);
      await capture(tester, 'create-material-bottom');
      tester.view.physicalSize = const Size(320, 568);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Nhãn & hồ sơ tuân thủ'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
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
        expect(thresholdUnit(tester), 'đơn vị quy đổi');
        await enterField(tester, 'Quy đổi mỗi chai', '1500');
        final dropdown = find.byType(
          DropdownButtonFormField<domain.InventoryConversionUnit>,
        );
        await tester.ensureVisible(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text('ml').last);
        await tester.pumpAndSettle();
        expect(thresholdUnit(tester), 'ml');
        await enterField(tester, 'Ngưỡng cảnh báo', '1000');
        await capture(tester, 'threshold-conversion-pair', waitForFonts: false);
        await tester.ensureVisible(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text('g').last);
        await tester.pumpAndSettle();
        expect(thresholdUnit(tester), 'g');
        await tester.ensureVisible(find.text('kg').first);
        await tester.pumpAndSettle();
        await tester.tap(find.text('kg').first);
        await tester.pumpAndSettle();
        expect(thresholdUnit(tester), 'kg');
        await tester.ensureVisible(find.text('chai'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('chai'));
        await tester.pumpAndSettle();
        await enterField(tester, 'Quy đổi mỗi chai', '1500');
        await tester.ensureVisible(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(dropdown);
        await tester.pumpAndSettle();
        await tester.tap(find.text('ml').last);
        await tester.pumpAndSettle();
        await submitForm(tester, 'Thêm vào kho');
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
      await submitForm(tester, 'Thêm vào kho');

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
        final expiryField = find.descendant(
          of: find.byWidgetPredicate(
            (w) => w is InventoryField && w.label == 'Hạn sử dụng',
          ),
          matching: find.byType(TextFormField),
        );
        final expiry = DateTime(DateTime.now().year + 1, 6, 15);
        Future<void> openExpiryPicker() async {
          await tester.ensureVisible(expiryField);
          await tester.tap(expiryField);
          await tester.pumpAndSettle();
        }

        Future<void> chooseExpiry() async {
          await openExpiryPicker();
          tester
              .widget<CalendarDatePicker>(find.byType(CalendarDatePicker))
              .onDateChanged(expiry);
          await tester.pump();
          await tester.tap(find.text('OK'));
          await tester.pumpAndSettle();
        }

        expect(
          tester
              .widget<EditableText>(
                find.descendant(
                  of: expiryField,
                  matching: find.byType(EditableText),
                ),
              )
              .readOnly,
          isTrue,
        );
        await chooseExpiry();
        expect(find.text('15/06/${expiry.year}'), findsOneWidget);
        await openExpiryPicker();
        expect(
          tester
              .widget<CalendarDatePicker>(find.byType(CalendarDatePicker))
              .initialDate,
          expiry,
        );
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(find.text('15/06/${expiry.year}'), findsOneWidget);
        await tester.tap(find.byTooltip('Xóa hạn sử dụng'));
        await tester.pumpAndSettle();
        expect(
          tester.widget<TextFormField>(expiryField).controller!.text,
          isEmpty,
        );
        await chooseExpiry();
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
        expect(repository.stockInExpiryDate, expiry);
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
    manufacturerId: 'supplier',
    manufacturer: {'id': 'supplier', 'name': 'Nhà cung cấp A'},
    category: domain.InventoryProductCategory.feed,
    unit: domain.InventoryProductUnit.kg,
    minAlertQuantity: 100,
    description: 'Thức ăn cho tôm.',
    status: 'ACTIVE',
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
  _FileImagePicker({this.fileCount = 2});
  final int fileCount;
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
  @override
  Future<domain.InventoryLot> updateLotExpiry({
    required String farmId,
    required String productId,
    required domain.InventoryLot lot,
    required DateTime expiryDate,
  }) async {
    final updated = lot.copyWith(expiryDate: expiryDate);
    product = product.copyWith(
      lots: product.lots
          .map((value) => value.id == lot.id ? updated : value)
          .toList(),
    );
    return updated;
  }

  @override
  Future<void> deleteProduct({
    required String farmId,
    required String productId,
  }) async {}

  Map<String, Object?>? stockOutPayload;
  @override
  Future<domain.InventoryStockResult> recordStockOut({
    required String farmId,
    required String productId,
    required String inventoryBalanceId,
    required double quantity,
    String? quantityExact,
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
  String? createdManufacturerId;
  Map<String, dynamic>? updatedCompliance;
  Map<String, Object?>? stockInPayload;
  DateTime? stockInExpiryDate;
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
    String? search,
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
    String manufacturerId = '',
    Map<String, dynamic>? compliance,
    required domain.InventoryProductUnit unit,
    double? conversionQuantity,
    domain.InventoryConversionUnit? conversionUnit,
    required double minAlertQuantity,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
  }) async {
    createdManufacturerId = manufacturerId;
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
    String manufacturerId = '',
    Map<String, dynamic>? compliance,
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
    updatedCompliance = compliance;
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
  }) async => product.copyWith(status: 'INACTIVE');

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
    DateTime? expiryDate,
    required double quantity,
    String? quantityExact,
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
    stockInExpiryDate = expiryDate;
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
    String? quantityExact,
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
      ownerId: 'farm-1',
      name: 'Nhà cung cấp B',
      canDelete: true,
      phone: '0901234567',
      contactName: 'Anh Bình',
      email: 'sales@example.com',
      address: 'Cần Thơ',
      note: 'Giao buổi sáng',
      manufacturedProductCount: 0,
      receiptCount: 0,
      manufacturedProducts: [],
      receipts: [],
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
    bool isActive = true,
    String supplierType = 'MANUFACTURER',
  }) async {
    lastExisting = existing;
    if (failNextSaveWithConflict) {
      failNextSaveWithConflict = false;
      throw const ApiException('Dữ liệu đã thay đổi.', statusCode: 409);
    }
    final value = InventorySupplier(
      id: existing?.id ?? 'created-supplier',
      ownerId: farmId,
      name: name,
      canDelete: true,
      contactName: contactName,
      phone: phone,
      email: email,
      address: address,
      note: note,
      status: isActive ? 'ACTIVE' : 'INACTIVE',
      supplierType: supplierType,
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
