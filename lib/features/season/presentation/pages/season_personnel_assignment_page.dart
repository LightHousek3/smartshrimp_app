import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_circle_button.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/auth/domain/entities/auth_account.dart';
import 'package:smartshrimp_app/features/personnel/domain/entities/managed_personnel.dart';
import 'package:smartshrimp_app/features/personnel/presentation/widgets/personnel_visuals.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart';
import 'package:smartshrimp_app/features/season/domain/season_rules.dart';
import 'package:smartshrimp_app/features/season/presentation/view_models/season_controller.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_ui.dart';

class SeasonPersonnelAssignmentPage extends ConsumerWidget {
  const SeasonPersonnelAssignmentPage({
    required this.farmId,
    required this.seasonId,
    super.key,
  });

  final String farmId;
  final String seasonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(seasonDetailControllerProvider(seasonId));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppGradientBackground(
        child: SafeArea(
          child: state.when(
            data: (season) {
              final canAssign =
                  season.status == SeasonStatus.planning ||
                  season.status == SeasonStatus.active;
              if (!canAssign) return const _AssignmentUnavailable();
              return _AssignmentForm(farmId: farmId, season: season);
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.ocean),
            ),
            error: (error, _) => _AssignmentLoadError(
              message: error is AppException
                  ? error.message
                  : 'Không thể tải thông tin vụ nuôi.',
              onRetry: ref
                  .read(seasonDetailControllerProvider(seasonId).notifier)
                  .refresh,
            ),
          ),
        ),
      ),
    );
  }
}

class _AssignmentForm extends ConsumerStatefulWidget {
  const _AssignmentForm({required this.farmId, required this.season});

  final String farmId;
  final AquacultureSeason season;

  @override
  ConsumerState<_AssignmentForm> createState() => _AssignmentFormState();
}

