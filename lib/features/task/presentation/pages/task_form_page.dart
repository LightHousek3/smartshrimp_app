import 'package:smartshrimp_app/core/widgets/app_form_field.dart';
import 'package:smartshrimp_app/core/widgets/app_select_field.dart';
import 'package:smartshrimp_app/features/task/domain/task_rules.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/task/domain/entities/task_models.dart';
import 'package:smartshrimp_app/features/task/presentation/view_models/task_controller.dart';
import 'package:smartshrimp_app/features/task/presentation/widgets/task_ui.dart';

class TaskFormPage extends ConsumerWidget {
  const TaskFormPage({this.taskId, super.key});
  final String? taskId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (taskId == null) return const _TaskForm();
    return ref
        .watch(taskDetailProvider(taskId!))
        .when(
          data: (task) => _TaskForm(original: task),
          loading: () => const AppGradientBackground(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => AppGradientBackground(
            child: SafeArea(
              child: Column(
                children: [
                  TaskHeader(
                    title: 'Chỉnh sửa nhiệm vụ',
                    onBack: () => context.pop(),
                  ),
                  TaskLoadError(
                    e,
                    () => ref.invalidate(taskDetailProvider(taskId!)),
                  ),
                ],
              ),
            ),
          ),
        );
  }
}

