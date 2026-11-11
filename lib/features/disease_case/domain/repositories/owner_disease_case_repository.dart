import '../entities/owner_disease_case.dart';

abstract interface class DiseaseCaseRepository {
  Future<DiseaseCasePage> list({
    required String seasonId,
    required bool resolved,
    required int page,
  });

  Future<DiseaseCaseDetail> detail(String caseId);
}
