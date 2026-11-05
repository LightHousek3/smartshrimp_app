import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import '../../data/repositories/ai_diagnosis_repository_impl.dart';
import '../../data/services/ai_diagnosis_api_service.dart';
import '../../data/services/ai_diagnosis_image_picker.dart';
import '../../domain/ai_diagnosis_rules.dart';
import '../../domain/entities/ai_diagnosis.dart';
import '../../domain/repositories/ai_diagnosis_repository.dart';
import 'ai_diagnosis_state.dart';

final aiDiagnosisRepositoryProvider = Provider<AiDiagnosisRepository>((ref) {
  // Discard account-owned history when the authenticated account changes.
  ref.watch(authControllerProvider.select((value) => value.value?.id));
  return AiDiagnosisRepositoryImpl(
    AiDiagnosisApiService(ref.watch(apiClientProvider)),
  );
});
final aiDiagnosisImagePickerProvider = Provider<AiDiagnosisImagePicker>(
  (ref) => DeviceAiDiagnosisImagePicker(ImagePicker()),
);

final aiDiagnosisHistoryProvider = AsyncNotifierProvider.autoDispose
    .family<AiDiagnosisHistoryController, AiDiagnosisHistory, String>(
      AiDiagnosisHistoryController.new,
      retry: (_, _) => null,
    );
final aiDiagnosisDraftProvider = NotifierProvider.autoDispose
    .family<AiDiagnosisDraftController, AiDiagnosisDraft, String>(
      AiDiagnosisDraftController.new,
    );
typedef AiDiagnosisKey = ({String seasonId, String diagnosisId});
final aiDiagnosisDetailProvider = AsyncNotifierProvider.autoDispose
    .family<AiDiagnosisDetailController, AiDiagnosisDetail, AiDiagnosisKey>(
      AiDiagnosisDetailController.new,
      retry: (_, _) => null,
    );

Future<T> _withSession<T>(Ref ref, Future<T> Function() action) async {
  try {
    return await action();
  } on SessionExpiredException {
    if (ref.mounted) {
      await ref.read(authControllerProvider.notifier).expireSession();
    }
    rethrow;
  }
}

class AiDiagnosisHistoryController extends AsyncNotifier<AiDiagnosisHistory> {
  AiDiagnosisHistoryController(this.seasonId);
  final String seasonId;
  int _revision = 0;
  @override
  Future<AiDiagnosisHistory> build() {
    _revision++;
    final repository = ref.watch(aiDiagnosisRepositoryProvider);
    return _withSession(ref, () async {
      return AiDiagnosisHistory(page: await repository.list(seasonId));
    });
  }

  Future<void> refresh() async {
    // Rebuild also cancels an unfinished initial load; manually assigning state
    // would let that older build future overwrite the refreshed result.
    ref.invalidateSelf();
    // The provider exposes failures as AsyncError for the history view.
    await AsyncValue.guard(() => future);
  }

  Future<void> loadMore() async {
    final previous = state.asData?.value;
    if (previous == null ||
        previous.loadingMore ||
        !previous.page.pagination.hasNextPage) {
      return;
    }
    final revision = _revision;
    state = AsyncData(
      previous.copyWith(loadingMore: true, paginationError: null),
    );
    try {
      final next = await _withSession(
        ref,
        () => ref
            .read(aiDiagnosisRepositoryProvider)
            .list(seasonId, cursor: previous.page.pagination.nextCursor),
      );
      if (!ref.mounted || revision != _revision) return;
      final items = {
        for (final item in previous.page.items) item.id: item,
        for (final item in next.items) item.id: item,
      }.values.toList();
      state = AsyncData(
        AiDiagnosisHistory(
          page: AiDiagnosisPage(items: items, pagination: next.pagination),
        ),
      );
    } on Object catch (error) {
      if (ref.mounted && revision == _revision) {
        state = AsyncData(
          previous.copyWith(loadingMore: false, paginationError: error),
        );
      }
    }
  }
}

class AiDiagnosisDetailController extends AsyncNotifier<AiDiagnosisDetail> {
  AiDiagnosisDetailController(this.key);
  final AiDiagnosisKey key;
  int _revision = 0;
  @override
  Future<AiDiagnosisDetail> build() {
    _revision++;
    final repository = ref.watch(aiDiagnosisRepositoryProvider);
    return _withSession(
      ref,
      () => repository.detail(key.seasonId, key.diagnosisId),
    );
  }

