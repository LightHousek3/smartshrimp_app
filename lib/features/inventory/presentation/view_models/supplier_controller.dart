import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/inventory/data/repositories/supplier_repository_impl.dart';
import 'package:smartshrimp_app/features/inventory/data/services/supplier_api_service.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/supplier_repository.dart';

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  ref.watch(authControllerProvider.select((state) => state.value?.id));
  return SupplierRepositoryImpl(
    SupplierApiService(ref.watch(apiClientProvider)),
  );
});
final supplierListControllerProvider = AsyncNotifierProvider.autoDispose
    .family<SupplierListController, List<InventorySupplier>, String>(
      SupplierListController.new,
    );
final supplierDetailProvider = FutureProvider.autoDispose
    .family<InventorySupplier, ({String farmId, String supplierId})>((
      ref,
      key,
    ) async {
      if (ref.watch(authControllerProvider).value?.role !=
          AccountRole.farmOwner) {
        throw const UnsupportedRoleException();
      }
      try {
        return await ref
            .watch(supplierRepositoryProvider)
            .getSupplier(key.farmId, key.supplierId);
      } on SessionExpiredException {
        if (ref.mounted) {
          await ref.read(authControllerProvider.notifier).expireSession();
        }
        rethrow;
      }
    });

final class SupplierListController
    extends AsyncNotifier<List<InventorySupplier>> {
  SupplierListController(this.farmId);
  final String farmId;
  bool _mutating = false;

  @override
  Future<List<InventorySupplier>> build() {
    ref.watch(authControllerProvider);
    _requireOwner();
    return _authenticated(
      () => ref.watch(supplierRepositoryProvider).getSuppliers(farmId),
    );
  }

  void _requireOwner() {
    if (ref.read(authControllerProvider).value?.role != AccountRole.farmOwner) {
      throw const UnsupportedRoleException();
    }
  }

  Future<T> _authenticated<T>(Future<T> Function() work) async {
    try {
      return await work();
    } on SessionExpiredException {
      if (ref.mounted) {
        await ref.read(authControllerProvider.notifier).expireSession();
      }
      rethrow;
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }

  Future<InventorySupplier> save({
    InventorySupplier? existing,
    required String name,
    String? contactName,
    String? phone,
    String? email,
    String? address,
    String? note,
  }) => _mutate(() async {
    final result = await ref
        .read(supplierRepositoryProvider)
        .saveSupplier(
          farmId: farmId,
          existing: existing,
          name: name,
          contactName: contactName,
          phone: phone,
          email: email,
          address: address,
          note: note,
        );
    if (ref.mounted) {
      final current = state.value;
      if (current != null) {
        final updated = [
          ...current.where((item) => item.id != result.id),
          result,
        ]..sort((a, b) => a.name.compareTo(b.name));
        state = AsyncData(updated);
      } else {
        // A quick creation can finish before the directory's initial request.
        // Reload it so that an older in-flight response cannot hide the new row.
        ref.invalidateSelf();
      }
      ref.invalidate(
        supplierDetailProvider((farmId: farmId, supplierId: result.id)),
      );
    }
    return result;
  });

  Future<void> delete(String supplierId) => _mutate(() async {
    await ref
        .read(supplierRepositoryProvider)
        .deleteSupplier(farmId, supplierId);
    if (ref.mounted) {
      final current = state.value;
      if (current != null) {
        state = AsyncData(current.where((s) => s.id != supplierId).toList());
      }
      ref.invalidate(
        supplierDetailProvider((farmId: farmId, supplierId: supplierId)),
      );
    }
  });

  Future<T> _mutate<T>(Future<T> Function() work) async {
    _requireOwner();
    if (_mutating) throw const ApiException('Thao tác trước đang được xử lý.');
    _mutating = true;
    final link = ref.keepAlive();
    try {
      return await _authenticated(work);
    } finally {
      _mutating = false;
      link.close();
    }
  }
}
