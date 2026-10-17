import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/harvest/domain/entities/harvest_event.dart';
import 'package:smartshrimp_app/features/harvest/domain/repositories/harvest_repository.dart';

/// Direct repository adapter, matching the dashboard pattern without a pass-through layer.
final class HarvestApiService implements HarvestRepository {
  HarvestApiService(this._client);
  final ApiClient _client;
  String _path(String seasonId) =>
      '/owner/seasons/${Uri.encodeComponent(seasonId)}/harvests';

  @override
  Future<HarvestPage> list(String seasonId, Map<String, dynamic> query) async {
    final response = await _client.get(
      _path(seasonId),
      queryParameters: query,
      authenticated: true,
    );
    try {
      final items = response
          .requireListData()
          .map((item) => HarvestEvent.fromJson(item as Map<String, dynamic>))
          .toList();
      final meta = response.meta!;
      final page = HarvestPage(
        items: items,
        limit: meta['limit'] as int,
        totalResults: meta['totalResults'] as int,
        hasNextPage: meta['hasNextPage'] as bool,
        nextCursor: meta['nextCursor'] as String?,
        totalWeightKg: (meta['totalWeightKg'] as num).toDouble(),
        totalRevenue: (meta['totalRevenue'] as num).toDouble(),
      );
      if (page.limit < 1 ||
          page.limit > 50 ||
          page.totalResults < 0 ||
          !page.totalWeightKg.isFinite ||
          page.totalWeightKg < 0 ||
          !page.totalRevenue.isFinite ||
          page.totalRevenue < 0 ||
          (page.hasNextPage &&
              (page.nextCursor == null ||
                  page.nextCursor!.isEmpty ||
                  items.isEmpty))) {
        throw const InvalidResponseException();
      }
      return page;
    } on InvalidResponseException {
      rethrow;
    } on Object catch (_, stack) {
      Error.throwWithStackTrace(const InvalidResponseException(), stack);
    }
  }

  @override
  Future<HarvestEvent> detail(String seasonId, String harvestId) async {
    final response = await _client.get(
      '${_path(seasonId)}/${Uri.encodeComponent(harvestId)}',
      authenticated: true,
    );
    return HarvestEvent.fromJson(response.requireMapData());
  }

  @override
  Future<HarvestEvent> record(
    String seasonId,
    Map<String, dynamic> body,
    String key,
  ) async {
    final response = await _client.post(
      _path(seasonId),
      data: body,
      headers: {'Idempotency-Key': key},
      authenticated: true,
    );
    return HarvestEvent.fromJson(response.requireMapData());
  }
}
