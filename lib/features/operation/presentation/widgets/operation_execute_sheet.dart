import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/auth/presentation/view_models/auth_controller.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/technician_dashboard_controller.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_execute_item_card.dart';
import 'package:uuid/uuid.dart';

class OperationExecuteSheet extends ConsumerStatefulWidget {
  const OperationExecuteSheet({required this.schedules, super.key});

  final List<OperationSchedule> schedules;

  static Future<bool?> show(
    BuildContext context, {
    required List<OperationSchedule> schedules,
  }) => showModalBottomSheet<bool>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.white,
    showDragHandle: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => OperationExecuteSheet(schedules: schedules),
  );

  @override
  ConsumerState<OperationExecuteSheet> createState() =>
      _OperationExecuteSheetState();
}

class _OperationExecuteSheetState extends ConsumerState<OperationExecuteSheet> {
  static const _activationNote = 'Ghi bổ sung do vụ nuôi kích hoạt muộn';

  final _form = GlobalKey<FormState>();
  late final _items = widget.schedules.map(_ExecutionItem.new).toList();
  late final _quantities = Listenable.merge(
    _items.map((item) => item.quantity),
  );
  late final _earliest = widget.schedules
      .map((row) => row.scheduledAt)
      .reduce((left, right) => left.isAfter(right) ? left : right);
  DateTime? get _activation => widget.schedules.first.activatedAt;

  static DateTime _vietnamTime(DateTime instant) =>
      instant.toUtc().add(AssignedSeasonRules.vietnamOffset);

  late DateTime _date = DateUtils.dateOnly(_vietnamTime(_earliest));
  late final _note = TextEditingController(
    text: _activation == null ? null : _activationNote,
  );
  TimeOfDay? _time;
  String? _timeError;
  bool _sending = false;

  DateTime? get _executedAt {
    final time = _time;
    if (time == null) return null;
    return DateTime.utc(
      _date.year,
      _date.month,
      _date.day,
      time.hour,
      time.minute,
    ).subtract(AssignedSeasonRules.vietnamOffset);
  }

  bool get _needsNote {
    final actual = _executedAt;
    return _activation != null ||
        (actual != null &&
            widget.schedules.any((row) => row.requiresExecutionNote(actual)));
  }

  bool get _checkCurrentStock =>
      DateUtils.isSameDay(_date, _vietnamTime(DateTime.now()));

  bool get _needsVarianceReason => _items.any((item) {
    final evaluation = item.evaluate();
    return evaluation.exceedsAllowed &&
        (!_checkCurrentStock ||
            !item.schedule.isStockInsufficientFor(evaluation.actual!));
  });

  bool _requiresLateReason(DateTime actual) {
    final activation = _activation;
    return (activation == null || !actual.isBefore(activation)) &&
        widget.schedules.any((row) => row.isLateAt(actual));
  }

