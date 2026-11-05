import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/entities/ai_diagnosis.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/entities/ai_diagnosis_image.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/domain/repositories/ai_diagnosis_repository.dart';
import 'package:smartshrimp_app/features/ai_diagnosis/presentation/view_models/ai_diagnosis_controller.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import '../home/owner_dashboard_fixtures.dart';
import 'ai_diagnosis_fixtures.dart';

class ControlledDiagnosisRepository extends DiagnosisFixtureRepository {
  final completion = Completer<AiDiagnosisDetail>();
  final more = Completer<AiDiagnosisPage>();
  bool paginated = false;
  @override
  Future<AiDiagnosisDetail> create(
    String seasonId,
    List<AiDiagnosisImage> images,
  ) {
    creates++;
    return completion.future;
  }

  @override
  Future<AiDiagnosisPage> list(String seasonId, {String? cursor}) async {
    lists++;
    return cursor == null ? diagnosisPage(more: paginated) : more.future;
  }
}

class InitialHistoryRace extends DiagnosisFixtureRepository {
  final initial = Completer<AiDiagnosisPage>();
  @override
  Future<AiDiagnosisPage> list(String seasonId, {String? cursor}) {
    lists++;
    return lists == 1
        ? initial.future
        : Future.value(diagnosisPage(id: 'fresh'));
  }
}

Future<ProviderContainer> setup(
  DiagnosisFixtureRepository repo,
  DiagnosisFixturePicker picker, {
  AssignedSeasonStatus status = AssignedSeasonStatus.active,
  AccountRole role = AccountRole.technician,
}) async {
  final c = ProviderContainer(
    overrides: [
      authRepositoryProvider.overrideWithValue(
        DashboardFixtureAuth(role: role),
      ),
      assignedSeasonRepositoryProvider.overrideWithValue(
        DiagnosisFixtureSeasons()..status = status,
      ),
      aiDiagnosisRepositoryProvider.overrideWithValue(repo),
      aiDiagnosisImagePickerProvider.overrideWithValue(picker),
    ],
  );
  addTearDown(c.dispose);
  await c.read(authControllerProvider.future);
  final sub = c.listen(aiDiagnosisDraftProvider('season'), (_, _) {});
  addTearDown(sub.close);
  return c;
}