class _AssignmentFormState extends ConsumerState<_AssignmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  AccountRole _role = AccountRole.technician;
  ManagedPersonnel? _selected;
  String? _selectionError;
  String? _submitError;

  SeasonAssignment? get _current => switch (_role) {
    AccountRole.technician => widget.season.personnel?.technician,
    AccountRole.expert => widget.season.personnel?.expert,
    _ => null,
  };

  bool get _isReplacement => _current != null;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _selectRole(AccountRole role) {
    if (_role == role) return;
    setState(() {
      _role = role;
      _selected = null;
      _selectionError = null;
      _submitError = null;
      _reasonController.clear();
    });
  }

  Future<void> _submit() async {
    final mutation = ref.read(seasonMutationControllerProvider);
    if (mutation.isLoading) return;

    final selected = _selected;
    setState(() {
      _selectionError = selected == null ? 'Vui lòng chọn nhân sự.' : null;
      _submitError = null;
    });
    final formValid = _formKey.currentState?.validate() ?? false;
    if (selected == null || !formValid) return;

    try {
      final current = _current;
      String message;
      if (current == null) {
        await ref
            .read(seasonMutationControllerProvider.notifier)
            .assignPersonnel(
              farmId: widget.farmId,
              current: widget.season,
              accountId: selected.id,
              role: _role,
            );
        message = 'Đã phân công ${selected.displayName}.';
      } else {
        final result = await ref
            .read(seasonMutationControllerProvider.notifier)
            .replacePersonnel(
              farmId: widget.farmId,
              current: widget.season,
              accountId: selected.id,
              role: _role,
              expectedAssignmentId: current.id,
              reason: _reasonController.text,
            );
        final transferred =
            result.transferredTaskCount + result.transferredDiseaseCaseCount;
        message = transferred == 0
            ? 'Đã thay nhân sự thành ${selected.displayName}.'
            : 'Đã thay nhân sự và bàn giao $transferred công việc.';
      }
      if (mounted) context.pop(message);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _submitError = error is AppException
            ? error.message
            : 'Không thể cập nhật nhân sự. Vui lòng thử lại.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mutation = ref.watch(seasonMutationControllerProvider);
    final people = ref.watch(assignablePersonnelProvider(_role));
    final assignedIds = <String>{
      if (widget.season.personnel?.technician case final value?)
        value.account.id,
      if (widget.season.personnel?.expert case final value?) value.account.id,
    };

    return Form(
      key: _formKey,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: <Widget>[
          StickyPageHeader(
            title: _isReplacement ? 'Thay nhân sự' : 'Phân công nhân sự',
            subtitle:
                '${widget.season.pond.name} · ${widget.season.pond.farm?.name ?? 'Trang trại'}',
            onBack: mutation.isLoading ? null : context.pop,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
            sliver: SliverList.list(
              children: <Widget>[
                _SeasonSummary(season: widget.season),
                const SizedBox(height: 18),
                const _FieldLabel('Vai trò cần phân công'),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _RoleOption(
                        key: const Key('assignment_role_technician'),
                        label: 'Kỹ thuật viên',
                        icon: Icons.engineering_rounded,
                        selected: _role == AccountRole.technician,
                        current: widget.season.personnel?.technician,
                        onTap: mutation.isLoading
                            ? null
                            : () => _selectRole(AccountRole.technician),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _RoleOption(
                        key: const Key('assignment_role_expert'),
                        label: 'Chuyên gia',
                        icon: Icons.health_and_safety_rounded,
                        selected: _role == AccountRole.expert,
                        current: widget.season.personnel?.expert,
                        onTap: mutation.isLoading
                            ? null
                            : () => _selectRole(AccountRole.expert),
                      ),
                    ),
                  ],
                ),
                if (_current case final current?) ...<Widget>[
                  const SizedBox(height: 13),
                  _NoticeCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Đang phân công: ${current.account.fullName}',
                    message: 'Chọn nhân sự mới để thực hiện thay thế.',
                    foreground: const Color(0xFF9A6500),
                    background: const Color(0xFFFFF7DF),
                    border: const Color(0xFFF3D27A),
                  ),
                  const SizedBox(height: 10),
                  _NoticeCard(
                    icon: Icons.swap_horiz_rounded,
                    title: 'Phạm vi bàn giao tự động',
                    message: _role == AccountRole.technician
                        ? 'Nhiệm vụ chưa kết thúc sẽ được chuyển sang Kỹ thuật viên mới; lịch sử thực hiện vẫn được giữ nguyên.'
                        : 'Ca bệnh đang mở sẽ được chuyển trách nhiệm theo dõi sang Chuyên gia mới; phản hồi cũ không thay đổi.',
                    foreground: AppColors.ocean,
                    background: const Color(0xFFEAF4FF),
                    border: const Color(0xFFB8D8F7),
                  ),
                ],
                const SizedBox(height: 18),
                _FieldLabel('Chọn ${PersonnelVisuals.roleLabel(_role)} *'),
                const SizedBox(height: 8),
                people.when(
                  data: (items) {
                    final eligible = items
                        .where((person) => !assignedIds.contains(person.id))
                        .toList(growable: false);
                    if (eligible.isEmpty) {
                      return _PersonnelEmpty(role: _role);
                    }
                    return Column(
                      children: <Widget>[
                        for (final person in eligible) ...<Widget>[
                          _PersonnelOption(
                            key: Key('assignment_candidate_${person.id}'),
                            person: person,
                            selected: _selected?.id == person.id,
                            enabled: !mutation.isLoading,
                            onTap: () => setState(() {
                              _selected = person;
                              _selectionError = null;
                              _submitError = null;
                            }),
                          ),
                          if (person != eligible.last)
                            const SizedBox(height: 9),
                        ],
                      ],
                    );
                  },
                  loading: () => const _PersonnelLoading(),
                  error: (error, _) => _PersonnelError(
                    message: error is AppException
                        ? error.message
                        : 'Không thể tải danh sách nhân sự.',
                    onRetry: () =>
                        ref.invalidate(assignablePersonnelProvider(_role)),
                  ),
                ),
                if (_selectionError case final error?) ...<Widget>[
                  const SizedBox(height: 7),
                  Text(
                    error,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                if (_isReplacement) ...<Widget>[
                  const SizedBox(height: 18),
                  const _FieldLabel('Lý do thay nhân sự *'),
                  const SizedBox(height: 8),
                  TextFormField(
                    key: const Key('replacement_reason_field'),
                    controller: _reasonController,
                    enabled: !mutation.isLoading,
                    minLines: 3,
                    maxLines: 5,
                    maxLength: SeasonRules.replacementReasonMaxLength,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      hintText: 'Nhập lý do thay nhân sự...',
                      alignLabelWithHint: true,
                    ),
                    validator: SeasonRules.validateReplacementReason,
                  ),
                ],
                if (_submitError case final error?) ...<Widget>[
                  const SizedBox(height: 12),
                  _SubmitError(message: error),
                ],
                const SizedBox(height: 22),
                GradientButton(
                  key: const Key('submit_personnel_assignment'),
                  label: _isReplacement ? 'Xác nhận thay nhân sự' : 'Phân công',
                  icon: _isReplacement
                      ? Icons.swap_horiz_rounded
                      : Icons.person_add_alt_1_rounded,
                  isLoading: mutation.isLoading,
                  onPressed: mutation.isLoading ? null : _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SeasonSummary extends StatelessWidget {
  const _SeasonSummary({required this.season});

  final AquacultureSeason season;

  @override
  Widget build(BuildContext context) => SeasonSectionCard(
    child: Row(
      children: <Widget>[
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: const Color(0xFFE7F4FF),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.waves_rounded, color: AppColors.ocean),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                season.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                seasonStatusLabel(season.status),
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
        ),
        SeasonStatusBadge(status: season.status),
      ],
    ),
  );
}

class _RoleOption extends StatelessWidget {
  const _RoleOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.current,
    required this.onTap,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final SeasonAssignment? current;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? const Color(0xFFEAF4FF) : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(
        color: selected ? AppColors.oceanLight : AppColors.line,
        width: selected ? 1.5 : 1,
      ),
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              size: 22,
              color: selected ? AppColors.ocean : AppColors.inkMuted,
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.ocean : AppColors.inkSoft,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (current case final assignment?) ...<Widget>[
              const SizedBox(height: 3),
              Text(
                'Hiện: ${assignment.account.fullName}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 9.5,
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _NoticeCard extends StatelessWidget {
  const _NoticeCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.foreground,
    required this.background,
    required this.border,
  });

  final IconData icon;
  final String title;
  final String message;
  final Color foreground;
  final Color background;
  final Color border;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: border),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: foreground, size: 19),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  color: foreground,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                message,
                style: TextStyle(color: foreground, fontSize: 11, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _PersonnelOption extends StatelessWidget {
  const _PersonnelOption({
    required this.person,
    required this.selected,
    required this.enabled,
    required this.onTap,
    super.key,
  });

  final ManagedPersonnel person;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? const Color(0xFFEAF4FF) : Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(
        color: selected ? AppColors.oceanLight : AppColors.line,
        width: selected ? 1.5 : 1,
      ),
    ),
    child: InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        child: Row(
          children: <Widget>[
            PersonnelAvatar(personnel: person, radius: 21),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    person.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    person.email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 10.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${person.currentSeasonAssignments} vụ đang phụ trách',
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected ? AppColors.ocean : const Color(0xFFB5BFCD),
              size: 23,
            ),
          ],
        ),
      ),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(
      color: AppColors.inkSoft,
      fontSize: 12.5,
      fontWeight: FontWeight.w700,
    ),
  );
}

class _PersonnelLoading extends StatelessWidget {
  const _PersonnelLoading();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 90,
    child: Center(
      child: CircularProgressIndicator(color: AppColors.ocean, strokeWidth: 2),
    ),
  );
}

