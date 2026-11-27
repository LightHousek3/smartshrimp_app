import 'package:smartshrimp_app/core/utils/vietnamese_number.dart';
import 'package:smartshrimp_app/core/utils/vietnamese_number_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/harvest/domain/harvest_policy.dart';
import 'package:smartshrimp_app/features/harvest/domain/entities/harvest_event.dart';
import 'package:smartshrimp_app/features/harvest/presentation/view_models/harvest_controller.dart';
import 'package:smartshrimp_app/features/harvest/presentation/widgets/harvest_ui.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';

typedef _QuantityValidationError = ({String message, Set<String> fields});

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
      'price',
      'buyer',
      'contact',
      'note',
      'variance',
    ])
      key: TextEditingController(),
  };
  DateTime? _time;
  bool _final = false;
  bool _confirming = false;
  String? _error;
  String? _timeError;
  _QuantityValidationError? _quantityError;
  bool _submitted = false;
  final _weightFocus = FocusNode();
  final _countFocus = FocusNode();
  bool _weightBlurred = false;
  bool _countBlurred = false;

  @override
  void initState() {
    super.initState();
    _weightFocus.addListener(_onWeightFocusChanged);
    _countFocus.addListener(_onCountFocusChanged);
  }

  void _onWeightFocusChanged() {
    setState(() {
      if (!_weightFocus.hasFocus) _weightBlurred = true;
    });
  }

  void _onCountFocusChanged() {
    setState(() {
      if (!_countFocus.hasFocus) _countBlurred = true;
    });
  }

  AutovalidateMode get _fieldAutovalidateMode =>
      _submitted ? AutovalidateMode.always : AutovalidateMode.onUserInteraction;

  ({String seasonId, DateTime? at}) get _populationQuery =>
      (seasonId: widget.seasonId, at: _time?.toUtc());

  void _switchHarvestType(bool isFinal) {
    if (_final == isFinal) return;
    FocusScope.of(context).unfocus();
    _form.currentState?.reset();
    for (final controller in _fields.values) {
      controller.clear();
    }
    setState(() {
      _final = isFinal;
      _time = null;
      _submitted = false;
      _weightBlurred = false;
      _countBlurred = false;
      _timeError = null;
      _quantityError = null;
      _error = null;
    });
  }

  @override
  void dispose() {
    _weightFocus.dispose();
    _countFocus.dispose();
    for (final controller in _fields.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _label(String text, {bool required = false}) => Text.rich(
    TextSpan(
      text: text,
      children: [
        if (required)
          const TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.error),
          ),
      ],
    ),
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
    final normalized = normalizeVietnameseNumber(raw);
    if (normalized == null ||
        !RegExp(r'^-?\d+(?:\.\d+)?$').hasMatch(normalized)) {
      return 'Vui lòng chỉ nhập số';
    }
    final value = double.tryParse(normalized);
    if (value == null || !value.isFinite) return 'Giá trị quá lớn';
    if (zero ? value < 0 : value <= 0) {
      return zero
          ? 'Giá trị phải lớn hơn hoặc bằng 0'
          : 'Giá trị phải lớn hơn 0';
    }
    final fraction = normalized.split('.');
    if (fraction.length > 1 && fraction.last.length > decimals) {
      return decimals == 0
          ? 'Vui lòng nhập số nguyên'
          : 'Chỉ nhập tối đa $decimals chữ số sau dấu phẩy';
    }
    if (value > max) return 'Giá trị quá lớn';
    return null;
  }

  num? _value(String key) =>
      num.tryParse(normalizeVietnameseNumber(_fields[key]!.text) ?? '');

  String? _validateTime(AquacultureSeason season) =>
      validateHarvestTime(_time, season.stockingDate);

  Widget _withdrawalStatus(HarvestWithdrawal state) {
    final String message;
    if (state.unknown) {
      message = 'Chưa xác định được thời gian ngừng thuốc.';
    } else {
      final end = state.latestEndAt?.toUtc().add(const Duration(hours: 7));
      String two(int value) => value.toString().padLeft(2, '0');
      final date = end == null
          ? 'chưa xác định'
          : '${two(end.hour)}:${two(end.minute)} ${two(end.day)}/${two(end.month)}/${end.year} (giờ VN)';
      message = 'Chưa đủ thời gian ngừng thuốc tới $date.';
    }
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: AppNoticeCard(
        key: const ValueKey('harvest-withdrawal-status'),
        title: 'Thời gian ngừng thuốc',
        message: '$message Không thể ghi nhận thu hoạch, kể cả thu hoạch cuối.',
        level: AppNoticeLevel.danger,
        expand: true,
      ),
    );
  }

  String? _quantityFieldError(String field) =>
      _quantityError?.fields.contains(field) == true
      ? _quantityError!.message
      : null;

  int? _compareHarvestCount(BigInt? available) {
    final count = BigInt.tryParse(
      normalizeVietnameseNumber(_fields['count']!.text) ?? '',
    );
    if (available == null ||
        count == null ||
        count <= BigInt.zero ||
        count > BigInt.from(9007199254740991)) {
      return null;
    }
    return count.compareTo(available);
  }

  String _countLabel(String value) => groupVietnameseDigits(value);

  _QuantityValidationError? _validateQuantity(
    ShrimpType species, {
    required BigInt? available,
    required bool speciesThresholdsEnabled,
  }) {
    final countDifference = _compareHarvestCount(available);
    if (!_final && countDifference != null && countDifference >= 0) {
      return (
        message:
            'Số lượng thu tỉa phải nhỏ hơn số tôm hiện có ước tính. Nếu thu hết hoặc vượt ước tính, vui lòng chọn thu hoạch cuối.',
        fields: const {'count'},
      );
    }
    // Field errors take priority over derived population/size errors.
    for (final key in ['weight', 'count', 'price']) {
      final raw = _fields[key]!.text.trim();
      if (raw.isNotEmpty &&
          _numeric(
                raw,
                required: true,
                max: key == 'weight'
                    ? 99999999999.999
                    : key == 'price'
                    ? 999999999999.99
                    : 9007199254740991,
                decimals: key == 'weight'
                    ? 3
                    : key == 'price'
                    ? 2
                    : 0,
                zero: key == 'price',
              ) !=
              null) {
        return null;
      }
    }
    final raw = normalizeVietnameseNumber(_fields['count']!.text) ?? '';
    final harvestedCount = BigInt.tryParse(raw);
    if (!RegExp(r'^\d+$').hasMatch(raw) ||
        harvestedCount == null ||
        harvestedCount <= BigInt.zero ||
        harvestedCount > BigInt.from(9007199254740991)) {
      return (
        message: _final
            ? 'Vui lòng nhập số con thu hoạch hợp lệ khi thu hoạch cuối.'
            : 'Vui lòng nhập số con thu hoạch hợp lệ khi thu tỉa.',
        fields: const {'count'},
      );
    }
    if (!_final && available == null) {
      return (
        message:
            'Chưa xác định được số tôm hiện có. Vui lòng cập nhật số lượng trước khi thu tỉa.',
        fields: const {'count'},
      );
    }

    return _validateSize(
      species,
      speciesThresholdsEnabled: speciesThresholdsEnabled,
    );
  }

  _QuantityValidationError? _validateSize(
    ShrimpType species, {
    required bool speciesThresholdsEnabled,
  }) {
    final weightError = _numeric(
      _fields['weight']!.text,
      required: true,
      max: 99999999999.999,
      decimals: 3,
    );
    final countError = _numeric(
      _fields['count']!.text,
      required: true,
      max: 9007199254740991,
    );
    if (weightError != null || countError != null) return null;

    // Mirror server limits after rounding size to two decimal places.
    final count = _value('count')!;
    final weight = _value('weight')!;
    final size = count / weight;
    final rounded = roundedHarvestSize(count, weight);
    final (min, max) = harvestSizeLimits(
      species,
      enabled: speciesThresholdsEnabled,
    );
    if (rounded >= min && rounded <= max) return null;
    final sizeLabel = size < 0.01 ? '< 0,01' : harvestNumber(rounded);
    return (
      message:
          'Cỡ tôm (số lượng / sản lượng) vô lý: $sizeLabel con/kg. Kiểm tra lại sản lượng hoặc số lượng.'
          '${speciesThresholdsEnabled ? ' Giới hạn: $min–$max con/kg.' : ''}',
      fields: const {'weight', 'count'},
    );
  }

  Future<void> _showQuantityAlert(String message) async {
    if (_confirming || !mounted) return;
    setState(() => _confirming = true);
    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AppDialog(
          title: 'Số lượng thu hoạch chưa hợp lệ',
          description: message,
          level: AppNoticeLevel.danger,
          content: Text(
            'Hiện có: ${ref.read(harvestPopulationProvider(_populationQuery)).value?.availableQuantityCount ?? 'Chưa xác định'} con\n'
            'Số lượng thu hoạch: ${_fields['count']!.text.isEmpty ? 'Chưa nhập' : _fields['count']!.text} con\n'
            'Số lượng còn lại: ${_final ? '0' : 'Hệ thống tính khi ghi nhận'}',
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Kiểm tra lại'),
            ),
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _confirming = false);
        _countFocus.requestFocus();
      }
    }
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
      final selected = DateTime(
        day.year,
        day.month,
        day.day,
        time.hour,
        time.minute,
      );
      setState(() {
        _time = selected;
        _quantityError = null;
        if (_submitted) _timeError = _validateTime(season);
      });
    }
  }

  Future<void> _submit(
    AquacultureSeason season, {
    required BigInt? available,
    required bool speciesThresholdsEnabled,
    required bool reasonRequired,
  }) async {
    if (_confirming ||
        ref.read(harvestMutationProvider(widget.seasonId)).isLoading) {
      return;
    }
    setState(() {
      _submitted = true;
      _timeError = _validateTime(season);
      _quantityError = _validateQuantity(
        season.shrimpType,
        available: available,
        speciesThresholdsEnabled: speciesThresholdsEnabled,
      );
    });
    final valid = _form.currentState!.validate();
    if (_quantityError != null) {
      await _showQuantityAlert(_quantityError!.message);
      return;
    }
    final price = _value('price');
    if (!valid || _timeError != null) return;
    final sizeWarning = harvestSizeWarning(
      _value('count')!,
      _value('weight')!,
      season.shrimpType,
      enabled: speciesThresholdsEnabled,
    );
    final priceWarning = harvestPriceWarning(
      price,
      season.shrimpType,
      enabled: speciesThresholdsEnabled,
    );
    final separateSizeWarning = _final && !speciesThresholdsEnabled;
    if (separateSizeWarning &&
        sizeWarning != null &&
        (!await _confirmUnusualFinalSize() || !mounted)) {
      return;
    }

    final body = <String, dynamic>{
      'harvestType': _final ? 'FINAL' : 'PARTIAL',
      'harvestedAt': _time!.toUtc().toIso8601String(),
      'totalWeightKg': _value('weight')!.toDouble(),
      if (_value('count') != null) 'quantityCount': _value('count')!.toInt(),
      if (reasonRequired) 'varianceReason': _fields['variance']!.text.trim(),
      'pricePerKg': ?price?.toDouble(),
      'buyerName': _fields['buyer']!.text.trim(),
      for (final entry in {'buyerContact': 'contact', 'note': 'note'}.entries)
        if (_fields[entry.value]!.text.trim().isNotEmpty)
          entry.key: _fields[entry.value]!.text.trim(),
    };
    if (!await _confirm(
      body,
      speciesThresholdsEnabled: speciesThresholdsEnabled,
      inputWarnings: [
        if (!separateSizeWarning && sizeWarning != null) sizeWarning,
        ?priceWarning,
      ],
    )) {
      return;
    }
    await _save(body);
  }

  Future<bool> _confirmUnusualFinalSize() async {
    setState(() => _confirming = true);
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AppConfirmDialog(
          title: 'Cỡ tôm ngoài khoảng thường gặp',
          description: harvestUnusualSizeWarning,
          cancelLabel: 'Kiểm tra lại',
          confirmLabel: 'Vẫn lưu',
          onCancel: () => Navigator.of(dialogContext).pop(false),
          onConfirm: () => Navigator.of(dialogContext).pop(true),
        ),
      );
      return mounted && confirmed == true;
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  Future<bool> _confirm(
    Map<String, dynamic> body, {
    bool recovery = false,
    bool speciesThresholdsEnabled = false,
    List<String> inputWarnings = const [],
  }) async {
    if (_confirming ||
        ref.read(harvestMutationProvider(widget.seasonId)).isLoading) {
      return false;
    }
    final isFinal = body['harvestType'] == 'FINAL';
    final season = ref
        .read(seasonDetailControllerProvider(widget.seasonId))
        .value;
    final warning = season == null
        ? null
        : earlyHarvestWarning(
            season,
            DateTime.parse(body['harvestedAt'] as String),
            speciesThresholdsEnabled: speciesThresholdsEnabled,
          );
    try {
      setState(() => _confirming = true);
      final confirmed = await showDialog<bool>(
        context: context,
        barrierColor: AppColors.ink.withValues(alpha: 0.35),
        builder: (dialogContext) => AppConfirmDialog(
          title: recovery
              ? 'Kiểm tra lần thu hoạch đang chờ'
              : isFinal
              ? 'Xác nhận thu hoạch cuối'
              : 'Xác nhận thu tỉa',
          description: recovery
              ? 'Gửi lại đúng dữ liệu và mã ghi nhận cũ để lấy kết quả, không tạo một lần thu hoạch mới.'
              : isFinal
              ? 'Thao tác này sẽ hoàn tất vụ nuôi. Bạn không thể ghi thêm lần thu hoạch cho vụ này.'
              : 'Kiểm tra thông tin trước khi ghi nhận thu tỉa. Vụ nuôi sẽ tiếp tục hoạt động.',
          confirmLabel: 'Xác nhận',
          cancelLabel: inputWarnings.isNotEmpty ? 'Kiểm tra lại' : 'Quay lại',
          level:
              isFinal || recovery || warning != null || inputWarnings.isNotEmpty
              ? AppNoticeLevel.warning
              : AppNoticeLevel.info,
          content: Text(
            '${isFinal ? 'Thu hoạch cuối' : 'Thu tỉa'} · ${harvestNumber(body['totalWeightKg'] as num)} kg\n'
            '${harvestDate(DateTime.parse(body['harvestedAt'] as String))}'
            '${body['quantityCount'] == null ? '' : '\nSố lượng thu: ${harvestNumber(body['quantityCount'] as num?)} con'}'
            '${body['pricePerKg'] == null ? '\nĐơn giá và doanh thu chưa xác định.' : ''}'
            '${isFinal
                ? ''
                : body['estimatedRemainingCount'] == null
                ? '\nSố tôm còn lại được hệ thống tính khi ghi nhận.'
                : '\nCòn lại ước tính: ${body['estimatedRemainingCount']} con'}'
            '${body['varianceReason'] == null ? '' : '\nLý do ghi nhận: ${body['varianceReason']}'}'
            '${inputWarnings.isEmpty ? '' : '\n\n${inputWarnings.join('\n\n')}'}'
            '${warning == null ? '' : '\n\nLưu ý: $warning'}',
          ),
          onConfirm: () => Navigator.of(dialogContext).pop(true),
          onCancel: () => Navigator.of(dialogContext).pop(false),
        ),
      );
      return mounted && confirmed == true;
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  void _restoreSubmission(Map<String, dynamic> body) {
    for (final entry in {
      'totalWeightKg': 'weight',
      'quantityCount': 'count',
      'pricePerKg': 'price',
      'buyerName': 'buyer',
      'buyerContact': 'contact',
      'note': 'note',
      'varianceReason': 'variance',
    }.entries) {
      final value = body[entry.key];
      _fields[entry.value]!.text = value is num
          ? formatVietnameseNumber(value)
          : value?.toString() ?? '';
    }
    _time = DateTime.parse(body['harvestedAt'] as String).toLocal();
    _final = body['harvestType'] == 'FINAL';
  }

  Future<void> _save(Map<String, dynamic> body) async {
    setState(() => _error = null);
    try {
      await ref
          .read(harvestMutationProvider(widget.seasonId).notifier)
          .submit(body);
      if (!mounted) return;
      AppNoticeService.success(context, 'Đã ghi nhận thu hoạch thành công.');
      context.pop();
    } on Object catch (error) {
      if (!mounted) return;
      final details = error is AppException ? error.details : null;
      final code = details is Map ? details['code'] : null;
      final populationError = const {
        'HARVEST_PARTIAL_COUNT_REQUIRED',
        'HARVEST_POPULATION_UNKNOWN',
        'HARVEST_POPULATION_MISMATCH',
      }.contains(code);
      setState(() {
        final harvestLabel = body['harvestType'] == 'FINAL'
            ? 'thu hoạch cuối'
            : 'thu tỉa';
        _error = harvestError(
          error,
          fallback:
              'Chưa thể xác nhận kết quả ghi nhận $harvestLabel. Vui lòng kiểm tra trạng thái lần thu và thử lại.',
        );
        if (isConfirmedHarvestTimeRejection(error)) {
          _restoreSubmission(body);
          _submitted = true;
          _timeError = _error;
          _quantityError = null;
        }
        if (populationError) {
          _submitted = true;
          _quantityError = (message: _error!, fields: const {'count'});
        }
      });
      if (error is AppException && [400, 409].contains(error.statusCode)) {
        ref.invalidate(harvestListProvider(widget.seasonId));
        ref.invalidate(harvestPopulationProvider(_populationQuery));
        ref.invalidate(seasonDetailControllerProvider(widget.seasonId));
      }
      if (populationError) await _showQuantityAlert(_error!);
    }
  }

  Widget _submissionError({required bool isFinal}) => Semantics(
    key: const ValueKey('harvest-submission-error'),
    liveRegion: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isFinal
              ? 'Không thể ghi nhận thu hoạch cuối'
              : 'Không thể ghi nhận thu tỉa',
          style: const TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(_error!, style: const TextStyle(color: AppColors.error)),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final seasonState = ref.watch(
      seasonDetailControllerProvider(widget.seasonId),
    );
    final mutation = ref.watch(harvestMutationProvider(widget.seasonId));
    // The estimate must use the selected instant, before later mortality occurred.
    final populationProvider = harvestPopulationProvider(_populationQuery);
    final populationState = ref.watch(populationProvider);
    // Policy flags apply to the whole form. Keep the initial response available
    // while the selected time loads its own population and withdrawal checks.
    final initialPolicy = ref
        .watch(harvestPopulationProvider((seasonId: widget.seasonId, at: null)))
        .value;
    final policy = populationState.value ?? initialPolicy;
    final pendingState = ref.watch(pendingHarvestProvider(widget.seasonId));
    final busy = mutation.isLoading || _confirming;
    if (pendingState.isLoading) {
      return const HarvestScaffold(
        title: 'Ghi nhận thu hoạch',
        children: [Center(child: CircularProgressIndicator())],
      );
    }
    if (pendingState.hasError) {
      return HarvestScaffold(
        title: 'Ghi nhận thu hoạch',
        children: [
          AppErrorState(
            error: pendingState.error!,
            onRetry: () =>
                ref.invalidate(pendingHarvestProvider(widget.seasonId)),
          ),
        ],
      );
    }
    final pending = pendingState.value;
    if (pending != null) {
      return PopScope(
        canPop: !busy,
        child: HarvestScaffold(
          title: 'Thu hoạch đang chờ xác nhận',
          children: [
            const Text(
              'Lần ghi nhận trước chưa có kết quả xác định. Hãy kiểm tra bằng mã cũ trước khi ghi thêm thu hoạch.',
            ),
            const SizedBox(height: 16),
            Text(
              '${pending.body['harvestType'] == 'FINAL' ? 'Thu hoạch cuối' : 'Thu tỉa'} · ${harvestNumber(pending.body['totalWeightKg'] as num)} kg',
            ),
            const SizedBox(height: 16),
            if (_error != null)
              _submissionError(isFinal: pending.body['harvestType'] == 'FINAL'),
            GradientButton(
              label: 'Kiểm tra và gửi lại',
              isLoading: mutation.isLoading,
              onPressed: busy
                  ? null
                  : () async {
                      if (await _confirm(pending.body, recovery: true)) {
                        await _save(pending.body);
                      }
                    },
            ),
          ],
        ),
      );
    }
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
            AppErrorState(
              error: error,
              onRetry: () => ref.invalidate(
                seasonDetailControllerProvider(widget.seasonId),
              ),
            ),
          ],
        ),
        data: (season) {
          final raw = populationState.isLoading || populationState.hasError
              ? null
              : populationState.value?.availableQuantityCount;
          final available = raw == null ? null : BigInt.tryParse(raw);
          final withdrawal =
              populationState.isLoading || populationState.hasError
              ? null
              : populationState.value?.withdrawal;
          final withdrawalBlocked =
              withdrawal?.verified == true &&
              (withdrawal!.unknown || withdrawal.blocked);
          final speciesThresholdsEnabled =
              policy?.speciesThresholdsEnabled ?? false;
          final deferredPriceEnabled = policy?.deferredPriceEnabled ?? false;
          final populationCorrectionEnabled =
              policy?.populationCorrectionEnabled ?? false;
          final warning = policy == null
              ? null
              : earlyHarvestWarning(
                  season,
                  _time,
                  speciesThresholdsEnabled: speciesThresholdsEnabled,
                );
          final countDifference = _compareHarvestCount(available);
          final correctionNeeded =
              _final && countDifference != null && countDifference > 0;
          final partialExhausted =
              !_final && countDifference != null && countDifference >= 0;
          _QuantityValidationError? validateQuantity() => _validateQuantity(
            season.shrimpType,
            available: available,
            speciesThresholdsEnabled: speciesThresholdsEnabled,
          );
          void refreshQuantityError() {
            if (_submitted) setState(() => _quantityError = validateQuantity());
          }

          final showCountError =
              !_countFocus.hasFocus && (_countBlurred || _submitted);
          // Size depends on both inputs and should wait while either is edited.
          final showSizeError =
              !_weightFocus.hasFocus &&
              !_countFocus.hasFocus &&
              (_weightBlurred || _countBlurred || _submitted) &&
              !partialExhausted;
          final liveSizeError =
              !showSizeError || (_final && !speciesThresholdsEnabled)
              ? null
              : _validateSize(
                  season.shrimpType,
                  speciesThresholdsEnabled: speciesThresholdsEnabled,
                )?.message;
          final submittedSizeError = _quantityFieldError('weight');
          final sizeError = showSizeError
              ? submittedSizeError ?? liveSizeError
              : null;
          final countError = !showCountError
              ? null
              : partialExhausted
              ? validateQuantity()?.message
              : submittedSizeError == null
              ? _quantityFieldError('count')
              : null;
          final diseaseRestricted =
              !populationCorrectionEnabled &&
              populationState.value?.finalReasonRequired == true;
          final reasonRequired =
              correctionNeeded || (_final && diseaseRestricted);
          final reasonLabel = correctionNeeded
              ? 'Lý do hiệu chỉnh'
              : 'Lý do thu hoạch cuối';

          return HarvestScaffold(
            title: 'Ghi nhận thu hoạch',
            subtitle: '${season.pond.name} · ${season.name}',
            children: [
              if (season.status == SeasonStatus.active)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: AppFormMessageBanner(
                    title: 'Lưu ý',
                    message:
                        'Tôm chết ghi vào hao hụt, không ghi thành thu hoạch.',
                    level: AppNoticeLevel.info,
                  ),
                ),
              if (populationState.isLoading) const LinearProgressIndicator(),
              if (season.status != SeasonStatus.active)
                const Text(
                  'Vụ nuôi đã kết thúc hoặc chưa hoạt động. Không thể ghi thêm thu hoạch.',
                )
              else
                Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label('Loại thu hoạch', required: true),
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
                                    : () => _switchHarvestType(value),
                                child: Text(
                                  value ? 'Thu hoạch cuối' : 'Thu tỉa',
                                ),
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
                      if (!_final && diseaseRestricted)
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: AppNoticeCard(
                            title: 'Ca bệnh / điều trị',
                            message:
                                'Không thể thu tỉa khi còn ca bệnh chưa đóng hoặc phác đồ điều trị chưa kết thúc.',
                            level: AppNoticeLevel.danger,
                            expand: true,
                          ),
                        ),
                      const SizedBox(height: 16),
                      _label('Thời điểm thu hoạch', required: true),
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
                            errorText:
                                _timeError ??
                                (populationState.hasError
                                    ? harvestError(
                                        populationState.error!,
                                        fallback:
                                            'Không thể kiểm tra số tôm tại thời điểm đã chọn. Vui lòng thử lại.',
                                      )
                                    : null),
                            errorMaxLines: 4,
                            errorStyle: const TextStyle(color: AppColors.error),
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
                      if (populationState.hasError &&
                          !(populationState.error is AppException &&
                              (populationState.error as AppException)
                                      .statusCode ==
                                  400))
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: busy
                                ? null
                                : () => ref.invalidate(populationProvider),
                            child: const Text('Kiểm tra lại số tôm'),
                          ),
                        ),
                      if (warning != null)
                        Container(
                          key: const ValueKey('harvest-early-warning'),
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF2D8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Color(0xFF92400E),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  warning,
                                  style: const TextStyle(
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (withdrawalBlocked) _withdrawalStatus(withdrawal),
                      _field(
                        'weight',
                        'Sản lượng (kg)',
                        busy,
                        hint: 'VD: 480',
                        decimals: 3,
                        required: true,
                        max: 99999999999.999,
                        fieldError: sizeError,
                        focusNode: _weightFocus,
                        validateOnBlur: true,
                        onChangedExtra: refreshQuantityError,
                      ),
                      if (!populationState.isLoading &&
                          !populationState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            available == null
                                ? 'Chưa có ước tính số tôm còn lại trong ao.'
                                : 'Số tôm còn lại ước tính trong ao: ${_countLabel(available.toString())} con.',
                            key: const ValueKey('harvest-available-count'),
                          ),
                        ),
                      _field(
                        'count',
                        'Số lượng thu hoạch (con)',
                        busy,
                        hint: 'Nhập số con thu hoạch',
                        required: true,
                        fieldError: countError ?? sizeError,
                        focusNode: _countFocus,
                        validateOnBlur: true,
                        max: 9007199254740991,
                        onChangedExtra: refreshQuantityError,
                      ),
                      if (reasonRequired)
                        _text(
                          'variance',
                          reasonLabel,
                          busy,
                          required: true,
                          maxLength: 500,
                          lines: 2,
                          hint: correctionNeeded
                              ? 'Giải thích vì sao số tôm thực tế vượt ước tính'
                              : 'Lý do thu hoạch cuối khi còn ca bệnh hoặc phác đồ điều trị',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập ${reasonLabel.toLowerCase()}.';
                            }
                            return validateHarvestTextLength(
                              value,
                              label: reasonLabel,
                              maxLength: 500,
                            );
                          },
                          onChangedExtra: refreshQuantityError,
                        ),
                      _field(
                        'price',
                        'Giá bán (đ/kg)',
                        busy,
                        hint: 'Nhập giá bán',
                        decimals: 2,
                        required: !deferredPriceEnabled,
                        zero: deferredPriceEnabled || speciesThresholdsEnabled,
                        max: 999999999999.99,
                        validateOnBlur: true,
                        validateValue: (price) => harvestPriceError(
                          price,
                          enabled: speciesThresholdsEnabled,
                        ),
                      ),
                      _text(
                        'buyer',
                        'Tên người mua',
                        busy,
                        required: true,
                        maxLength: 255,
                        hint: 'Nhập tên người mua',
                        validator: (value) {
                          final name = value?.trim() ?? '';
                          if (name.isEmpty) {
                            return 'Vui lòng nhập tên người mua.';
                          }
                          return validateHarvestTextLength(
                            name,
                            label: 'Tên người mua',
                            maxLength: 255,
                          );
                        },
                      ),
                      _text(
                        'contact',
                        'Liên hệ người mua',
                        busy,
                        maxLength: 255,
                        hint: 'Số điện thoại, địa chỉ,...',
                        lines: 4,
                      ),
                      _text(
                        'note',
                        'Ghi chú',
                        busy,
                        maxLength: harvestNoteMaxLength,
                        validator: validateHarvestNote,
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
                          child: _submissionError(isFinal: _final),
                        ),
                      const SizedBox(height: 8),
                      GradientButton(
                        label: _final
                            ? 'Ghi nhận thu hoạch cuối'
                            : 'Ghi nhận thu tỉa',
                        compact: true,
                        borderRadius: 14,
                        leading: const AppSvgIcon(
                          AppSvgIconName.harvest,
                          color: Colors.white,
                        ),
                        isLoading: mutation.isLoading,
                        onPressed:
                            busy ||
                                populationState.isLoading ||
                                populationState.hasError ||
                                withdrawalBlocked ||
                                (!_final && diseaseRestricted)
                            ? null
                            : () => _submit(
                                season,
                                available: available,
                                speciesThresholdsEnabled:
                                    speciesThresholdsEnabled,
                                reasonRequired: reasonRequired,
                              ),
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
    bool readOnly = false,
    String? fieldError,
    String? Function(num?)? validateValue,
    FocusNode? focusNode,
    bool validateOnBlur = false,
    VoidCallback? onChangedExtra,
  }) => Padding(
    key: ValueKey(key),
    padding: const EdgeInsets.only(top: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: required),
        const SizedBox(height: 6),
        TextFormField(
          key: ValueKey('harvest-field-$key'),
          controller: _fields[key],
          autovalidateMode: validateOnBlur
              ? AutovalidateMode.onUnfocus
              : _fieldAutovalidateMode,
          focusNode: focusNode,
          readOnly: readOnly,
          forceErrorText: fieldError,
          enabled: !busy,
          keyboardType: TextInputType.numberWithOptions(decimal: decimals > 0),
          inputFormatters: const [
            VietnameseNumberInputFormatter(rejectNonNumeric: true),
          ],
          style: const TextStyle(fontSize: 13, color: AppColors.ink),
          decoration: InputDecoration(
            hintText: hint,
            errorMaxLines: 4,
            hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
          onChanged: (_) {
            setState(() {});
            onChangedExtra?.call();
          },
          validator: readOnly
              ? null
              : (v) =>
                    _numeric(
                      v,
                      required: required,
                      max: max,
                      decimals: decimals,
                      zero: zero,
                    ) ??
                    validateValue?.call(_value(key)),
        ),
      ],
    ),
  );

  Widget _text(
    String key,
    String label,
    bool busy, {
    required int maxLength,
    bool required = false,
    FormFieldValidator<String>? validator,
    int lines = 1,
    String? hint = 'Tùy chọn',
    VoidCallback? onChangedExtra,
  }) => Padding(
    key: ValueKey(key),
    padding: const EdgeInsets.only(top: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label, required: required),
        const SizedBox(height: 6),
        TextFormField(
          key: ValueKey('harvest-field-$key'),
          controller: _fields[key],
          autovalidateMode: _fieldAutovalidateMode,
          enabled: !busy,
          maxLines: lines,
          maxLength: maxLength,
          validator:
              validator ??
              (value) => validateHarvestTextLength(
                value,
                label: label,
                maxLength: maxLength,
              ),
          onChanged: (_) => onChangedExtra?.call(),
          style: const TextStyle(fontSize: 13, color: AppColors.ink),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
            counterText: '',
            errorMaxLines: 2,
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