  Future<AiDiagnosisDetail> refresh() async {
    final revision = ++_revision;
    try {
      final detail = await _withSession(
        ref,
        () => ref
            .read(aiDiagnosisRepositoryProvider)
            .detail(key.seasonId, key.diagnosisId),
      );
      if (ref.mounted && revision == _revision) state = AsyncData(detail);
      return detail;
    } on Object catch (error, stack) {
      if (ref.mounted && revision == _revision && !state.hasValue) {
        state = AsyncError(error, stack);
      }
      rethrow;
    }
  }

  /// A refreshed detail grants new URLs without sending another inference request.
  Future<AiDiagnosisDetail> imagesForViewing({
    bool forceRefresh = false,
  }) async {
    final detail = state.asData?.value;
    return detail == null ||
            forceRefresh ||
            detail.imageUrlsExpiredAt(DateTime.now())
        ? refresh()
        : detail;
  }
}

class AiDiagnosisDraftController extends Notifier<AiDiagnosisDraft> {
  AiDiagnosisDraftController(this.seasonId);
  final String seasonId;
  int _epoch = 0;
  @override
  AiDiagnosisDraft build() {
    _epoch++;
    ref.watch(aiDiagnosisRepositoryProvider);
    ref.onDispose(() => _epoch++);
    return const AiDiagnosisDraft();
  }

  bool _current(int epoch) => ref.mounted && epoch == _epoch;

  Future<void> pick(AiImageSource source) async {
    if (state.submitting ||
        state.picking ||
        state.images.length >= AiDiagnosisRules.maxImages) {
      return;
    }
    final epoch = _epoch;
    final link = ref.keepAlive();
    state = state.copyWith(picking: true, error: null, submissionFailed: false);
    try {
      final selected = await ref
          .read(aiDiagnosisImagePickerProvider)
          .pick(
            source,
            limit: AiDiagnosisRules.maxImages - state.images.length,
          );
      if (!_current(epoch)) return;
      final images = [...state.images, ...selected];
      if (images.isNotEmpty) AiDiagnosisRules.validate(images);
      state = state.copyWith(images: images);
    } on Object catch (error) {
      if (_current(epoch)) state = state.copyWith(error: error);
    } finally {
      if (_current(epoch)) state = state.copyWith(picking: false);
      link.close();
    }
  }

  void remove(int index) {
    if (state.submitting ||
        state.picking ||
        index < 0 ||
        index >= state.images.length) {
      return;
    }
    state = state.copyWith(
      images: [...state.images]..removeAt(index),
      error: null,
      submissionFailed: false,
    );
  }

  Future<AiDiagnosisDetail?> submit() async {
    if (state.submitting || state.picking) return null;
    final epoch = _epoch;
    final link = ref.keepAlive();
    final images = state.images;
    var requestStarted = false;
    state = state.copyWith(
      submitting: true,
      error: null,
      submissionFailed: false,
    );
    try {
      AiDiagnosisRules.validate(images);
      final account = ref.read(authControllerProvider).value;
      if (account?.role != AccountRole.technician ||
          account?.status != AccountStatus.active) {
        throw const ApiException(
          'Chỉ kỹ thuật viên đang hoạt động được yêu cầu nhận diện.',
          statusCode: 403,
        );
      }
      final season = await _withSession(
        ref,
        () => ref.read(assignedSeasonDetailProvider(seasonId).future),
      );
      if (!_current(epoch)) return null;
      if (season.status != AssignedSeasonStatus.active) {
        throw const ApiException(
          'Chỉ được yêu cầu nhận diện trong vụ nuôi đang hoạt động.',
          statusCode: 403,
        );
      }
      requestStarted = true;
      final result = await _withSession(
        ref,
        () => ref.read(aiDiagnosisRepositoryProvider).create(seasonId, images),
      );
      if (!_current(epoch)) return null;
      state = state.copyWith(images: []);
      return result;
    } on Object catch (error) {
      if (_current(epoch)) {
        state = state.copyWith(error: error, submissionFailed: requestStarted);
      }
      return null;
    } finally {
      if (_current(epoch)) {
        state = state.copyWith(submitting: false);
        // Reload authoritative history after every POST, including uncertain failures.
        if (requestStarted) {
          ref.invalidate(aiDiagnosisHistoryProvider(seasonId));
        }
      }
      link.close();
    }
  }
}
