import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_sheet_widgets.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/destructive_action_button.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_param_tiles.dart';

/// Mở bottom sheet chi tiết nhật ký và hủy hiệu lực. Trả về true khi hủy thành công.
Future<bool?> showVoidWaterLogSheet({
  required BuildContext context,
  required String seasonId,
  required WaterLog log,
}) => showModalBottomSheet<bool>(
  context: context,
  useRootNavigator: true,
  useSafeArea: true,
  isScrollControlled: true,
  backgroundColor: Colors.white,
  showDragHandle: false,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
  ),
  clipBehavior: Clip.antiAlias,
  barrierColor: const Color(0x990F1C2E),
  constraints: BoxConstraints(
    maxWidth: MediaQuery.sizeOf(context).width,
    maxHeight: MediaQuery.sizeOf(context).height * 0.86,
  ),
  builder: (sheetContext) => AnimatedPadding(
    duration: const Duration(milliseconds: 180),
    curve: Curves.easeOut,
    padding: EdgeInsets.only(
      bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
    ),
    child: SafeArea(
      top: false,
      child: _VoidWaterLogSheet(seasonId: seasonId, log: log),
    ),
  ),
);

class _VoidWaterLogSheet extends ConsumerStatefulWidget {
  const _VoidWaterLogSheet({required this.seasonId, required this.log});

  final String seasonId;
  final WaterLog log;

  @override
  ConsumerState<_VoidWaterLogSheet> createState() => _VoidWaterLogSheetState();
}

class _VoidWaterLogSheetState extends ConsumerState<_VoidWaterLogSheet> {
  final TextEditingController _reasonController = TextEditingController();
  String? _error;
  bool _submitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (_submitting) return;
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      setState(() => _error = 'Vui lòng nhập lý do hủy hiệu lực.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref
          .read(waterLogListProvider(widget.seasonId).notifier)
          .voidWaterLog(logId: widget.log.id, voidReason: reason);
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = error is AppException
            ? error.message
            : 'Không thể hủy hiệu lực. Vui lòng thử lại.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final log = widget.log;
    final role = ref.watch(authControllerProvider).value?.role;
    final canVoid = !log.isVoided && role == AccountRole.technician;

    return Container(
      key: const Key('void_water_log_sheet'),
      width: double.infinity,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.86,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          WaterLogSheetHeader(
            title: 'Nhật ký đo nước',
            closeKey: const Key('close_void_water_log'),
            onClose: _submitting ? null : () => Navigator.of(context).pop(),
          ),
          const Divider(height: 1.2, color: Color(0xFFEEF1F7)),
          Flexible(
            fit: FlexFit.loose,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${formatWaterTime(log.recordedAt)} · ${formatWaterDay(log.recordedAt)}',
                          style: const TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 12,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      _ValidityBadge(isVoided: log.isVoided),
                    ],
                  ),
                  const SizedBox(height: 12),
                  WaterParamTiles(log: log, boxed: true),
                  if (log.note?.trim().isNotEmpty == true) ...<Widget>[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF1F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        log.note!.trim(),
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  if (canVoid) ...<Widget>[
                    const SizedBox(height: 16),
                    const Text(
                      'Lý do hủy hiệu lực (bắt buộc)',
                      style: TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _reasonController,
                      enabled: !_submitting,
                      minLines: 2,
                      maxLines: 4,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textInputAction: TextInputAction.done,
                      decoration: waterLogInputDecoration(
                        hintText: 'Vì sao bản ghi này không chính xác?',
                      ),
                    ),
                    if (_error != null) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SizedBox(
                            height: 47,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.inkSoft,
                                side: const BorderSide(
                                  color: AppColors.line,
                                  width: 1.2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: _submitting
                                  ? null
                                  : () => Navigator.of(context).pop(),
                              child: const Text('Hủy bỏ'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DestructiveActionButton(
                            label: 'Xác nhận',
                            filled: true,
                            loading: _submitting,
                            onPressed: _confirm,
                          ),
                        ),
                      ],
                    ),
                  ] else if (log.isVoided) ...<Widget>[
                    const SizedBox(height: 16),
                    _VoidInfo(log: log),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ValidityBadge extends StatelessWidget {
  const _ValidityBadge({required this.isVoided});
  final bool isVoided;

  @override
  Widget build(BuildContext context) {
    final foreground = isVoided ? AppColors.inkMuted : const Color(0xFF0F9B8E);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isVoided ? const Color(0xFFEEF1F6) : const Color(0xFFE2F6F3),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isVoided ? 'Đã hủy hiệu lực' : 'Có hiệu lực',
            style: TextStyle(
              color: foreground,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _VoidInfo extends StatelessWidget {
  const _VoidInfo({required this.log});

  final WaterLog log;

  @override
  Widget build(BuildContext context) {
    final reason = log.voidReason?.trim();
    final voidedAt = log.voidedAt;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF1F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (reason != null && reason.isNotEmpty)
            Text(
              'Lý do hủy: $reason',
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
          if (voidedAt != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              'Thời gian hủy: ${_formatFull(voidedAt)}',
              style: const TextStyle(
                color: AppColors.inkMuted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatFull(DateTime value) {
    final local = value.toLocal();
    String p(int v) => v.toString().padLeft(2, '0');
    return '${p(local.day)}/${p(local.month)}/${local.year} ${p(local.hour)}:${p(local.minute)}';
  }
}
