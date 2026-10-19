import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';

abstract interface class TaskRemoteDataSource {
  Future<TaskPage> list(TaskStatus status, int page);
  Future<TaskItem> detail(String id);
  Future<TaskOptions> options(String? farmId);
  Future<TaskItem> create(Map<String, dynamic> body);
  Future<TaskItem> update(String id, Map<String, dynamic> body);
  Future<TaskItem> cancel(String id, String reason);
}

final class TaskApiService implements TaskRemoteDataSource {
  TaskApiService(this._client);
  final ApiClient _client;
  static const _path = '/owner/tasks';

  @override
  Future<TaskPage> list(TaskStatus status, int page) async {
    final response = await _client.get(
      _path,
      authenticated: true,
      queryParameters: {
        'status': taskStatusApiValue(status),
        'page': page,
        'limit': 20,
      },
    );
    final meta = response.meta;
    if (meta == null) throw const InvalidResponseException();
    return TaskPage.fromJson({...meta, 'items': response.requireListData()});
  }

  @override
  Future<TaskItem> detail(String id) async => TaskItem.fromJson(
    (await _client.get('$_path/$id', authenticated: true)).requireMapData(),
  );
  @override
  Future<TaskOptions> options(String? farmId) async => TaskOptions.fromJson(
    (await _client.get(
      '$_path/form-options',
      authenticated: true,
      queryParameters: {'farmId': ?farmId},
    )).requireMapData(),
  );
  @override
  Future<TaskItem> create(Map<String, dynamic> body) async => TaskItem.fromJson(
    (await _client.post(
      _path,
      authenticated: true,
      data: body,
    )).requireMapData(),
  );
  @override
  Future<TaskItem> update(String id, Map<String, dynamic> body) async =>
      TaskItem.fromJson(
        (await _client.patch(
          '$_path/$id',
          authenticated: true,
          data: body,
        )).requireMapData(),
      );
  @override
  Future<TaskItem> cancel(String id, String reason) async => TaskItem.fromJson(
    (await _client.patch(
      '$_path/$id/cancel',
      authenticated: true,
      data: {'reason': reason},
    )).requireMapData(),
  );
}
