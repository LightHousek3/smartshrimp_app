import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart';

class ProtocolTimeline extends StatefulWidget {
  const ProtocolTimeline({
    required this.detail,
    required this.selectedDay,
    required this.onSelect,
    this.currentDay,
    super.key,
  });
  final ProtocolDetail detail;
  final int selectedDay;
  final ValueChanged<int> onSelect;
  final int? currentDay;

  @override
  State<ProtocolTimeline> createState() => _ProtocolTimelineState();
}

class _ProtocolTimelineState extends State<ProtocolTimeline> {
  late final PageController _ranges = PageController(
    initialPage: (widget.selectedDay - 1) ~/ 30,
  );
  @override
  void didUpdateWidget(covariant ProtocolTimeline oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.selectedDay - 1) ~/ 30 != (widget.selectedDay - 1) ~/ 30) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _ranges.hasClients) {
          _ranges.jumpToPage((widget.selectedDay - 1) ~/ 30);
        }
      });
    }
  }

  @override
  void dispose() {
    _ranges.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    final selectedDay = widget.selectedDay;
    final onSelect = widget.onSelect;
    final range = (selectedDay - 1) ~/ 6;
    final rangeStart = range * 6 + 1;
    final rangeEnd = math.min(rangeStart + 5, detail.durationDays);
    final treatment = detail.card.protocolType == ProtocolType.treatment;
    return ProtocolSurface(
      padding: EdgeInsets.zero,
      shadow: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFEEF1F7))),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEAF4FF), Colors.white, protocolTealPanel],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lịch theo từng cữ',
                  style:
                      AppTypography.display(
                        fontSize: 15,
                        height: 1.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ).copyWith(
                        fontFamily: 'Sora',
                        fontFamilyFallback: const ['PlusJakartaSans'],
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: Text(
                        'Chọn khoảng, sau đó chọn một DOC để xem chi tiết.',
                        style: TextStyle(
                          fontSize: 10,
                          height: 1.625,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ProtocolBadge(
                      '${detail.durationDays} ngày',
                      color: const Color(0xFF0C4E8F),
                      background: const Color(0xFFEAF4FF),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Step(1, 'CHỌN KHOẢNG DOC'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 44,
                  child: PageView.builder(
                    controller: _ranges,
                    itemCount: (detail.durationDays / 30).ceil(),
                    itemBuilder: (context, page) => Row(
                      children: [
                        for (var slot = 0; slot < 5; slot++) ...[
                          if (slot > 0) const SizedBox(width: 8),
                          Expanded(
                            child: (page * 5 + slot) * 6 < detail.durationDays
                                ? _RangeButton(
                                    index: page * 5 + slot,
                                    duration: detail.durationDays,
                                    selected: range == page * 5 + slot,
                                    current:
                                        widget.currentDay != null &&
                                        (widget.currentDay! - 1) ~/ 6 ==
                                            page * 5 + slot,
                                    onTap: () =>
                                        onSelect((page * 5 + slot) * 6 + 1),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _Step(2, treatment ? 'CHỌN NGÀY' : 'CHỌN DOC'),
                    ),
                    const Text(
                      'Chỉ hiển thị 1 ngày',
                      style: TextStyle(fontSize: 9, color: AppColors.inkMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var day = rangeStart; day <= rangeEnd; day++) ...[
                      if (day > rangeStart) const SizedBox(width: 6),
                      Expanded(
                        child: _DayButton(
                          day: day,
                          selected: selectedDay == day,
                          current: widget.currentDay == day,
                          treatment: treatment,
                          anchor: detail.anchorDate,
                          marker: detail.dayMarkers
                              .where((m) => m.day == day)
                              .firstOrNull,
                          onTap: () => onSelect(day),
                        ),
                      ),
                    ],
                    // Preserve six equal columns in the last, shorter range.
                    for (
                      var empty = rangeEnd - rangeStart + 1;
                      empty < 6;
                      empty++
                    ) ...[
                      const SizedBox(width: 6),
                      const Expanded(child: SizedBox()),
                    ],
                  ],
                ),
                const SizedBox(height: 10),
                const Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _Legend('Đã hoàn tất', Color(0xFF00D5BE)),
                    _Legend('Đang chờ', Color(0xFFFFB900)),
                    _Legend('Có vấn đề', Color(0xFFFF637E)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeButton extends StatelessWidget {
  const _RangeButton({
    required this.index,
    required this.duration,
    required this.selected,
    required this.current,
    required this.onTap,
  });
  final int index;
  final int duration;
  final bool selected;
  final bool current;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: selected ? AppColors.ocean : protocolPanel,
          border: Border.all(
            color: selected ? AppColors.ocean : AppColors.line,
            width: 1.25,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Text(
                '${index * 6 + 1}–${math.min(index * 6 + 6, duration)}',
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.inkSoft,
                  fontSize: 11,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (current)
              Positioned(
                right: 4,
                top: 4,
                child: Semantics(
                  label: 'Khoảng DOC hiện tại',
                  child: Container(
                    key: const Key('protocol_current_range_badge'),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: protocolTeal,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class _Step extends StatelessWidget {
  const _Step(this.number, this.label);
  final int number;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.ocean,
        ),
        child: Text(
          '$number',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      const SizedBox(width: 8),
      Flexible(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            height: 1.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
            color: AppColors.inkSoft,
          ),
        ),
      ),
    ],
  );
}

class _Legend extends StatelessWidget {
  const _Legend(this.label, this.color);
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(
          fontSize: 8,
          height: 1.5,
          color: AppColors.inkMuted,
        ),
      ),
    ],
  );
}

class _DayButton extends StatelessWidget {
  const _DayButton({
    required this.day,
    required this.selected,
    required this.current,
    required this.treatment,
    required this.anchor,
    required this.marker,
    required this.onTap,
  });
  final int day;
  final bool selected;
  final bool current;
  final bool treatment;
  final String? anchor;
  final ProtocolDayMarker? marker;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final date = anchor == null
        ? null
        : DateTime.parse('${anchor!}T00:00:00Z').add(Duration(days: day - 1));
    final dot = marker == null
        ? null
        : marker!.cancelled > 0 || marker!.issues > 0
        ? const Color(0xFFFF637E)
        : marker!.planned > 0
        ? const Color(0xFFFFB900)
        : const Color(0xFF00D5BE);
    return Semantics(
      selected: selected,
      button: true,
      label: '${treatment ? 'Ngày' : 'DOC'} $day',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: date == null ? 50 : 66.5),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.ocean
                : current
                ? protocolTealPanel
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? const Color(0xFFD3E8FF)
                  : current
                  ? const Color(0xFF3DE2D2)
                  : AppColors.line,
              width: selected ? 2 : 1.25,
            ),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x1A000000),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 3,
                  vertical: 10,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        treatment ? 'NGÀY' : 'DOC',
                        style: TextStyle(
                          fontSize: 8,
                          height: 1.5,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? const Color(0xFFD3E8FF)
                              : AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1,
                          fontWeight: FontWeight.w800,
                          color: selected
                              ? Colors.white
                              : current
                              ? protocolTeal
                              : AppColors.inkSoft,
                        ),
                      ),
                      if (date != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${date.day.toString().padLeft(2, '0')}–${date.month.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            fontSize: 8,
                            height: 1.5,
                            color: selected
                                ? const Color(0xFFD3E8FF)
                                : AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (dot != null)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dot,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProtocolDayBanner extends StatelessWidget {
  const ProtocolDayBanner({
    required this.detail,
    required this.day,
    required this.data,
    required this.onSelect,
    super.key,
  });
  final ProtocolDetail detail;
  final int day;
  final ProtocolDay? data;
  final ValueChanged<int> onSelect;
  @override
  Widget build(BuildContext context) {
    final date = data?.date;
    final rows = data?.rows ?? const <ProtocolDayRow>[];
    final meals = rows.map((r) => r.time).toSet().length;
    final completed = rows
        .where((r) => r.status == ProtocolOperationStatus.completed)
        .length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF0C4E8F), AppColors.ocean],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x290E7490),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _Arrow(
            previous: true,
            enabled: day > 1,
            onTap: () => onSelect(day - 1),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  detail.card.protocolType == ProtocolType.treatment
                      ? 'Ngày điều trị $day'
                      : 'DOC $day',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                if (date != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const AppSvgIcon(
                        AppSvgIconName.calendar,
                        size: 11,
                        color: Color(0xFFD3E8FF),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _dateLabel(date),
                        style: const TextStyle(
                          fontSize: 10,
                          height: 1.5,
                          color: Color(0xFFD3E8FF),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  data == null
                      ? 'Đang tải…'
                      : '$meals cữ · $completed/${rows.length} hạng mục hoàn tất',
                  style: const TextStyle(
                    fontSize: 9,
                    height: 1.5,
                    color: Color(0xCCFFFFFF),
                  ),
                ),
              ],
            ),
          ),
          _Arrow(
            previous: false,
            enabled: day < detail.durationDays,
            onTap: () => onSelect(day + 1),
          ),
        ],
      ),
    );
  }

  String _dateLabel(String date) {
    final d = DateTime.parse(date);
    final weekday = d.weekday == 7 ? 'CN' : 'Thứ ${d.weekday + 1}';
    return '$weekday, ${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({
    required this.previous,
    required this.enabled,
    required this.onTap,
  });
  final bool previous;
  final bool enabled;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Opacity(
    opacity: enabled ? 1 : .3,
    child: SizedBox.square(
      dimension: 36,
      child: Material(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Tooltip(
            message: previous ? 'Ngày trước' : 'Ngày tiếp theo',
            child: Center(
              child: RotatedBox(
                quarterTurns: previous ? 2 : 0,
                child: const AppSvgIcon(
                  AppSvgIconName.chevron,
                  size: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
