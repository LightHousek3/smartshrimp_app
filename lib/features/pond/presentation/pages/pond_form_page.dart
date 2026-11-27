import 'package:smartshrimp_app/core/utils/vietnamese_number.dart';
import 'package:smartshrimp_app/core/utils/vietnamese_number_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show MaxLengthEnforcement;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/domain/pond_rules.dart';
import 'package:smartshrimp_app/features/pond/presentation/view_models/pond_controller.dart';

/// Use navigation data when available; direct edit links first load the pond.
class PondEditPage extends ConsumerWidget {
  const PondEditPage({
    required this.farmId,
    required this.pondId,
    this.initialPond,
    super.key,
  });
  final String farmId;
  final String pondId;
  final Pond? initialPond;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pond = initialPond;
    if (pond != null) return PondFormPage(farmId: farmId, initialPond: pond);
    final ids = (farmId: farmId, pondId: pondId);
    return ref
        .watch(pondDetailControllerProvider(ids))
        .when(
          data: (loaded) => PondFormPage(farmId: farmId, initialPond: loaded),
          loading: () => const Scaffold(
            backgroundColor: Colors.transparent,
            body: AppGradientBackground(
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (error, _) => Scaffold(
            backgroundColor: Colors.transparent,
            body: AppGradientBackground(
              child: SafeArea(
                child: AppErrorState(
                  error: error,
                  message: 'Không thể tải thông tin ao.',
                  onRetry: ref
                      .read(pondDetailControllerProvider(ids).notifier)
                      .refresh,
                ),
              ),
            ),
          ),
        );
  }
}

/// Shared create/edit form with local autofill and server-authoritative validation.
class PondFormPage extends ConsumerStatefulWidget {
  const PondFormPage({required this.farmId, this.initialPond, super.key});
  final String farmId;
  final Pond? initialPond;

  @override
  ConsumerState<PondFormPage> createState() => _PondFormPageState();
}

class _PondFormPageState extends ConsumerState<PondFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _area;
  late final TextEditingController _depth;
  late final TextEditingController _volume;
  final _volumeFocus = FocusNode();
  late bool _autoVolume;
  late PondType _type;
  late PondStatus _status;
  String? _volumeError;

  bool get _editing => widget.initialPond != null;

  // This is a UI snapshot: the backend rechecks occupancy if it changes meanwhile.
  bool get _hasOpenSeason => widget.initialPond?.hasOpenSeason == true;

  double? get _calculatedVolume => PondRules.calculateVolume(
    PondRules.parseNumber(_area.text),
    PondRules.parseNumber(_depth.text),
  );

  bool _isVolumeOutsideEstimate(double estimate) {
    final entered = PondRules.parseNumber(_volume.text);
    if (entered == null || PondRules.validateVolume(_volume.text) != null) {
      return false;
    }
    // Compare at storage precision so exactly 10% does not warn.
    final estimateHundredths = (estimate * 100).round();
    final enteredHundredths = (entered * 100).round();
    return (enteredHundredths - estimateHundredths).abs() * 10 >
        estimateHundredths;
  }

  // Compare normalized values so formatting changes cannot trigger an empty update.
  bool get _hasChanges {
    final pond = widget.initialPond;
    if (pond == null) return true;
    final volume = _volume.text.trim().isEmpty
        ? pond.volumeM3
        : PondRules.parseNumber(_volume.text);
    return PondRules.normalizeName(_name.text) !=
            PondRules.normalizeName(pond.name) ||
        volume != pond.volumeM3 ||
        (!_hasOpenSeason &&
            (PondRules.parseNumber(_area.text) != pond.areaM2 ||
                PondRules.parseNumber(_depth.text) != pond.depthM)) ||
        _type != pond.type ||
        _status != pond.status;
  }

  // Allow an existing maintenance value, but never enter it with an open season.
  bool get _canEnterMaintenance =>
      !_hasOpenSeason || widget.initialPond?.status == PondStatus.maintenance;