class _TaskForm extends ConsumerStatefulWidget {
  const _TaskForm({this.original});
  final TaskItem? original;
  @override
  ConsumerState<_TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<_TaskForm> {
  final _form = GlobalKey<FormState>();
  final _deadlineField = GlobalKey<FormFieldState<String>>();
  late final TextEditingController _title, _description, _deadline;
  late TaskPriority _priority;
  DateTime? _dueAt;
  String? _farmId, _seasonId, _assigneeId;
  String? _error;
  String? _deadlineServerError;
  bool get _locked => widget.original?.status == TaskStatus.inProgress;
  @override
  void initState() {
    super.initState();
    final task = widget.original;
    _title = TextEditingController(text: task?.title);
    _description = TextEditingController(text: task?.description);
    _priority = task?.priority ?? TaskPriority.normal;
    _dueAt = task?.dueAt.toLocal();
    _deadline = TextEditingController(
      text: _dueAt == null ? "" : taskDeadlineInput(_dueAt!),
    );
    _farmId = task?.farmId;
    _seasonId = task?.seasonId;
    _assigneeId = task?.assignedTo;
    if (task == null) {
      ref.listenManual(taskOptionsProvider(null), (_, next) {
        final farms = next.value?.farms;
        if (mounted && _farmId == null && farms != null && farms.isNotEmpty) {
          setState(() => _farmId = farms.first.id);
        }
      }, fireImmediately: true);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _deadline.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final earliest = TaskRules.firstSelectableDeadline(DateTime.now());
    final initial = _dueAt != null && _dueAt!.isAfter(earliest)
        ? _dueAt!
        : earliest;
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(earliest.year, earliest.month, earliest.day),
      lastDate: DateTime(2100),
      helpText: 'Hạn hoàn thành',
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child!,
      ),
    );
    if (time == null || !mounted) return;
    final value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      _deadlineServerError = null;
      _dueAt = value;
      _deadline.text = taskDeadlineInput(value);
    });
    _deadlineField.currentState?.validate();
  }

  String? _deadlineError() {
    if (_deadlineServerError != null) return _deadlineServerError;
    if (_dueAt != null &&
        widget.original != null &&
        _dueAt!.isAtSameMomentAs(widget.original!.dueAt)) {
      return null;
    }
    return TaskRules.deadlineError(_dueAt, DateTime.now());
  }

  Future<void> _save(String? farmId, String? assignedTo) async {
    if (!_form.currentState!.validate()) return;
    final deadline = _dueAt;
    if (deadline == null) return;
    if (farmId == null || assignedTo == null) {
      setState(
        () => _error = farmId == null
            ? 'Vui lòng chọn trang trại.'
            : 'Vui lòng chọn nhân sự.',
      );
      return;
    }
    setState(() => _error = null);
    try {
      final task = await ref
          .read(taskMutationProvider.notifier)
          .save(
            TaskInput(
              title: _title.text,
              description: _description.text,
              priority: _priority,
              dueAt: deadline,
              farmId: farmId,
              seasonId: _seasonId,
              assignedTo: assignedTo,
            ),
            original: widget.original,
          );
      if (!mounted) return;
      if (widget.original != null) {
        context.pop(true);
      } else {
        context.replace('/tasks/${task.id}');
        AppNoticeService.success(
          context,
          'Nhiệm vụ đã được tạo và giao thành công.',
        );
      }
    } catch (error) {
      if (!mounted) return;
      if (taskError(error) == TaskRules.deadlineMessage) {
        setState(() => _deadlineServerError = TaskRules.deadlineMessage);
        _deadlineField.currentState?.validate();
      } else {
        setState(() => _error = taskError(error));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(taskMutationProvider).isLoading;
    final editable = widget.original == null || widget.original!.canEdit;
    final options = ref.watch(taskOptionsProvider(_locked ? null : _farmId));
    return PopScope(
      canPop: !busy,
      child: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              TaskHeader(
                title: widget.original == null
                    ? 'Tạo & giao nhiệm vụ'
                    : 'Chỉnh sửa nhiệm vụ',
                onBack: busy
                    ? () {}
                    : () => context.canPop()
                          ? context.pop()
                          : context.go('/tasks'),
              ),
              Expanded(
                child: !editable
                    ? const Center(
                        child: Text(
                          'Nhiệm vụ đã hoàn thành hoặc đã hủy, không thể chỉnh sửa.',
                        ),
                      )
                    : options.when(
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (e, _) => TaskLoadError(
                          e,
                          () => ref.invalidate(
                            taskOptionsProvider(_locked ? null : _farmId),
                          ),
                        ),
                        data: (choices) => _fields(choices, busy),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fields(TaskOptions options, bool busy) {
    // Initial farm selection is explicit. Changing farm clears every dependent choice.
    final selectedFarm = _farmId;
    final season = options.seasons.where((s) => s.id == _seasonId).firstOrNull;
    final assignedTo = _locked
        ? widget.original!.assignedTo
        : _seasonId != null
        ? season?.technician?.id
        : options.technicians.any((t) => t.id == _assigneeId)
        ? _assigneeId
        : null;
    final technicians = _locked
        ? [widget.original!.assignee]
        : _seasonId != null
        ? [if (season?.technician != null) season!.technician!]
        : options.technicians;
    return Form(
      key: _form,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _label('Tiêu đề nhiệm vụ *'),
            AppTextField(
              key: const Key('task_title'),
              controller: _title,
              enabled: !_locked && !busy,
              maxLength: TaskRules.titleLimit,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 14,
                color: AppColors.ink,
                height: 1.5,
              ),
              decoration: _decoration('VD: Kiểm tra & xử lý NO2 cao tại Ao A3'),
              validator: TaskRules.titleError,
            ),
            const SizedBox(height: 16),
            _label('Mô tả'),
            SizedBox(
              height: 80,
              child: AppTextField(
                controller: _description,
                enabled: !busy,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                maxLines: null,
                maxLength: TaskRules.descriptionLimit,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 14,
                  color: AppColors.ink,
                  height: 1.5,
                ),
                decoration: _decoration('Mô tả chi tiết nhiệm vụ…'),
                validator: TaskRules.descriptionError,
              ),
            ),
            const SizedBox(height: 22.34),
            _label('Mức độ ưu tiên *'),
            Row(
              children: [
                for (final p in TaskPriority.values.where(
                  (p) => p != TaskPriority.unknown,
                )) ...[
                  if (p != TaskPriority.low) const SizedBox(width: 6),
                  Expanded(
                    child: Semantics(
                      selected: p == _priority,
                      child: OutlinedButton(
                        onPressed: busy
                            ? null
                            : () => setState(() => _priority = p),
                        style: OutlinedButton.styleFrom(
                          fixedSize: const Size.fromHeight(
                            AppFormMetrics.controlHeight,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 8,
                          ),
                          foregroundColor: p == _priority
                              ? priorityColors(p).$2
                              : AppColors.inkMuted,
                          backgroundColor: p == _priority
                              ? priorityColors(p).$1
                              : Colors.white,
                          side: BorderSide(
                            color: p == _priority
                                ? switch (p) {
                                    TaskPriority.normal => const Color(
                                      0xFF3F97E8,
                                    ),
                                    TaskPriority.urgent => const Color(
                                      0xFFFF577D,
                                    ),
                                    _ => priorityColors(p).$2,
                                  }
                                : AppColors.line,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppFormMetrics.radius,
                            ),
                          ),
                        ),
                        child: Text(
                          taskPriorityLabel(p),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            _label('Hạn hoàn thành *'),
            SizedBox(
              key: const Key('task_deadline'),
              child: AppTextField(
                key: _deadlineField,
                controller: _deadline,
                readOnly: true,
                enabled: !busy,
                onTap: busy ? null : _pickDueDate,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 14,
                  color: AppColors.ink,
                  height: 1.5,
                ),
                decoration: _decoration('dd/mm/yyyy hh:mm AM/PM').copyWith(
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: AppFormMetrics.controlHeight,
                    minHeight: AppFormMetrics.controlHeight,
                  ),
                  suffixIcon: const Center(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: AppSvgIcon(
                      AppSvgIconName.calendar,
                      size: 16,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                validator: (_) => _deadlineError(),
              ),
            ),
            const SizedBox(height: 16),
            _label('Trang trại *'),
            if (_locked)
              _readonly(widget.original!.farm?.name ?? 'Trang trại đã chọn')
            else
              AppSelectField<String>(
                key: ValueKey('farm-$selectedFarm'),
                value: options.farms.any((f) => f.id == selectedFarm)
                    ? selectedFarm
                    : null,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 14,
                  color: AppColors.ink,
                ),
                hint: 'Chọn trang trại',
                items: options.farms
                    .map(
                      (f) => DropdownMenuItem(
                        value: f.id,
                        child: Text(f.name, softWrap: true),
                      ),
                    )
                    .toList(),
                onChanged: busy
                    ? null
                    : (v) => setState(() {
                        _farmId = v;
                        _seasonId = null;
                        _assigneeId = null;
                      }),
                validator: (v) =>
                    v == null ? 'Vui lòng chọn trang trại.' : null,
              ),
            const SizedBox(height: 16),
            _label('Vụ nuôi liên quan'),
            if (_locked)
              _readonly(
                widget.original!.season?.name ?? '— Không gắn với vụ nuôi —',
              )
            else
              AppSelectField<String>(
                key: ValueKey('season-$_farmId-$_seasonId'),
                value: options.seasons.any((s) => s.id == _seasonId)
                    ? _seasonId
                    : null,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 14,
                  color: AppColors.ink,
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('— Không gắn với vụ nuôi —'),
                  ),
                  ...options.seasons.map(
                    (s) => DropdownMenuItem(
                      value: s.id,
                      child: Text('${s.pondName} · ${s.name}', softWrap: true),
                    ),
                  ),
                ],
                onChanged: busy || _farmId == null
                    ? null
                    : (v) => setState(() {
                        _seasonId = v;
                        _assigneeId = null;
                      }),
              ),
            const SizedBox(height: 16),
            _label('Giao cho Kỹ thuật viên *'),
            if (_seasonId != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: taskBlue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Nhiệm vụ gắn với vụ nuôi được giao tự động cho KTV đang phụ trách để đúng trách nhiệm vận hành.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.6,
                    color: Color(0xFF0C4E8F),
                  ),
                ),
              ),
            if (_locked)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Nhiệm vụ đang làm chỉ được sửa mô tả, ưu tiên và hạn hoàn thành.',
                  style: TextStyle(color: AppColors.inkSoft, fontSize: 11),
                ),
              ),
            FormField<String>(
              key: ValueKey('assignee-$_farmId-$_seasonId'),
              initialValue: assignedTo,
              validator: (_) =>
                  assignedTo == null ? 'Vui lòng chọn nhân sự.' : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final technician in technicians)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _TechnicianCard(
                        technician,
                        selected: assignedTo == technician.id,
                        onTap: busy || _locked || _seasonId != null
                            ? null
                            : () {
                                setState(() => _assigneeId = technician.id);
                                field.didChange(technician.id);
                              },
                      ),
                    ),
                  if (field.hasError) AppFieldError(field.errorText!),
                ],
              ),
            ),
            if (technicians.isEmpty)
              Text(
                _seasonId == null
                    ? 'Chưa có kỹ thuật viên đang hoạt động.'
                    : 'Vụ nuôi chưa có kỹ thuật viên đang phụ trách. Vui lòng phân công trước khi giao nhiệm vụ.',
                style: const TextStyle(fontSize: 12, color: AppColors.error),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  _error!,
                  style: const TextStyle(color: AppColors.error, fontSize: 12),
                ),
              ),
            const SizedBox(height: 16),
            GradientButton(
              label: widget.original == null
                  ? 'Tạo & giao nhiệm vụ'
                  : 'Lưu thay đổi',
              height: 45,
              borderRadius: 12,
              compact: true,
              leading: const AppSvgIcon(
                AppSvgIconName.check,
                size: 18,
                color: Colors.white,
              ),
              isLoading: busy,
              onPressed: busy ? null : () => _save(selectedFarm, assignedTo),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: AppFormMetrics.labelGap),
    child: AppFieldLabel(text),
  );
  Widget _readonly(String value) => SizedBox(
    height: AppFormMetrics.selectHeight,
    child: InputDecorator(
      decoration: AppFormMetrics.decoration(
        const InputDecoration(),
        select: true,
      ),
      child: SizedBox(
        height: AppFormMetrics.selectHeight,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: const TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 14,
              height: 18.105 / 14,
              color: AppColors.inkMuted,
            ),
          ),
        ),
      ),
    ),
  );
  InputDecoration _decoration(String hint) => InputDecoration(
    hintText: hint,
    counterText: '',
    errorMaxLines: 3,
    hintStyle: const TextStyle(
      fontFamily: 'PlusJakartaSans',
      fontSize: 14,
      color: AppColors.inkMuted,
    ),
  );
}

class _TechnicianCard extends StatelessWidget {
  const _TechnicianCard(this.technician, {required this.selected, this.onTap});
  final TaskChoice technician;
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: Material(
      color: selected ? taskBlue : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xFF3F97E8) : AppColors.line,
              width: 1.2,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFD3E8FF),
                child: Text(
                  technician.name
                      .trim()
                      .split(RegExp(r'\s+'))
                      .last
                      .characters
                      .first,
                  style: const TextStyle(
                    color: Color(0xFF0C4E8F),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  technician.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (selected)
                const AppSvgIcon(
                  AppSvgIconName.check,
                  size: 18,
                  color: AppColors.ocean,
                ),
            ],
          ),
        ),
      ),
    ),
  );
}
