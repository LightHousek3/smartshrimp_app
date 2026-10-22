import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/features/inventory/data/services/cloudinary_inventory_image_storage.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_image_storage.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:smartshrimp_app/features/inventory/data/services/inventory_api_service.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_repository.dart';

typedef InventoryProductKey = ({String farmId, String productId});
typedef InventoryHistoryKey = ({
  String farmId,
  InventoryHistoryFilters filters,
});

final inventoryRemoteDataSourceProvider = Provider<InventoryRemoteDataSource>((
  ref,
) {
  return InventoryApiService(ref.watch(apiClientProvider));
});

final inventoryImageStorageProvider = Provider<InventoryImageStorage>(
  (ref) => CloudinaryInventoryImageStorage(ref.watch(cloudinaryDioProvider)),
);

final inventoryImagePickerProvider = Provider<ImagePicker>(
  (ref) => ImagePicker(),
);

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  ref.watch(authControllerProvider.select((state) => state.value?.id));
  return InventoryRepositoryImpl(ref.watch(inventoryRemoteDataSourceProvider));
});

final inventoryListControllerProvider = AsyncNotifierProvider.autoDispose
    .family<InventoryListController, InventoryProductPage, String>(
      InventoryListController.new,
    );

typedef InventoryCatalogKey = ({
  String farmId,
  String search,
  InventoryProductCategory? category,
  bool lowStockOnly,
  InventoryArchiveStatus archiveStatus,
});

final filteredInventoryListControllerProvider = AsyncNotifierProvider
    .autoDispose
    .family<InventoryListController, InventoryProductPage, InventoryCatalogKey>(
      (key) => InventoryListController(key.farmId, filters: key),
    );

final inventoryDetailControllerProvider = AsyncNotifierProvider.autoDispose
    .family<InventoryDetailController, InventoryProduct, InventoryProductKey>(
      InventoryDetailController.new,
    );

final inventoryHistoryControllerProvider = AsyncNotifierProvider.autoDispose
    .family<InventoryHistoryController, InventoryHistoryPage, String>(
      InventoryHistoryController.new,
    );

final filteredInventoryHistoryControllerProvider = AsyncNotifierProvider
    .autoDispose
    .family<
      InventoryHistoryController,
      InventoryHistoryPage,
      InventoryHistoryKey
    >((key) => InventoryHistoryController(key.farmId, filters: key.filters));

final inventoryMutationControllerProvider = AsyncNotifierProvider.autoDispose
    .family<InventoryMutationController, void, String>(
      InventoryMutationController.new,
    );

/// Share the Owner UI gate and session-expiry handling across inventory flows.
/// Backend ownership checks remain authoritative for every request.
abstract base class _OwnerInventoryController<T> extends AsyncNotifier<T> {
  void requireOwner() {
    if (ref.watch(authControllerProvider).value?.role !=
        AccountRole.farmOwner) {
      throw const UnsupportedRoleException();
    }
  }

  Future<R> runAuthenticated<R>(Future<R> Function() operation) async {
    try {
      return await operation();
    } on SessionExpiredException {
      if (ref.mounted) {
        await ref.read(authControllerProvider.notifier).expireSession();
      }
      rethrow;
    }
  }
}

/// Fetch ten products per request and let the API apply combined filters.
final class InventoryListController
    extends _OwnerInventoryController<InventoryProductPage> {
  InventoryListController(this.farmId, {this.filters});

  static const _pageSize = 10;
  final String farmId;
  final InventoryCatalogKey? filters;
  int _refreshGeneration = 0;
  bool _refreshing = false;
  int? _loadingMoreGeneration;

  @override
  Future<InventoryProductPage> build() {
    requireOwner();
    _refreshGeneration++;
    _refreshing = false;
    _loadingMoreGeneration = null;
    return _loadPage();
  }

  Future<void> refresh() async {
    final generation = ++_refreshGeneration;
    _refreshing = true;
    _loadingMoreGeneration = null;
    final result = await AsyncValue.guard(_loadPage);
    if (ref.mounted && generation == _refreshGeneration) {
      _refreshing = false;
      state = result;
    }
  }

  Future<InventoryProductPage> _loadPage([int pageNumber = 1]) =>
      runAuthenticated(
        () => ref
            .read(inventoryRepositoryProvider)
            .getProducts(
              farmId: farmId,
              page: pageNumber,
              limit: _pageSize,
              search: filters?.search,
              category: filters?.category,
              lowStockOnly: filters?.lowStockOnly ?? false,
              archiveStatus:
                  filters?.archiveStatus ?? InventoryArchiveStatus.all,
            ),
      );

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null ||
        !current.hasNextPage ||
        _refreshing ||
        _loadingMoreGeneration != null) {
      return;
    }
    final generation = _refreshGeneration;
    _loadingMoreGeneration = generation;
    try {
      final page = await _loadPage(current.page + 1);
      if (!ref.mounted || generation != _refreshGeneration) return;
      if (page.page != current.page + 1) {
        throw const InvalidResponseException();
      }
      final unique = {
        for (final product in current.items) product.id: product,
        for (final product in page.items) product.id: product,
      };
      state = AsyncData(page.copyWith(items: unique.values.toList()));
    } finally {
      if (_loadingMoreGeneration == generation) _loadingMoreGeneration = null;
    }
  }
}

