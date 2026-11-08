import 'package:dio/dio.dart';
import 'package:smartshrimp_app/core/config/app_config.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import '../../domain/entities/ai_diagnosis.dart';
import '../../domain/entities/ai_diagnosis_image.dart';

class AiDiagnosisApiService {
  AiDiagnosisApiService(this._client);
  final ApiClient _client;
  static const _pageSize = 10;

  String _base(String seasonId) =>
      '/technician/seasons/${Uri.encodeComponent(seasonId)}/ai-diagnoses';

  Future<AiDiagnosisPage> list(String seasonId, {String? cursor}) async {
    final response = await _client.get(
      _base(seasonId),
      authenticated: true,
      queryParameters: {'limit': _pageSize, 'cursor': ?cursor},
    );
    final items = response
        .requireListData()
        .map(AiDiagnosisSummary.parse)
        .toList();
    final pagination = AiDiagnosisPagination.parse(response.meta);
    if (items.length > _pageSize ||
        items.map((item) => item.id).toSet().length != items.length ||
        pagination.totalResults < items.length ||
        (items.isEmpty && pagination.hasNextPage) ||
        (pagination.hasNextPage && pagination.nextCursor == cursor)) {
      throw const InvalidResponseException();
    }
    return AiDiagnosisPage(items: items, pagination: pagination);
  }

  Future<AiDiagnosisDetail> detail(String seasonId, String diagnosisId) async {
    final response = await _client.get(
      '${_base(seasonId)}/${Uri.encodeComponent(diagnosisId)}',
      authenticated: true,
    );
    final value = _detail(response.requireMapData(), seasonId);
    if (value.id != diagnosisId) throw const InvalidResponseException();
    return value;
  }

  Future<AiDiagnosisDetail> create(
    String seasonId,
    List<AiDiagnosisImage> images,
  ) async {
    final form = FormData();
    for (final image in images) {
      form.files.add(
        MapEntry(
          'images',
          MultipartFile.fromBytes(
            image.bytes,
            filename: image.fileName,
            contentType: DioMediaType.parse(image.mimeType),
          ),
        ),
      );
    }
    final response = await _client.post(
      _base(seasonId),
      authenticated: true,
      data: form,
      headers: {'Content-Type': 'multipart/form-data'},
      receiveTimeout: AppConfig.aiDiagnosisTimeout,
      sendTimeout: AppConfig.aiDiagnosisTimeout,
    );
    return _detail(response.requireMapData(), seasonId);
  }

  AiDiagnosisDetail _detail(Map<String, dynamic> json, String seasonId) {
    final value = AiDiagnosisDetail.parse(json);
    if (value.seasonId != seasonId) throw const InvalidResponseException();
    return value;
  }
}
