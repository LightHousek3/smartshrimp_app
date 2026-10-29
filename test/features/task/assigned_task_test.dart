import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/network/api_client.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/task/data/repositories/task_repository_impl.dart';
import 'package:smartshrimp_app/features/task/data/services/task_api_service.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/domain/repositories/task_repository.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/assigned_task_controller.dart';
import '../home/owner_dashboard_fixtures.dart';
import 'task_api_test.dart' show TaskSessionStore;
import 'task_models_repository_test.dart' show jsonTask;
import 'task_fixtures.dart';

Map<String, dynamic> assignedDetailJson() => {
  ...jsonTask(),
  'createdAt': '2026-10-26T07:07:00Z',
  'assigner': {'id': 'owner', 'name': 'Chủ trại'},
  'farm': {'id': 'farm', 'name': 'Trang trại'},
  'canOpenRelatedSeason': false,
};

class AssignedTaskFixtureRepository implements AssignedTaskRepository {
  final tasks = <String, TaskItem>{
    for (final item in [
      pendingTask,
      progressTask,
      completedTask,
      cancelledTask,
    ])
      item.id: item.copyWith(
        assigner: const TaskChoice(id: 'owner', name: 'Nguyễn Văn Đạt'),
        createdAt: DateTime.parse('2026-10-26T07:07:00Z'),
        dueAt: DateTime.parse(
          item.status == TaskStatus.cancelled
              ? '2026-10-28T07:07:00Z'
              : '2026-10-29T03:07:00Z',
        ),
        cancelledAt: item.status == TaskStatus.cancelled
            ? DateTime.parse('2026-10-28T09:07:00Z')
            : null,
        startedAt:
            item.status == TaskStatus.inProgress ||
                item.status == TaskStatus.completed
            ? DateTime.parse('2026-10-29T07:11:00Z')
            : null,
        completedAt: item.status == TaskStatus.completed
            ? DateTime.parse('2026-10-29T07:12:00Z')
            : null,
        pond: const TaskChoice(id: 'pond', name: 'Ao A5'),
        season: taskSeason,
        canOpenRelatedSeason: true,
      ),
  };
  Object? failure;
  Completer<TaskItem>? mutation;
  Completer<TaskPage>? nextPage;
  int advances = 0;
  final lists = <TaskGroup>[];
  @override
  Future<TaskPage> list(TaskGroup group, {int page = 1}) async {
    lists.add(group);
    if (failure != null) throw failure!;
    if (page > 1 && nextPage != null) return nextPage!.future;
    final items = tasks.values
        .where((task) => task.canEdit == (group == TaskGroup.todo))
        .toList();
    return TaskPage(
      items: items,
      page: page,
      hasNextPage: nextPage != null,
      totalResults: items.length,
      counts: TaskCounts(
        pending: tasks.values
            .where((t) => t.status == TaskStatus.pending)
            .length,
        inProgress: tasks.values
            .where((t) => t.status == TaskStatus.inProgress)
            .length,
        completed: tasks.values
            .where((t) => t.status == TaskStatus.completed)
            .length,
        cancelled: tasks.values
            .where((t) => t.status == TaskStatus.cancelled)
            .length,
      ),
      serverNow: taskNow,
    );
  }

  @override
  Future<TaskItem> detail(String id) async {
    if (failure != null) throw failure!;
    return tasks[id]!;
  }

  @override
  Future<TaskItem> advance(TaskItem task) async {
    advances++;
    if (failure != null) throw failure!;
    if (mutation != null) return mutation!.future;
    return tasks[task.id] = task.copyWith(
      status: task.status == TaskStatus.pending
          ? TaskStatus.inProgress
          : TaskStatus.completed,
      startedAt: task.startedAt ?? DateTime.now(),
      completedAt: task.status == TaskStatus.inProgress ? DateTime.now() : null,
    );
  }
}

