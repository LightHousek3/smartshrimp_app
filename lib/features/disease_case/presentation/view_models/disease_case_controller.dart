import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'package:smartshrimp_app/core/config/app_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/core/network/cloudinary_image_storage.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/notifications/presentation/view_models/notification_controller.dart';
import '../../domain/domain.dart';
import '../../data/data.dart';

final diseaseCaseRepositoryProvider = Provider<DiseaseCaseRepository>(
  (ref) => DiseaseCaseRepositoryImpl(
    DiseaseCaseApiService(ref.watch(apiClientProvider)),
  ),
);
final caseImagePickerProvider = Provider<ImagePicker>((ref) => ImagePicker());
final caseEvidenceStorageProvider = Provider<CloudinaryImageStorage>(
  (ref) => CloudinaryImageStorage(
    ref.watch(cloudinaryDioProvider),
    folder: AppConfig.cloudinaryDiseaseCaseFolder,
    validateBytes: DiseaseCaseRules.validateImage,
  ),
);

Future<T> _authorized<T>(
  Ref ref,
  Future<T> Function(DiseaseCaseRepository) action,
) async {
  final account = ref.read(authControllerProvider).value;
  if (account == null) throw const SessionExpiredException();
  if (account.role != AccountRole.technician) {
    throw const UnsupportedRoleException();
  }
  try {
    return await action(ref.read(diseaseCaseRepositoryProvider));
  } on SessionExpiredException {
    if (ref.mounted) {
      await ref.read(authControllerProvider.notifier).expireSession();
    }
    rethrow;
  }
}

typedef CaseListKey = ({
  String seasonId,
  int page,
  DiseaseCaseStatus? status,
  bool? resolved,
});

void _listenForCaseUpdates(Ref ref, {String? caseId}) {
  final socket = ref.watch(notificationSocketProvider);
  final subscription = socket?.caseChanges.listen((changedCaseId) {
    if (ref.mounted &&
        (caseId == null || changedCaseId == null || changedCaseId == caseId)) {
      ref.invalidateSelf();
    }
  });
  ref.onDispose(() => subscription?.cancel());
}

final caseCreationOptionsProvider = FutureProvider.autoDispose
    .family<CaseCreationOptions, String>((ref, seasonId) {
      ref.watch(authControllerProvider);
      return _authorized(ref, (repo) => repo.creationOptions(seasonId));
    }, retry: (_, _) => null);
final diseaseCaseListProvider = FutureProvider.autoDispose
    .family<DiseaseCasePage, CaseListKey>((ref, key) {
      ref.watch(authControllerProvider);
      _listenForCaseUpdates(ref);
      return _authorized(
        ref,
        (repo) => repo.list(
          key.seasonId,
          page: key.page,
          status: key.status,
          resolved: key.resolved,
        ),
      );
    }, retry: (_, _) => null);
typedef CaseDetailKey = ({String seasonId, String id});
final diseaseCaseDetailProvider = FutureProvider.autoDispose
    .family<DiseaseCase, CaseDetailKey>((ref, key) {
      ref.watch(authControllerProvider);
      _listenForCaseUpdates(ref, caseId: key.id);
      return _authorized(ref, (repo) => repo.detail(key.seasonId, key.id));
    }, retry: (_, _) => null);

final diseaseCaseMutationProvider =
    AsyncNotifierProvider.autoDispose<DiseaseCaseMutation, void>(
      DiseaseCaseMutation.new,
    );

class DiseaseCaseMutation extends AsyncNotifier<void> {
  Future<String> uploadEvidence(Uint8List bytes, String fileName) async {
    final account = ref.read(authControllerProvider).value;
    if (account?.role != AccountRole.technician) {
      throw const UnsupportedRoleException();
    }
    return ref
        .read(caseEvidenceStorageProvider)
        .upload(bytes: bytes, fileName: fileName);
  }

  @override
  Future<void> build() async {}
  Future<DiseaseCase> _run(
    Future<DiseaseCase> Function(DiseaseCaseRepository) action,
  ) async {
    if (state.isLoading) {
      throw const ApiException('Thao tác trước đang được xử lý.');
    }
    state = const AsyncLoading();
    try {
      final item = await _authorized(ref, action);
      if (ref.mounted) {
        state = const AsyncData(null);
        ref.invalidate(diseaseCaseListProvider);
        ref.invalidate(diseaseCaseDetailProvider);
      }
      return item;
    } catch (error, stack) {
      if (ref.mounted) {
        state = AsyncError(error, stack);
        if (error is AppException &&
            [403, 404, 409].contains(error.statusCode)) {
          ref.invalidate(diseaseCaseDetailProvider);
          ref.invalidate(diseaseCaseListProvider);
        }
      }
      rethrow;
    }
  }

  Future<DiseaseCase> create(
    String seasonId,
    String title,
    String description,
    CaseSeverity severity, {
    List<String> attachments = const [],
    String? aiDiagnosisId,
    String? relatedCaseId,
  }) => _run(
    (repo) => repo.create(
      seasonId,
      title,
      description,
      severity,
      attachments: attachments,
      aiDiagnosisId: aiDiagnosisId,
      relatedCaseId: relatedCaseId,
    ),
  );
  Future<DiseaseCase> respond(
    String seasonId,
    DiseaseCase item,
    CaseResponseType type,
    String message, {
    List<String> attachments = const [],
  }) => _run(
    (repo) =>
        repo.respond(seasonId, item, type, message, attachments: attachments),
  );
}
