import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season.dart';
import 'package:smartshrimp_app/features/assigned_season/domain/entities/assigned_season_detail.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_param_tiles.dart';

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
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                StickyPageHeader(
                  title: season.pondName,
                  subtitle:
                      '${season.name}${season.dayOfCulture == null ? '' : ' · DOC ${season.dayOfCulture}'}',
                  onBack: context.pop,
                  trailing: _Badge(season.status),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                  sliver: SliverToBoxAdapter(
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
                        if (season.status ==
                            AssignedSeasonStatus.active) ...<Widget>[
                          const SizedBox(height: 18),
                          _FeatureActions(
                            seasonId: season.id,
                            farmName: season.farmName,
                            seasonName: season.name,
                            pondName: season.pondName,
                          ),
                          const SizedBox(height: 22),
                          _LatestWaterMeasurement(
                            seasonId: season.id,
                            pondName: season.pondName,
                          ),
                          const SizedBox(height: 22),
                          const _TodayOperations(),
                        ],
                        const SizedBox(height: 18),
                        const _Title('Nhân sự vụ nuôi'),
                        const SizedBox(height: 10),
                        _PersonnelCard(season),
                        if (season.otherAssignedSeasons.isNotEmpty) ...<Widget>[
                          const SizedBox(height: 18),
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
      'Vụ đang chuẩn bị và chưa phát sinh dữ liệu vận hành. Các chức năng đo nước, sức khỏe, vận hành và AI nhận diện sẽ mở khi Chủ trại kích hoạt vụ.',
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
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xB3EEF1F6),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.home_work_outlined,
                color: AppColors.inkMuted,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Trang trại',
                      style: TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      season.farmName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (season.farmAddress?.trim().isNotEmpty ==
                        true) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        season.farmAddress!.trim(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
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
              _Metric(
                'SỐ LƯỢNG THẢ',
                season.initialQuantity == null
                    ? '—'
                    : '${season.initialQuantity} con',
              ),
              const SizedBox(width: 10),
              _Metric('KẾT THÚC DỰ KIẾN', _date(season.expectedEndDate)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              _Metric(
                'MẬT ĐỘ THẢ',
                '${_num(season.initialDensityPerM2)} con/m²',
              ),
              const SizedBox(width: 10),
              _Metric(
                'SINH KHỐI HIỆN TẠI',
                '${_num(season.currentBiomassKg)} kg',
              ),
            ],
          ),
        ],
      ],
    ),
  );
}

class _FeatureActions extends StatelessWidget {
  const _FeatureActions({
    required this.seasonId,
    required this.farmName,
    required this.seasonName,
    required this.pondName,
  });

  final String seasonId;
  final String farmName;
  final String seasonName;
  final String pondName;

  static const _items = <_FeatureActionData>[
    _FeatureActionData(
      label: 'Đo nước',
      icon: Icons.water_drop_outlined,
      background: Color(0xFFEAF4FF),
      foreground: Color(0xFF1378D1),
    ),
    _FeatureActionData(
      label: 'Sức khỏe',
      icon: Icons.favorite_border_rounded,
      background: Color(0xFFFBE6EA),
      foreground: AppColors.error,
    ),
    _FeatureActionData(
      label: 'Vận hành',
      icon: Icons.settings_outlined,
      background: Color(0xFFE2F6F3),
      foreground: Color(0xFF0F9B8E),
    ),
    _FeatureActionData(
      label: 'AI nhận diện',
      icon: Icons.center_focus_strong_outlined,
      background: Color(0xFFF0E9FF),
      foreground: Color(0xFF7B5BD6),
    ),
    _FeatureActionData(
      label: 'Trợ lý AI',
      icon: Icons.chat_bubble_outline_rounded,
      background: Color(0xFFEAF4FF),
      foreground: Color(0xFF1378D1),
    ),
    _FeatureActionData(
      label: 'Ca bệnh',
      icon: Icons.emergency_outlined,
      background: Color(0xFFFBE6EA),
      foreground: AppColors.error,
      badge: '1',
    ),
  ];

  @override
  Widget build(BuildContext context) => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: _items.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.14,
    ),
    itemBuilder: (context, index) => _FeatureAction(
      _items[index],
      onTap: switch (index) {
        0 => () => context.push(
          '/seasons/$seasonId/water-logs',
          extra: <String, String>{
            'farmName': farmName,
            'seasonName': seasonName,
            'pondName': pondName,
          },
        ),
        4 => () => context.push('/seasons/$seasonId/rag'),
        _ => null,
      },
    ),
  );
}

