import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/rag/presentation/view_models/rag_controller.dart';
import 'package:smartshrimp_app/features/rag/presentation/widgets/rag_chat_widgets.dart';
import 'package:smartshrimp_app/features/rag/presentation/widgets/rag_history_widgets.dart';

class RagConversationsPage extends ConsumerStatefulWidget {
  const RagConversationsPage({required this.seasonId, super.key});
  final String seasonId;
  @override
  ConsumerState<RagConversationsPage> createState() =>
      _RagConversationsPageState();
}

class _RagConversationsPageState extends ConsumerState<RagConversationsPage> {
  int _page = 1;
  Future<void> _refresh() async {
    final key = (widget.seasonId, _page);
    ref.invalidate(ragListProvider(key));
    ref.invalidate(assignedSeasonDetailProvider(widget.seasonId));
    try {
      await Future.wait([
        ref.read(ragListProvider(key).future),
        ref.read(assignedSeasonDetailProvider(widget.seasonId).future),
      ]);
    } on Object {
      /* Providers expose errors in the page. */
    }
  }

  Future<void> _open(String id) async {
    await context.push('/seasons/${widget.seasonId}/rag/$id');
    if (mounted) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final key = (widget.seasonId, _page);
    final season = ref.watch(assignedSeasonDetailProvider(widget.seasonId));
    final conversations = ref.watch(ragListProvider(key));
    final closed =
        season.hasValue &&
        [
          AssignedSeasonStatus.completed,
          AssignedSeasonStatus.cancelled,
        ].contains(season.value!.status);
    final count = conversations.value?.totalResults;
    return Scaffold(
      body: AppGradientBackground(
        colors: const [AppColors.backgroundTop, AppColors.backgroundBottom],
        stops: const [0, 1],
        child: Column(
          children: [
            RagChatHeader(
              title: 'Lịch sử trò chuyện',
              subtitle: count == null
                  ? 'Hội thoại theo vụ nuôi'
                  : '$count cuộc trò chuyện',
              onBack: () => context.canPop()
                  ? context.pop()
                  : context.go('/seasons/${widget.seasonId}'),
            ),
            RagContextBar(
              seasonName: season.value?.name ?? 'Vụ nuôi',
              farmName: season.value?.farmName,
              pondName: season.value?.pondName,
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: conversations.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) =>
                        _HistoryError(error: error, onRetry: _refresh),
                    data: (data) => ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (season.hasError)
                          _HistoryError(error: season.error!, onRetry: _refresh)
                        else if (closed)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Text(
                              'Vụ nuôi đã kết thúc. Bạn vẫn có thể xem hội thoại và đánh giá câu trả lời.',
                            ),
                          )
                        else
                          RagNewConversationButton(
                            onPressed: season.hasValue
                                ? () => _open('new')
                                : null,
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4, 20, 4, 8),
                          child: Text('Gần đây', style: ragHistoryTitleStyle),
                        ),
                        if (data.items.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 48),
                            child: Center(child: Text('Chưa có hội thoại.')),
                          ),
                        for (final item in data.items) ...[
                          RagConversationCard(
                            item: item,
                            onTap: () => _open(item.id),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (_page > 1 || data.hasNextPage)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                tooltip: 'Trang trước',
                                onPressed: _page > 1
                                    ? () => setState(() => _page--)
                                    : null,
                                icon: const Icon(Icons.chevron_left),
                              ),
                              Text('Trang $_page'),
                              IconButton(
                                tooltip: 'Trang sau',
                                onPressed: data.hasNextPage
                                    ? () => setState(() => _page++)
                                    : null,
                                icon: const Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryError extends StatelessWidget {
  const _HistoryError({required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            error is AppException
                ? (error as AppException).message
                : 'Không thể tải hội thoại.',
          ),
          TextButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    ),
  );
}
