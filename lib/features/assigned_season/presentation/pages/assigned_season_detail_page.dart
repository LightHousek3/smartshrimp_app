import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';

class AssignedSeasonDetailPage extends ConsumerWidget {
  const AssignedSeasonDetailPage({required this.seasonId, super.key});
  final String seasonId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assignedSeasonDetailProvider(seasonId));
    return AppGradientBackground(
      child: SafeArea(
        bottom: false,
        child: state.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.ocean),
          ),
          error: (error, _) => _Failure(
            error: error,
            onRetry: () => ref
                .read(assignedSeasonDetailProvider(seasonId).notifier)
                .refresh(),
          ),
          data: (season) => RefreshIndicator(
            onRefresh: ref
                .read(assignedSeasonDetailProvider(seasonId).notifier)
                .refresh,
            child: ListView(
              children: <Widget>[
                _Header(season),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _Breadcrumb(season),
                      const SizedBox(height: 16),
                      if (season.status ==
                          AssignedSeasonStatus.planning) ...<Widget>[
                        const _PlanningNotice(),
                        const SizedBox(height: 18),
                      ],
                      _PondCard(season),
                      const SizedBox(height: 18),
                      const _Title('Nhân sự vụ nuôi'),
                      const SizedBox(height: 10),
                      _PersonnelCard(season),
                      const SizedBox(height: 18),
                      const _Title('Dữ liệu thả ban đầu'),
                      const SizedBox(height: 10),
                      _InfoCard(<(String, String)>[
                        ('Ngày thả', _date(season.stockingDate)),
                        ('Số lượng', '${season.initialQuantity ?? '—'} con'),
                        (
                          'Mật độ',
                          '${_num(season.initialDensityPerM2)} con/m²',
                        ),
                      ]),
                      if (season.otherAssignedSeasons.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: _Title('Các ao khác trong trại'),
                        ),
                        const SizedBox(height: 10),
                        for (
                          var i = 0;
                          i < season.otherAssignedSeasons.length;
                          i++
                        ) ...<Widget>[
                          _OtherAssignedSeasonCard(
                            season.otherAssignedSeasons[i],
                          ),
                          if (i < season.otherAssignedSeasons.length - 1)
                            const SizedBox(height: 10),
                        ],
                      ],
                      const SizedBox(height: 18),
                      const _Title('Thông tin trang trại'),
                      const SizedBox(height: 10),
                      _InfoCard(<(String, String)>[
                        ('Trang trại', season.farmName),
                        ('Địa chỉ', season.farmAddress ?? 'Chưa cập nhật'),
                        (
                          'Ngày dự kiến kết thúc',
                          _date(season.expectedEndDate),
                        ),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.season);
  final AssignedSeasonDetail season;
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xE6FFF7F4),
    padding: const EdgeInsets.fromLTRB(10, 14, 16, 14),
    child: Row(
      children: <Widget>[
        IconButton(onPressed: context.pop, icon: const Icon(Icons.arrow_back)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                season.pondName,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                '${season.name}${season.dayOfCulture == null ? '' : ' · DOC ${season.dayOfCulture}'}',
                style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        _Badge(season.status),
      ],
    ),
  );
}

class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb(this.season);
  final AssignedSeasonDetail season;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xB3E6F4FF),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Text(
      '⌖  ${season.farmName}  ›  ${season.name}  ›  ${season.pondName}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: AppColors.ocean,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _PlanningNotice extends StatelessWidget {
  const _PlanningNotice();
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color(0xFFEFE7FF),
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Text(
      'Vụ đang chuẩn bị và chưa phát sinh dữ liệu vận hành. Các chức năng đo nước, sức khỏe, vận hành và AI sẽ mở khi Chủ trại kích hoạt vụ.',
      style: TextStyle(color: Color(0xFF7008E7), fontSize: 12, height: 1.55),
    ),
  );
}

