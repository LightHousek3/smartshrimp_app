import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/harvest/presentation/view_models/harvest_controller.dart';
import 'package:smartshrimp_app/features/harvest/presentation/widgets/harvest_ui.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';

class HarvestFormPage extends ConsumerStatefulWidget {
  const HarvestFormPage({required this.seasonId, super.key});
  final String seasonId;
  @override
  ConsumerState<HarvestFormPage> createState() => _HarvestFormPageState();
}

class _HarvestFormPageState extends ConsumerState<HarvestFormPage> {
  final _form = GlobalKey<FormState>();
  final _fields = <String, TextEditingController>{
    for (final key in [
      'weight',
      'count',
      'remaining',
      'price',
      'buyer',
      'contact',
      'note',
    ])
      key: TextEditingController(),
  };
  DateTime? _time;
  bool _final = false;
  bool _confirming = false;
  String? _error;
  String? _timeError;
  String? _quantityError; // cross-field: mirrors backend INVALID_QUANTITY rule
  bool _submitted = false;

  @override
  void dispose() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 13.5,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
    ),
  );

  String? _numeric(
    String? text, {
    required bool required,
    required double max,
    int decimals = 0,
    bool zero = false,
  }) {
    final raw = text?.trim() ?? '';
    if (raw.isEmpty) return required ? 'Vui lòng nhập giá trị.' : null;
    final pattern = decimals == 0
        ? RegExp(r'^\d+$')
        : RegExp('^\\d+(?:[.,]\\d{1,$decimals})?\$');
    final value = double.tryParse(raw.replaceAll(',', '.'));
    if (!pattern.hasMatch(raw) ||
        value == null ||
        !value.isFinite ||
        value > max ||
        (zero ? value < 0 : value <= 0)) {
      return 'Giá trị ${zero ? '≥ 0' : '> 0'}, tối đa $max${decimals > 0 ? ', $decimals chữ số thập phân' : ', số nguyên'}.';
    }
    return null;
  }

  num? _value(String key) =>
      num.tryParse(_fields[key]!.text.trim().replaceAll(',', '.'));

  String? _validateTime() {
    if (_time == null) return 'Vui lòng chọn thời điểm thu hoạch.';
    if (_time!.isAfter(DateTime.now())) {
      return 'Thời điểm thu hoạch không được ở tương lai.';
    }
    return null;
  }

  /// Mirrors backend harvest.service.js lines 104-112:
  /// - (quantityCount ?? 0) + estimatedRemainingCount must not exceed [available]
  /// - size = quantityCount / totalWeightKg must be < 100_000_000 con/kg
  String? _validateQuantity({required int? available}) {
    final weight = _value('weight');
    final count = _value('count'); // optional
    final remaining = _value('remaining'); // required for PARTIAL

    // Cross-field: quantity + remaining <= available (only when available is known)
    if (available != null && !_final) {
      final q = count?.toInt() ?? 0;
      final r = remaining?.toInt() ?? 0;
      if (q + r > available) {
        return 'Số lượng thu ($q) + số con còn lại ($r) vượt quá số con hiện có ($available).';
      }
    }

    // size = count / weight < 100_000_000 con/kg
    if (count != null && weight != null && weight > 0) {
      final size = count.toDouble() / weight.toDouble();
      if (size >= 100000000) {
        return 'Mật độ tôm (số lượng / sản lượng) vô lý: ${size.toStringAsFixed(0)} con/kg. Kiểm tra lại sản lượng hoặc số lượng.';
      }
    }

    return null;
  }

  Future<void> _pickTime(AquacultureSeason season) async {
    final now = DateTime.now();
    final stocking = season.stockingDate;
    final first = stocking == null
        ? DateTime(2000)
        : DateTime(stocking.year, stocking.month, stocking.day);
    final day = await showDatePicker(
      context: context,
      firstDate: first.isAfter(now) ? now : first,
      lastDate: now,
      initialDate: _time ?? now,
    );
    if (day == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_time ?? now),
    );
    if (time != null && mounted) {
      setState(() {
        _time = DateTime(
          day.year,
          day.month,
          day.day,
          time.hour,
          time.minute,
        );
        if (_submitted) _timeError = _validateTime();
      });
    }
  }

  Future<void> _submit({required int? available}) async {
    setState(() {
      _submitted = true;
      _timeError = _validateTime();
      _quantityError = _validateQuantity(available: available);
    });
    if (_confirming ||
        ref.read(harvestMutationProvider(widget.seasonId)).isLoading ||
        !_form.currentState!.validate()) {
      return;
    }
    if (_timeError != null || _quantityError != null) return;

    if (_final) {
      setState(() => _confirming = true);
      final confirmed = await showDialog<bool>(
        context: context,
        barrierColor: AppColors.ink.withValues(alpha: 0.35),
        builder: (dialogContext) => AppConfirmDialog(
          title: 'Xác nhận thu hoạch cuối',
          description:
              'Thao tác này sẽ hoàn tất vụ nuôi. Bạn không thể ghi thêm lần thu hoạch cho vụ này.',
          confirmLabel: 'Xác nhận',
          level: AppNoticeLevel.warning,
          onConfirm: () => Navigator.of(dialogContext).pop(true),
          onCancel: () => Navigator.of(dialogContext).pop(false),
        ),
      );
      if (!mounted) return;
      setState(() => _confirming = false);
      if (confirmed != true) return;
    }
    final body = <String, dynamic>{
      'harvestType': _final ? 'FINAL' : 'PARTIAL',
      'harvestedAt': _time!.toUtc().toIso8601String(),
      'totalWeightKg': _value('weight')!.toDouble(),
      if (_value('count') != null) 'quantityCount': _value('count')!.toInt(),
      'estimatedRemainingCount': _final ? 0 : _value('remaining')!.toInt(),
      if (_value('price') != null) 'pricePerKg': _value('price')!.toDouble(),
      for (final entry in {
        'buyerName': 'buyer',
        'buyerContact': 'contact',
        'note': 'note',
      }.entries)
        if (_fields[entry.value]!.text.trim().isNotEmpty)
          entry.key: _fields[entry.value]!.text.trim(),
    };
    setState(() => _error = null);
    try {
      await ref
          .read(harvestMutationProvider(widget.seasonId).notifier)
          .submit(body);
      if (!mounted) return;
      AppNoticeService.success(context, 'Đã ghi nhận thu hoạch thành công.');
      context.pop();
    } on Object catch (error) {
      if (mounted) setState(() => _error = harvestError(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final seasonState = ref.watch(
      seasonDetailControllerProvider(widget.seasonId),
    );
    final mutation = ref.watch(harvestMutationProvider(widget.seasonId));
    // Watch the harvest list so we can mirror the backend's "available" count:
    // latest.estimatedRemainingCount if any harvest exists, else season.initialQuantity.
    final harvestListState = ref.watch(harvestListProvider(widget.seasonId));
    final busy = mutation.isLoading || _confirming;
    return PopScope(
      canPop: !busy,
      child: seasonState.when(
        loading: () => const HarvestScaffold(
          title: 'Ghi nhận thu hoạch',
          children: [Center(child: CircularProgressIndicator())],
        ),
        error: (error, _) => HarvestScaffold(
          title: 'Ghi nhận thu hoạch',
          children: [
            HarvestErrorView(
              error: error,
              retry: () => ref.invalidate(
                seasonDetailControllerProvider(widget.seasonId),
              ),
            ),
          ],
        ),
        data: (season) {
          // Mirrors backend: available = latest.estimatedRemainingCount ?? season.initialQuantity
          final latestHarvest = harvestListState.value?.items.firstOrNull;
          final available = latestHarvest?.estimatedRemainingCount != null
              ? int.tryParse(latestHarvest!.estimatedRemainingCount!)
              : season.initialQuantity;

          return HarvestScaffold(
          title: 'Ghi nhận thu hoạch',
          subtitle: '${season.pond.name} · ${season.name}',
          children: [
            if (season.status != SeasonStatus.active)
              const Text(
                'Vụ nuôi đã kết thúc hoặc chưa hoạt động. Không thể ghi thêm thu hoạch.',
              )
            else
              Form(
                key: _form,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label('Loại thu hoạch *'),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        for (final value in [false, true]) ...[
                          if (value) const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: _final == value
                                    ? (value
                                          ? const Color(0xFFE2F6F3)
                                          : const Color(0xFFEAF4FF))
                                    : Colors.white,
                                foregroundColor: _final == value
                                    ? (value
                                          ? const Color(0xFF00786F)
                                          : const Color(0xFF0C4E8F))
                                    : AppColors.inkMuted,
                                side: BorderSide(
                                  color: _final == value
                                      ? (value
                                            ? const Color(0xFF00BFA5)
                                            : const Color(0xFF3B9AFF))
                                      : const Color(0xFFE5E8F0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(0, 44),
                                textStyle: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onPressed: busy
                                  ? null
                                  : () => setState(() => _final = value),
                              child: Text(value ? 'Thu hoạch cuối' : 'Thu tỉa'),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (_final)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF2D8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFFD97706),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Thu hoạch cuối sẽ kết thúc vụ nuôi. Không thể hoàn tác.',
                                  style: TextStyle(
                                    color: Color(0xFF92400E),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    _label('Thời điểm thu hoạch *'),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: busy ? null : () => _pickTime(season),
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          errorText: _timeError,
                          suffixIcon: const SizedBox(
                            width: 44,
                            child: Center(
                              child: AppSvgIcon(
                                AppSvgIconName.calendar,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        isEmpty: _time == null,
                        child: Text(
                          _time == null
                              ? 'Chọn ngày và giờ...'
                              : harvestDate(_time!),
                          style: TextStyle(
                            fontSize: 13,
                            color: _time == null
                                ? AppColors.inkMuted
                                : AppColors.ink,
                          ),
                        ),
                      ),
                    ),
                    _field(
                      'weight',
                      'Sản lượng (kg) *',
                      busy,
                      hint: 'VD: 480',
                      decimals: 3,
                      required: true,
                      max: 99999999999.999,
                      onChangedExtra: _submitted
                          ? () => setState(
                                () => _quantityError =
                                    _validateQuantity(available: available),
                              )
                          : null,
                    ),
                    _field(
                      'count',
                      'Số lượng thu hoạch (con)',
                      busy,
                      hint: 'Tùy chọn',
                      max: 9007199254740991,
                      onChangedExtra: _submitted
                          ? () => setState(
                                () => _quantityError =
                                    _validateQuantity(available: available),
                              )
                          : null,
                    ),
                    if (!_final)
                      _field(
                        'remaining',
                        'Số con còn lại ước tính *',
                        busy,
                        hint: 'Ước tính sau lần thu này',
                        required: true,
                        max: 9007199254740991,
                        onChangedExtra: _submitted
                            ? () => setState(
                                  () => _quantityError =
                                      _validateQuantity(available: available),
                                )
                            : null,
                      ),
                    _field(
                      'price',
                      'Giá bán (đ/kg)',
                      busy,
                      hint: 'VD: 180000',
                      decimals: 2,
                      zero: true,
                      max: 999999999999.99,
                    ),
                    _text(
                      'buyer',
                      'Tên người mua',
                      busy,
                      maxLength: 255,
                      hint: 'Tùy chọn',
                    ),
                    _text(
                      'contact',
                      'Liên hệ người mua',
                      busy,
                      maxLength: 255,
                      hint: 'Số điện thoại...',
                    ),
                    _text(
                      'note',
                      'Ghi chú',
                      busy,
                      maxLength: 5000,
                      lines: 3,
                      hint: 'Ghi chú thêm...',
                    ),
                    if (_value('weight') != null && _value('price') != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 16),
                        child: Text(
                          'Doanh thu dự kiến: ${harvestNumber(_value('weight')! * _value('price')!)} đ',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    if (_quantityError != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _quantityError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12.5),
                        ),
                      ),
                    const SizedBox(height: 8),
                    GradientButton(
                      label: _final
                          ? 'Ghi nhận thu hoạch cuối'
                          : 'Ghi nhận thu tỉa',
                      compact: true,
                      borderRadius: 14,
                      leading: const AppSvgIcon(
                        AppSvgIconName.shrimp,
                        color: Colors.white,
                      ),
                      isLoading: mutation.isLoading,
                      onPressed: busy
                          ? null
                          : () => _submit(available: available),
                    ),
                  ],
                ),
              ),
          ],
        );
        },
      ),
    );
  }

  Widget _field(
    String key,
    String label,
    bool busy, {
    String? hint,
    bool required = false,
    double max = 9007199254740991,
    int decimals = 0,
    bool zero = false,
    VoidCallback? onChangedExtra,
  }) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 6),
        TextFormField(
          key: ValueKey('harvest-field-$key'),
          controller: _fields[key],
          enabled: !busy,
          keyboardType: TextInputType.numberWithOptions(decimal: decimals > 0),
          style: const TextStyle(fontSize: 13, color: AppColors.ink),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 13,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          onChanged: (_) {
            setState(() {});
            onChangedExtra?.call();
          },
          validator: (v) => _numeric(
            v,
            required: required,
            max: max,
            decimals: decimals,
            zero: zero,
          ),
        ),
      ],
    ),
  );

  Widget _text(
    String key,
    String label,
    bool busy, {
    required int maxLength,
    int lines = 1,
    String? hint = 'Tùy chọn',
  }) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        const SizedBox(height: 6),
        TextFormField(
          key: ValueKey('harvest-field-$key'),
          controller: _fields[key],
          enabled: !busy,
          maxLines: lines,
          maxLength: maxLength,
          style: const TextStyle(fontSize: 13, color: AppColors.ink),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 13,
            ),
            counterText: '',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    ),
  );
}
