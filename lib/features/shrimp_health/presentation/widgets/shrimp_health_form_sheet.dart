import 'package:flutter/material.dart';
import 'package:smartshrimp_app/core/errors/error_mapper.dart';
import 'package:smartshrimp_app/features/home/presentation/view_models/technician_dashboard_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/gradient_button.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/shrimp_health/domain/entities/shrimp_health_models.dart';
import 'package:smartshrimp_app/features/shrimp_health/presentation/view_models/shrimp_health_controller.dart';
import 'package:uuid/uuid.dart';

class ShrimpHealthFormSheet extends ConsumerStatefulWidget {
  const ShrimpHealthFormSheet({
    required this.seasonId,
    this.initialQuantity,
    this.previousPopulation,
    this.onCreated,
    super.key,
  });

  final String seasonId;
  final int? initialQuantity;
  final int? previousPopulation;
  final VoidCallback? onCreated;

  static Future<bool?> show(
    BuildContext context, {
    required String seasonId,
    int? initialQuantity,
    int? previousPopulation,
    VoidCallback? onCreated,
  }) => showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ShrimpHealthFormSheet(
      seasonId: seasonId,
      initialQuantity: initialQuantity,
      previousPopulation: previousPopulation,
      onCreated: onCreated,
    ),
  );

  @override
  ConsumerState<ShrimpHealthFormSheet> createState() =>
      _ShrimpHealthFormSheetState();
}

