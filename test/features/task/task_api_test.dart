import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/core/storage/session_store.dart';
import 'package:smartshrimp_app/features/task/data/services/task_api_service.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'task_models_repository_test.dart' show jsonTask;

class TaskSessionStore implements SessionStore {
  @override
  String? accessToken = 'access-token';
  @override
  String? refreshToken;
  @override
  Future<void> initialize() async {}
  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }

  @override
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }
}

void main() {
  test(
    'N: all task requests use exact method/path/query/body and Bearer auth',
    () async {
      final requests = <RequestOptions>[];
      final dio = Dio(BaseOptions(baseUrl: 'https://task.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            requests.add(request);
            handler.resolve(
              Response(
                requestOptions: request,
                statusCode: request.method == 'POST' ? 201 : 200,
                data: {
                  'success': true,
                  'message': 'OK',
                  'data': request.path.endsWith('form-options')
                      ? {'farms': [], 'technicians': [], 'seasons': []}
                      : request.path == '/owner/tasks' &&
                            request.method == 'GET'
                      ? [jsonTask()]
                      : jsonTask(),
                  'meta': {
                    'page': 2,
                    'totalResults': 21,
                    'hasNextPage': false,
                    'counts': {
                      'PENDING': 5,
                      'IN_PROGRESS': 21,
                      'COMPLETED': 3,
                      'CANCELLED': 0,
                    },
                    'serverNow': '2026-10-19T01:00:00Z',
                  },
                },
              ),
            );
          },
        ),
      );
      final api = TaskApiService(ApiClient(dio, TaskSessionStore()));
      final page = await api.list(TaskStatus.inProgress, 2);
      expect(page.items.single.id, 'task');
      expect(page.counts.pending, 5);
      expect(page.counts.inProgress, 21);
      expect(page.counts.completed, 3);
      expect(page.counts.cancelled, 0);
      expect(page.serverNow, DateTime.parse('2026-10-19T01:00:00Z'));
      expect(requests.first.queryParameters, {
        'status': 'IN_PROGRESS',
        'page': 2,
        'limit': 20,
      });
      await api.detail('task');
      await api.options('farm');
      await api.create({'title': 'Tạo'});
      await api.update('task', {'description': 'Theo dõi'});
      await api.cancel('task', 'Dừng');
      expect(requests.map((r) => '${r.method} ${r.path}'), [
        'GET /owner/tasks',
        'GET /owner/tasks/task',
        'GET /owner/tasks/form-options',
        'POST /owner/tasks',
        'PATCH /owner/tasks/task',
        'PATCH /owner/tasks/task/cancel',
      ]);
      expect(
        requests.map((r) => r.headers['Authorization']),
        everyElement('Bearer access-token'),
      );
      expect(requests[2].queryParameters, {'farmId': 'farm'});
      expect(requests[4].data, {'description': 'Theo dõi'});
      expect(requests[5].data, {'reason': 'Dừng'});
    },
  );
  for (final status in [400, 403, 404, 409, 429, 500]) {
    test('A: task API preserves backend status $status and message', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://task.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) {
            handler.reject(
              DioException(
                requestOptions: request,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: request,
                  statusCode: status,
                  data: {
                    'success': false,
                    'statusCode': status,
                    'message': 'Lỗi nhiệm vụ',
                  },
                ),
              ),
            );
          },
        ),
      );
      await expectLater(
        TaskApiService(ApiClient(dio, TaskSessionStore())).detail('task'),
        throwsA(
          isA<AppException>()
              .having((e) => e.message, 'message', 'Lỗi nhiệm vụ')
              .having((e) => e.statusCode, 'statusCode', status),
        ),
      );
    });
  }
}
