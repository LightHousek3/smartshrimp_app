import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/operation/data/services/operation_api_service.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';

void main() {
  group('OperationApiService', () {
    test('getSchedules passes query params and parses result list', () async {
      late RequestOptions capturedRequest;

      final service = OperationApiService(
        ApiClient(
          _dioWithHandler((request, handler) {
            capturedRequest = request;
            handler.resolve(
              _success(
                request,
                data: <String, dynamic>{
                  'summary': {
                    'planned': 2,
                    'completed': 1,
                    'cancelled': 0,
                    'total': 3,
                  },
                  'banner': {'hasBiomassWarning': false},
                  'season': {'id': 'season-1', 'name': 'Vụ 1'},
                  'schedules': <dynamic>[
                    _mockScheduleJson(id: 'sched-1', status: 'PLANNED'),
                    _mockScheduleJson(id: 'sched-2', status: 'COMPLETED'),
                  ],
                },
              ),
            );
          }),
          _FakeSessionStore(),
        ),
      );

      final result = await service.getSchedules(
        'season-1',
        status: 'PLANNED',
        operationType: 'FEEDING',
      );

      expect(capturedRequest.path, '/operations/seasons/season-1/schedules');
      expect(capturedRequest.queryParameters['status'], 'PLANNED');
      expect(capturedRequest.queryParameters['operationType'], 'FEEDING');

      expect(result.summary.total, 3);
      expect(result.schedules.length, 2);
      expect(result.schedules.first.status, OperationStatus.planned);
      expect(result.schedules.last.status, OperationStatus.completed);
    });

    test('getSchedule parses full schedule object', () async {
      final service = OperationApiService(
        ApiClient(
          _dioWithHandler((request, handler) {
            expect(request.path, '/operations/schedules/sched-123');
            handler.resolve(
              _success(
                request,
                data: _mockScheduleJson(
                  id: 'sched-123',
                  status: 'COMPLETED',
                  hasExecution: true,
                ),
              ),
            );
          }),
          _FakeSessionStore(),
        ),
      );

      final schedule = await service.getSchedule('sched-123');

      expect(schedule.id, 'sched-123');
      expect(schedule.status, OperationStatus.completed);
      expect(schedule.execution, isNotNull);
      expect(schedule.execution!.actualQuantity, 52.0);
    });

    test(
      'executeSchedule sends expected payload with idempotencyKey',
      () async {
        late RequestOptions capturedRequest;

        final service = OperationApiService(
          ApiClient(
            _dioWithHandler((request, handler) {
              capturedRequest = request;
              handler.resolve(
                _success(
                  request,
                  data: <String, dynamic>{
                    'id': 'exec-123',
                    'actualQuantity': 52.0,
                    'executedAt': '2026-10-08T08:00:00.000Z',
                    'varianceReason': 'Tôm ăn nhanh',
                    'note': 'Ghi nhận bình thường',
                  },
                ),
              );
            }),
            _FakeSessionStore(),
          ),
        );

        final execTime = DateTime.parse('2026-10-08T08:00:00Z');
        final execution = await service.executeSchedule(
          'sched-123',
          actualQuantity: 52.0,
          executedAt: execTime,
          varianceReason: 'Tôm ăn nhanh',
          note: 'Ghi nhận bình thường',
          idempotencyKey: 'idem-key-123',
        );

        expect(capturedRequest.path, '/operations/schedules/sched-123/execute');
        expect(capturedRequest.method, 'POST');
        final data = capturedRequest.data as Map<String, dynamic>;
        expect(data['actualQuantity'], 52.0);
        expect(data['varianceReason'], 'Tôm ăn nhanh');
        expect(data['note'], 'Ghi nhận bình thường');
        expect(data['idempotencyKey'], 'idem-key-123');

        expect(execution.id, 'exec-123');
        expect(execution.actualQuantity, 52.0);
        expect(execution.varianceReason, 'Tôm ăn nhanh');
      },
    );

    test('getSeasonStats parses operation statistics', () async {
      final service = OperationApiService(
        ApiClient(
          _dioWithHandler((request, handler) {
            expect(request.path, '/operations/seasons/season-123/stats');
            handler.resolve(
              _success(
                request,
                data: <String, dynamic>{
                  'total': 20,
                  'planned': 5,
                  'completed': 14,
                  'cancelled': 1,
                  'overdue': 2,
                  'completionRate': 70.0,
                  'byType': {
                    'FEEDING': {
                      'total': 12,
                      'planned': 3,
                      'completed': 9,
                      'cancelled': 0,
                    },
                  },
                },
              ),
            );
          }),
          _FakeSessionStore(),
        ),
      );

      final stats = await service.getSeasonStats('season-123');

      expect(stats.total, 20);
      expect(stats.completionRate, 70.0);
      expect(stats.byType['FEEDING']?.completed, 9);
    });
  });
}

Dio _dioWithHandler(
  FutureOr<void> Function(RequestOptions, RequestInterceptorHandler) onRequest,
) {
  final dio = Dio(BaseOptions(baseUrl: 'https://api.smartshrimp.test'));
  dio.interceptors.add(InterceptorsWrapper(onRequest: onRequest));
  return dio;
}

Response<Map<String, dynamic>> _success(
  RequestOptions request, {
  required Object? data,
}) => Response<Map<String, dynamic>>(
  requestOptions: request,
  statusCode: 200,
  data: <String, dynamic>{'success': true, 'message': 'Success', 'data': data},
);

Map<String, dynamic> _mockScheduleJson({
  required String id,
  required String status,
  bool hasExecution = false,
}) => <String, dynamic>{
  'id': id,
  'seasonId': 'season-1',
  'protocolItemId': 'item-1',
  'operationType': 'FEEDING',
  'scheduledAt': '2026-10-08T07:00:00Z',
  'plannedQuantity': 50.0,
  'unit': 'kg',
  'doseBasisSnapshot': 'PERCENT_BIOMASS',
  'doseValueSnapshot': 3.5,
  'calculationVersion': 'v1',
  'status': status,
  'product': {'id': 'prod-1', 'name': 'Thức ăn CP 01', 'unit': 'kg'},
  'protocolItem': {
    'id': 'item-1',
    'mealNumber': 1,
    'plannedTime': '07:00',
    'protocol': {
      'id': 'proto-1',
      'title': 'Quy trình nuôi chuẩn',
      'allowedVariancePct': 10.0,
    },
  },
  if (hasExecution)
    'execution': {
      'id': 'exec-$id',
      'actualQuantity': 52.0,
      'executedAt': '2026-10-08T07:15:00Z',
      'varianceReason': 'Tôm ăn nhanh',
    },
};

final class _FakeSessionStore implements SessionStore {
  @override
  String? accessToken = 'access-token';
  @override
  String? refreshToken = 'refresh-token';
  @override
  Future<void> clear() async {}
  @override
  Future<void> initialize() async {}
  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}
