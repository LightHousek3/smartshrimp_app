import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/view_models/protocol_controller.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart';

enum _DecisionMode { initial, approve, reject }

class ProtocolDecision extends ConsumerStatefulWidget {
  const ProtocolDecision({required this.detail, super.key});
  final ProtocolDetail detail;
  @override
  ConsumerState<ProtocolDecision> createState() => _ProtocolDecisionState();
}

class _ProtocolDecisionState extends ConsumerState<ProtocolDecision> {
  _DecisionMode _mode = _DecisionMode.initial;
  final _reason = TextEditingController();
  final _form = GlobalKey<FormState>();
  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(protocolReviewProvider(widget.detail.card.id));
    final busy = mutation.isLoading;
    return ProtocolSurface(
      color: protocolAmberPanel,
      border: const Color(0xFFFFDF6A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const AppSvgIcon(
                  AppSvgIconName.shield,
                  size: 17,
                  color: Color(0xFFBB4D00),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quyết định của Chủ trại',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9F4100),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Chỉ quyết định sau khi đã kiểm tra toàn cảnh, từng cữ, liều lượng và mốc neo của phác đồ.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.625,
                        color: Color(0xFFBB4D00),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_mode == _DecisionMode.initial) ...[
            GradientButton(
              label: 'Phê duyệt phác đồ',
              compact: true,
              borderRadius: 12,
              leading: const AppSvgIcon(
                AppSvgIconName.shield,
                size: 18,
                color: Colors.white,
              ),
              onPressed: busy
                  ? null
                  : () => setState(() => _mode = _DecisionMode.approve),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: _Ghost(
                label: 'Từ chối và nêu lý do',
                icon: true,
                onPressed: busy
                    ? null
                    : () => setState(() => _mode = _DecisionMode.reject),
              ),
            ),
          ] else if (_mode == _DecisionMode.approve)
            ProtocolSurface(
              border: const Color(0xFF99F6E4),
              radius: 12,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xác nhận phê duyệt phiên bản ${widget.detail.card.versionNo}',
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF00786F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.detail.card.protocolType == ProtocolType.treatment
                        ? 'Phiên bản sẽ bị khóa. Ngày duyệt hôm nay trở thành ngày 1 điều trị.'
                        : 'Phiên bản sẽ bị khóa. Lịch được sinh cuốn theo ngày thả giống, không tạo cứng toàn bộ mùa vụ.',
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.625,
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _Ghost(
                        label: 'Xem lại',
                        onPressed: busy
                            ? null
                            : () =>
                                  setState(() => _mode = _DecisionMode.initial),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GradientButton(
                          label: 'Xác nhận duyệt',
                          compact: true,
                          borderRadius: 12,
                          leading: const AppSvgIcon(
                            AppSvgIconName.check,
                            size: 18,
                            color: Colors.white,
                          ),
                          isLoading: busy,
                          onPressed: () => _submit(true),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          else
            ProtocolSurface(
              border: const Color(0xFFFFC7D3),
              radius: 12,
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lý do từ chối *',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkSoft,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      key: const Key('protocol_rejection_reason'),
                      controller: _reason,
                      enabled: !busy,
                      minLines: 3,
                      maxLines: 5,
                      maxLength: 2000,
                      style: const TextStyle(fontSize: 13, height: 1.6),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Vui lòng nhập lý do từ chối.'
                          : value.trim().length > 2000
                          ? 'Tối đa 2000 ký tự.'
                          : null,
                      decoration: InputDecoration(
                        hintText:
                            'Ví dụ: Cần làm rõ liều ở cữ 14:00 và sản phẩm thay thế khi hết kho…',
                        hintStyle: const TextStyle(
                          fontSize: 13,
                          height: 1.6,
                          color: AppColors.inkMuted,
                        ),
                        contentPadding: const EdgeInsets.all(14),
                        counterText: '',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.line,
                            width: 1.25,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _Ghost(
                          label: 'Quay lại',
                          onPressed: busy
                              ? null
                              : () => setState(
                                  () => _mode = _DecisionMode.initial,
                                ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GradientButton(
                            label: 'Xác nhận từ chối',
                            compact: true,
                            borderRadius: 12,
                            gradientColors: const [protocolRose, protocolRose],
                            leading: const AppSvgIcon(
                              AppSvgIconName.close,
                              size: 18,
                              color: Colors.white,
                            ),
                            isLoading: busy,
                            onPressed: () {
                              if (_form.currentState!.validate()) {
                                _submit(false);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _submit(bool approve) async {
    await ref
        .read(protocolReviewProvider(widget.detail.card.id).notifier)
        .submit(widget.detail, approve: approve, reason: _reason.text);
  }
}

class _Ghost extends StatelessWidget {
  const _Ghost({
    required this.label,
    required this.onPressed,
    this.icon = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool icon;
  @override
  Widget build(BuildContext context) => OutlinedButton(
    style: OutlinedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.inkSoft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      minimumSize: const Size(0, 47),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: const BorderSide(color: AppColors.line, width: 1.25),
    ),
    onPressed: onPressed,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon) ...[
          const AppSvgIcon(
            AppSvgIconName.close,
            size: 18,
            color: AppColors.inkSoft,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
