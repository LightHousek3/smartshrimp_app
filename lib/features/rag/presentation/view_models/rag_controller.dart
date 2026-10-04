import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/di/core_providers.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/rag/data/repositories/rag_repository_impl.dart';
import 'package:smartshrimp_app/features/rag/data/services/rag_api_service.dart';
import 'package:smartshrimp_app/features/rag/domain/entities/rag_models.dart';
import 'package:smartshrimp_app/features/rag/domain/repositories/rag_repository.dart';

final ragRepositoryProvider = Provider<RagRepository>(
  (ref) => RagRepositoryImpl(RagApiService(ref.watch(apiClientProvider))),
);
final ragListProvider = FutureProvider.autoDispose
    .family<RagConversationPage, (String, int)>((ref, key) async {
      ref.watch(authControllerProvider);
      try {
        return await ref
            .watch(ragRepositoryProvider)
            .list(key.$1, page: key.$2);
      } on SessionExpiredException {
        await ref.read(authControllerProvider.notifier).expireSession();
        rethrow;
      }
    });
typedef RagChatKey = ({String seasonId, String? conversationId});
final ragChatProvider = AsyncNotifierProvider.autoDispose
    .family<RagChatController, RagChatState, RagChatKey>(RagChatController.new);

final class RagChatController extends AsyncNotifier<RagChatState> {
  RagChatController(this.key);
  final RagChatKey key;
  @override
  Future<RagChatState> build() async {
    ref.watch(authControllerProvider);
    return _session(() async {
      if (key.conversationId != null) {
        final detail = await ref
            .read(ragRepositoryProvider)
            .detail(key.conversationId!);
        if (detail.seasonId != key.seasonId) {
          throw const InvalidResponseException();
        }
        return detail;
      }
      final season = await ref
          .read(assignedSeasonRepositoryProvider)
          .getAssignedSeason(key.seasonId);
      return RagChatState(
        seasonId: season.id,
        seasonName: season.name,
        canAsk:
            season.status != AssignedSeasonStatus.completed &&
            season.status != AssignedSeasonStatus.cancelled,
      );
    });
  }

  Future<T> _session<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on SessionExpiredException {
      await ref.read(authControllerProvider.notifier).expireSession();
      rethrow;
    }
  }

  Future<void> send(String question) async {
    final current = state.value;
    if (current == null ||
        current.busy ||
        !current.canAsk ||
        current.hasNextPage) {
      return;
    }
    state = AsyncData(current.copyWith(busy: true));
    try {
      final query = await _session(
        () => ref
            .read(ragRepositoryProvider)
            .ask(
              seasonId: current.seasonId,
              question: question,
              conversationId: current.conversationId,
            ),
      );
      if (!ref.mounted) return;
      state = AsyncData(
        current.copyWith(
          conversationId: query.conversationId,
          queries: [...current.queries, query],
        ),
      );
      ref.invalidate(ragListProvider);
    } catch (error) {
      if (ref.mounted) {
        state = AsyncData(
          current.copyWith(
            canAsk: error is AppException && error.statusCode == 403
                ? false
                : current.canAsk,
          ),
        );
      }
      rethrow;
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || current.busy || !current.hasNextPage) return;
    state = AsyncData(current.copyWith(busy: true));
    try {
      final next = await _session(
        () => ref
            .read(ragRepositoryProvider)
            .detail(current.conversationId!, page: current.page + 1),
      );
      if (ref.mounted) {
        state = AsyncData(
          next.copyWith(queries: [...current.queries, ...next.queries]),
        );
      }
    } catch (_) {
      if (ref.mounted) state = AsyncData(current);
      rethrow;
    }
  }

  Future<void> rate(String id, int rating, String? comment) async {
    final current = state.value;
    if (current == null || current.busy) return;
    state = AsyncData(current.copyWith(busy: true));
    try {
      final feedback = await _session(
        () => ref.read(ragRepositoryProvider).rate(id, rating, comment),
      );
      if (ref.mounted) {
        state = AsyncData(
          current.copyWith(
            queries: current.queries
                .map((q) => q.id == id ? q.copyWith(feedback: feedback) : q)
                .toList(),
          ),
        );
      }
    } catch (_) {
      if (ref.mounted) state = AsyncData(current);
      rethrow;
    }
  }
}
