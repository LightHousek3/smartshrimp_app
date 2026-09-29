import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/presentation/view_models/pond_controller.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/season_rules.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_ui.dart';

class SeasonCreatePage extends ConsumerWidget {
  const SeasonCreatePage({
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
    if (pond != null) {
      return SeasonFormPage(farmId: farmId, pond: pond);
    }
    final ids = (farmId: farmId, pondId: pondId);
    return ref
        .watch(pondDetailControllerProvider(ids))
        .when(
          data: (loaded) => SeasonFormPage(farmId: farmId, pond: loaded),
          loading: _loading,
          error: (error, _) => _LoadError(
            message: error is AppException
                ? error.message
                : 'Không thể tải thông tin ao.',
            onRetry: ref
                .read(pondDetailControllerProvider(ids).notifier)
                .refresh,
          ),
        );
  }
}

class SeasonEditPage extends ConsumerWidget {
  const SeasonEditPage({
    required this.farmId,
    required this.seasonId,
    this.initialSeason,
    super.key,
  });

  final String farmId;
  final String seasonId;
  final AquacultureSeason? initialSeason;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final season = initialSeason;
    if (season != null) {
      return SeasonFormPage(
        farmId: farmId,
        pond: season.pond,
        initialSeason: season,
      );
    }
    return ref
        .watch(seasonDetailControllerProvider(seasonId))
        .when(
          data: (loaded) => SeasonFormPage(
            farmId: farmId,
            pond: loaded.pond,
            initialSeason: loaded,
          ),
          loading: _loading,
          error: (error, _) => _LoadError(
            message: error is AppException
                ? error.message
                : 'Không thể tải thông tin vụ nuôi.',
            onRetry: ref
                .read(seasonDetailControllerProvider(seasonId).notifier)
                .refresh,
          ),
        );
  }
}

Widget _loading() => const Scaffold(
  backgroundColor: Colors.transparent,
  body: AppGradientBackground(
    child: Center(child: CircularProgressIndicator(color: AppColors.ocean)),
  ),
);

class SeasonFormPage extends ConsumerStatefulWidget {
  const SeasonFormPage({
    required this.farmId,
    required this.pond,
    this.initialSeason,
    super.key,
  });

  final String farmId;
  final Pond pond;
  final AquacultureSeason? initialSeason;

  @override
  ConsumerState<SeasonFormPage> createState() => _SeasonFormPageState();
}

