import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/rag/domain/entities/rag_models.dart';
import 'package:smartshrimp_app/features/rag/presentation/view_models/rag_controller.dart';
import 'package:smartshrimp_app/features/rag/presentation/widgets/rag_chat_widgets.dart';

class RagChatPage extends ConsumerStatefulWidget {
  const RagChatPage({required this.seasonId, this.conversationId, super.key});
  final String seasonId;
  final String? conversationId;
  @override
  ConsumerState<RagChatPage> createState() => _RagChatPageState();
}

class _RagChatPageState extends ConsumerState<RagChatPage> {
  final _question = TextEditingController();
  final _scroll = ScrollController();
  String? _pendingQuestion;
  bool get _sending => _pendingQuestion != null;
  RagChatKey get _key =>
      (seasonId: widget.seasonId, conversationId: widget.conversationId);
  @override
  void dispose() {
    _question.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _error(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error is AppException
              ? error.message
              : 'Không thể hoàn tất thao tác. Vui lòng thử lại.',
        ),
      ),
    );
  }

  Future<void> _send() async {
    final current = ref.read(ragChatProvider(_key)).value;
    if (_sending ||
        current == null ||
        current.busy ||
        !current.canAsk ||
        current.hasNextPage) {
      return;
    }
    final draft = _question.text;
    final text = draft.trim();
    if (text.isEmpty || text.length > 2000) {
      _error(const ApiException('Câu hỏi cần từ 1 đến 2000 ký tự.'));
      return;
    }
    setState(() => _pendingQuestion = text);
    _question.clear();
    _scrollToLatest();
    try {
      await ref.read(ragChatProvider(_key).notifier).send(text);
      if (!mounted) return;
      _scrollToLatest();
      // Replace /rag/new with /rag/{conversationId} after first message
      final newConvId = ref.read(ragChatProvider(_key)).value?.conversationId;
      if (widget.conversationId == null && newConvId != null) {
        GoRouter.of(
          context,
        ).replace('/seasons/${widget.seasonId}/rag/$newConvId');
      }
    } catch (error) {
      if (mounted) {
        _question.value = TextEditingValue(
          text: draft,
          selection: TextSelection.collapsed(offset: draft.length),
        );
      }
      _error(error);
    } finally {
      if (mounted) setState(() => _pendingQuestion = null);
    }
  }

  void _scrollToLatest() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _rate(RagQuery query, int? initialRating) async {
    final result = await showDialog<(int, String?)>(
      context: context,
      builder: (_) =>
          _FeedbackDialog(query.feedback, initialRating: initialRating),
    );
    if (result == null || !mounted) return;
    try {
      await ref
          .read(ragChatProvider(_key).notifier)
          .rate(query.id, result.$1, result.$2);
    } catch (error) {
      _error(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final season = ref
        .watch(assignedSeasonDetailProvider(widget.seasonId))
        .value;
    return Scaffold(
      body: AppGradientBackground(
        colors: const [AppColors.backgroundTop, AppColors.backgroundBottom],
        stops: const [0, 1],
        child: Column(
          children: [
            RagChatHeader(onBack: () => Navigator.of(context).maybePop()),
            Expanded(
              child: ref
                  .watch(ragChatProvider(_key))
                  .when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: AppColors.ocean),
                    ),
                    error: (error, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              error is AppException
                                  ? error.message
                                  : 'Không thể tải hội thoại.',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: () =>
                                  ref.invalidate(ragChatProvider(_key)),
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    data: (data) => Column(
                      children: [
                        RagContextBar(
                          seasonName: data.seasonName,
                          farmName: season?.farmName,
                          pondName: season?.pondName,
                        ),
                        if (!data.canAsk)
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Không thể gửi thêm câu hỏi. Vụ nuôi đã kết thúc hoặc quyền truy cập đã thay đổi.',
                              style: TextStyle(
                                color: AppColors.inkMuted,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        Expanded(
                          child: data.queries.isEmpty && !_sending
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(24),
                                    child: Text(
                                      'Gửi câu hỏi kỹ thuật về vụ nuôi này.',
                                      style: TextStyle(
                                        color: AppColors.inkMuted,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scroll,
                                  keyboardDismissBehavior:
                                      ScrollViewKeyboardDismissBehavior.onDrag,
                                  padding: const EdgeInsets.all(16),
                                  itemCount:
                                      data.queries.length + (_sending ? 1 : 0),
                                  itemBuilder: (_, index) =>
                                      index == data.queries.length
                                      ? Column(
                                          children: [
                                            RagQuestionBubble(
                                              question: _pendingQuestion!,
                                            ),
                                            const SizedBox(height: 8),
                                            const RagThinkingBubble(),
                                          ],
                                        )
                                      : RagMessagePair(
                                          query: data.queries[index],
                                          busy: data.busy,
                                          onRate: (rating) => _rate(
                                            data.queries[index],
                                            rating,
                                          ),
                                        ),
                                ),
                        ),
                        if (data.hasNextPage)
                          TextButton(
                            onPressed: data.busy
                                ? null
                                : () async {
                                    try {
                                      await ref
                                          .read(ragChatProvider(_key).notifier)
                                          .loadMore();
                                    } catch (error) {
                                      _error(error);
                                    }
                                  },
                            child: const Text('Tải thêm câu hỏi'),
                          ),
                        if (data.busy && !_sending)
                          const LinearProgressIndicator(minHeight: 2),
                        if (data.canAsk)
                          RagComposer(
                            controller: _question,
                            enabled: !data.busy && !data.hasNextPage,
                            onSend: _send,
                          )
                        else
                          const SafeArea(
                            top: false,
                            child: SizedBox(height: 12),
                          ),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeedbackDialog extends StatefulWidget {
  const _FeedbackDialog(this.feedback, {this.initialRating});
  final RagFeedback? feedback;
  final int? initialRating;
  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  late int _rating = widget.initialRating ?? widget.feedback?.rating ?? 0;
  late final _comment = TextEditingController(text: widget.feedback?.comment);
  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Đánh giá câu trả lời'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            children: [
              for (var star = 1; star <= 5; star++)
                IconButton(
                  tooltip: '$star sao',
                  onPressed: () => setState(() => _rating = star),
                  icon: Icon(
                    star <= _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
            ],
          ),
          TextField(
            controller: _comment,
            maxLength: 2000,
            minLines: 2,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Bình luận (tùy chọn)',
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Hủy'),
      ),
      FilledButton(
        onPressed: _rating == 0
            ? null
            : () {
                if (_comment.text.trim().length > 2000) return;
                Navigator.pop(context, (_rating, _comment.text.trim()));
              },
        child: const Text('Lưu đánh giá'),
      ),
    ],
  );
}
