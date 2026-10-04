import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_circle_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/rag/domain/entities/rag_models.dart';
import 'package:smartshrimp_app/features/rag/presentation/widgets/rag_answer_body.dart';

abstract final class RagAssets {
  static const back = 'assets/icons/rag/back.svg';
  static const location = 'assets/icons/rag/location.svg';
  static const assistant = 'assets/icons/rag/assistant.svg';
  static const star = 'assets/icons/rag/star.svg';
  static const starMuted = 'assets/icons/rag/star_muted.svg';
  static const send = 'assets/icons/rag/send.svg';
  static const add = 'assets/icons/rag/add.svg';
  static const conversation = 'assets/icons/rag/conversation.svg';
  static const clock = 'assets/icons/rag/clock.svg';
  static const chevron = 'assets/icons/rag/chevron.svg';
}

class RagChatHeader extends StatelessWidget {
  const RagChatHeader({
    required this.onBack,
    this.title = 'Hỏi chuyên gia AI',
    this.subtitle = 'Trợ lý kỹ thuật (RAG)',
    super.key,
  });
  final VoidCallback onBack;
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .8),
      border: Border(
        bottom: BorderSide(color: AppColors.line.withValues(alpha: .7)),
      ),
    ),
    child: SafeArea(
      bottom: false,
      child: PageHeaderBar(
        title: title,
        subtitle: subtitle,
        height: 62,
        backgroundColor: Colors.transparent,
        titleStyle: AppTypography.display(
          color: AppColors.ink,
          fontSize: 16,
          letterSpacing: 0,
          fontWeight: FontWeight.w700,
          height: 1.25,
        ).copyWith(fontFamilyFallback: const ['PlusJakartaSans_regular']),
        backButton: AppCircleButton(
          icon: Icons.chevron_left,
          tooltip: 'Quay lại',
          onPressed: onBack,
          size: 36,
          backgroundColor: const Color(0xFFEEF1F6),
          iconWidget: Center(child: SvgPicture.asset(RagAssets.back)),
        ),
      ),
    ),
  );
}

class RagContextBar extends StatelessWidget {
  const RagContextBar({
    required this.seasonName,
    this.farmName,
    this.pondName,
    super.key,
  });
  final String seasonName;
  final String? farmName, pondName;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .85),
      border: Border(
        bottom: BorderSide(color: AppColors.line.withValues(alpha: .6)),
      ),
    ),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xCCEAF4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(RagAssets.location),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              [?farmName, seasonName].join('  ›  '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF0C4E8F),
                fontSize: 12,
                letterSpacing: 0,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
          if (pondName != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Text('›', style: TextStyle(color: Color(0xFF3F97E8))),
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 100),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  pondName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF0C4E8F),
                    fontSize: 12,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

class RagThinkingBubble extends StatefulWidget {
  const RagThinkingBubble({super.key});
  @override
  State<RagThinkingBubble> createState() => _RagThinkingBubbleState();
}

class _RagThinkingBubbleState extends State<RagThinkingBubble>
    with SingleTickerProviderStateMixin {
  late final _animation = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _animation.stop();
      _animation.value = .5;
    } else {
      _animation.repeat();
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Semantics(
      liveRegion: true,
      label: 'AI đang suy nghĩ',
      child: ExcludeSemantics(
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.line),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              SvgPicture.asset(RagAssets.assistant),
              const Text(
                'AI đang suy nghĩ…',
                style: TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 12,
                  letterSpacing: 0,
                  height: 1.5,
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (_, _) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Opacity(
                          opacity:
                              .3 +
                              .7 *
                                  (math.sin(
                                        _animation.value * math.pi * 2 - i * .8,
                                      ) +
                                      1) /
                                  2,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: Color(0xFF7B5BD6),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class RagQuestionBubble extends StatelessWidget {
  const RagQuestionBubble({required this.question, super.key});
  final String question;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (_, constraints) => Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth * .85),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.ocean,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(6),
          ),
        ),
        child: SelectableText(
          question,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            letterSpacing: 0,
            height: 1.5,
          ),
        ),
      ),
    ),
  );
}

class RagMessagePair extends StatelessWidget {
  const RagMessagePair({
    required this.query,
    required this.busy,
    required this.onRate,
    super.key,
  });
  final RagQuery query;
  final bool busy;
  final void Function(int? rating) onRate;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RagQuestionBubble(question: query.question),
          const SizedBox(height: 8),
          Container(
            width: constraints.maxWidth * .88,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.line),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(RagAssets.assistant),
                    const SizedBox(width: 6),
                    const Text(
                      'Trợ lý AI',
                      style: TextStyle(
                        color: Color(0xFF7B5BD6),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                if (query.warning != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '${query.warning}',
                      style: const TextStyle(
                        color: Color(0xFF99631A),
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ),
                RagAnswerBody(
                  text:
                      query.answer ??
                      query.errorMessage ??
                      'AI chưa thể tạo câu trả lời. Vui lòng thử lại.',
                ),
                if (query.retrievedChunks.isNotEmpty)
                  ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    dense: true,
                    title: Text(
                      'Nguồn tham chiếu (${query.retrievedChunks.length})',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.ocean,
                      ),
                    ),
                    children: [
                      for (final chunk in query.retrievedChunks)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${chunk.sourceFile} · Phần ${chunk.chunkIndex + 1}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                              SelectableText(
                                '${(chunk.similarity * 100).toStringAsFixed(1)}% tương đồng\n${chunk.content}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.inkMuted,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                if (query.canRate) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 1, color: Color(0xFFEEF1F7)),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        Semantics(
                          button: true,
                          child: InkWell(
                            onTap: busy ? null : () => onRate(null),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text(
                                'Đánh giá:',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.inkMuted,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        for (var star = 1; star <= 5; star++)
                          Tooltip(
                            message:
                                '${query.feedback == null ? 'Đánh giá' : 'Sửa đánh giá'} $star sao',
                            child: Semantics(
                              button: true,
                              selected: star == query.feedback?.rating,
                              label: '$star sao',
                              child: InkWell(
                                onTap: busy ? null : () => onRate(star),
                                borderRadius: BorderRadius.circular(4),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 3,
                                    horizontal: 1,
                                  ),
                                  child: SvgPicture.asset(
                                    star <= (query.feedback?.rating ?? 0)
                                        ? RagAssets.star
                                        : RagAssets.starMuted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (query.feedback?.comment != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        query.feedback!.comment!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.inkMuted,
                          height: 1.5,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class RagComposer extends StatelessWidget {
  const RagComposer({
    required this.controller,
    required this.enabled,
    required this.onSend,
    super.key,
  });
  final TextEditingController controller;
  final bool enabled;
  final VoidCallback onSend;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .9),
      border: Border(
        top: BorderSide(color: AppColors.line.withValues(alpha: .7)),
      ),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                enabled: enabled,
                minLines: 1,
                maxLines: 4,
                maxLength: 2000,
                style: const TextStyle(
                  fontSize: 14,
                  letterSpacing: 0,
                  color: AppColors.inkSoft,
                ),
                decoration: InputDecoration(
                  hintText: 'Hỏi về kỹ thuật, nước, bệnh…',
                  hintStyle: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 14,
                    letterSpacing: 0,
                  ),
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.ocean),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox.square(
              dimension: 44,
              child: IconButton(
                tooltip: 'Gửi câu hỏi',
                onPressed: enabled ? onSend : null,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.ocean,
                  disabledBackgroundColor: AppColors.oceanLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: SvgPicture.asset(RagAssets.send),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