class _SeasonFormPageState extends ConsumerState<SeasonFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _quantity;
  late final TextEditingController _averageWeight;
  late ShrimpType _shrimpType;
  DateTime? _stockingDate;
  DateTime? _expectedEndDate;
  String? _dateError;

  bool get _editing => widget.initialSeason != null;

  @override
  void initState() {
    super.initState();
    final season = widget.initialSeason;
    _name = TextEditingController(text: season?.name ?? '');
    _quantity = TextEditingController(
      text: season?.initialQuantity?.toString() ?? '',
    );
    _averageWeight = TextEditingController(
      text: season?.initialAvgWeightG == null
          ? ''
          : seasonDecimalLabel(season!.initialAvgWeightG, digits: 3),
    );
    _shrimpType = season?.shrimpType ?? ShrimpType.whiteleg;
    _stockingDate = season?.stockingDate;
    _expectedEndDate = season?.expectedEndDate;
  }

  @override
  void dispose() {
    _name.dispose();
    _quantity.dispose();
    _averageWeight.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(seasonMutationControllerProvider).isLoading;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          top: false,
          bottom: false,
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                seasonScreenTopPadding(context),
                16,
                40,
              ),
              children: <Widget>[
                _header(loading),
                const SizedBox(height: 28),
                _label('Tên vụ nuôi', required: true),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _name,
                  maxLength: SeasonRules.nameMaxLength,
                  validator: SeasonRules.validateName,
                  enabled: !loading,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: 'monospace',
                  ),
                  decoration: _inputDecoration(
                    hintText: 'VD: Vụ Đông Xuân 2026',
                    counterText: '',
                  ),
                ),
                if (!_editing) ...<Widget>[
                  const SizedBox(height: 16),
                  _label('Loại tôm', required: true),
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      for (final type in const <ShrimpType>[
                        ShrimpType.whiteleg,
                        ShrimpType.blackTiger,
                      ]) ...<Widget>[
                        Expanded(
                          child: _ShrimpTypeOption(
                            label: shrimpTypeLabel(type),
                            selected: _shrimpType == type,
                            enabled: !loading,
                            onTap: () => setState(() => _shrimpType = type),
                          ),
                        ),
                        if (type == ShrimpType.whiteleg)
                          const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                _DateField(
                  label: _editing ? 'Ngày thả giống' : 'Ngày thả giống *',
                  value: _stockingDate,
                  enabled: !loading,
                  onChanged: (value) => setState(() {
                    _stockingDate = value;
                    _dateError = null;
                  }),
                ),
                const SizedBox(height: 16),
                _DateField(
                  label: 'Ngày kết thúc dự kiến',
                  value: _expectedEndDate,
                  enabled: !loading,
                  onChanged: (value) => setState(() {
                    _expectedEndDate = value;
                    _dateError = null;
                  }),
                ),
                if (_dateError != null) ...<Widget>[
                  const SizedBox(height: 6),
                  Text(
                    _dateError!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                _numberField(
                  controller: _quantity,
                  label: 'Số lượng thả (con)',
                  hint: 'VD: 480000',
                  validator: SeasonRules.validateQuantity,
                  decimal: false,
                  enabled: !loading,
                ),
                const SizedBox(height: 16),
                _densityPreviewField(),
                const SizedBox(height: 24),
                SeasonPrimaryButton(
                  label: _editing ? 'Lưu thay đổi' : 'Tạo vụ nuôi',
                  icon: Icons.check_rounded,
                  loading: loading,
                  onPressed: loading ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(bool loading) => SeasonScreenHeader(
    title: _editing ? 'Chỉnh sửa vụ nuôi' : 'Tạo vụ nuôi mới',
    subtitle: '${widget.pond.name} · ${widget.pond.farm?.name ?? 'Trang trại'}',
    onBack: loading ? null : context.pop,
  );

  Widget _numberField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    required bool decimal,
    required bool enabled,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _label(label),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: TextInputType.numberWithOptions(decimal: decimal),
        validator: validator,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 14,
          height: 1.5,
          fontFamily: 'monospace',
        ),
        decoration: _inputDecoration(hintText: hint),
      ),
    ],
  );

  InputDecoration _inputDecoration({
    required String hintText,
    String? counterText,
  }) => InputDecoration(
    hintText: hintText,
    counterText: counterText,
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.line),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.oceanLight),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error),
    ),
  );

  Widget _densityPreviewField() {
    final quantity = SeasonRules.parseQuantity(_quantity.text);
    final area = widget.pond.areaM2;
    final density = SeasonRules.calculateDensity(quantity, area);
    final missingArea = quantity != null && (area == null || area <= 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _label('Mật độ thả (con/m²)'),
        const SizedBox(height: 6),
        Semantics(
          readOnly: true,
          label: 'Mật độ thả tự tính',
          value: density == null
              ? ''
              : '${seasonDecimalLabel(density)} con trên mét vuông',
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 43),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: missingArea ? AppColors.error : AppColors.line,
              ),
            ),
            child: Text(
              missingArea
                  ? 'Chưa có diện tích ao'
                  : density == null
                  ? 'VD: 150'
                  : seasonDecimalLabel(density),
              style: TextStyle(
                color: missingArea
                    ? AppColors.error
                    : density == null
                    ? AppColors.inkMuted
                    : AppColors.ink,
                fontSize: 14,
                height: 1.5,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),
      ],
    );
  }

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
    if (!_formKey.currentState!.validate()) return;
    if (!_editing && _stockingDate == null) {
      setState(() => _dateError = 'Vui lòng chọn ngày thả giống.');
      return;
    }
    final dateError = SeasonRules.validateDateRange(
      _stockingDate,
      _expectedEndDate,
    );
    if (dateError != null) {
      setState(() => _dateError = dateError);
      return;
    }
    if (_dateError != null) setState(() => _dateError = null);

    final current = widget.initialSeason;
    try {
      final notifier = ref.read(seasonMutationControllerProvider.notifier);
      final saved = current == null
          ? await notifier.create(
              farmId: widget.farmId,
              pondId: widget.pond.id,
              name: _name.text,
              shrimpType: _shrimpType,
              stockingDate: _stockingDate,
              expectedEndDate: _expectedEndDate,
              initialQuantity: SeasonRules.parseQuantity(_quantity.text),
              initialAvgWeightG: SeasonRules.parseWeight(_averageWeight.text),
            )
          : await notifier.updateSeason(
              farmId: widget.farmId,
              current: current,
              name: _name.text,
              shrimpType: _shrimpType,
              stockingDate: _stockingDate,
              expectedEndDate: _expectedEndDate,
              initialQuantity: SeasonRules.parseQuantity(_quantity.text),
              initialAvgWeightG: SeasonRules.parseWeight(_averageWeight.text),
            );
      if (!mounted) return;
      AppNoticeService.success(
        context,
        current == null
            ? 'Vụ nuôi mới đã được tạo và lưu ở trạng thái đang chuẩn bị.'
            : 'Thông tin vụ nuôi đã được cập nhật thành công.',
      );
      if (current == null) {
        context.go(
          '/farms/${widget.farmId}/ponds/${widget.pond.id}/seasons/${saved.id}',
        );
      } else {
        context.pop();
      }
    } on AppException catch (error) {
      if (mounted) {
        AppNoticeService.danger(
          context,
          error.message,
          title: current == null
              ? 'Không thể tạo vụ nuôi'
              : 'Không thể cập nhật vụ nuôi',
        );
      }
    }
  }
}

class _ShrimpTypeOption extends StatelessWidget {
  const _ShrimpTypeOption({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    child: Material(
      color: selected ? const Color(0xFFEAF4FF) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 46),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xFF3F97E8) : AppColors.line,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? const Color(0xFF0C4E8F) : AppColors.inkMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ),
  );
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final bool enabled;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
          color: AppColors.inkSoft,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 6),
      Semantics(
        button: true,
        label: value == null
            ? 'Chọn $label'
            : '$label ${seasonDateLabel(value)}',
        child: Material(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.line),
          ),
          child: InkWell(
            onTap: enabled ? () => _pick(context) : null,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 43,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        value == null
                            ? 'dd / mm / yyyy'
                            : seasonDateLabel(value),
                        style: TextStyle(
                          color: value == null
                              ? AppColors.inkMuted
                              : AppColors.ink,
                          fontSize: 14,
                          height: 1.5,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    if (value == null)
                      const Icon(
                        Icons.calendar_today_rounded,
                        color: AppColors.ink,
                        size: 14,
                      )
                    else if (enabled)
                      IconButton(
                        tooltip: 'Xóa ngày',
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 30,
                          minHeight: 43,
                        ),
                        onPressed: () => onChanged(null),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.inkMuted,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 10, 12, 31),
    );
    if (selected != null) onChanged(selected);
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    body: AppGradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: FarmCircleButton(
                  icon: Icons.adaptive.arrow_back,
                  tooltip: 'Quay lại',
                  onPressed: context.pop,
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: onRetry,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