class _ShrimpHealthFormSheetState extends ConsumerState<ShrimpHealthFormSheet> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _recordedAt;
  HealthStatus _healthStatus = HealthStatus.good;

  final _sampleSizeController = TextEditingController();
  final _sampleWeightController = TextEditingController();
  final _avgWeightController = TextEditingController();
  final _avgLengthController = TextEditingController();
  final _mortalityController = TextEditingController();
  final _populationController = TextEditingController();
  final _biomassController = TextEditingController();
  final _noteController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _recordedAt = DateTime.now();

    _sampleSizeController.addListener(_recalculateAll);
    _sampleWeightController.addListener(_recalculateAll);
    _mortalityController.addListener(_recalculateAll);
    _populationController.addListener(_recalculateAll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recalculateAll();
    });
  }

  @override
  void dispose() {
    _sampleSizeController.removeListener(_recalculateAll);
    _sampleWeightController.removeListener(_recalculateAll);
    _mortalityController.removeListener(_recalculateAll);
    _populationController.removeListener(_recalculateAll);

    _sampleSizeController.dispose();
    _sampleWeightController.dispose();
    _avgWeightController.dispose();
    _avgLengthController.dispose();
    _mortalityController.dispose();
    _populationController.dispose();
    _biomassController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  int? get _effectiveInitialQuantity =>
      widget.initialQuantity ??
      ref
          .watch(assignedSeasonDetailProvider(widget.seasonId))
          .value
          ?.initialQuantity;

  int? get _basePopulation {
    if (widget.previousPopulation != null && widget.previousPopulation! > 0) {
      return widget.previousPopulation;
    }
    final logs = ref
        .watch(shrimpHealthListProvider(widget.seasonId))
        .value
        ?.logs;
    final latestValidLog = logs
        ?.where((l) => !l.isVoided && l.estimatedPopulation != null)
        .firstOrNull;
    if (latestValidLog?.estimatedPopulation != null &&
        latestValidLog!.estimatedPopulation! > 0) {
      return latestValidLog.estimatedPopulation;
    }
    return _effectiveInitialQuantity;
  }

  static double? _parseDouble(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    final normalized = trimmed.replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  static String _formatNumber(int value) => value.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]}.',
  );

  static String _formatWeight(double val) {
    if (val == val.roundToDouble()) {
      return val.toStringAsFixed(0);
    }
    if (val >= 100) return val.toStringAsFixed(0);
    if (val >= 10) return val.toStringAsFixed(1);
    return val.toStringAsFixed(2);
  }

  static String _formatTimeDayMonth(DateTime dt) {
    final local = dt.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    return '$hour:$minute  •  Hôm nay ($day/$month)';
  }

  double? get _calculatedAvgWeight {
    final weightKg = _parseDouble(_sampleWeightController.text);
    if (weightKg == null || weightKg <= 0) return null;

    final sampleSize = int.tryParse(_sampleSizeController.text.trim());
    if (sampleSize != null && sampleSize > 0) {
      // (weight in kg * 1000) / sampleSize = grams per shrimp
      return (weightKg * 1000) / sampleSize;
    }
    return null;
  }

  int? get _calculatedPopulation {
    final basePop = _basePopulation;
    final mortality = int.tryParse(_mortalityController.text.trim()) ?? 0;
    if (basePop != null && basePop > 0) {
      final remaining = basePop - mortality;
      return remaining < 0 ? 0 : remaining;
    }
    final raw = _populationController.text.replaceAll('.', '').trim();
    return int.tryParse(raw);
  }

  void _recalculateAll() {
    final basePop = _basePopulation;
    final population = _calculatedPopulation;
    if (basePop != null && basePop > 0) {
      if (population != null) {
        final formattedPop = _formatNumber(population);
        if (_populationController.text != formattedPop) {
          _populationController.text = formattedPop;
        }
      } else {
        if (_populationController.text.isNotEmpty) {
          _populationController.clear();
        }
      }
    }

    final avgWeight = _calculatedAvgWeight;
    if (avgWeight != null) {
      final formattedWeight = _formatWeight(avgWeight);
      if (_avgWeightController.text != formattedWeight) {
        _avgWeightController.text = formattedWeight;
      }
    } else {
      if (_avgWeightController.text.isNotEmpty) {
        _avgWeightController.clear();
      }
    }

    if (avgWeight != null && avgWeight > 0 && population != null && population > 0) {
      final calculatedBiomass = (population * avgWeight) / 1000;
      final formattedBiomass = calculatedBiomass == calculatedBiomass.roundToDouble()
          ? calculatedBiomass.toStringAsFixed(0)
          : calculatedBiomass.toStringAsFixed(1);
      if (_biomassController.text != formattedBiomass) {
        _biomassController.text = formattedBiomass;
      }
    } else {
      if (_biomassController.text.isNotEmpty) {
        _biomassController.clear();
      }
    }

    if (mounted) setState(() {});
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_recordedAt),
      helpText: 'CHỌN GIỜ GHI NHẬN HÔM NAY',
    );
    if (pickedTime == null || !mounted) return;

    final candidate = DateTime(
      now.year,
      now.month,
      now.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (candidate.isAfter(now.add(const Duration(minutes: 5)))) {
      AppNoticeService.show(
        context,
        message: 'Thời điểm ghi nhận không thể ở tương lai.',
        level: AppNoticeLevel.danger,
      );
      return;
    }

    setState(() {
      _recordedAt = candidate;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    if (_recordedAt.isBefore(startOfToday)) {
      AppNoticeService.show(
        context,
        message: 'Chỉ được ghi nhận sức khỏe tôm trong ngày hôm nay.',
        level: AppNoticeLevel.danger,
      );
      return;
    }
    if (_recordedAt.isAfter(now.add(const Duration(minutes: 5)))) {
      AppNoticeService.show(
        context,
        message: 'Thời điểm ghi nhận không thể ở tương lai.',
        level: AppNoticeLevel.danger,
      );
      return;
    }

    if (_formKey.currentState?.validate() == false) {
      return;
    }

    final sampleSize = int.tryParse(_sampleSizeController.text.trim());
    final avgWeightG = _calculatedAvgWeight;
    final avgLengthCm = _parseDouble(_avgLengthController.text);
    final mortalityCount = int.tryParse(_mortalityController.text.trim()) ?? 0;
    final estimatedPopulation = _calculatedPopulation;
    final estimatedBiomassKg = _parseDouble(_biomassController.text);
    final note = _noteController.text.trim();

    final initialQty = _effectiveInitialQuantity;
    if (initialQty != null &&
        initialQty > 0 &&
        estimatedPopulation != null &&
        estimatedPopulation > initialQty) {
      AppNoticeService.show(
        context,
        message:
            'Ước tính đàn (${_formatNumber(estimatedPopulation)} con) không được vượt quá số giống ban đầu (${_formatNumber(initialQty)} con)',
        level: AppNoticeLevel.danger,
      );
      return;
    }

    final hasAnyMetric =
        sampleSize != null ||
        avgWeightG != null ||
        avgLengthCm != null ||
        mortalityCount > 0 ||
        estimatedPopulation != null ||
        estimatedBiomassKg != null ||
        note.isNotEmpty;

    if (!hasAnyMetric) {
      AppNoticeService.show(
        context,
        message: 'Vui lòng nhập ít nhất một chỉ số sức khỏe hoặc thể trạng tôm',
        level: AppNoticeLevel.warning,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final idempotencyKey = const Uuid().v4();

      await ref
          .read(shrimpHealthRepositoryProvider)
          .createLog(
            widget.seasonId,
            recordedAt: _recordedAt,
            sampleSize: sampleSize,
            avgWeightG: avgWeightG,
            avgLengthCm: avgLengthCm,
            mortalityCount: mortalityCount,
            estimatedPopulation: estimatedPopulation,
            estimatedBiomassKg: estimatedBiomassKg,
            healthStatus: _healthStatus,
            note: note.isNotEmpty ? note : null,
            idempotencyKey: idempotencyKey,
          );

      if (!mounted) return;

      AppNoticeService.show(
        context,
        message: 'Ghi nhận sức khỏe tôm thành công',
        level: AppNoticeLevel.success,
      );

      ref.invalidate(technicianDashboardProvider);
      widget.onCreated?.call();
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      AppNoticeService.show(
        context,
        message: ErrorMapper.displayMessage(e),
        level: AppNoticeLevel.danger,
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String unit,
    String? hint,
    TextInputType keyboardType = const TextInputType.numberWithOptions(
      decimal: true,
    ),
    List<TextInputFormatter>? inputFormatters,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F1C2E),
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6A7994),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        readOnly: readOnly,
        enableInteractiveSelection: !readOnly,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: readOnly ? const Color(0xFF334155) : const Color(0xFF0F1C2E),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: readOnly ? const Color(0xFFF1F5F9) : Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: readOnly ? const Color(0xFFE2E8F0) : const Color(0xFFDDE3EA),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: readOnly ? const Color(0xFFE2E8F0) : const Color(0xFFDDE3EA),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: readOnly ? const Color(0xFFE2E8F0) : const Color(0xFF1378D1),
              width: readOnly ? 1 : 1.5,
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildHealthStatusSelector() {
    const statuses = <HealthStatus, String>{
      HealthStatus.excellent: 'Rất tốt',
      HealthStatus.good: 'Tốt',
      HealthStatus.warning: 'Cần chú ý',
      HealthStatus.critical: 'Nguy cấp',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Đánh giá sức khỏe',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F1C2E),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: statuses.entries.map((entry) {
            final status = entry.key;
            final label = entry.value;
            final isSelected = _healthStatus == status;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  onTap: () => setState(() => _healthStatus = status),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFEAF4FF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0F62B4)
                            : const Color(0xFFDDE3EA),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF0F62B4)
                            : const Color(0xFF0F1C2E),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    ref.listen(assignedSeasonDetailProvider(widget.seasonId), (prev, next) {
      if (prev?.value?.initialQuantity != next.value?.initialQuantity) {
        _recalculateAll();
      }
    });

    ref.listen(shrimpHealthListProvider(widget.seasonId), (prev, next) {
      if (prev?.value != next.value) {
        _recalculateAll();
      }
    });

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Header row: Title + Circular close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Ghi nhận sức khỏe tôm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F1C2E),
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEEF1F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Color(0xFF6A7994),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Recorded Date Time Bar
                InkWell(
                  onTap: _pickDateTime,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF1F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6A7994),
                              fontFamily: 'PlusJakartaSans',
                            ),
                            children: <TextSpan>[
                              const TextSpan(text: 'Thời điểm ghi nhận: '),
                              TextSpan(
                                text: _formatTimeDayMonth(_recordedAt),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F1C2E),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.edit_calendar_rounded,
                          size: 16,
                          color: Color(0xFF6A7994),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 2-Column Grid: Row 1 (Nhập: Số mẫu + Tổng KL mẫu)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _buildField(
                        controller: _sampleSizeController,
                        label: 'Số mẫu (chài)',
                        unit: 'con',
                        hint: '120',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) => _recalculateAll(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        controller: _sampleWeightController,
                        label: 'Tổng khối lượng mẫu',
                        unit: 'kg',
                        hint: '1.2',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*[,.]?\d*'),
                          ),
                        ],
                        onChanged: (_) => _recalculateAll(),
                        validator: (val) {
                          if (val != null && val.trim().isNotEmpty) {
                            final sampleSize = int.tryParse(
                              _sampleSizeController.text.trim(),
                            );
                            if (sampleSize == null || sampleSize <= 0) {
                              return 'Vui lòng nhập số mẫu';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 2-Column Grid: Row 2 (Nhập: Chiều dài TB + Số hao hụt)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _buildField(
                        controller: _avgLengthController,
                        label: 'Chiều dài TB',
                        unit: 'cm',
                        hint: '11.2',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*[,.]?\d*'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        controller: _mortalityController,
                        label: 'Số hao hụt',
                        unit: 'con',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (_) => _recalculateAll(),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return null;
                          final mortality = int.tryParse(val.trim());
                          if (mortality == null || mortality < 0) {
                            return 'Số lượng không hợp lệ';
                          }
                          final base = _basePopulation;
                          if (base != null && base > 0 && mortality > base) {
                            return 'Hao hụt vượt quá số tôm hiện có';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 2-Column Grid: Row 3 (Tự sinh: Trọng lượng TB + Ước tính đàn)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: _buildField(
                        controller: _avgWeightController,
                        readOnly: true,
                        label: 'Trọng lượng TB',
                        unit: 'g',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildField(
                        controller: _populationController,
                        readOnly: _basePopulation != null && _basePopulation! > 0,
                        label: 'Ước tính đàn',
                        unit: 'con',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Row 4 (Tự sinh: Sinh khối ước tính)
                _buildField(
                  controller: _biomassController,
                  readOnly: true,
                  label: 'Sinh khối ước tính',
                  unit: 'kg',
                ),
                const SizedBox(height: 16),

                // Health status rating
                _buildHealthStatusSelector(),
                const SizedBox(height: 16),

                // Note
                const Text(
                  'Ghi chú quan sát',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F1C2E),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0F1C2E),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Màu sắc, đường ruột, phân, vỏ...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDDE3EA)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFDDE3EA)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1378D1),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Submit button (đồng bộ GradientButton theo thiết kế hệ thống)
                GradientButton(
                  onPressed: _isSubmitting ? null : _submit,
                  isLoading: _isSubmitting,
                  label: 'Lưu bản ghi',
                  icon: Icons.check_rounded,
                  compact: true,
                  borderRadius: 14,
                  height: 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
