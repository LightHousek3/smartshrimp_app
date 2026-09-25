import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
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
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(19, 14, 19, 30),
              children: <Widget>[
                _header(loading),
                const SizedBox(height: 20),
                SeasonSectionCard(child: _pondSummary()),
                const SizedBox(height: 16),
                _label('Tên vụ nuôi', required: true),
                const SizedBox(height: 7),
                TextFormField(
                  controller: _name,
                  maxLength: SeasonRules.nameMaxLength,
                  validator: SeasonRules.validateName,
                  enabled: !loading,
                  decoration: const InputDecoration(
                    hintText: 'VD: Vụ tôm tháng 9',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 15),
                _label('Loại tôm', required: true),
                const SizedBox(height: 7),
                DropdownButtonFormField<ShrimpType>(
                  initialValue: _shrimpType,
                  decoration: const InputDecoration(),
                  items:
                      const <ShrimpType>[
                        ShrimpType.whiteleg,
                        ShrimpType.blackTiger,
                      ].map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(shrimpTypeLabel(value)),
                        );
                      }).toList(),
                  onChanged: loading
                      ? null
                      : (value) => setState(() => _shrimpType = value!),
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _DateField(
                        label: 'Ngày thả giống',
                        value: _stockingDate,
                        enabled: !loading,
                        onChanged: (value) => setState(() {
                          _stockingDate = value;
                          _dateError = null;
                        }),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: _DateField(
                        label: 'Ngày kết thúc dự kiến',
                        value: _expectedEndDate,
                        enabled: !loading,
                        onChanged: (value) => setState(() {
                          _expectedEndDate = value;
                          _dateError = null;
                        }),
                      ),
                    ),
                  ],
                ),
                if (_dateError != null) ...<Widget>[
                  const SizedBox(height: 7),
                  Text(
                    _dateError!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 17),
                const Text(
                  'Thông tin thả giống',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Có thể bổ sung sau khi tạo, nhưng bắt buộc trước khi kích hoạt.',
                  style: TextStyle(color: AppColors.inkMuted, fontSize: 11.5),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _numberField(
                        controller: _quantity,
                        label: 'Số lượng (con)',
                        hint: '100000',
                        validator: SeasonRules.validateQuantity,
                        decimal: false,
                        enabled: !loading,
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: _numberField(
                        controller: _averageWeight,
                        label: 'Khối lượng TB (g)',
                        hint: '0.02',
                        validator: SeasonRules.validateAverageWeight,
                        decimal: true,
                        enabled: !loading,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _calculationPreview(),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: loading ? null : _submit,
                    child: loading
                        ? const SizedBox.square(
                            dimension: 19,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(_editing ? 'Lưu thay đổi' : 'Tạo vụ nuôi'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(bool loading) => Row(
    children: <Widget>[
      FarmCircleButton(
        icon: Icons.arrow_back_ios_new_rounded,
        tooltip: 'Quay lại',
        onPressed: loading ? null : context.pop,
      ),
      const SizedBox(width: 12),
      Text(
        _editing ? 'Cập nhật vụ nuôi' : 'Tạo vụ nuôi',
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );

  Widget _pondSummary() => Row(
    children: <Widget>[
      Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFE7F4FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.water_drop_rounded, color: AppColors.ocean),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.pond.name,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '${widget.pond.farm?.name ?? 'Trang trại'} • ${seasonDecimalLabel(widget.pond.areaM2)} m²',
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    ],
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
      const SizedBox(height: 7),
      TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: TextInputType.numberWithOptions(decimal: decimal),
        validator: validator,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(hintText: hint),
      ),
    ],
  );

  Widget _calculationPreview() {
    final quantity = SeasonRules.parseQuantity(_quantity.text);
    final weight = SeasonRules.parseWeight(_averageWeight.text);
    final area = widget.pond.areaM2;
    final biomass = quantity == null || weight == null
        ? null
        : quantity * weight / 1000;
    final density = quantity == null || area == null || area <= 0
        ? null
        : quantity / area;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xDFFFFFFF),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _PreviewMetric(
              label: 'Sinh khối dự kiến',
              value: '${seasonDecimalLabel(biomass, digits: 3)} kg',
            ),
          ),
          Container(width: 1, height: 34, color: AppColors.line),
          const SizedBox(width: 14),
          Expanded(
            child: _PreviewMetric(
              label: 'Mật độ dự kiến',
              value: '${seasonDecimalLabel(density)} con/m²',
            ),
          ),
        ],
      ),
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
    final dateError = SeasonRules.validateDateRange(
      _stockingDate,
      _expectedEndDate,
    );
    if (dateError != null) {
      setState(() => _dateError = dateError);
      return;
    }
    if (_dateError != null) setState(() => _dateError = null);

    try {
      final notifier = ref.read(seasonMutationControllerProvider.notifier);
      final current = widget.initialSeason;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            current == null ? 'Đã tạo vụ nuôi.' : 'Đã cập nhật vụ nuôi.',
          ),
        ),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.message)));
      }
    }
  }
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
      const SizedBox(height: 7),
      InkWell(
        onTap: enabled ? () => _pick(context) : null,
        borderRadius: BorderRadius.circular(16),
        child: InputDecorator(
          decoration: InputDecoration(
            enabled: enabled,
            suffixIcon: value == null
                ? const Icon(Icons.calendar_month_outlined, size: 19)
                : IconButton(
                    tooltip: 'Xóa ngày',
                    onPressed: enabled ? () => onChanged(null) : null,
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
          ),
          child: Text(
            value == null ? 'Chọn ngày' : seasonDateLabel(value),
            style: TextStyle(
              color: value == null ? AppColors.inkMuted : AppColors.ink,
              fontSize: 13,
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

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          color: AppColors.ink,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
    ],
  );
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
                  icon: Icons.arrow_back_rounded,
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
