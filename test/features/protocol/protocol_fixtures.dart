import 'dart:async';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/domain/repositories/protocol_repository.dart';

Map<String, dynamic> cardJson({
  String type = 'PRODUCTION',
  String status = 'PENDING_APPROVAL',
}) => {
  'id': 'protocol-1',
  'seasonId': 'season-1',
  'protocolType': type,
  'title': type == 'TREATMENT'
      ? 'Phác đồ điều trị Phân trắng — Ao A3 v2'
      : 'Mô hình nuôi tôm thẻ 90 ngày — tham chiếu Khuyến nông',
  'summary': type == 'TREATMENT'
      ? 'Điều chỉnh liều Doxycycline và bổ sung Probiotic sau khi v1 cho hiệu quả chậm. Duy trì 5 ngày điều trị.'
      : 'Mô hình kỹ thuật tham chiếu phù hợp nguyên tắc VietGAP, không phải một công thức VietGAP bắt buộc. DOC 1–30 chia 6 cữ/ngày; DOC 31–90 chia 4 cữ/ngày với tổng khẩu phần tham chiếu 3% sinh khối. Chế phẩm xử lý nước dùng định kỳ 4 ngày/lần.',
  'versionNo': type == 'TREATMENT' ? 2 : 1,
  'status': status,
  'authorName': 'TS. Phạm Hải Đăng',
  'submittedAt': '2026-06-20T02:00:00Z',
  'diseaseCaseId': type == 'TREATMENT' ? 'case-1' : null,
  'diseaseCaseTitle': type == 'TREATMENT'
      ? 'Nghi phân trắng & mềm vỏ — Ao A3'
      : null,
  'seasonName': 'Vụ Đông Xuân 2025',
  'pondName': 'Ao A3',
  'farmName': 'Trang trại Cửa Lấp',
};
Map<String, dynamic> detailJson({
  String type = 'PRODUCTION',
  String status = 'PENDING_APPROVAL',
}) => {
  ...cardJson(type: type, status: status),
  'updatedAt': '2026-06-20T02:00:00Z',
  'durationDays': type == 'TREATMENT' ? 7 : 90,
  'anchorDate': type == 'TREATMENT' && status == 'PENDING_APPROVAL'
      ? null
      : '2026-06-28',
  'canReview': status == 'PENDING_APPROVAL',
  'reviewedAt': status == 'APPROVED' ? '2026-06-20T08:10:00Z' : null,
  'reviewerName': status == 'APPROVED' ? 'Nguyễn Văn Đạt' : null,
  'dayMarkers': status == 'APPROVED'
      ? [
          for (var day = 1; day <= 5; day++)
            {'day': day, 'completed': 7, 'planned': 0, 'cancelled': 0},
        ]
      : [],
  'history': [
    {
      'id': 'history-1',
      'fromStatus': null,
      'toStatus': 'DRAFT',
      'changedByName': 'TS. Phạm Hải Đăng',
      'changedAt': '2026-06-18T01:00:00Z',
      'reason': null,
    },
    {
      'id': 'history-2',
      'fromStatus': 'DRAFT',
      'toStatus': 'PENDING_APPROVAL',
      'changedByName': 'TS. Phạm Hải Đăng',
      'changedAt': '2026-06-20T02:00:00Z',
      'reason': null,
    },
  ],
};
Map<String, dynamic> dayRowJson({
  String status = 'PENDING_APPROVAL',
  bool medicine = false,
}) => {
  'itemId': 'item-1',
  'operationType': medicine ? 'MEDICINE' : 'FEEDING',
  'productName': medicine
      ? 'Doxycycline 98% (trộn thức ăn)'
      : 'Thức ăn công nghiệp 40% đạm — cỡ 0',
  'time': '06:30',
  'doseBasis': medicine ? 'PER_KG_BIOMASS' : 'FIXED_QUANTITY',
  'doseValue': medicine ? .05 : 1.6,
  'doseUnit': medicine ? 'G' : 'KG',
  'unit': 'KG',
  'status': status,
  'instructions':
      'Rải đều quanh ao. Lượng thực tế phải điều chỉnh theo bắt mồi, thời tiết và chất lượng nước.',
  if (status == 'COMPLETED') ...{
    'scheduleId': 'schedule-1',
    'plannedQuantity': 1.6,
    'actualQuantity': 1.35,
    'actualUnit': 'KG',
    'executorName': 'Cô Thái Bảo',
    'executedAt': '2026-06-28T23:38:00Z',
    'varianceReason': 'Giảm 0,25 kg vì mưa rào, tôm giảm bắt mồi.',
  },
};

class ProtocolFixtureRepository implements ProtocolRepository {
  @override
  Future<List<ProtocolMaterialOption>> materialOptions(
    String id,
    String itemId, {
    String search = '',
  }) async {
    materialOptionsCalls++;
    return [ProtocolMaterialOption.parse(materialOptionJson())];
  }

