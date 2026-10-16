import 'package:smartshrimp_app/features/harvest/domain/entities/harvest_event.dart';

abstract interface class HarvestRepository {
  Future<HarvestPage> list(String seasonId, Map<String, dynamic> query);
  Future<HarvestEvent> detail(String seasonId, String harvestId);
  Future<HarvestEvent> record(
    String seasonId,
    Map<String, dynamic> body,
    String key,
  );
}
