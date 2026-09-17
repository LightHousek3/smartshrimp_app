import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/farm/domain/entities/farm.dart';
import 'package:smartshrimp_app/features/farm/domain/farm_rules.dart';
import 'package:smartshrimp_app/features/farm/presentation/view_models/farm_controller.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';

class FarmEditPage extends ConsumerWidget {
  const FarmEditPage({required this.farmId, this.initialFarm, super.key});
  final String farmId;
  final Farm? initialFarm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initial = initialFarm;
    if (initial != null) return FarmFormPage(farm: initial);
    final state = ref.watch(farmDetailControllerProvider(farmId));
    return AppGradientBackground(
      child: SafeArea(
        child: state.when(
          data: (farm) => FarmFormPage(farm: farm),
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.ocean),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    error is AppException
                        ? error.message
                        : 'Không thể tải trang trại.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: ref
                        .read(farmDetailControllerProvider(farmId).notifier)
                        .refresh,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Thử lại'),
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

class FarmFormPage extends ConsumerStatefulWidget {
  const FarmFormPage({this.farm, super.key});
  final Farm? farm;

  @override
  ConsumerState<FarmFormPage> createState() => _FarmFormPageState();
}

class _FarmFormPageState extends ConsumerState<FarmFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;
  late final TextEditingController _areaController;

  bool get _isEditing => widget.farm != null;

  @override
  void initState() {
    super.initState();
    final farm = widget.farm;
    _nameController = TextEditingController(text: farm?.name ?? '');
    _addressController = TextEditingController(text: farm?.address ?? '');
    _areaController = TextEditingController(
      text: farm?.totalAreaHectares == null
          ? ''
          : formatCompactNumber(farm!.totalAreaHectares),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(farmMutationControllerProvider);
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(21, 18, 21, 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FarmCircleButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Quay lại',
                      onPressed: mutation.isLoading ? null : context.pop,
                    ),
                    const SizedBox(width: 14),
                    Text(
                      _isEditing ? 'Chỉnh sửa trang trại' : 'Tạo trang trại',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 29),
                _FarmFieldLabel(label: 'Tên trang trại', required: true),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  autofocus: !_isEditing,
                  maxLength: FarmRules.nameMaxLength,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: FarmRules.validateName,
                  decoration: _decoration('Nhập tên trang trại'),
                ),
                const SizedBox(height: 18),
                const _FarmFieldLabel(label: 'Địa chỉ'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  maxLength: FarmRules.addressMaxLength,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  validator: FarmRules.validateAddress,
                  decoration: _decoration('Nhập địa chỉ trang trại'),
                ),
                const SizedBox(height: 18),
                const _FarmFieldLabel(label: 'Tổng diện tích (ha)'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _areaController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  textInputAction: TextInputAction.done,
                  validator: FarmRules.validateArea,
                  onFieldSubmitted: (_) =>
                      mutation.isLoading ? null : _submit(),
                  decoration: _decoration('Ví dụ: 3.5'),
                ),
                const SizedBox(height: 23),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDEEFF),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.ocean,
                        size: 18,
                      ),
                      SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'Sau khi tạo trang trại, bạn có thể thêm ao nuôi và bắt đầu quản lý vụ nuôi.',
                          style: TextStyle(
                            color: AppColors.inkSoft,
                            fontSize: 11.5,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 29),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: mutation.isLoading
                          ? null
                          : const LinearGradient(
                              colors: <Color>[
                                AppColors.oceanLight,
                                AppColors.tealLight,
                              ],
                            ),
                      color: mutation.isLoading ? AppColors.line : null,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: mutation.isLoading
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
                      onPressed: mutation.isLoading ? null : _submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        disabledBackgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: mutation.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.inkMuted,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  _isEditing
                                      ? Icons.check_rounded
                                      : Icons.add_rounded,
                                  size: 19,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isEditing
                                      ? 'Lưu thay đổi'
                                      : 'Tạo trang trại',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
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

  InputDecoration _decoration(String hint) => InputDecoration(
    hintText: hint,
    counterText: '',
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: AppColors.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: AppColors.oceanLight, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(11),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
  );

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    try {
      final area = FarmRules.parseArea(_areaController.text);
      final notifier = ref.read(farmMutationControllerProvider.notifier);
      final result = _isEditing
          ? await notifier.updateFarm(
              farmId: widget.farm!.id,
              name: _nameController.text,
              address: _addressController.text,
              totalAreaHectares: area,
            )
          : await notifier.create(
              name: _nameController.text,
              address: _addressController.text,
              totalAreaHectares: area,
            );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Đã cập nhật trang trại.' : 'Đã tạo trang trại.',
          ),
        ),
      );
      if (_isEditing) {
        context.pop();
      } else {
        context.go('/farms/${result.id}');
      }
    } on AppException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}

class _FarmFieldLabel extends StatelessWidget {
  const _FarmFieldLabel({required this.label, this.required = false});
  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      text: label,
      children: required
          ? const <InlineSpan>[
              TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.error),
              ),
            ]
          : const <InlineSpan>[],
    ),
    style: const TextStyle(
      color: AppColors.inkSoft,
      fontSize: 12.5,
      fontWeight: FontWeight.w700,
    ),
  );
}
