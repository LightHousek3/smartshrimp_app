import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/domain/repositories/farm_repository.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';

void main() {
  test(
    'searches, filters and paginates farms locally after one API load',
    () async {
      final repository = _CatalogFarmRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(_OwnerAuthRepository()),
          farmRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(authControllerProvider.future);
      final subscription = container.listen(
        farmListControllerProvider,
        (_, _) {},
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      final firstPage = await container.read(farmListControllerProvider.future);

      expect(firstPage.items, hasLength(20));
      expect(firstPage.totalResults, 24);
      expect(firstPage.totalPages, 2);
      expect(repository.getCalls, 1);

      await container.read(farmListControllerProvider.notifier).loadMore();
      expect(
        container.read(farmListControllerProvider).value?.items,
        hasLength(24),
      );
      expect(repository.getCalls, 1);

      await container
          .read(farmListControllerProvider.notifier)
          .load(search: 'TRANG TRẠI 23');
      expect(
        container.read(farmListControllerProvider).value?.items.single.name,
        'Trang trại 23',
      );
      expect(repository.getCalls, 1);

      await container
          .read(farmListControllerProvider.notifier)
          .load(status: FarmStatus.inactive);
      expect(
        container.read(farmListControllerProvider).value?.items.single.name,
        'Trang trại 24',
      );
      expect(repository.getCalls, 1);
    },
  );
}

const _owner = AuthAccount(
  id: 'owner-1',
  email: 'owner@smartshrimp.vn',
  role: AccountRole.farmOwner,
  status: AccountStatus.active,
);

final class _OwnerAuthRepository implements AuthRepository {
  @override
  Future<AuthAccount> login({
    required String email,
    required String password,
  }) async => _owner;

  @override
  Future<void> logout() async {}

  @override
  Future<AuthAccount?> restoreSession() async => _owner;
}

final class _CatalogFarmRepository implements FarmRepository {
  int getCalls = 0;

  late final List<Farm> farms = <Farm>[
    for (var index = 0; index < 25; index++)
      Farm(
        id: 'farm-$index',
        ownerId: _owner.id,
        name: 'Trang trại ${index.toString().padLeft(2, '0')}',
        status: index == 24 ? FarmStatus.inactive : FarmStatus.active,
      ),
  ];

  @override
  Future<List<Farm>> getFarms() async {
    getCalls++;
    return farms;
  }

  @override
  Future<Farm> getFarm(String farmId) async => farms.first;

  @override
  Future<Farm> createFarm({
    required String name,
    required FarmStatus status,
    String? address,
    double? latitude,
    double? longitude,
    double? totalAreaHectares,
  }) => throw UnimplementedError();

  @override
  Future<Farm> updateFarm({
    required String farmId,
    required String name,
    required FarmStatus status,
    String? address,
    double? latitude,
    double? longitude,
    double? totalAreaHectares,
  }) => throw UnimplementedError();

  @override
  Future<Farm> deleteFarm(String farmId) => throw UnimplementedError();
}
