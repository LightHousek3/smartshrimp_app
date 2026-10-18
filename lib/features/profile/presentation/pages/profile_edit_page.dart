import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/router/app_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/account_profile.dart';
import 'package:smartshrimp_app/features/profile/presentation/profile_form_utils.dart';
import 'package:smartshrimp_app/features/profile/presentation/view_models/profile_controller.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/profile/presentation/widgets/profile_form_field.dart';

class ProfileEditPage extends ConsumerWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileControllerProvider);
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: profileState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.ocean),
          ),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                error is AppException
                    ? error.message
                    : 'Không thể tải thông tin hồ sơ.',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (profile) => _ProfileEditForm(
            key: ValueKey<String>(profile.id),
            profile: profile,
          ),
        ),
      ),
    );
  }
}

class _ProfileEditForm extends ConsumerStatefulWidget {
  const _ProfileEditForm({required this.profile, super.key});

  final AccountProfile profile;

  @override
  ConsumerState<_ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends ConsumerState<_ProfileEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.fullName);
    _phoneController = TextEditingController(text: widget.profile.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PageHeaderBar(
          title: 'Cập nhật thông tin',
          onBack: context.pop,
          contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          titleStyle: AppTypography.display(
            fontSize: 16,
            height: 1.25,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ).copyWith(fontFamilyFallback: const ['PlusJakartaSans']),
        ),
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ProfileFormField(
                    label: 'Họ và tên',
                    child: TextFormField(
                      key: const Key('profile_name_field'),
                      controller: _nameController,
                      enabled: !_isSaving,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      maxLength: 50,
                      style: profileIdentityInputStyle,
                      decoration: profileInputDecoration(
                        hintText: 'VD: Trần Quốc Bảo',
                      ),
                      validator: ProfileFormUtils.validateFullName,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ProfileFormField(
                    label: 'Số điện thoại',
                    child: TextFormField(
                      key: const Key('profile_phone_field'),
                      controller: _phoneController,
                      enabled: !_isSaving,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      maxLength: 20,
                      style: profileIdentityInputStyle,
                      decoration: profileInputDecoration(
                        hintText: '09xx xxx xxx',
                      ),
                      validator: ProfileFormUtils.validatePhone,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                  ),
                  const SizedBox(height: 28),
                  GradientButton(
                    label: 'Lưu thay đổi',
                    compact: true,
                    height: 45,
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                    borderRadius: 12,
                    leading: const AppSvgIcon(
                      AppSvgIconName.check,
                      size: 18,
                      color: Colors.white,
                    ),
                    isLoading: _isSaving,
                    onPressed: _isSaving ? null : _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (_isSaving || !(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);
    try {
      await ref
          .read(profileControllerProvider.notifier)
          .updateProfile(
            fullName: ProfileFormUtils.normalizeFullName(_nameController.text),
            phone: ProfileFormUtils.normalizePhone(_phoneController.text),
          );
      if (!mounted) return;
      AppNoticeService.success(context, 'Cập nhật hồ sơ thành công.');
      context.go(AppRoutes.account);
    } on AppException catch (error) {
      if (mounted) {
        _showError(error.message);
      }
    } on Object {
      if (mounted) {
        _showError('Không thể cập nhật hồ sơ. Vui lòng thử lại.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    AppNoticeService.danger(context, message);
  }
}