class _FeatureActionData {
  const _FeatureActionData({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
    this.badge,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final String? badge;
}

class _FeatureAction extends StatelessWidget {
  const _FeatureAction(this.data, {this.onTap});
  final _FeatureActionData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xF7FFFFFF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.line),
    ),
    child: InkWell(
      onTap:
          onTap ??
          () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${data.label} đang được phát triển.')),
          ),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: data.background,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(data.icon, color: data.foreground, size: 21),
              ),
              if (data.badge != null)
                Positioned(
                  right: -5,
                  top: -5,
                  child: Container(
                    constraints: const BoxConstraints(minWidth: 18),
                    height: 18,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      data.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 9),
          Text(
            data.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.inkSoft,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ),
  );
}

class _LatestWaterMeasurement extends ConsumerWidget {
  const _LatestWaterMeasurement({
    required this.seasonId,
    required this.pondName,
  });

  final String seasonId;
  final String pondName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(latestWaterLogProvider(seasonId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(child: _Title('Đo nước gần nhất')),
            TextButton(
              onPressed: () => context.push(
                '/seasons/$seasonId/water-logs/statistics',
                extra: <String, String>{'pondName': pondName},
              ),
              child: const Text('Xem thống kê'),
            ),
          ],
        ),
        const SizedBox(height: 10),
        state.when(
          loading: () => const _Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.ocean),
              ),
            ),
          ),
          error: (_, _) => const _Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Text(
                'Không tải được dữ liệu đo nước.',
                style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
              ),
            ),
          ),
          data: (log) {
            if (log == null) {
              return const _Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'Chưa có nhật ký đo nước.',
                      style: TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }
            return _Card(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 14,
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            '${formatWaterTime(log.recordedAt)} · ${formatWaterDay(log.recordedAt)}',
                            style: const TextStyle(
                              color: AppColors.inkMuted,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        WaterLogStatusBadge(log: log),
                      ],
                    ),
                  ),
                  const Divider(height: 24),
                  WaterParamTiles(log: log),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _TodayOperations extends StatelessWidget {
  const _TodayOperations();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          const Expanded(child: _Title('Cữ vận hành hôm nay')),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Vận hành đang được phát triển.')),
            ),
            child: const Text('Xem tất cả'),
          ),
        ],
      ),
      const SizedBox(height: 4),
      const _OperationCard(
        icon: Icons.settings_outlined,
        iconBackground: Color(0xFFE2F6F3),
        iconForeground: Color(0xFF0F9B8E),
        category: 'Cho ăn',
        slot: 'Cữ 2',
        title: 'Thức ăn CP 9004 (40% đạm)',
        time: '10:30',
        amount: '47.2 kg',
        note: 'Kèm Vitamin C tạt',
      ),
      SizedBox(height: 10),
      _OperationCard(
        icon: Icons.science_outlined,
        iconBackground: Color(0xFFF0E9FF),
        iconForeground: Color(0xFF7B5BD6),
        category: 'Hóa chất',
        title: 'Yucca khử khí độc',
        time: '11:00',
        amount: '4.48 l',
      ),
    ],
  );
}

class _OperationCard extends StatelessWidget {
  const _OperationCard({
    required this.icon,
    required this.iconBackground,
    required this.iconForeground,
    required this.category,
    required this.title,
    required this.time,
    required this.amount,
    this.slot,
    this.note,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconForeground;
  final String category;
  final String? slot;
  final String title;
  final String time;
  final String amount;
  final String? note;

  @override
  Widget build(BuildContext context) => _Card(
    padding: const EdgeInsets.all(14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(icon, color: iconForeground, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _OperationBadge(
                    label: category,
                    background: iconBackground,
                    foreground: iconForeground,
                  ),
                  if (slot != null) ...<Widget>[
                    const SizedBox(width: 6),
                    Text(
                      slot!,
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const Spacer(),
                  const _OperationBadge(
                    label: '● Đã lên lịch',
                    background: Color(0xFFEAF4FF),
                    foreground: Color(0xFF1378D1),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.schedule_rounded,
                    color: AppColors.inkMuted,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$time · $amount',
                    style: const TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (note != null) ...<Widget>[
                const SizedBox(height: 8),
                _OperationBadge(
                  label: '▣ $note',
                  background: const Color(0xFFFBE6EA),
                  foreground: AppColors.error,
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

class _OperationBadge extends StatelessWidget {
  const _OperationBadge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(7),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: foreground,
        fontSize: 9.5,
        fontWeight: FontWeight.w700,
      ),
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
