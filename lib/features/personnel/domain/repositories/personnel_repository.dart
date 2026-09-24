import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';

abstract interface class PersonnelRepository {
  Future<ManagedPersonnelPage> getPersonnel({
    String? cursor,
    int limit = 20,
    AccountRole? role,
    AccountStatus? status,
    String? search,
  });

  Future<ManagedPersonnel> getPersonnelById(String personnelId);
}