  @override
  void dispose() {
    for (final item in _items) {
      item.quantity.dispose();
    }
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final first = DateUtils.dateOnly(_vietnamTime(_earliest));
    final last = DateUtils.dateOnly(_vietnamTime(DateTime.now()));
    if (first.isAfter(last)) return;
    final result = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: first,
      lastDate: last,
      helpText: 'Ngày thực hiện thực tế',
    );
    if (mounted && result != null) {
      setState(() {
        _date = result;
        _timeError = null;
      });
    }
  }

  Future<void> _pickTime() async {
    final current = _vietnamTime(DateTime.now());
    final start = _vietnamTime(_earliest);
    final result = await showTimePicker(
      context: context,
      initialTime:
          _time ??
          TimeOfDay.fromDateTime(
            DateUtils.isSameDay(_date, current) ? current : start,
          ),
      helpText: 'Giờ thực hiện thực tế',
    );
    if (mounted && result != null) {
      setState(() {
        _time = result;
        _timeError = null;
        if (_activation != null) {
          final note = _note.text.trim();
          if (_requiresLateReason(_executedAt!)) {
            if (note == _activationNote) _note.clear();
          } else if (note.isEmpty) {
            _note.text = _activationNote;
          }
        }
      });
    }
  }

  String? _validateTime(DateTime? actual, DateTime now) {
    if (actual == null) return 'Vui lòng chọn giờ thực hiện.';
    if (actual.isAfter(now)) {
      return 'Giờ thực hiện không được sau thời điểm hiện tại.';
    }
    if (actual.isBefore(_earliest)) {
      return 'Giờ thực hiện phải từ giờ đã lên lịch.';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_sending || widget.schedules.any((row) => !row.canExecute)) return;
    final actual = _executedAt;
    final timeError = _validateTime(actual, DateTime.now());
    setState(() => _timeError = timeError);
    final valid = _form.currentState!.validate();
    if (!valid || timeError != null || actual == null) return;

    final explanation = _note.text.trim();
    final entries = <OperationExecuteBatchItem>[];
    for (final item in _items) {
      final evaluation = item.evaluate();
      final quantity = evaluation.actual!;
      if (_checkCurrentStock &&
          item.schedule.isStockInsufficientFor(quantity)) {
        AppNoticeService.danger(
          context,
          'Không đủ tồn kho cho ${item.schedule.productName}.',
        );
        return;
      }
      entries.add(
        item.prepare(
          quantity: quantity,
          actual: actual,
          note: item.schedule.requiresExecutionNote(actual)
              ? explanation
              : null,
          reason: evaluation.exceedsAllowed ? explanation : null,
        ),
      );
    }
    setState(() => _sending = true);
    try {
      final repo = ref.read(operationRepositoryProvider);
      if (entries.length == 1) {
        final entry = entries.single;
        await repo.executeSchedule(
          entry.scheduleId,
          actualQuantity: entry.actualQuantity,
          idempotencyKey: entry.idempotencyKey,
          executedAt: entry.executedAt,
          note: entry.note,
          varianceReason: entry.varianceReason,
          historicalOccurrence: entry.historicalOccurrence,
        );
      } else {
        await repo.executeSchedulesBatch(entries);
      }
      if (!mounted) return;
      ref.invalidate(technicianDashboardProvider);
      Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (!mounted) return;
      if (error is SessionExpiredException) {
        await ref.read(authControllerProvider.notifier).expireSession();
      } else {
        AppNoticeService.danger(context, ErrorMapper.displayMessage(error));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    final locale = MaterialLocalizations.of(context);
    final enabled =
        !_sending && widget.schedules.every((row) => row.canExecute);
    return PopScope(
      canPop: !_sending,
      child: Padding(
        padding: EdgeInsets.only(bottom: inset),
        child: SafeArea(
          top: false,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * .88 - inset * .55,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Ghi nhận thực hiện',
                          style: TextStyle(
                            color: AppColors.ink,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Đóng',
                        onPressed: _sending
                            ? null
                            : () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thời gian thực hiện thực tế',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                OutlinedButton.icon(
                                  icon: const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 16,
                                  ),
                                  label: Text(locale.formatCompactDate(_date)),
                                  onPressed: enabled && _activation == null
                                      ? _pickDate
                                      : null,
                                ),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.access_time, size: 17),
                                  label: Text(
                                    _time?.format(context) ??
                                        'Chọn giờ thực hiện',
                                  ),
                                  onPressed: enabled ? _pickTime : null,
                                ),
                              ],
                            ),
                            if (_timeError case final error?) ...[
                              const SizedBox(height: 4),
                              Text(
                                error,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            for (var index = 0; index < _items.length; index++)
                              OperationExecuteItemCard(
                                schedule: _items[index].schedule,
                                quantityController: _items[index].quantity,
                                checkCurrentStock: _checkCurrentStock,
                                showDivider: index < _items.length - 1,
                              ),
                            ListenableBuilder(
                              listenable: _quantities,
                              builder: (_, _) => _buildReasonField(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  GradientButton(
                    label: _sending ? 'Đang ghi nhận...' : 'Xác nhận ghi nhận',
                    compact: true,
                    height: 48,
                    borderRadius: 16,
                    icon: Icons.check_rounded,
                    isLoading: _sending,
                    onPressed: enabled ? _submit : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReasonField() {
    final needsNote = _needsNote;
    final needsVarianceReason = _needsVarianceReason;
    if (!needsNote && !needsVarianceReason) return const SizedBox.shrink();

    final actual = _executedAt;
    final label = switch ((needsNote, needsVarianceReason)) {
      (true, true) => 'Lý do ghi nhận *',
      (false, true) => 'Lý do chênh lệch *',
      _ when actual != null && _requiresLateReason(actual) =>
        'Lý do thực hiện quá hạn *',
      _ => 'Lý do ghi bổ sung *',
    };
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextFormField(
        key: const Key('operation-execution-reason'),
        controller: _note,
        enabled: !_sending,
        maxLength: 500,
        minLines: 2,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          helperText: needsNote && needsVarianceReason
              ? 'Nêu lý do về thời điểm thực hiện và lượng dùng.'
              : null,
          helperMaxLines: 2,
          alignLabelWithHint: true,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          final explanation = value?.trim() ?? '';
          if (needsVarianceReason &&
              (explanation.isEmpty || explanation == _activationNote)) {
            return 'Bắt buộc nhập lý do chênh lệch';
          }
          return explanation.isEmpty ? 'Vui lòng nhập lý do.' : null;
        },
      ),
    );
  }
}

class _ExecutionItem {
  _ExecutionItem(this.schedule);

  final OperationSchedule schedule;
  late final quantity = TextEditingController(
    text: formatOperationCompact(schedule.plannedQuantity, maxDecimals: 9),
  );
  ({double quantity, DateTime actual, String? note, String? reason})?
  _lastInput;
  String? _requestKey;

  OperationVarianceEvaluation evaluate() => OperationVarianceEvaluation(
    planned: schedule.plannedQuantity,
    actual: parseOperationQuantity(quantity.text),
    allowedPct: schedule.protocolItem?.protocol?.allowedVariancePct ?? 10,
  );

  OperationExecuteBatchItem prepare({
    required double quantity,
    required DateTime actual,
    String? note,
    String? reason,
  }) {
    final input = (
      quantity: quantity,
      actual: actual,
      note: note,
      reason: reason,
    );
    if (input != _lastInput) {
      _lastInput = input;
      _requestKey = const Uuid().v4();
    }
    return OperationExecuteBatchItem(
      scheduleId: schedule.id,
      actualQuantity: quantity,
      idempotencyKey: _requestKey!,
      executedAt: actual,
      note: note,
      varianceReason: reason,
      historicalOccurrence: schedule.activatedAt == null
          ? null
          : (seasonId: schedule.seasonId, scheduledAt: schedule.scheduledAt),
    );
  }
}
