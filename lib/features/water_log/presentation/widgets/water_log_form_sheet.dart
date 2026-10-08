import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:uuid/uuid.dart';

/// Mở bottom sheet nhập nhật ký đo nước. Trả về true khi lưu thành công.
Future<bool?> showWaterLogFormSheet({
  required BuildContext context,
  required String seasonId,
}) => showModalBottomSheet<bool>(
  context: context,
  useRootNavigator: true,
  useSafeArea: true,
  isScrollControlled: true,
  backgroundColor: Colors.white,
  showDragHandle: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  clipBehavior: Clip.antiAlias,
  barrierColor: const Color(0x990F1C2E),
  constraints: BoxConstraints(
    maxWidth: MediaQuery.sizeOf(context).width,
    maxHeight: MediaQuery.sizeOf(context).height * 0.92,
  ),
  builder: (sheetContext) => AnimatedPadding(
    duration: const Duration(milliseconds: 180),
    curve: Curves.easeOut,
    padding: EdgeInsets.only(
      bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
    ),
    child: SafeArea(top: false, child: _WaterLogFormSheet(seasonId: seasonId)),
  ),
);

class _WaterLogFormSheet extends ConsumerStatefulWidget {
  const _WaterLogFormSheet({required this.seasonId});

  final String seasonId;

  @override
  ConsumerState<_WaterLogFormSheet> createState() => _WaterLogFormSheetState();
}

class _WaterLogFormSheetState extends ConsumerState<_WaterLogFormSheet> {
  final Map<String, TextEditingController> _controllers = {
    for (final param in waterLogFormParams)
      param.field: TextEditingController(),
  };
  final TextEditingController _noteController = TextEditingController();
  final Map<String, String?> _fieldErrors = <String, String?>{};
  String? _formError;

  DateTime _recordedAt = DateTime.now();
  bool _submitting = false;
  String? _lastPayload;
  String? _idempotencyKey;

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _noteController.dispose();
    super.dispose();
  }

  String _formatRecordedAt() {
    final local = _recordedAt;
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    final dd = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$hh:$mm · $dd/$month';
  }

  Future<void> _pickRecordedAt() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _recordedAt,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 1)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_recordedAt),
    );
    if (time == null || !mounted) return;
    setState(() {
      _recordedAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  /// Parse các ô nhập. Trả về map field -> double cho các ô có giá trị,
  /// đồng thời điền _fieldErrors. Trả về null khi có lỗi.
  Map<String, double>? _parseInputs() {
    final values = <String, double>{};
    var hasError = false;
    _fieldErrors.clear();
    for (final param in waterLogFormParams) {
      final raw = _controllers[param.field]!.text.trim().replaceAll(',', '.');
      if (raw.isEmpty) {
        _fieldErrors[param.field] = null;
        continue;
      }
      final value = double.tryParse(raw);
      if (value == null) {
        _fieldErrors[param.field] = 'Số không hợp lệ';
        hasError = true;
        continue;
      }
      final rangeError = _checkRange(param.field, value);
      if (rangeError != null) {
        _fieldErrors[param.field] = rangeError;
        hasError = true;
        continue;
      }
      _fieldErrors[param.field] = null;
      values[param.field] = value;
    }
    return hasError ? null : values;
  }

  String? _checkRange(String field, double value) {
    switch (field) {
      case 'temperatureC':
        if (value < 0 || value > 50) return '0 – 50 °C';
      case 'ph':
        if (value < 0 || value > 14) return '0 – 14';
      default:
        if (value < 0) return 'Phải ≥ 0';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_submitting) return;
    final values = _parseInputs();
    setState(() {
      _formError = values == null
          ? 'Vui lòng kiểm tra lại các ô nhập.'
          : values.isEmpty
          ? 'Vui lòng nhập ít nhất một chỉ số đo.'
          : null;
    });
    if (values == null || values.isEmpty) return;

    setState(() => _submitting = true);
    try {
      final payload = <String, Object?>{
        'recordedAt': _recordedAt.toUtc().toIso8601String(),
        ...values,
      };
      final note = _noteController.text.trim();
      if (note.isNotEmpty) payload['note'] = note;
      final serializedPayload = jsonEncode(payload);
      if (_lastPayload != serializedPayload) {
        _lastPayload = serializedPayload;
        _idempotencyKey = const Uuid().v4();
      }

      await ref
          .read(waterLogListProvider(widget.seasonId).notifier)
          .createWaterLog(payload: payload, idempotencyKey: _idempotencyKey!);
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _formError = error is AppException
            ? error.message
            : 'Không thể lưu nhật ký. Vui lòng thử lại.';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Container(
    key: const Key('water_log_form_sheet'),
    width: double.infinity,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.92,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _SheetHeader(onClose: () => Navigator.of(context).pop()),
        const Divider(height: 1, color: Color(0xFFEEF1F7)),
        Flexible(
          fit: FlexFit.loose,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Thời điểm đo',
                  style: TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: AppColors.line),
                  ),
                  child: InkWell(
                    onTap: _pickRecordedAt,
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(
                            Icons.schedule_rounded,
                            color: AppColors.ocean,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _formatRecordedAt(),
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.edit_calendar_rounded,
                            color: AppColors.inkMuted,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 92,
                  ),
                  itemCount: waterLogFormParams.length,
                  itemBuilder: (context, index) {
                    final param = waterLogFormParams[index];
                    return _NumberField(
                      param: param,
                      controller: _controllers[param.field]!,
                      errorText: _fieldErrors[param.field],
                    );
                  },
                ),
                const SizedBox(height: 14),
                const Text(
                  'Ghi chú',
                  style: TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  minLines: 2,
                  maxLines: 4,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: 'Quan sát tại hiện trường…',
                  ),
                ),
                if (_formError != null) ...<Widget>[
                  const SizedBox(height: 10),
                  Text(
                    _formError!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                GradientButton(
                  label: 'Lưu nhật ký',
                  icon: Icons.check_rounded,
                  isLoading: _submitting,
                  onPressed: _submit,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 12, 10),
    child: Row(
      children: <Widget>[
        const Expanded(
          child: Text(
            'Nhập nhật ký đo nước',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Material(
          color: const Color(0xFFEEF1F6),
          shape: const CircleBorder(),
          child: IconButton(
            key: const Key('close_water_log_form'),
            tooltip: 'Đóng',
            visualDensity: VisualDensity.compact,
            onPressed: onClose,
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.inkMuted,
              size: 19,
            ),
          ),
        ),
      ],
    ),
  );
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.param,
    required this.controller,
    this.errorText,
  });

  final WaterLogParam param;
  final TextEditingController controller;
  final String? errorText;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      RichText(
        text: TextSpan(
          style: const TextStyle(
            color: AppColors.inkSoft,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          children: <InlineSpan>[
            TextSpan(text: param.label),
            if (param.unit.isNotEmpty)
              TextSpan(
                text: ' (${param.unit})',
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 6),
      SizedBox(
        height: 46,
        child: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          textInputAction: TextInputAction.next,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
          decoration: InputDecoration(
            hintText: '0.0',
            errorText: errorText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ),
    ],
  );
}
