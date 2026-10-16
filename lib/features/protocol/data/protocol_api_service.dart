import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/domain/repositories/protocol_repository.dart';

/// ApiClient owns the envelope and session policy; this read/write adapter maps feature data.
final class ProtocolApiService implements ProtocolRepository {
  ProtocolApiService(this._client);
  final ApiClient _client;

  @override
  Future<ProtocolPage> list({
    String? seasonId,
    required ProtocolType type,
    bool pendingOnly = false,
    int page = 1,
  }) async {
    final response = await _client.get(
      '/owner/protocols',
      authenticated: true,
      queryParameters: {
        'seasonId': ?seasonId,
        'protocolType': type == ProtocolType.treatment
            ? 'TREATMENT'
            : 'PRODUCTION',
        if (pendingOnly) 'status': 'PENDING_APPROVAL',
        'page': page,
        'limit': 20,
      },
    );
    return ProtocolPage.parse(response.requireListData(), response.meta);
  }

  @override
  Future<ProtocolDetail> detail(String id) async => ProtocolDetail.parse(
    (await _client.get(
      '/owner/protocols/$id',
      authenticated: true,
    )).requireMapData(),
  );
  @override
  Future<ProtocolDay> day(String id, int day) async => ProtocolDay.parse(
    (await _client.get(
      '/owner/protocols/$id/days/$day',
      authenticated: true,
    )).requireMapData(),
  );
  @override
  Future<List<ProtocolInventoryEntry>> inventory(
    String id,
    String scheduleId,
  ) async {
    final response = await _client.get(
      '/owner/protocols/$id/schedules/$scheduleId/inventory-transactions',
      authenticated: true,
    );
    return response.requireListData().map((row) {
      if (row is! Map<String, dynamic>) throw const InvalidResponseException();
      return ProtocolInventoryEntry.parse(row);
    }).toList();
  }

  @override
  Future<void> review(
    String id, {
    required DateTime updatedAt,
    required bool approve,
    String? reason,
  }) async {
    await _client.post(
      '/owner/protocols/$id/review',
      authenticated: true,
      data: {
        'decision': approve ? 'APPROVE' : 'REJECT',
        'updatedAt': updatedAt.toUtc().toIso8601String(),
        if (!approve) 'reason': reason?.trim(),
      },
    );
  }
}
