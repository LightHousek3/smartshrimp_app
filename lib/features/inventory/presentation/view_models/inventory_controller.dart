import 'dart:typed_data';
import 'dart:async';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_substance.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_substance_repository.dart';
import 'package:smartshrimp_app/features/inventory/data/repositories/inventory_substance_repository_impl.dart';
import 'package:smartshrimp_app/features/inventory/data/services/inventory_substance_api_service.dart';
import 'package:smartshrimp_app/features/inventory/data/repositories/inventory_label_repository_impl.dart';
import 'package:smartshrimp_app/features/inventory/data/services/inventory_label_api_service.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_label.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_label_repository.dart';
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

final inventoryLabelRepositoryProvider = Provider<InventoryLabelRepository>((
  ref,
) {
  ref.watch(authControllerProvider.select((state) => state.value?.id));
  return InventoryLabelRepositoryImpl(
    InventoryLabelApiService(ref.watch(apiClientProvider)),
  );
});

final inventoryLabelControllerProvider = AsyncNotifierProvider.autoDispose
    .family<InventoryLabelController, void, String>(
      InventoryLabelController.new,
    );

final inventorySubstanceRepositoryProvider =
    Provider<InventorySubstanceRepository>(
      (ref) => InventorySubstanceRepositoryImpl(
        InventorySubstanceApiService(ref.watch(apiClientProvider)),
      ),
    );

final inventorySubstanceControllerProvider = AsyncNotifierProvider.autoDispose
    .family<InventorySubstanceController, InventorySubstanceState, String>(
      InventorySubstanceController.new,
    );

final class InventorySubstanceController
    extends _OwnerInventoryController<InventorySubstanceState> {
  InventorySubstanceController(this.farmId);
  final String farmId;
  Timer? _searchTimer;
  Timer? _checkTimer;
  int _searchGeneration = 0;
  int _checkGeneration = 0;

  @override
  InventorySubstanceState build() {
    requireOwner();
    ref.onDispose(() {
      _searchTimer?.cancel();
      _checkTimer?.cancel();
      _searchGeneration++;
      _checkGeneration++;
    });
    return const InventorySubstanceState();
  }

  void searchChanged(String query) {
    _searchTimer?.cancel();
    final generation = ++_searchGeneration;
    state = AsyncData(
      (state.value ?? const InventorySubstanceState()).copyWith(
        query: query,
        items: [],
        isSearching: true,
        isLoadingMore: false,
        hasNextPage: false,
        nextCursor: null,
        searchError: null,
      ),
    );
    _searchTimer = Timer(
      const Duration(milliseconds: 350),
      () => _search(query, generation),
    );
  }

  Future<void> _search(String query, int generation, {String? cursor}) async {
    try {
      final page = await runAuthenticated(
        () => ref
            .read(inventorySubstanceRepositoryProvider)
            .search(farmId: farmId, query: query, cursor: cursor),
      );
      if (!ref.mounted || generation != _searchGeneration) return;
      if (page.hasNextPage &&
          (page.items.isEmpty ||
              (int.tryParse(page.nextCursor ?? '') ?? -1) <=
                  (int.tryParse(cursor ?? '0') ?? 0))) {
        throw const InvalidResponseException();
      }
      final current = state.requireValue;
      final items = {
        for (final item in [
          ...(cursor == null ? <InventorySubstance>[] : current.items),
          ...page.items,
        ])
          item.id: item,
      };
      state = AsyncData(
        current.copyWith(
          items: items.values.toList(),
          isSearching: false,
          isLoadingMore: false,
          hasNextPage: page.hasNextPage,
          nextCursor: page.nextCursor,
          searchError: null,
        ),
      );
    } catch (error) {
      if (!ref.mounted || generation != _searchGeneration) return;
      state = AsyncData(
        state.requireValue.copyWith(
          isSearching: false,
          isLoadingMore: false,
          searchError: error is AppException
              ? error.message
              : 'Không tải được gợi ý thành phần.',
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null ||
        current.isSearching ||
        current.isLoadingMore ||
        !current.hasNextPage ||
        current.nextCursor == null) {
      return;
    }
    state = AsyncData(current.copyWith(isLoadingMore: true, searchError: null));
    await _search(current.query, _searchGeneration, cursor: current.nextCursor);
  }

  void ingredientsChanged(String text) {
    _checkTimer?.cancel();
    _checkGeneration++;
    state = AsyncData(
      (state.value ?? const InventorySubstanceState()).copyWith(
        check: null,
        checkError: null,
        isChecking: text.trim().isNotEmpty,
      ),
    );
    if (text.trim().isEmpty) return;
    _checkTimer = Timer(
      const Duration(milliseconds: 350),
      () => checkNow(text),
    );
  }

  Future<InventorySubstanceCheck?> checkNow(
    String text, {
    bool throwOnError = false,
  }) async {
    _checkTimer?.cancel();
    final generation = ++_checkGeneration;
    state = AsyncData(
      (state.value ?? const InventorySubstanceState()).copyWith(
        isChecking: true,
        checkError: null,
      ),
    );
    try {
      final result = await runAuthenticated(
        () => ref
            .read(inventorySubstanceRepositoryProvider)
            .check(farmId: farmId, ingredientsText: text),
      );
      if (ref.mounted && generation == _checkGeneration) {
        state = AsyncData(
          state.requireValue.copyWith(check: result, isChecking: false),
        );
      }
      return result;
    } catch (error) {
      if (ref.mounted && generation == _checkGeneration) {
        state = AsyncData(
          state.requireValue.copyWith(
            isChecking: false,
            check: null,
            checkError: error is AppException
                ? error.message
                : 'Chưa kiểm tra được thành phần. Vui lòng thử lại.',
          ),
        );
      }
      if (throwOnError) rethrow;
      return null;
    }
  }
}

final class InventoryLabelController extends _OwnerInventoryController<void> {
  InventoryLabelController(this.farmId);
  final String farmId;

  @override
  void build() => requireOwner();

  Future<InventoryLabelResult> scan(List<InventoryLabelImage> images) async {
    if (state.isLoading) {
      throw const ApiException('Đang đọc nhãn, vui lòng chờ.');
    }
    state = const AsyncLoading();
    try {
      final result = await runAuthenticated(
        () => ref
            .read(inventoryLabelRepositoryProvider)
            .scan(farmId: farmId, images: images),
      );
      if (ref.mounted) state = const AsyncData(null);
      return result;
    } catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
      rethrow;
    }
  }
}

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

  Future<void> delete(String productId, {String? confirmationToken}) => _mutate(
    () => ref
        .read(inventoryRepositoryProvider)
        .deleteProduct(
          farmId: farmId,
          productId: productId,
          confirmationToken: confirmationToken,
        ),
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