/// Load one farm/product pair and prevent older refreshes replacing newer data.
final class InventoryDetailController
    extends _OwnerInventoryController<InventoryProduct> {
  InventoryDetailController(this.key);

  final InventoryProductKey key;
  int _refreshGeneration = 0;

  @override
  Future<InventoryProduct> build() {
    requireOwner();
    return _load();
  }

  Future<void> refresh() async {
    final generation = ++_refreshGeneration;
    final result = await AsyncValue.guard(_load);
    if (ref.mounted && generation == _refreshGeneration) state = result;
  }

  Future<InventoryProduct> _load() => runAuthenticated(
    () => ref
        .read(inventoryRepositoryProvider)
        .getProduct(farmId: key.farmId, productId: key.productId),
  );
}

/// Fetch ten ledger records per request, preserving server totals and filter cursors.
final class InventoryHistoryController
    extends _OwnerInventoryController<InventoryHistoryPage> {
  InventoryHistoryController(
    this.farmId, {
    this.filters = const InventoryHistoryFilters(),
  });

  static const _pageSize = 10;
  final String farmId;
  final InventoryHistoryFilters filters;
  int _refreshGeneration = 0;
  bool _refreshing = false;
  int? _loadingMoreGeneration;
  final _loadedCursors = <String>{};

  @override
  Future<InventoryHistoryPage> build() {
    requireOwner();
    _refreshGeneration++;
    _refreshing = false;
    _loadingMoreGeneration = null;
    _loadedCursors.clear();
    return _loadPage();
  }

  Future<void> refresh() async {
    final generation = ++_refreshGeneration;
    _refreshing = true;
    _loadingMoreGeneration = null;
    _loadedCursors.clear();
    final result = await AsyncValue.guard(_loadPage);
    if (ref.mounted && generation == _refreshGeneration) {
      _refreshing = false;
      state = result;
    }
  }

  Future<InventoryHistoryPage> _loadPage([String? cursor]) => runAuthenticated(
    () async {
      if (!filters.isValidDateRange) {
        throw const ApiException('Ngày bắt đầu không được sau ngày kết thúc.');
      }
      final repository = ref.read(inventoryRepositoryProvider);
      final page = await repository.getHistory(
        farmId: farmId,
        cursor: cursor,
        limit: _pageSize,
        search: filters.search,
        productId: filters.productId,
        transactionType: filters.transactionType,
        seasonId: filters.seasonId,
        createdFrom: filters.createdFrom,
        createdTo: filters.createdTo,
      );
      if (page.hasNextPage &&
          (page.nextCursor == null ||
              page.nextCursor == cursor ||
              _loadedCursors.contains(page.nextCursor))) {
        throw const InvalidResponseException();
      }
      return page;
    },
  );

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null ||
        !current.hasNextPage ||
        _refreshing ||
        _loadingMoreGeneration != null) {
      return;
    }
    final cursor = current.nextCursor;
    if (cursor == null) throw const InvalidResponseException();
    final generation = _refreshGeneration;
    _loadingMoreGeneration = generation;
    try {
      final page = await _loadPage(cursor);
      if (!ref.mounted || generation != _refreshGeneration) return;
      _loadedCursors.add(cursor);
      final unique = {
        for (final row in current.items) row.id: row,
        for (final row in page.items) row.id: row,
      };
      state = AsyncData(page.copyWith(items: unique.values.toList()));
    } finally {
      if (_loadingMoreGeneration == generation) _loadingMoreGeneration = null;
    }
  }
}

