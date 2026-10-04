import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/rag/domain/entities/rag_models.dart';
import 'package:smartshrimp_app/features/rag/presentation/widgets/rag_chat_widgets.dart';

TextStyle get ragHistoryTitleStyle => AppTypography.display(
  fontSize: 14,
  fontWeight: FontWeight.w700,
  height: 20 / 14,
  letterSpacing: 0,
  color: AppColors.ink,
).copyWith(fontFamilyFallback: const ['PlusJakartaSans_regular']);

class RagNewConversationButton extends StatelessWidget {
  const RagNewConversationButton({required this.onPressed, super.key});
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.oceanLight, AppColors.tealLight],
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1A000000),
          blurRadius: 3,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: SizedBox(
      height: 45,
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white70,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.5,
            letterSpacing: 0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(RagAssets.add),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Bắt đầu cuộc trò chuyện mới',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class RagConversationCard extends StatelessWidget {
  const RagConversationCard({
    required this.item,
    required this.onTap,
    super.key,
  });
  final RagConversationSummary item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final date = item.lastMessageAt.toLocal();
    String two(int value) => value.toString().padLeft(2, '0');
    final timestamp =
        '${two(date.hour)}:${two(date.minute)} · ${two(date.day)}-${two(date.month)}';
    const subtitleStyle = TextStyle(
      fontSize: 12,
      height: 16 / 12,
      letterSpacing: 0,
      color: AppColors.inkMuted,
    );
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.line, width: 1.277),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEAFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: SvgPicture.asset(RagAssets.conversation)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? 'Hội thoại AI',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ragHistoryTitleStyle,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.lastMessagePreview ?? 'Xem nội dung hội thoại',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: subtitleStyle,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        SvgPicture.asset(RagAssets.clock),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            '$timestamp${item.messageCount == null ? '' : '  ·  ${item.messageCount} tin nhắn'}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: subtitleStyle.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(RagAssets.chevron),
            ],
          ),
        ),
      ),
    );
  }
}
