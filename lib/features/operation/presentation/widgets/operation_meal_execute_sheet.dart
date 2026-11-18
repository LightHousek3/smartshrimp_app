import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/technician_dashboard_controller.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_item_card.dart';
import 'package:uuid/uuid.dart';

class OperationMealExecuteSheet extends ConsumerStatefulWidget {
  const OperationMealExecuteSheet({
    required this.group,
    required this.onSuccess,
    super.key,
  });

  final FeedingMedicineMealGroup group;
  final VoidCallback onSuccess;

  static Future<void> show(
    BuildContext context, {
    required FeedingMedicineMealGroup group,
    required VoidCallback onSuccess,
  }) => showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) =>
        OperationMealExecuteSheet(group: group, onSuccess: onSuccess),
  );

  @override
  ConsumerState<OperationMealExecuteSheet> createState() =>
      _OperationMealExecuteSheetState();
}

class _OperationMealExecuteSheetState
    extends ConsumerState<OperationMealExecuteSheet> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _quantityControllers =
      <String, TextEditingController>{};
  final Map<String, TextEditingController> _varianceControllers =
      <String, TextEditingController>{};
  late final Listenable _formListenable;
  late final DateTime _openedAt;

  bool _isSubmitting = false;

  List<OperationSchedule> get _executableSchedules =>
      widget.group.allSchedules
          .where((s) => s.status == OperationStatus.planned)
          .toList(growable: false);

  String get _mealLabel => widget.group.mealNumber != null
      ? 'Cữ ${widget.group.mealNumber}'
      : 'cữ ăn';

  @override
  void initState() {
    super.initState();
    _openedAt = DateTime.now();

    for (final schedule in _executableSchedules) {
      _quantityControllers[schedule.id] = TextEditingController(
        text: formatOperationCompact(schedule.plannedQuantity, maxDecimals: 3),
      );
      _varianceControllers[schedule.id] = TextEditingController();
    }

    _formListenable = Listenable.merge(<Listenable>[
      ..._quantityControllers.values,
      ..._varianceControllers.values,
    ]);
  }

  @override
  void dispose() {
    for (final c in _quantityControllers.values) {
      c.dispose();
    }
    for (final c in _varianceControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  OperationVarianceEvaluation _evaluate(OperationSchedule schedule) {
    final raw = _quantityControllers[schedule.id]?.text ?? '';
    final allowed =
        schedule.protocolItem?.protocol?.allowedVariancePct ?? 10.0;
    return OperationVarianceEvaluation(
      planned: schedule.plannedQuantity,
      actual: parseOperationQuantity(raw),
      allowedPct: allowed,
    );
  }

  bool get _canSubmit {
    if (_executableSchedules.isEmpty) return false;
    if (_executableSchedules.any((s) => !s.canExecute)) return false;
    for (final schedule in _executableSchedules) {
      final eval = _evaluate(schedule);
      if (!eval.isValidPositive) return false;
      if (schedule.isStockInsufficientFor(eval.actual!)) return false;
      if (eval.hasAnyDeviation) {
        final reason = _varianceControllers[schedule.id]?.text.trim() ?? '';
        if (reason.isEmpty) return false;
      }
    }
    return true;
  }

  Future<void> _handleSubmit() async {
    if (_executableSchedules.any((s) => !s.canExecute)) {
      AppNoticeService.warning(
        context,
        'Chưa đến thời gian dự kiến thực hiện lịch vận hành.',
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    for (final schedule in _executableSchedules) {
      final eval = _evaluate(schedule);
      if (!eval.isValidPositive) return;
      if (schedule.isStockInsufficientFor(eval.actual!)) {
        AppNoticeService.danger(
          context,
          'Số lượng vật tư trong kho không đủ để thực hiện (${schedule.productName}).',
        );
        return;
      }
      final reason = _varianceControllers[schedule.id]?.text.trim() ?? '';
      if (eval.hasAnyDeviation && reason.isEmpty) {
        AppNoticeService.danger(
          context,
          'Mục "${schedule.productName}" có chênh lệch so với kế hoạch. Vui lòng nhập lý do trước khi ghi nhận.',
        );
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repo = ref.read(operationRepositoryProvider);
      final batchItems = _executableSchedules
          .map((schedule) {
            final eval = _evaluate(schedule);
            final reason = _varianceControllers[schedule.id]?.text.trim();
            return OperationExecuteBatchItem(
              scheduleId: schedule.id,
              actualQuantity: eval.actual!,
              idempotencyKey: const Uuid().v4(),
              varianceReason:
                  eval.hasAnyDeviation && reason != null && reason.isNotEmpty
                      ? reason
                      : null,
            );
          })
          .toList(growable: false);

      // Ghi nhận toàn bộ các mục trong cữ trong 1 transaction atomic trên BE:
      // nếu bất kỳ vật tư nào thiếu kho hoặc lỗi, toàn bộ cữ rollback, không trừ kho dở dang.
      await repo.executeSchedulesBatch(batchItems);

      if (mounted) {
        ref.invalidate(technicianDashboardProvider);
        AppNoticeService.success(
          context,
          'Đã ghi nhận hoàn tất $_mealLabel!',
        );
        Navigator.of(context).pop();
        widget.onSuccess();
      }
    } on AppException catch (e) {
      if (mounted) {
        AppNoticeService.danger(context, e.message);
      }
    } catch (e) {
      if (mounted) {
        AppNoticeService.danger(context, 'Ghi nhận thất bại: $e');
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
    final title = _mealLabel;
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
                  title: 'Ghi nhận $title',
                  recordedAt: _openedAt,
                  onClose: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        for (var i = 0; i < _executableSchedules.length; i++)
                          OperationExecuteItemCard(
                            schedule: _executableSchedules[i],
                            quantityController:
                                _quantityControllers[_executableSchedules[i]
                                    .id]!,
                            varianceReasonController:
                                _varianceControllers[_executableSchedules[i]
                                    .id]!,
                            showDivider: i < _executableSchedules.length - 1,
                          ),
                      ],
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
                          : 'Xác nhận hoàn thành',
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