class _PondCard extends StatelessWidget {
  const _PondCard(this.season);
  final AssignedSeasonDetail season;
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF126BC0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                _initials(season.pondName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    season.pondName,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '${season.shrimpType == 'WHITELEG' ? 'Tôm thẻ chân trắng' : 'Tôm sú'} · ${_num(season.areaM2)} m² · ${_num(season.volumeM3)} m³',
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 28),
        Row(
          children: <Widget>[
            _PondFact('LOẠI AO', _pondTypeLabel(season.pondType)),
            const SizedBox(width: 8),
            _PondFact('TRẠNG THÁI', _pondStatusLabel(season.pondStatus)),
            const SizedBox(width: 8),
            _PondFact('ĐỘ SÂU', '${_num(season.depthM)} m'),
          ],
        ),
        if (season.status == AssignedSeasonStatus.active) ...<Widget>[
          const Divider(height: 32),
          Row(
            children: <Widget>[
              _Metric(
                'NGÀY TUỔI (DOC)',
                '${season.dayOfCulture ?? '—'}',
                subtitle: 'Thả vào: ${_date(season.stockingDate)}',
              ),
              const SizedBox(width: 10),
              const _Metric('SỨC KHỎE ĐÀN', 'Chưa có dữ liệu'),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              _Metric('SỐ LƯỢNG THẢ', '${season.initialQuantity ?? '—'} con'),
              const SizedBox(width: 10),
              _Metric(
                'MẬT ĐỘ THẢ',
                '${_num(season.initialDensityPerM2)} con/m²',
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

class _PersonnelCard extends StatelessWidget {
  const _PersonnelCard(this.season);
  final AssignedSeasonDetail season;
  @override
  Widget build(BuildContext context) => _Card(
    padding: EdgeInsets.zero,
    child: Column(
      children: <Widget>[
        for (var i = 0; i < season.personnel.length; i++) ...<Widget>[
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFF0F4FA),
              child: Icon(
                Icons.person_outline,
                color: AppColors.inkMuted,
                size: 18,
              ),
            ),
            title: Text(
              season.personnel[i].name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              season.personnel[i].role == 'TECHNICIAN'
                  ? 'Kỹ thuật viên phụ trách'
                  : 'Chuyên gia thủy sản',
              style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
            ),
          ),
          const Divider(height: 1),
        ],
        ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFF0F4FA),
            child: Icon(
              Icons.home_work_outlined,
              color: AppColors.inkMuted,
              size: 18,
            ),
          ),
          title: Text(
            season.farmName,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
          ),
          subtitle: const Text(
            'Chủ trang trại',
            style: TextStyle(fontSize: 11, color: AppColors.inkMuted),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.inkMuted,
                size: 18,
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Bạn được phân công',
                  style: TextStyle(color: AppColors.inkMuted, fontSize: 11.5),
                ),
              ),
              Text(
                _dateTime(season.assignedAt),
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard(this.rows);
  final List<(String, String)> rows;
  @override
  Widget build(BuildContext context) => _Card(
    child: Column(
      children: <Widget>[
        for (var i = 0; i < rows.length; i++) ...<Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  rows[i].$1,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 12,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  rows[i].$2,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (i < rows.length - 1) const Divider(height: 22),
        ],
      ],
    ),
  );
}

class _OtherAssignedSeasonCard extends StatelessWidget {
  const _OtherAssignedSeasonCard(this.season);
  final OtherAssignedSeason season;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (season.status) {
      'PLANNING' => ('Đang chuẩn bị', const Color(0xFF7B5BD6)),
      'ACTIVE' => ('Đang nuôi', const Color(0xFF0F9B8E)),
      'COMPLETED' => ('Hoàn tất', const Color(0xFF52647F)),
      'CANCELLED' => ('Đã hủy', AppColors.error),
      _ => ('Không xác định', AppColors.inkMuted),
    };
    return InkWell(
      onTap: () => context.push('/seasons/${season.id}'),
      borderRadius: BorderRadius.circular(18),
      child: _Card(
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F3FF),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.water_outlined, color: AppColors.ocean),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    season.pondName,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${season.name} · ${_num(season.pondAreaM2)} m² · ${_num(season.pondVolumeM3)} m³',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '● $label',
              style: TextStyle(
                color: color,
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: BoxDecoration(
      color: const Color(0xF7FFFFFF),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.line),
      boxShadow: const <BoxShadow>[
        BoxShadow(
          color: Color(0x300F1C2E),
          blurRadius: 16,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: child,
  );
}

class _PondFact extends StatelessWidget {
  const _PondFact(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xB3EEF1F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 9),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value, {this.subtitle});
  final String label, value;
  final String? subtitle;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 3),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.inkMuted, fontSize: 10.5),
            ),
          ],
        ],
      ),
    ),
  );
}

class _Title extends StatelessWidget {
  const _Title(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: AppColors.ink,
      fontSize: 16,
      fontWeight: FontWeight.w800,
    ),
  );
}

class _Badge extends StatelessWidget {
  const _Badge(this.status);
  final AssignedSeasonStatus status;
  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      AssignedSeasonStatus.planning => (
        '● Đang chuẩn bị',
        const Color(0xFF7B5BD6),
      ),
      AssignedSeasonStatus.active => ('● Đang nuôi', const Color(0xFF0F9B8E)),
      AssignedSeasonStatus.completed => ('● Hoàn tất', const Color(0xFF52647F)),
      AssignedSeasonStatus.cancelled => ('● Đã hủy', AppColors.error),
    };
    return Text(
      label,
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700),
    );
  }
}

class _Failure extends StatelessWidget {
  const _Failure({required this.error, required this.onRetry});
  final Object error;
  final Future<void> Function() onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.error_outline, size: 48),
          const SizedBox(height: 12),
          Text(
            error is AppException
                ? (error as AppException).message
                : 'Không thể tải chi tiết vụ nuôi.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    ),
  );
}

String _initials(String value) {
  final parts = value.trim().split(RegExp(r'\s+'));
  return parts.length > 1
      ? '${parts.first[0]}${parts.last}'
      : value.substring(0, value.length.clamp(0, 2));
}

String _num(num? value) => value == null
    ? '—'
    : value % 1 == 0
    ? value.toInt().toString()
    : value.toStringAsFixed(1);
String _date(DateTime? value) => value == null
    ? 'Chưa cập nhật'
    : '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
String _dateTime(DateTime value) {
  final local = value.toLocal();
  return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')} ${_date(local)}';
}

String _pondTypeLabel(String value) => switch (value) {
  'AQUACULTURE' => 'Ao nuôi',
  'WATER_TREATMENT' => 'Ao xử lý',
  _ => 'Không rõ',
};

String _pondStatusLabel(String value) => switch (value) {
  'AVAILABLE' => 'Sẵn sàng',
  'MAINTENANCE' => 'Bảo trì',
  'INACTIVE' => 'Ngừng dùng',
  _ => 'Không rõ',
};
