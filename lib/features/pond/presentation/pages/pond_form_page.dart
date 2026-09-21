import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/domain/pond_rules.dart';
import 'package:smartshrimp_app/features/pond/presentation/pages/pond_list_page.dart';
import 'package:smartshrimp_app/features/pond/presentation/view_models/pond_controller.dart';

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
  late PondType _type;
  late PondStatus _status;
  String? _volumeError;

  @override
  void initState() {
    super.initState();
    final pond = widget.initialPond;
    _name = TextEditingController(text: pond?.name);
    _area = TextEditingController(text: pond?.areaM2?.toString() ?? '');
    _depth = TextEditingController(text: pond?.depthM?.toString() ?? '');
    _type = pond?.type ?? PondType.aquaculture;
    _status = pond?.status ?? PondStatus.available;
  }

  @override
  void dispose() {
    _name.dispose();
    _area.dispose();
    _depth.dispose();
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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FarmCircleButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      tooltip: 'Quay lại',
                      onPressed: loading ? null : context.pop,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      editing ? 'Cập nhật ao' : 'Tạo ao mới',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                _label('Tên ao', required: true),
                const SizedBox(height: 7),
                TextFormField(
                  controller: _name,
                  maxLength: PondRules.nameMaxLength,
                  validator: PondRules.validateName,
                  decoration: const InputDecoration(
                    hintText: 'VD: Ao A1, Ao Lắng...',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _numberField(
                        _area,
                        'Diện tích (m²)',
                        '1200',
                        PondRules.validateArea,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _numberField(
                        _depth,
                        'Độ sâu (m)',
                        '1.5',
                        PondRules.validateDepth,
                      ),
                    ),
                  ],
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
                _label('Loại ao'),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _ChoiceButton(
                        label: 'Ao nuôi',
                        selected: _type == PondType.aquaculture,
                        onTap: loading
                            ? null
                            : () =>
                                  setState(() => _type = PondType.aquaculture),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ChoiceButton(
                        label: 'Ao xử lý nước',
                        selected: _type == PondType.waterTreatment,
                        onTap: loading
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
                        PondStatus.inactive,
                      ].map((value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(pondStatusLabel(value)),
                        );
                      }).toList(),
                  onChanged: loading
                      ? null
                      : (value) => setState(() => _status = value!),
                ),
                if (widget.initialPond?.hasOpenSeason == true) ...<Widget>[
                  const SizedBox(height: 13),
                  const Text(
                    'Ao có vụ nuôi mở: không thể đổi loại ao, ngừng hoạt động hoặc thay đổi diện tích/độ sâu.',
                    style: TextStyle(color: Color(0xFF9A5B00), fontSize: 12),
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
                    onPressed: loading ? null : _submit,
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
        ),
      ),
    );
  }

  Widget _numberField(
    TextEditingController controller,
    String label,
    String hint,
    String? Function(String?) validator,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      _label(label, required: true),
      const SizedBox(height: 7),
      TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (_) {
          if (_volumeError != null) setState(() => _volumeError = null);
        },
        validator: validator,
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
    if (!_formKey.currentState!.validate()) return;
    final areaM2 = PondRules.parseNumber(_area.text)!;
    final depthM = PondRules.parseNumber(_depth.text)!;
    final volumeError = PondRules.validateCalculatedVolume(areaM2, depthM);
    if (volumeError != null) {
      setState(() => _volumeError = volumeError);
      return;
    }
    if (_volumeError != null) setState(() => _volumeError = null);
    try {
      final pond = await ref
          .read(pondMutationControllerProvider(widget.farmId).notifier)
          .save(
            pondId: widget.initialPond?.id,
            name: _name.text,
            areaM2: areaM2,
            depthM: depthM,
            type: _type,
            status: _status,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.initialPond == null ? 'Đã tạo ao.' : 'Đã cập nhật ao.',
          ),
        ),
      );
      if (widget.initialPond == null) {
        context.go('/farms/${widget.farmId}/ponds/${pond.id}');
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
