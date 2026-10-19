import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/task_controller.dart';
import '../home/owner_dashboard_fixtures.dart';
import 'task_fixtures.dart';

class ControlledTaskRepository extends TaskFixtureRepository {
  final saveCompletion = Completer<TaskItem>();
  final nextPage = Completer<TaskPage>();
  int saves = 0;
  @override
  Future<TaskItem> save(TaskInput input, {TaskItem? original}) {
    saves++;
    return saveCompletion.future;
  }

  @override
  Future<TaskPage> list(TaskStatus tab, {int page = 1}) async => page == 1
      ? (await super.list(tab)).copyWith(hasNextPage: true)
      : nextPage.future;
}

final draft = TaskInput(
  title: 'Kiểm tra',
  dueAt: DateTime.now().add(const Duration(hours: 1)),
  farmId: 'farm',
  priority: TaskPriority.normal,
  assignedTo: 'tech',
);

Future<ProviderContainer> setup(
  ControlledTaskRepository repo, {
  AccountRole role = AccountRole.farmOwner,
}) async {
  final container = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        DashboardFixtureAuth(role: role),
      ),
      taskRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(container.dispose);
  await container.read(authControllerProvider.future);
  return container;
}

void main() {
  test(
    'N/A: duplicate submissions share no extra mutation and invalidate after success',
    () async {
      final repo = ControlledTaskRepository();
      final c = await setup(repo);
      final sub = c.listen(taskMutationProvider, (_, _) {});
      addTearDown(sub.close);
      await c.read(taskMutationProvider.future);
      final controller = c.read(taskMutationProvider.notifier);
      final first = controller.save(draft);
      await expectLater(controller.save(draft), throwsA(isA<ApiException>()));
      expect(repo.saves, 1);
      repo.saveCompletion.complete(pendingTask);
      expect(await first, pendingTask);
      expect(c.read(taskMutationProvider).hasError, isFalse);
    },
  );
  test('A: unsupported actor cannot read or mutate owner tasks', () async {
    final repo = ControlledTaskRepository();
    final c = await setup(repo, role: AccountRole.technician);
    final listSub = c.listen(taskListProvider(TaskStatus.pending), (_, _) {});
    addTearDown(listSub.close);
    final sub = c.listen(taskMutationProvider, (_, _) {});
    addTearDown(sub.close);
    await c.read(taskMutationProvider.future);
    await expectLater(
      c.read(taskListProvider(TaskStatus.pending).future),
      throwsA(isA<UnsupportedRoleException>()),
    );
    await expectLater(
      c.read(taskMutationProvider.notifier).save(draft),
      throwsA(isA<UnsupportedRoleException>()),
    );
    expect(repo.saves, 0);
  });
  test(
    'B: an old load-more response cannot overwrite a refreshed list',
    () async {
      final repo = ControlledTaskRepository();
      final c = await setup(repo);
      final sub = c.listen(taskListProvider(TaskStatus.pending), (_, _) {});
      addTearDown(sub.close);
      final initial = await c.read(taskListProvider(TaskStatus.pending).future);
      final controller = c.read(taskListProvider(TaskStatus.pending).notifier);
      final more = controller.loadMore();
      await controller.refresh();
      repo.nextPage.complete(initial.copyWith(page: 2, items: [cancelledTask]));
      await more;
      expect(c.read(taskListProvider(TaskStatus.pending)).value?.page, 1);
      expect(
        c.read(taskListProvider(TaskStatus.pending)).value?.items,
        initial.items,
      );
    },
  );
  test(
    'B: a completed request after provider disposal cannot write state',
    () async {
      final repo = ControlledTaskRepository();
      final c = await setup(repo);
      final sub = c.listen(taskMutationProvider, (_, _) {});
      await c.read(taskMutationProvider.future);
      final pending = c.read(taskMutationProvider.notifier).save(draft);
      sub.close();
      await c.pump();
      repo.saveCompletion.complete(pendingTask);
      expect(await pending, pendingTask);
    },
  );
}
