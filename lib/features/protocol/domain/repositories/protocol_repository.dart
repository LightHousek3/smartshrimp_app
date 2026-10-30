import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';

abstract interface class ProtocolRepository {
  Future<ProtocolPage> list({
    String? seasonId,
    required ProtocolType type,
    bool pendingOnly = false,
    int page = 1,
  });
  Future<ProtocolDetail> detail(String id);
  Future<ProtocolDay> day(String id, int day);
  Future<List<ProtocolInventoryEntry>> inventory(String id, String scheduleId);
  Future<List<ProtocolMaterialOption>> materialOptions(
    String id,
    String itemId, {
    String search = '',
  });
  Future<void> review(
    String id, {
    required DateTime updatedAt,
    required bool approve,
    String? reason,
    int contentVersion = 1,
    Map<String, String> materialSelections = const {},
  });
}