void main() {
  test(
    'N: a successful POST reloads the first history page from the server',
    () async {
      final repo = PersistedDiagnosisRepository();
      repo.result = repo.result.copyWith(id: 'created');
      final c = await setup(repo, DiagnosisFixturePicker());
      final sub = c.listen(aiDiagnosisHistoryProvider('season'), (_, _) {});
      addTearDown(sub.close);
      await c.read(aiDiagnosisHistoryProvider('season').future);
      final draft = c.read(aiDiagnosisDraftProvider('season').notifier);
      await draft.pick(AiImageSource.gallery);
      expect(await draft.submit(), repo.result);
      await c.pump();
      final value = await c.read(aiDiagnosisHistoryProvider('season').future);
      expect(value.page.items.map((item) => item.id), ['created', 'diagnosis']);
      expect(repo.lists, 2);
      expect(repo.creates, 1);
    },
  );
  test(
    'B: history reload after POST discards an older in-flight page',
    () async {
      final repo = ControlledDiagnosisRepository()..paginated = true;
      final c = await setup(repo, DiagnosisFixturePicker());
      final sub = c.listen(aiDiagnosisHistoryProvider('season'), (_, _) {});
      addTearDown(sub.close);
      await c.read(aiDiagnosisHistoryProvider('season').future);
      final history = c.read(aiDiagnosisHistoryProvider('season').notifier);
      final oldPage = history.loadMore();
      final draft = c.read(aiDiagnosisDraftProvider('season').notifier);
      await draft.pick(AiImageSource.gallery);
      final post = draft.submit();
      await c.pump();
      await c.pump();
      repo.completion.complete(repo.result);
      await post;
      await c.pump();
      await c.read(aiDiagnosisHistoryProvider('season').future);
      repo.more.complete(diagnosisPage(id: 'stale'));
      await oldPage;
      expect(
        c
            .read(aiDiagnosisHistoryProvider('season'))
            .value!
            .page
            .items
            .single
            .id,
        'diagnosis',
      );
      expect(repo.lists, 3);
    },
  );

  test(
    'B: scrolling requests one cursor at a time and stops after the last page',
    () async {
      final repo = PaginatedDiagnosisRepository()..secondPage = Completer();
      final c = await setup(repo, DiagnosisFixturePicker());
      final sub = c.listen(aiDiagnosisHistoryProvider('season'), (_, _) {});
      addTearDown(sub.close);
      await c.read(aiDiagnosisHistoryProvider('season').future);
      final controller = c.read(aiDiagnosisHistoryProvider('season').notifier);
      final more = controller.loadMore();
      await controller.loadMore();
      expect(repo.cursors, [null, 'cursor-10']);
      repo.secondPage!.complete(paginatedDiagnosisPage(10));
      await more;
      await controller.loadMore();
      await controller.loadMore();
      expect(repo.cursors, [null, 'cursor-10', 'cursor-20']);
      expect(
        c.read(aiDiagnosisHistoryProvider('season')).value!.page.items.length,
        25,
      );
    },
  );
  test(
    'A: a page failure preserves loaded items and retries the same cursor',
    () async {
      final repo = PaginatedDiagnosisRepository()..failNextPage = true;
      final c = await setup(repo, DiagnosisFixturePicker());
      final sub = c.listen(aiDiagnosisHistoryProvider('season'), (_, _) {});
      addTearDown(sub.close);
      await c.read(aiDiagnosisHistoryProvider('season').future);
      final controller = c.read(aiDiagnosisHistoryProvider('season').notifier);
      await controller.loadMore();
      expect(
        c.read(aiDiagnosisHistoryProvider('season')).value!.page.items.length,
        10,
      );
      expect(
        c.read(aiDiagnosisHistoryProvider('season')).value!.paginationError,
        isA<ApiException>(),
      );
      await controller.loadMore();
      expect(repo.cursors, [null, 'cursor-10', 'cursor-10']);
      expect(
        c.read(aiDiagnosisHistoryProvider('season')).value!.page.items.length,
        20,
      );
    },
  );
  test(
    'B: an initial response cannot replace a newer pull-to-refresh result',
    () async {
      final repo = InitialHistoryRace();
      final c = await setup(repo, DiagnosisFixturePicker());
      final sub = c.listen(aiDiagnosisHistoryProvider('season'), (_, _) {});
      addTearDown(sub.close);
      final controller = c.read(aiDiagnosisHistoryProvider('season').notifier);
      await controller.refresh();
      repo.initial.complete(diagnosisPage(id: 'stale'));
      await c.pump();
      expect(
        c
            .read(aiDiagnosisHistoryProvider('season'))
            .value!
            .page
            .items
            .single
            .id,
        'fresh',
      );
    },
  );
  test(
    'B: completion after invalidation cannot mutate the replacement draft',
    () async {
      final repo = ControlledDiagnosisRepository();
      final c = await setup(repo, DiagnosisFixturePicker());
      final controller = c.read(aiDiagnosisDraftProvider('season').notifier);
      await controller.pick(AiImageSource.gallery);
      final pending = controller.submit();
      await c.pump();
      await c.pump();
      c.invalidate(aiDiagnosisDraftProvider('season'));
      await c.pump();
      repo.completion.complete(repo.result);
      expect(await pending, isNull);
      expect(c.read(aiDiagnosisDraftProvider('season')).images, isEmpty);
      expect(c.read(aiDiagnosisDraftProvider('season')).submitting, isFalse);
      expect(repo.lists, 0);
    },
  );
  test(
    'N/B: cancelling selection keeps photos; invalid additions keep the previous draft',
    () async {
      final picker = DiagnosisFixturePicker();
      final c = await setup(DiagnosisFixtureRepository(), picker);
      final controller = c.read(aiDiagnosisDraftProvider('season').notifier);
      await controller.pick(AiImageSource.gallery);
      picker.selection = [];
      await controller.pick(AiImageSource.gallery);
      expect(c.read(aiDiagnosisDraftProvider('season')).images.length, 1);
      picker.selection = List.filled(5, sampleImage());
      await controller.pick(AiImageSource.gallery);
      expect(c.read(aiDiagnosisDraftProvider('season')).images.length, 1);
      expect(
        c.read(aiDiagnosisDraftProvider('season')).error,
        isA<ApiException>(),
      );
    },
  );
  test(
    'B: blocks duplicate submissions and edits until the request settles',
    () async {
      final repo = ControlledDiagnosisRepository();
      final c = await setup(repo, DiagnosisFixturePicker());
      final controller = c.read(aiDiagnosisDraftProvider('season').notifier);
      await controller.pick(AiImageSource.gallery);
      final first = controller.submit();
      await c.pump();
      await c.pump();
      expect(await controller.submit(), isNull);
      controller.remove(0);
      expect(c.read(aiDiagnosisDraftProvider('season')).images.length, 1);
      expect(repo.creates, 1);
      repo.completion.complete(repo.result);
      expect(await first, repo.result);
      expect(c.read(aiDiagnosisDraftProvider('season')).images, isEmpty);
      expect(c.read(aiDiagnosisDraftProvider('season')).submitting, isFalse);
    },
  );
  test(
    'A: a failed submission preserves photos and reconciles history without retrying',
    () async {
      final repo = ControlledDiagnosisRepository();
      final c = await setup(repo, DiagnosisFixturePicker());
      final sub = c.listen(aiDiagnosisHistoryProvider('season'), (_, _) {});
      addTearDown(sub.close);
      await c.read(aiDiagnosisHistoryProvider('season').future);
      final controller = c.read(aiDiagnosisDraftProvider('season').notifier);
      await controller.pick(AiImageSource.gallery);
      final submit = controller.submit();
      await c.pump();
      await c.pump();
      repo.completion.completeError(const NetworkException());
      expect(await submit, isNull);
      await c.pump();
      expect(
        c.read(aiDiagnosisDraftProvider('season')).submissionFailed,
        isTrue,
      );
      expect(c.read(aiDiagnosisDraftProvider('season')).images.length, 1);
      expect(repo.creates, 1);
      expect(repo.lists, 2);
    },
  );
  for (final status in [
    AssignedSeasonStatus.planning,
    AssignedSeasonStatus.completed,
    AssignedSeasonStatus.cancelled,
  ]) {
    test('A: $status permits history but blocks classification', () async {
      final repo = DiagnosisFixtureRepository();
      final c = await setup(repo, DiagnosisFixturePicker(), status: status);
      final controller = c.read(aiDiagnosisDraftProvider('season').notifier);
      await controller.pick(AiImageSource.gallery);
      expect(await controller.submit(), isNull);
      expect(repo.creates, 0);
      expect(
        c.read(aiDiagnosisDraftProvider('season')).error,
        isA<ApiException>(),
      );
    });
  }
  test('A: owner cannot request a technician diagnosis', () async {
    final repo = DiagnosisFixtureRepository();
    final c = await setup(
      repo,
      DiagnosisFixturePicker(),
      role: AccountRole.farmOwner,
    );
    final controller = c.read(aiDiagnosisDraftProvider('season').notifier);
    await controller.pick(AiImageSource.gallery);
    await controller.submit();
    expect(repo.creates, 0);
  });
  test('B: stale load-more cannot overwrite refreshed history', () async {
    final repo = ControlledDiagnosisRepository()..paginated = true;
    final c = await setup(repo, DiagnosisFixturePicker());
    final sub = c.listen(aiDiagnosisHistoryProvider('season'), (_, _) {});
    addTearDown(sub.close);
    await c.read(aiDiagnosisHistoryProvider('season').future);
    final controller = c.read(aiDiagnosisHistoryProvider('season').notifier);
    final more = controller.loadMore();
    await controller.refresh();
    repo.more.complete(diagnosisPage(id: 'stale'));
    await more;
    expect(
      c.read(aiDiagnosisHistoryProvider('season')).value!.page.items.single.id,
      'diagnosis',
    );
  });
  test('N: expired gallery URLs refresh with GET detail only', () async {
    final repo = DiagnosisFixtureRepository();
    repo.result = repo.result.copyWith(imageUrlsExpireAt: DateTime.utc(2020));
    final c = await setup(repo, DiagnosisFixturePicker());
    const key = (seasonId: 'season', diagnosisId: 'diagnosis');
    final sub = c.listen(aiDiagnosisDetailProvider(key), (_, _) {});
    addTearDown(sub.close);
    await c.read(aiDiagnosisDetailProvider(key).future);
    repo.result = repo.result.copyWith(imageUrlsExpireAt: DateTime.utc(2030));
    final controller = c.read(aiDiagnosisDetailProvider(key).notifier);
    await controller.imagesForViewing();
    await controller.imagesForViewing();
    expect(repo.details, 2);
    expect(repo.creates, 0);
  });
}