  @override
  void initState() {
    super.initState();
    final pond = widget.initialPond;
    _name = TextEditingController(text: pond?.name);
    _area = TextEditingController(text: formatVietnameseNumber(pond?.areaM2));
    _depth = TextEditingController(text: formatVietnameseNumber(pond?.depthM));
    _volume = TextEditingController(
      text: formatVietnameseNumber(pond?.volumeM3),
    );
    _type = pond?.type ?? PondType.aquaculture;
    _status = pond?.status ?? PondStatus.available;
    // Existing usable volume is intentional; never replace it on opening edit.
    _autoVolume = !_editing;
    if (_autoVolume) _fillVolume();
    _volumeFocus.addListener(_onVolumeFocusChanged);
  }

  /// Fill only from supported dimensions; invalid dimensions clear an automatic value.
  void _fillVolume() {
    final text = formatVietnameseNumber(_calculatedVolume, decimalPlaces: 2);
    if (_volume.text == text) return;
    _volume.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _onNumberChanged(TextEditingController controller) {
    setState(() {
      _volumeError = null;
      if (identical(controller, _volume)) {
        // Manual input takes precedence over later changes to dimensions.
        _autoVolume = false;
      } else if (_autoVolume) {
        _fillVolume();
      }
    });
  }

  // Wait for blur so clearing/retyping a manual value is not interrupted by autofill.
  void _onVolumeFocusChanged() {
    if (!_editing && !_volumeFocus.hasFocus && _volume.text.trim().isEmpty) {
      _useAutoVolume();
    }
  }

  /// Clearing volume opts back into following dimension changes.
  void _useAutoVolume() {
    setState(() {
      _autoVolume = true;
      _volumeError = null;
      _fillVolume();
    });
  }

  @override
  void dispose() {
    _volumeFocus.dispose();
    _name.dispose();
    _area.dispose();
    _depth.dispose();
    _volume.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref
        .watch(pondMutationControllerProvider(widget.farmId))
        .isLoading;
    final editing = widget.initialPond != null;
    final farmName = ref
        .watch(farmDetailControllerProvider(widget.farmId))
        .value
        ?.name;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: <Widget>[
                StickyPageHeader(
                  title: editing ? 'Chỉnh sửa ao' : 'Thêm ao mới',
                  subtitle: farmName,
                  onBack: loading ? null : context.pop,
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
                  sliver: SliverList.list(
                    children: <Widget>[
                      _label('Tên ao', required: true),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _name,
                        maxLength: PondRules.nameMaxLength,
                        maxLengthEnforcement: MaxLengthEnforcement.none,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: PondRules.validateName,
                        onChanged: (_) => setState(() {}),
                        style: AppFormMetrics.inputStyle,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: AppFormMetrics.compactDecoration(
                          hintText: 'VD: Ao A3',
                        ).copyWith(counterText: ''),
                      ),
                      const SizedBox(height: 15),
                      _label('Loại ao'),
                      const SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: _ChoiceButton(
                              label: 'Ao nuôi',
                              selected: _type == PondType.aquaculture,
                              onTap: loading || _hasOpenSeason
                                  ? null
                                  : () => setState(
                                      () => _type = PondType.aquaculture,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _ChoiceButton(
                              label: 'Ao xử lý nước',
                              selected: _type == PondType.waterTreatment,
                              onTap: loading || _hasOpenSeason
                                  ? null
                                  : () => setState(
                                      () => _type = PondType.waterTreatment,
                                    ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _label('Trạng thái'),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          for (final status in [
                            PondStatus.available,
                            PondStatus.maintenance,
                          ])
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: status == PondStatus.available
                                      ? 12
                                      : 0,
                                ),
                                child: _ChoiceButton(
                                  label: status == PondStatus.available
                                      ? 'Sẵn sàng'
                                      : 'Đang bảo trì',
                                  selected: _status == status,
                                  onTap:
                                      loading ||
                                          (status == PondStatus.maintenance &&
                                              !_canEnterMaintenance)
                                      ? null
                                      : () => setState(() => _status = status),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xB3FFFFFF),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _label('Thông số ao'),
                            const SizedBox(height: 14),
                            _numberField(
                              _area,
                              'Diện tích mặt nước (m²)',
                              'VD: 3.200',
                              (value) =>
                                  editing &&
                                      widget.initialPond?.areaM2 == null &&
                                      (value?.trim().isEmpty ?? true)
                                  ? null
                                  : PondRules.validateArea(value),
                              readOnly: _hasOpenSeason,
                            ),
                            const SizedBox(height: 15),
                            _numberField(
                              _depth,
                              'Độ sâu trung bình (m)',
                              'VD: 1,4',
                              (value) =>
                                  editing &&
                                      widget.initialPond?.depthM == null &&
                                      (value?.trim().isEmpty ?? true)
                                  ? null
                                  : PondRules.validateDepth(value),
                              readOnly: _hasOpenSeason,
                            ),
                            if (_volumeError != null) ...<Widget>[
                              const SizedBox(height: 7),
                              Text(
                                _volumeError!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 15),
                            _numberField(
                              _volume,
                              'Thể tích nước (m³)',
                              'VD: 4.480',
                              PondRules.validateVolume,
                              required: false,
                            ),
                            if (_calculatedVolume case final estimate?) ...[
                              const SizedBox(height: 12),
                              _VolumeEstimate(
                                volume: estimate,
                                showWarning: _isVolumeOutsideEstimate(estimate),
                                onApply: loading ? null : _useAutoVolume,
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.initialPond?.hasOpenSeason ==
                          true) ...<Widget>[
                        const SizedBox(height: 13),
                        const Text(
                          'Ao có vụ đang chuẩn bị hoặc đang nuôi. Diện tích, độ sâu và loại ao được khóa.',
                          style: TextStyle(
                            color: Color(0xFF9A5B00),
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: loading || !_hasChanges
                                ? null
                                : const LinearGradient(
                                    colors: <Color>[
                                      AppColors.oceanLight,
                                      AppColors.tealLight,
                                    ],
                                  ),
                            color: loading || !_hasChanges
                                ? AppColors.line
                                : null,
                            borderRadius: BorderRadius.circular(13),
                            boxShadow: loading || !_hasChanges
                                ? null
                                : const <BoxShadow>[
                                    BoxShadow(
                                      color: Color(0x3377A1D3),
                                      blurRadius: 13,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                          ),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              disabledBackgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                            onPressed: loading || !_hasChanges ? null : _submit,
                            child: loading
                                ? const SizedBox.square(
                                    dimension: 19,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.check, size: 18),
                                      const SizedBox(width: 8),
                                      Text(editing ? 'Lưu thay đổi' : 'Tạo ao'),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label,
    String hint,
    String? Function(String?) validator, {
    bool required = true,
    bool readOnly = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _label(label, required: required),
      const SizedBox(height: 7),
      TextFormField(
        controller: controller,
        readOnly: readOnly,
        focusNode: identical(controller, _volume) ? _volumeFocus : null,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        autocorrect: false,
        enableSuggestions: false,
        inputFormatters: const [VietnameseNumberInputFormatter()],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (_) => _onNumberChanged(controller),
        validator: readOnly ? null : validator,
        style: AppFormMetrics.inputStyle.copyWith(fontFamily: 'JetBrainsMono'),
        decoration: AppFormMetrics.compactDecoration(hintText: hint).copyWith(
          hintStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            color: AppColors.inkMuted,
          ),
        ),
      ),
    ],
  );

  Widget _label(String text, {bool required = false}) => Text.rich(
    TextSpan(
      text: text,
      children: <InlineSpan>[
        if (required)
          const TextSpan(
            text: ' *',
            style: TextStyle(color: AppColors.error),
          ),
      ],
    ),
    style: const TextStyle(
      color: AppColors.inkSoft,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  );

  Future<void> _submit() async {
    // A submit tap may arrive before the volume field loses focus.
    if (!_editing && _volume.text.trim().isEmpty) _useAutoVolume();
    // Also guard the handler, not just the disabled save button.
    if (!_hasChanges) return;
    if (!_formKey.currentState!.validate()) return;
    final areaM2 = PondRules.parseNumber(_area.text);
    final depthM = PondRules.parseNumber(_depth.text);
    final volumeM3 = PondRules.parseNumber(_volume.text);
    if (!_editing && volumeM3 == null && areaM2 != null && depthM != null) {
      final error = PondRules.validateCalculatedVolume(areaM2, depthM);
      if (error != null) {
        setState(() => _volumeError = error);
        return;
      }
    }
    if (_volumeError != null) setState(() => _volumeError = null);
    // Validate locally for immediate feedback; backend checks capacity/ownership again.
    try {
      final controller = ref.read(
        pondMutationControllerProvider(widget.farmId).notifier,
      );
      final initialPond = widget.initialPond;
      final pond = initialPond == null
          ? await controller.createPond(
              name: _name.text,
              areaM2: areaM2!,
              depthM: depthM!,
              volumeM3: volumeM3,
              type: _type,
              status: _status,
            )
          : await controller.updatePond(
              pondId: initialPond.id,
              name: _name.text,
              areaM2: !_hasOpenSeason && areaM2 != initialPond.areaM2
                  ? areaM2
                  : null,
              depthM: !_hasOpenSeason && depthM != initialPond.depthM
                  ? depthM
                  : null,
              volumeM3: volumeM3 == initialPond.volumeM3 ? null : volumeM3,
              type: _type,
              status: _status,
            );
      if (!mounted) return;
      AppNoticeService.success(
        context,
        widget.initialPond == null ? 'Đã tạo ao.' : 'Đã cập nhật ao.',
      );
      if (widget.initialPond == null) {
        context.go('/farms/${widget.farmId}/ponds/${pond.id}');
      } else {
        context.pop();
      }
    } on Object catch (error) {
      if (mounted) {
        AppNoticeService.danger(context, ErrorMapper.displayMessage(error));
      }
    }
  }
}

class _VolumeEstimate extends StatelessWidget {
  const _VolumeEstimate({
    required this.volume,
    required this.showWarning,
    required this.onApply,
  });

  final double volume;
  final bool showWarning;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    final ink = showWarning ? const Color(0xFF9C4E12) : const Color(0xFF007970);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: showWarning ? const Color(0xFFFBF2DE) : const Color(0xFFE0F4F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: showWarning
              ? const Color(0xFFF2D681)
              : const Color(0xFF8CF4E4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THỂ TÍCH ƯỚC TÍNH',
                      style: TextStyle(
                        color: ink,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatVietnameseNumber(volume, decimalPlaces: 2)} m³',
                      style: TextStyle(
                        color: ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.ocean,
                      surfaceTintColor: Colors.transparent,
                      shadowColor: ink.withValues(alpha: 0.2),
                      elevation: 2,
                      minimumSize: const Size(0, 40),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: onApply,
                    child: const Text(
                      'Dùng số này',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            showWarning
                ? 'Diện tích × độ sâu. Số đang nhập lệch trên 10%; hãy kiểm tra vì '
                      'thể tích ảnh hưởng trực tiếp đến liều xử lý nước.'
                : 'Diện tích × độ sâu. Dùng làm cơ sở kiểm tra liều theo m³ nước.',
            style: TextStyle(color: ink, fontSize: 11, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: selected ? AppColors.ocean : AppColors.inkSoft,
        backgroundColor: selected ? const Color(0xFFF4F9FF) : Colors.white24,
        side: BorderSide(
          color: selected ? const Color(0xFF2583E2) : Colors.white70,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onTap,
      child: Text(label),
    ),
  );
}
