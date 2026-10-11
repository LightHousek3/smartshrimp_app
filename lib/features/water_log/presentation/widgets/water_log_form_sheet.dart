import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_sheet_widgets.dart';
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
  showDragHandle: false,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
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
        WaterLogSheetHeader(
          title: 'Nhập nhật ký đo nước',
          closeKey: const Key('close_water_log_form'),
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
                Material(
                  color: const Color(0xFFEEF1F6),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: _submitting ? null : _pickRecordedAt,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: <InlineSpan>[
                            const TextSpan(text: 'Thời điểm đo: '),
                            TextSpan(
                              text: _formatRecordedAt(),
                              style: AppTypography.mono(
                                color: AppColors.ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ).copyWith(height: 1.5),
                            ),
                          ],
                        ),
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
                for (var row = 0; row < 4; row++) ...<Widget>[
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (var column = 0; column < 2; column++) ...<Widget>[
                        if (column > 0) const SizedBox(width: 12),
                        Expanded(
                          child: _NumberField(
                            param: waterLogFormParams[row * 2 + column],
                            controller:
                                _controllers[waterLogFormParams[row * 2 +
                                        column]
                                    .field]!,
                            errorText:
                                _fieldErrors[waterLogFormParams[row * 2 +
                                        column]
                                    .field],
                            enabled: !_submitting,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                const Text(
                  'Ghi chú',
                  style: TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _noteController,
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
                const SizedBox(height: 6),
              ],
            ),
          ),
        ),
        const Divider(height: 1.2, color: Color(0xFFEEF1F7)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: GradientButton(
            label: 'Lưu nhật ký',
            compact: true,
            borderRadius: 12,
            gradientColors: const <Color>[
              AppColors.oceanLight,
              AppColors.tealLight,
            ],
            leading: SvgPicture.asset(
              'assets/images/water_log_save.svg',
              width: 18,
              height: 18,
            ),
            isLoading: _submitting,
            onPressed: _submit,
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
    required this.enabled,
    this.errorText,
  });

  final WaterLogParam param;
  final TextEditingController controller;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: Text(
              param.field == 'alkalinityMgLCaCO3' ? 'Độ kiềm' : param.label,
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
          if (param.unit.isNotEmpty)
            Text(
              param.unit,
              style: AppTypography.mono(
                color: AppColors.inkMuted,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ).copyWith(height: 1.5),
            ),
        ],
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        ],
        textInputAction: TextInputAction.next,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.ink,
          height: 1.5,
        ),
        decoration: waterLogInputDecoration(
          hintText: '0.0',
          errorText: errorText,
        ),
      ),
    ],
  );
}
