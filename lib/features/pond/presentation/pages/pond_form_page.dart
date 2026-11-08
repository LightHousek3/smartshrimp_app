import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/domain/pond_rules.dart';
import 'package:smartshrimp_app/features/pond/presentation/widgets/pond_ui.dart';
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
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        error is AppException
                            ? error.message
                            : 'Không thể tải thông tin ao.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: ref
                            .read(pondDetailControllerProvider(ids).notifier)
                            .refresh,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
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
  static final _decimalInputFormatter = TextInputFormatter.withFunction((
    oldValue,
    newValue,
  ) {
    return RegExp(r'^\d*(?:[.,]\d{0,2})?$').hasMatch(newValue.text)
        ? newValue
        : oldValue;
  });

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
  bool get _canEditVolume => !_editing || _calculatedVolume != null;

  // This is a UI snapshot: the backend rechecks occupancy if it changes meanwhile.
  bool get _hasOpenSeason => widget.initialPond?.hasOpenSeason == true;

  double? get _calculatedVolume => PondRules.calculateVolume(
    PondRules.parseNumber(_area.text),
    PondRules.parseNumber(_depth.text),
  );

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
    _area = TextEditingController(text: pond?.areaM2?.toString() ?? '');
    _depth = TextEditingController(text: pond?.depthM?.toString() ?? '');
    _volume = TextEditingController(text: pond?.volumeM3?.toString() ?? '');
    _type = pond?.type ?? PondType.aquaculture;
    _status = pond?.status ?? PondStatus.available;
    // Existing usable volume is intentional; never replace it on opening edit.
    _autoVolume = !_editing;
    if (_autoVolume) _fillVolume();
    _volumeFocus.addListener(_onVolumeFocusChanged);
  }

  /// Fill only from supported dimensions; invalid dimensions clear an automatic value.
  void _fillVolume() {
    final text = _calculatedVolume?.toStringAsFixed(2) ?? '';
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
                  title: editing ? 'Cập nhật ao' : 'Tạo ao mới',
                  titleSize: 18,
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
                        decoration: const InputDecoration(
                          hintText: 'VD: Ao A1, Ao Lắng...',
                          counterText: '',
                        ),
                      ),
                      const SizedBox(height: 15),
                      _numberField(
                        _area,
                        'Diện tích (m²)',
                        '1200',
                        PondRules.validateArea,
                        readOnly: editing,
                      ),
                      const SizedBox(height: 15),
                      _numberField(
                        _depth,
                        'Độ sâu (m)',
                        '1.5',
                        PondRules.validateDepth,
                        readOnly: editing,
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
                        'Thể tích (m³) - tùy chọn',
                        editing
                            ? 'Để trống để giữ thể tích hiện tại'
                            : 'Để trống để hệ thống tự tính',
                        PondRules.validateVolume,
                        required: false,
                        readOnly: !_canEditVolume,
                      ),
                      if (editing && !_canEditVolume) ...<Widget>[
                        const SizedBox(height: 7),
                        const Text(
                          'Chưa đủ thông tin diện tích và độ sâu để cập nhật thể tích.',
                        ),
                      ],
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
                      DropdownButtonFormField<PondStatus>(
                        initialValue: _status,
                        decoration: const InputDecoration(),
                        items:
                            const <PondStatus>[
                              PondStatus.available,
                              PondStatus.maintenance,
                            ].map((value) {
                              return DropdownMenuItem(
                                value: value,
                                enabled:
                                    value != PondStatus.maintenance ||
                                    _canEnterMaintenance,
                                child: Text(pondStatusLabel(value)),
                              );
                            }).toList(),
                        onChanged: loading
                            ? null
                            : (value) => setState(() => _status = value!),
                      ),
                      if (widget.initialPond?.hasOpenSeason ==
                          true) ...<Widget>[
                        const SizedBox(height: 13),
                        const Text(
                          'Ao có vụ nuôi mở: không thể đổi loại ao hoặc chuyển sang bảo trì.',
                          style: TextStyle(
                            color: Color(0xFF9A5B00),
                            fontSize: 12,
                          ),
                        ),
                      ],
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 50,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
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
                              : Text(editing ? 'Lưu thay đổi' : 'Tạo ao'),
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
        inputFormatters: <TextInputFormatter>[_decimalInputFormatter],
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (_) => _onNumberChanged(controller),
        validator: readOnly ? null : validator,
        decoration: InputDecoration(hintText: hint),
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
    final volumeM3 = _canEditVolume
        ? PondRules.parseNumber(_volume.text)
        : null;
    if ((!_editing || volumeM3 != null) && areaM2 != null && depthM != null) {
      final volumeError = PondRules.validateCalculatedVolume(areaM2, depthM);
      if (volumeError != null) {
        setState(() => _volumeError = volumeError);
        return;
      }
      final capacityError = PondRules.validateVolumeCapacity(
        volumeM3,
        areaM2,
        depthM,
      );
      if (capacityError != null) {
        setState(() => _volumeError = capacityError);
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
              volumeM3: volumeM3,
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
    } on AppException catch (error) {
      if (mounted) {
        AppNoticeService.danger(context, error.message);
      }
    }
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