/// Coordinate inventory writes and invalidate dependent lists and details.
/// Keep mutation failures available to the initiating page for error display.
final class InventoryMutationController
    extends _OwnerInventoryController<void> {
  InventoryMutationController(this.farmId);

  final String farmId;

  @override
  void build() {
    requireOwner();
  }

  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) => _mutate(
    () => ref
        .read(inventoryImageStorageProvider)
        .upload(bytes: bytes, fileName: fileName),
  );

  Future<InventoryProduct> create({
    required String name,
    required InventoryProductCategory category,
    String manufacturerId = '',
    Map<String, dynamic>? compliance,
    required InventoryProductUnit unit,
    double? conversionQuantity,
    InventoryConversionUnit? conversionUnit,
    required double minAlertQuantity,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
  }) => _mutate(
    () => ref
        .read(inventoryRepositoryProvider)
        .createProduct(
          farmId: farmId,
          name: name,
          category: category,
          manufacturerId: manufacturerId,
          compliance: compliance,
          unit: unit,
          conversionQuantity: conversionQuantity,
          conversionUnit: conversionUnit,
          minAlertQuantity: minAlertQuantity,
          description: description,
          imageUrl: imageUrl,
          imageUrls: imageUrls,
        ),
  );

  Future<InventoryProduct> updateProduct({
    required InventoryProduct product,
    required String name,
    required InventoryProductCategory category,
    String manufacturerId = '',
    Map<String, dynamic>? compliance,
    required InventoryProductUnit unit,
    double? conversionQuantity,
    InventoryConversionUnit? conversionUnit,
    required double minAlertQuantity,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
  }) => _mutate(
    () => ref
        .read(inventoryRepositoryProvider)
        .updateProduct(
          farmId: farmId,
          product: product,
          name: name,
          category: category,
          manufacturerId: manufacturerId,
          compliance: compliance,
          unit: unit,
          conversionQuantity: conversionQuantity,
          conversionUnit: conversionUnit,
          minAlertQuantity: minAlertQuantity,
          description: description,
          imageUrl: imageUrl,
          imageUrls: imageUrls,
        ),
    productId: product.id,
  );

  Future<InventoryProduct> archive(String productId) => _mutate(
    () => ref
        .read(inventoryRepositoryProvider)
        .archiveProduct(farmId: farmId, productId: productId),
    productId: productId,
  );

  Future<InventoryStockResult> stockOut({
    required String productId,
    required String inventoryBalanceId,
    required double quantity,
    String? quantityExact,
    String? reason,
  }) => _mutate(
    () => ref
        .read(inventoryRepositoryProvider)
        .recordStockOut(
          farmId: farmId,
          productId: productId,
          inventoryBalanceId: inventoryBalanceId,
          quantity: quantity,
          quantityExact: quantityExact,
          reason: reason,
        ),
    productId: productId,
  );

  Future<InventoryLot> updateLotExpiry(
    String productId,
    InventoryLot lot,
    DateTime date,
  ) => _mutate(
    () => ref
        .read(inventoryRepositoryProvider)
        .updateLotExpiry(
          farmId: farmId,
          productId: productId,
          lot: lot,
          expiryDate: date,
        ),
    productId: productId,
  );

  Future<void> delete(String productId) => _mutate(
    () => ref
        .read(inventoryRepositoryProvider)
        .deleteProduct(farmId: farmId, productId: productId),
    productId: productId,
  );

  Future<InventoryProduct> restore(String productId) => _mutate(
    () => ref
        .read(inventoryRepositoryProvider)
        .restoreProduct(farmId: farmId, productId: productId),
    productId: productId,
  );

  Future<InventoryStockResult> stockIn({
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
  }) => _mutate(
    () => ref
        .read(inventoryRepositoryProvider)
        .recordStockIn(
          farmId: farmId,
          productId: productId,
          lotNumber: lotNumber,
          receivedAt: receivedAt,
          expiryDate: expiryDate,
          quantity: quantity,
          quantityExact: quantityExact,
          unitPrice: unitPrice,
          supplierName: supplierName,
          supplierId: supplierId,
          reason: reason,
        ),
    productId: productId,
  );

  Future<InventoryStockResult> adjust({
    required String productId,
    required String inventoryBalanceId,
    required bool increase,
    required double quantity,
    String? quantityExact,
    required String reason,
  }) => _mutate(
    () => ref
        .read(inventoryRepositoryProvider)
        .recordAdjustment(
          farmId: farmId,
          productId: productId,
          inventoryBalanceId: inventoryBalanceId,
          increase: increase,
          quantity: quantity,
          quantityExact: quantityExact,
          reason: reason,
        ),
    productId: productId,
  );

  Future<R> _mutate<R>(
    Future<R> Function() operation, {
    String? productId,
  }) async {
    if (ref.read(authControllerProvider).value?.role != AccountRole.farmOwner) {
      throw const UnsupportedRoleException();
    }
    if (state.isLoading) {
      throw const ApiException('Thao tác trước đang được xử lý.');
    }
    state = const AsyncLoading<void>();
    try {
      final result = await runAuthenticated(operation);
      if (!ref.mounted) return result;
      state = const AsyncData<void>(null);
      ref.invalidate(inventoryListControllerProvider(farmId));
      ref.invalidate(filteredInventoryListControllerProvider);
      ref.invalidate(inventoryHistoryControllerProvider(farmId));
      ref.invalidate(filteredInventoryHistoryControllerProvider);
      if (productId != null) {
        ref.invalidate(
          inventoryDetailControllerProvider((
            farmId: farmId,
            productId: productId,
          )),
        );
      }
      return result;
    } on Object catch (error, stackTrace) {
      if (ref.mounted) state = AsyncError<void>(error, stackTrace);
      rethrow;
    }
  }
}
