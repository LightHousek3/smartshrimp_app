import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/entities/ai_diagnosis.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/entities/ai_diagnosis_image.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/repositories/ai_diagnosis_repository.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/repositories/assigned_season_repository.dart';

Map<String, dynamic> diagnosisJson({
  bool error = false,
  String id = 'diagnosis',
  String predictedLabel = 'Đốm trắng',
  double confidence = 0.9,
  bool recognized = true,
}) => {
  'id': id,
  'seasonId': 'season',
  'createdAt': '2026-11-05T02:05:00Z',
  'runStatus': error ? 'ERROR' : 'SUCCESS',
  'imageUrls': [
    'https://images.example.test/private/shrimp.png?signature=private',
  ],
  'imageUrlsExpireAt': '2030-11-05T02:10:00Z',
  'processingTimeMs': 1406,
  'modelVersion': 'cvio-checkpoint',
  if (error)
    'error': {
      'code': 'AI_UNAVAILABLE',
      'message': 'Dịch vụ nhận diện chưa sẵn sàng.',
    }
  else ...{
    'recognitionStatus': recognized ? 'RECOGNIZED' : 'UNRECOGNIZED',
    'predictedLabel': recognized ? predictedLabel : null,
    'confidence': confidence,
    'predictions': [
      {'label': predictedLabel, 'probability': confidence},
      for (final (index, label) in [
        'Khỏe mạnh',
        'Mang đen',
        'Đốm trắng',
        'Đốm trắng và mang đen',
      ].where((label) => label != predictedLabel).indexed)
        {
          'label': label,
          'probability': (1 - confidence) * [0.5, 0.3, 0.2][index],
        },
    ],
    'recommendation': recognized
        ? 'Ghi nhận dấu hiệu bất thường và liên hệ Chuyên gia để kiểm tra.'
        : 'Vui lòng cung cấp lại ảnh tôm rõ nét, đủ sáng và thấy rõ vùng nghi bệnh để hỗ trợ nhận diện, hoặc liên hệ Chuyên gia để kiểm tra.',
  },
};

Map<String, dynamic> summaryJson({
  String id = 'diagnosis',
  bool error = false,
  double confidence = 0.9,
  bool recognized = true,
}) => {
  'id': id,
  'createdAt': '2026-11-05T02:05:00Z',
  'runStatus': error ? 'ERROR' : 'SUCCESS',
  'imageCount': 1,
  if (!error) ...{
    'recognitionStatus': recognized ? 'RECOGNIZED' : 'UNRECOGNIZED',
    'predictedLabel': recognized ? 'Đốm trắng' : null,
    'confidence': confidence,
  },
};

AiDiagnosisPage diagnosisPage({bool more = false, String id = 'diagnosis'}) =>
    AiDiagnosisPage(
      items: [AiDiagnosisSummary.parse(summaryJson(id: id))],
      pagination: AiDiagnosisPagination(
        totalResults: more ? 2 : 1,
        hasNextPage: more,
        nextCursor: more ? 'cursor-1' : null,
      ),
    );

AiDiagnosisImage sampleImage() => AiDiagnosisImage(
  bytes: Uint8List.fromList(
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/a9sAAAAASUVORK5CYII=',
    ),
  ),
  mimeType: 'image/png',
  fileName: 'shrimp.png',
);

class DiagnosisFixtureRepository implements AiDiagnosisRepository {
  int creates = 0, details = 0, lists = 0;
  AiDiagnosisDetail result = AiDiagnosisDetail.parse(diagnosisJson());
  @override
  Future<AiDiagnosisPage> list(String seasonId, {String? cursor}) async {
    lists++;
    return diagnosisPage();
  }

  @override
  Future<AiDiagnosisDetail> detail(String seasonId, String diagnosisId) async {
    details++;
    return result;
  }

  @override
  Future<AiDiagnosisDetail> create(
    String seasonId,
    List<AiDiagnosisImage> images,
  ) async {
    creates++;
    return result;
  }
}

class PersistedDiagnosisRepository extends DiagnosisFixtureRepository {
  AiDiagnosisDetail? saved;
  @override
  Future<AiDiagnosisDetail> create(
    String seasonId,
    List<AiDiagnosisImage> images,
  ) async {
    final detail = await super.create(seasonId, images);
    saved = detail;
    return detail;
  }

  @override
  Future<AiDiagnosisPage> list(String seasonId, {String? cursor}) async {
    final page = await super.list(seasonId, cursor: cursor);
    final detail = saved;
    if (detail == null) return page;
    final items = [
      AiDiagnosisSummary(
        id: detail.id,
        createdAt: detail.createdAt,
        runStatus: detail.runStatus,
        imageCount: detail.imageUrls.length,
        predictedLabel: detail.predictedLabel,
        confidence: detail.confidence,
      ),
      ...page.items.where((item) => item.id != detail.id),
    ];
    return AiDiagnosisPage(
      items: items,
      pagination: AiDiagnosisPagination(
        totalResults: items.length,
        hasNextPage: false,
      ),
    );
  }
}

AiDiagnosisPage paginatedDiagnosisPage(int start) {
  const total = 25;
  final count = total - start < 10 ? total - start : 10;
  final next = start + count;
  return AiDiagnosisPage(
    items: List.generate(
      count,
      (i) =>
          AiDiagnosisSummary.parse(summaryJson(id: 'diagnosis-${start + i}')),
    ),
    pagination: AiDiagnosisPagination(
      totalResults: total,
      hasNextPage: next < total,
      nextCursor: next < total ? 'cursor-$next' : null,
    ),
  );
}

class PaginatedDiagnosisRepository extends DiagnosisFixtureRepository {
  final cursors = <String?>[];
  Completer<AiDiagnosisPage>? secondPage;
  bool failNextPage = false;
  @override
  Future<AiDiagnosisPage> list(String seasonId, {String? cursor}) async {
    lists++;
    cursors.add(cursor);
    if (cursor != null && failNextPage) {
      failNextPage = false;
      throw const ApiException('Không tải được trang tiếp theo.');
    }
    if (cursor == 'cursor-10' && secondPage != null) return secondPage!.future;
    final start = cursor == null
        ? 0
        : int.parse(cursor.substring('cursor-'.length));
    return paginatedDiagnosisPage(start);
  }
}

class DiagnosisFixturePicker implements AiDiagnosisImagePicker {
  List<AiDiagnosisImage> selection = [sampleImage()];
  Object? error;
  @override
  Future<List<AiDiagnosisImage>> pick(
    AiImageSource source, {
    required int limit,
  }) async {
    if (error != null) throw error!;
    return selection;
  }
}

AssignedSeasonDetail diagnosisSeason(AssignedSeasonStatus status) =>
    AssignedSeasonDetail(
      id: 'season',
      name: 'Vụ Đông Xuân 2026',
      status: status,
      shrimpType: ShrimpType.whiteleg,
      pondId: 'pond',
      pondName: 'Ao A3',
      pondType: 'GROW_OUT',
      pondStatus: 'ACTIVE',
      farmId: 'farm',
      farmName: 'Trại tôm',
      personnel: [],
      otherAssignedSeasons: [],
      assignedAt: DateTime.utc(2026),
    );

class DiagnosisFixtureSeasons implements AssignedSeasonRepository {
  AssignedSeasonStatus status = AssignedSeasonStatus.active;
  @override
  Future<AssignedSeasonDetail> getAssignedSeason(String seasonId) async =>
      diagnosisSeason(status);
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