class _PersonnelEmpty extends StatelessWidget {
  const _PersonnelEmpty({required this.role});

  final AccountRole role;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0x99FFFFFF),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.line),
    ),
    child: Text(
      'Không có ${PersonnelVisuals.roleLabel(role)} đang hoạt động khả dụng.',
      textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
    ),
  );
}

class _PersonnelError extends StatelessWidget {
  const _PersonnelError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFFFCBD5)),
    ),
    child: Column(
      children: <Widget>[
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.error, fontSize: 12),
        ),
        TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Thử lại'),
        ),
      ],
    ),
  );
}

class _SubmitError extends StatelessWidget {
  const _SubmitError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    key: const Key('personnel_assignment_error'),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFFE8ED),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: <Widget>[
        const Icon(Icons.error_outline_rounded, color: AppColors.error),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}

class _AssignmentUnavailable extends StatelessWidget {
  const _AssignmentUnavailable();

  @override
  Widget build(BuildContext context) => _AssignmentMessage(
    icon: Icons.groups_2_outlined,
    title: 'Không thể phân công',
    message: 'Chỉ vụ đang chuẩn bị hoặc đang nuôi mới được thay đổi nhân sự.',
    onRetry: null,
  );
}

class _AssignmentLoadError extends StatelessWidget {
  const _AssignmentLoadError({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) => _AssignmentMessage(
    icon: Icons.error_outline_rounded,
    title: 'Không thể tải dữ liệu',
    message: message,
    onRetry: onRetry,
  );
}

class _AssignmentMessage extends StatelessWidget {
  const _AssignmentMessage({
    required this.icon,
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final IconData icon;
  final String title;
  final String message;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(19),
    child: Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: AppCircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            tooltip: 'Quay lại',
            onPressed: context.pop,
          ),
        ),
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(icon, size: 42, color: AppColors.inkSoft),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 13,
                    ),
                  ),
                  if (onRetry != null) ...<Widget>[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
