import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/profile/domain/entities/user_profile.dart';
import 'package:smartshrimp_app/features/profile/presentation/profile_form_utils.dart';
import 'package:smartshrimp_app/features/profile/presentation/view_models/profile_controller.dart';
import 'package:smartshrimp_app/features/profile/presentation/widgets/profile_screen_header.dart';

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
            key: ValueKey<String>(
              '${profile.id}-${profile.updatedAt?.toIso8601String()}',
            ),
            profile: profile,
          ),
        ),
      ),
    );
  }
}

class _ProfileEditForm extends ConsumerStatefulWidget {
  const _ProfileEditForm({required this.profile, super.key});

  final UserProfile profile;

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
        const ProfileScreenHeader(title: 'Cập nhật thông tin'),
        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _FieldLabel('Họ và tên'),
                  const SizedBox(height: 7),
                  TextFormField(
                    key: const Key('profile_name_field'),
                    controller: _nameController,
                    enabled: !_isSaving,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    maxLength: 255,
                    decoration: const InputDecoration(
                      hintText: 'VD: Trần Quốc Bảo',
                      counterText: '',
                    ),
                    validator: ProfileFormUtils.validateFullName,
                  ),
                  const SizedBox(height: 16),
                  const _FieldLabel('Số điện thoại'),
                  const SizedBox(height: 7),
                  TextFormField(
                    key: const Key('profile_phone_field'),
                    controller: _phoneController,
                    enabled: !_isSaving,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(hintText: '09xx xxx xxx'),
                    validator: ProfileFormUtils.validatePhone,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    label: 'Lưu thay đổi',
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
            fullName: _nameController.text,
            phone: ProfileFormUtils.normalizePhone(_phoneController.text),
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật hồ sơ thành công.')),
      );
      Navigator.of(context).pop();
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.inkSoft,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
