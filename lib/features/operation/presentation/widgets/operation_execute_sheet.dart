import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_item_card.dart';
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
    useRootNavigator: true,
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
  late final TextEditingController _varianceReasonController;
  late final Listenable _formListenable;
  late final DateTime _openedAt;
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _openedAt = DateTime.now();
    _quantityController = TextEditingController(
      text: formatOperationCompact(
        widget.schedule.plannedQuantity,
        maxDecimals: 3,
      ),
    );
    _varianceReasonController = TextEditingController();
    _formListenable = Listenable.merge(<Listenable>[
      _quantityController,
      _varianceReasonController,
    ]);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _varianceReasonController.dispose();
    super.dispose();
  }

  double get _allowedVariancePct =>
      widget.schedule.protocolItem?.protocol?.allowedVariancePct ?? 10.0;

  OperationVarianceEvaluation get _eval => OperationVarianceEvaluation(
    planned: widget.schedule.plannedQuantity,
    actual: parseOperationQuantity(_quantityController.text),
    allowedPct: _allowedVariancePct,
  );

  bool get _canSubmit {
    if (!widget.schedule.canExecute) return false;
    final eval = _eval;
    if (!eval.isValidPositive) return false;
    if (widget.schedule.isStockInsufficientFor(eval.actual!)) return false;
    if (eval.hasAnyDeviation && _varianceReasonController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _handleSubmit() async {
    if (!widget.schedule.canExecute) {
      AppNoticeService.warning(
        context,
        'Chưa đến thời gian dự kiến thực hiện lịch vận hành.',
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    final eval = _eval;
    if (!eval.isValidPositive) return;

    if (widget.schedule.isStockInsufficientFor(eval.actual!)) {
      AppNoticeService.danger(
        context,
        'Số lượng vật tư trong kho không đủ để thực hiện (${widget.schedule.productName}).',
      );
      return;
    }

    final reason = _varianceReasonController.text.trim();
    if (eval.hasAnyDeviation && reason.isEmpty) {
      AppNoticeService.danger(
        context,
        'Vui lòng nhập lý do khi số lượng thực tế khác kế hoạch.',
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
            actualQuantity: eval.actual!,
            idempotencyKey: idempotencyKey,
            varianceReason: eval.hasAnyDeviation ? reason : null,
          );

      if (mounted) {
        Navigator.of(context).pop();
        widget.onSuccess();
        AppNoticeService.success(
          context,
          'Ghi nhận thực hiện hoạt động thành công!',
        );
      }
    } on Object catch (error) {
      if (mounted) {
        AppNoticeService.danger(context, ErrorMapper.displayMessage(error));
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
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset + 20),
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                OperationExecuteSheetHeader(
                  title: 'Ghi nhận thực hiện',
                  recordedAt: _openedAt,
                  onClose: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: OperationExecuteItemCard(
                      schedule: widget.schedule,
                      quantityController: _quantityController,
                      varianceReasonController: _varianceReasonController,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ListenableBuilder(
                  listenable: _formListenable,
                  builder: (_, _) {
                    final enabled = _canSubmit && !_isSubmitting;
                    return GradientButton(
                      label: _isSubmitting
                          ? 'Đang ghi nhận...'
                          : 'Xác nhận ghi nhận',
                      compact: true,
                      height: 48,
                      borderRadius: 16,
                      icon: Icons.check_rounded,
                      isLoading: _isSubmitting,
                      onPressed: enabled ? _handleSubmit : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
