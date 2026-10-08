import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:uuid/uuid.dart';

class OperationExecuteSheet extends ConsumerStatefulWidget {
  const OperationExecuteSheet({
    required this.schedule,
    required this.onSuccess,
    super.key,
  });

  final OperationSchedule schedule;
  final VoidCallback onSuccess;

  static Future<void> show(
    BuildContext context, {
    required OperationSchedule schedule,
    required VoidCallback onSuccess,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        OperationExecuteSheet(schedule: schedule, onSuccess: onSuccess),
  );

  @override
  ConsumerState<OperationExecuteSheet> createState() =>
      _OperationExecuteSheetState();
}

class _OperationExecuteSheetState extends ConsumerState<OperationExecuteSheet> {
  late final TextEditingController _quantityController;
  late final TextEditingController _noteController;
  late final TextEditingController _varianceReasonController;
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;
  double _actualQuantity = 0;

  @override
  void initState() {
    super.initState();
    _actualQuantity = widget.schedule.plannedQuantity;
    _quantityController = TextEditingController(
      text: widget.schedule.plannedQuantity.toString(),
    );
    _noteController = TextEditingController();
    _varianceReasonController = TextEditingController();

    _quantityController.addListener(() {
      final parsed = double.tryParse(_quantityController.text);
      if (parsed != null && parsed != _actualQuantity) {
        setState(() {
          _actualQuantity = parsed;
        });
      }
    });
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    _varianceReasonController.dispose();
    super.dispose();
  }

  double get _allowedVariancePct =>
      widget.schedule.protocolItem?.protocol?.allowedVariancePct ?? 10.0;

  double get _variancePct {
    final planned = widget.schedule.plannedQuantity;
    if (planned <= 0) return 0;
    return ((_actualQuantity - planned).abs() / planned) * 100;
  }

  bool get _exceedsVariance => _variancePct > _allowedVariancePct;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_exceedsVariance && _varianceReasonController.text.trim().isEmpty) {
      AppNoticeService.warning(
        context,
        'Chênh lệch ${_variancePct.toStringAsFixed(1)}% vượt mức cho phép (${_allowedVariancePct.toStringAsFixed(0)}%). Vui lòng nhập lý do.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final idempotencyKey = const Uuid().v4();
      await ref
          .read(operationDetailProvider(widget.schedule.id).notifier)
          .execute(
            actualQuantity: _actualQuantity,
            idempotencyKey: idempotencyKey,
            note: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
            varianceReason: _exceedsVariance
                ? _varianceReasonController.text.trim()
                : null,
          );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onSuccess();
        AppNoticeService.success(
          context,
          'Ghi nhận thực hiện hoạt động thành công!',
        );
      }
    } on AppException catch (e) {
      if (mounted) {
        AppNoticeService.danger(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        AppNoticeService.danger(context, 'Lỗi: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Header
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Ghi nhận thực hiện',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // FIFO Warning card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F7F5),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF0F9B8E).withValues(alpha: 0.2),
                  ),
                ),
                child: const Text(
                  'Khi xác nhận, hệ thống trừ kho theo thứ tự lô nhập trước, lưu kết quả thực hiện không thể chỉnh sửa và hoàn tất lịch.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFF0B7A70),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Product name field (Readonly)
              const Text(
                'Sản phẩm sử dụng',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkSoft,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.line),
                ),
                child: Text(
                  widget.schedule.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Actual quantity input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Số lượng thực tế',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.inkSoft,
                    ),
                  ),
                  Text(
                    widget.schedule.unit.toLowerCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _quantityController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.ocean),
                  ),
                ),
                validator: (val) {
                  final n = double.tryParse(val ?? '');
                  if (n == null || n <= 0) {
                    return 'Số lượng phải lớn hơn 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6),
              Text(
                'Kế hoạch: ${widget.schedule.plannedQuantity} ${widget.schedule.unit.toLowerCase()}',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 8),

              // Variance info indicator
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: _exceedsVariance
                      ? const Color(0xFFFDE8EC)
                      : const Color(0xFFF2F6FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _exceedsVariance
                      ? 'Chênh lệch ${_variancePct.toStringAsFixed(1)}% — vượt ngưỡng cho phép (${_allowedVariancePct.toStringAsFixed(0)}%)! Bắt buộc nhập lý do.'
                      : 'Chênh lệch ${_variancePct.toStringAsFixed(1)}% — trong ngưỡng cho phép.',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: _exceedsVariance
                        ? AppColors.error
                        : const Color(0xFF1378D1),
                  ),
                ),
              ),

              // Variance reason if exceeded
              if (_exceedsVariance) ...<Widget>[
                const SizedBox(height: 16),
                const Text(
                  'Lý do chênh lệch *',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _varianceReasonController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Nhập lý do chênh lệch số lượng...',
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: AppColors.inkMuted,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.error),
                    ),
                  ),
                  validator: (val) {
                    if (_exceedsVariance &&
                        (val == null || val.trim().isEmpty)) {
                      return 'Vui lòng nhập lý do chênh lệch';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 16),

              // Notes field
              const Text(
                'Ghi chú',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkSoft,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tình trạng bắt mồi, thời tiết...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.inkMuted,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.line),
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Submit button
              GradientButton(
                label: _isSubmitting ? 'Đang ghi nhận...' : 'Xác nhận ghi nhận',
                isLoading: _isSubmitting,
                onPressed: _isSubmitting ? null : _handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
