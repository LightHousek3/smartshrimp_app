import 'package:smartshrimp_app/features/harvest/domain/entities/harvest_event.dart';

abstract interface class HarvestSubmissionStore {
  Future<PendingHarvestSubmission?> read(String ownerId, String seasonId);
  Future<void> write(
    String ownerId,
    String seasonId,
    PendingHarvestSubmission submission,
  );
  Future<void> clear(
    String ownerId,
    String seasonId, {
    required String expectedKey,
  });
}