  ProtocolFixtureRepository({
    this.type = 'PRODUCTION',
    this.status = 'PENDING_APPROVAL',
    this.empty = false,
    this.itemCount = 1,
    this.anchorDate,
    this.v2 = false,
  });
  final String type;
  String status;
  final bool empty;
  final int itemCount;
  final String? anchorDate;
  final bool v2;
  int materialOptionsCalls = 0;
  Map<String, String> selectedMaterials = {};
  int reviewedContentVersion = 1;
  int listCalls = 0;
  int detailCalls = 0;
  int reviewCalls = 0;
  final List<int> days = [];
  bool? approved;
  String? rejectionReason;
  DateTime? version;
  Object? readError;
  Object? reviewError;
  Completer<void>? reviewGate;
  Completer<ProtocolDay>? firstDay;
  @override
  Future<ProtocolPage> list({
    String? seasonId,
    required ProtocolType type,
    bool pendingOnly = false,
    int page = 1,
  }) async {
    listCalls++;
    if (readError != null) throw readError!;
    return ProtocolPage(
      items: empty
          ? []
          : List.generate(
              itemCount,
              (index) => ProtocolCardData.parse({
                ...cardJson(
                  type: type == ProtocolType.production
                      ? 'PRODUCTION'
                      : 'TREATMENT',
                  status: status,
                ),
                'id': 'protocol-${index + 1}',
              }),
            ),
      page: page,
      hasNextPage: false,
      productionCount: empty ? 0 : itemCount,
      treatmentCount: empty
          ? 0
          : itemCount == 1
          ? 2
          : itemCount,
    );
  }

  @override
  Future<ProtocolDetail> detail(String id) async {
    detailCalls++;
    if (readError != null) throw readError!;
    return ProtocolDetail.parse({
      ...detailJson(type: type, status: status),
      'id': id,
      if (v2) 'contentVersion': 2,
      if (v2) 'materialReviews': [materialReviewJson()],
      if (anchorDate != null) 'anchorDate': anchorDate,
      if (status == 'REJECTED') 'rejectionReason': rejectionReason,
    });
  }

  @override
  Future<ProtocolDay> day(String id, int day) async {
    days.add(day);
    if (day == 1 && firstDay != null) return firstDay!.future;
    return ProtocolDay.parse({
      'day': day,
      'date': type == 'TREATMENT' && status == 'PENDING_APPROVAL'
          ? null
          : DateTime.parse(
              anchorDate ?? '2026-06-28',
            ).add(Duration(days: day - 1)).toIso8601String().substring(0, 10),
      'rows': [
        dayRowJson(
          status: status == 'APPROVED'
              ? 'COMPLETED'
              : status == 'PENDING_APPROVAL'
              ? status
              : 'NOT_GENERATED',
          medicine: type == 'TREATMENT',
        ),
      ],
    });
  }

  @override
  Future<List<ProtocolInventoryEntry>> inventory(
    String id,
    String scheduleId,
  ) async => [];
  @override
  Future<void> review(
    String id, {
    required DateTime updatedAt,
    required bool approve,
    String? reason,
    int contentVersion = 1,
    Map<String, String> materialSelections = const {},
  }) async {
    reviewCalls++;
    selectedMaterials = materialSelections;
    reviewedContentVersion = contentVersion;
    approved = approve;
    rejectionReason = reason;
    version = updatedAt;
    if (reviewGate != null) await reviewGate!.future;
    if (reviewError != null) throw reviewError!;
    status = approve ? 'APPROVED' : 'REJECTED';
  }
}

Map<String, dynamic> materialReviewJson() => {
  'itemId': 'item-1',
  'name': 'Feed đề xuất',
  'productId': null,
  'operationType': 'FEEDING',
  'doseBasis': 'FIXED_QUANTITY',
  'doseValue': '0.7000',
  'doseUnit': 'KG',
  'dailyDoseIncrement': '0.0500',
  'firstDay': 10,
  'lastDay': 29,
  'repeatIntervalDays': 1,
  'recurrenceAnchorDay': 1,
  'doseAnchorDay': 1,
  'mealNumber': 1,
  'plannedTime': '06:00:12.123',
  'requiresResolution': true,
  'resolutionMessage': 'Cần chọn catalog đủ điều kiện.',
  'proposed': {
    'name': 'Feed đề xuất',
    'category': 'feed',
    'unit': 'kg',
    'description': 'Mô tả gốc',
    'manufacturer': {'name': 'Nhà sản xuất đề xuất'},
    'productCompliance': {
      'evidenceUrls': ['https://example.test/original'],
      'containsAntibiotic': false,
    },
  },
  'catalog': null,
};

Map<String, dynamic> materialOptionJson() => {
  'id': 'catalog-1',
  'name': 'Catalog Feed',
  'unit': 'KG',
  'manufacturerName': 'Nhà sản xuất catalog',
  'material': {
    'name': 'Catalog Feed',
    'category': 'FEED',
    'unit': 'KG',
    'manufacturerId': 'maker',
    'manufacturer': {'name': 'Nhà sản xuất catalog'},
    'compliance': {
      'regulatoryType': 'feed',
      'registrationNumber': '01-123456',
      'ingredientsText': 'Protein',
      'usageInstructions': 'Theo nhãn',
      'containsAntibiotic': false,
      'withdrawalDays': '0.000',
      'complianceStatus': 'reviewed',
      'evidenceUrls': ['https://example.test/catalog'],
      'checkedBy': 'owner',
      'checkedAt': '2026-10-30T00:00:00Z',
      'reviewNote': 'Đã đối chiếu hồ sơ',
    },
  },
};