void main() {
  test(
    'N: technician requests use compact query, exact paths and no client timestamps',
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
                statusCode: 200,
                data: {
                  'success': true,
                  'message': 'OK',
                  'data': request.path == '/me/tasks'
                      ? [jsonTask()..remove('assignee')]
                      : assignedDetailJson(),
                  'meta': {
                    'page': 2,
                    'totalResults': 1,
                    'hasNextPage': false,
                    'counts': {
                      'PENDING': 1,
                      'IN_PROGRESS': 0,
                      'COMPLETED': 0,
                      'CANCELLED': 0,
                    },
                    'serverNow': '2026-10-29T07:00:00Z',
                  },
                },
              ),
            );
          },
        ),
      );
      final repo = AssignedTaskRepositoryImpl(
        TaskApiService(ApiClient(dio, TaskSessionStore())),
      );
      expect(
        (await repo.list(TaskGroup.ended, page: 2)).items.single.assignee,
        isNull,
      );
      await repo.detail('task');
      await repo.advance(pendingTask);
      await repo.advance(progressTask);
      expect(requests.map((r) => '${r.method} ${r.path}'), [
        'GET /me/tasks',
        'GET /me/tasks/task',
        'PATCH /me/tasks/pending/status',
        'PATCH /me/tasks/progress/status',
      ]);
      expect(requests.first.queryParameters, {
        'group': 'ENDED',
        'page': 2,
        'limit': 20,
      });
      expect(requests[2].data, {'status': 'IN_PROGRESS'});
      expect(requests[3].data, {'status': 'COMPLETED'});
      expect(
        requests.map((r) => r.headers['Authorization']),
        everyElement('Bearer access-token'),
      );
    },
  );

  for (final missing in [
    'assigner',
    'assignee',
    'farm',
    'createdAt',
    'canOpenRelatedSeason',
  ]) {
    test('A: detail missing $missing fails safely', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://task.test'));
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (request, handler) => handler.resolve(
            Response(
              requestOptions: request,
              statusCode: 200,
              data: {
                'success': true,
                'message': 'OK',
                'data': assignedDetailJson()..remove(missing),
              },
            ),
          ),
        ),
      );
      await expectLater(
        TaskApiService(
          ApiClient(dio, TaskSessionStore()),
        ).assignedDetail('task'),
        throwsA(isA<InvalidResponseException>()),
      );
    });
  }

  test(
    'N/B: late completion/cancellation stay overdue, early completion and absent deadline do not',
    () {
      final task = pendingTask;
      final due = task.dueAt!;
      for (final status in [TaskStatus.completed, TaskStatus.cancelled]) {
        final late = task.copyWith(
          status: status,
          completedAt: due.add(const Duration(seconds: 1)),
          cancelledAt: due.add(const Duration(seconds: 1)),
        );
        expect(late.overdueAt(due.subtract(const Duration(days: 1))), isTrue);
        expect(
          late
              .copyWith(completedAt: due, cancelledAt: due)
              .overdueAt(DateTime.now()),
          isFalse,
        );
      }
      expect(task.copyWith(dueAt: null).overdueAt(DateTime.now()), isFalse);
      expect(
        task.copyWith(status: TaskStatus.unknown).overdueAt(DateTime.now()),
        isFalse,
      );
    },
  );

  Future<ProviderContainer> setup(
    AssignedTaskFixtureRepository repo, {
    AccountRole role = AccountRole.technician,
  }) async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          DashboardFixtureAuth(role: role),
        ),
        sessionStoreProvider.overrideWithValue(TaskSessionStore()),
        assignedTaskRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);
    await container.read(authControllerProvider.future);
    return container;
  }

  test(
    'N/A: duplicate progress is blocked and success refreshes both groups',
    () async {
      final repo = AssignedTaskFixtureRepository()
        ..mutation = Completer<TaskItem>();
      final c = await setup(repo);
      final sub = c.listen(assignedTaskMutationProvider, (_, _) {});
      addTearDown(sub.close);
      await c.read(assignedTaskMutationProvider.future);
      final controller = c.read(assignedTaskMutationProvider.notifier);
      final first = controller.advance(pendingTask);
      await expectLater(
        controller.advance(pendingTask),
        throwsA(isA<ApiException>()),
      );
      expect(repo.advances, 1);
      repo.mutation!.complete(progressTask);
      expect(await first, progressTask);
      expect(c.read(assignedTaskMutationProvider).hasError, isFalse);
    },
  );

  test('B: old pagination response cannot overwrite a refresh', () async {
    final repo = AssignedTaskFixtureRepository()
      ..nextPage = Completer<TaskPage>();
    final c = await setup(repo);
    final sub = c.listen(assignedTaskListProvider(TaskGroup.todo), (_, _) {});
    addTearDown(sub.close);
    final first = await c.read(assignedTaskListProvider(TaskGroup.todo).future);
    final controller = c.read(
      assignedTaskListProvider(TaskGroup.todo).notifier,
    );
    final more = controller.loadMore();
    await controller.refresh();
    repo.nextPage!.complete(first.copyWith(page: 2, items: [completedTask]));
    await more;
    expect(
      c.read(assignedTaskListProvider(TaskGroup.todo)).value?.items,
      first.items,
    );
  });

  for (final role in [AccountRole.farmOwner, AccountRole.expert]) {
    test('A: $role cannot read or mutate technician tasks', () async {
      final repo = AssignedTaskFixtureRepository();
      final c = await setup(repo, role: role);
      final sub = c.listen(assignedTaskDetailProvider('pending'), (_, _) {});
      addTearDown(sub.close);
      await expectLater(
        c.read(assignedTaskDetailProvider('pending').future),
        throwsA(isA<UnsupportedRoleException>()),
      );
      expect(repo.advances, 0);
    });
  }

  test(
    'A: session expiry clears auth while a network failure preserves it',
    () async {
      final repo = AssignedTaskFixtureRepository()
        ..failure = const NetworkException();
      final c = await setup(repo);
      final sub = c.listen(assignedTaskDetailProvider('pending'), (_, _) {});
      addTearDown(sub.close);
      await expectLater(
        c.read(assignedTaskDetailProvider('pending').future),
        throwsA(isA<NetworkException>()),
      );
      expect(c.read(authControllerProvider).value, isNotNull);
      repo.failure = const SessionExpiredException();
      c.invalidate(assignedTaskDetailProvider('pending'));
      await expectLater(
        c.read(assignedTaskDetailProvider('pending').future),
        throwsA(isA<SessionExpiredException>()),
      );
      expect(c.read(authControllerProvider).value, isNull);
    },
  );
}
