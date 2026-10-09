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
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_param_tiles.dart';
import 'package:smartshrimp_app/features/operation/presentation/view_models/operation_controller.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_schedule_card.dart';

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
                          _TodayOperations(seasonId: season.id),
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
        2 => () => context.push('/seasons/$seasonId/operations'),
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
    final log = state.asData?.value;
    final borderRadius = BorderRadius.circular(18);
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A0F1C2E),
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
          BoxShadow(
            color: Color(0x590F1C2E),
            blurRadius: 12,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: const BorderSide(color: AppColors.line, width: 1.2),
        ),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () => context.push(
            '/seasons/$seasonId/water-logs/statistics',
            extra: <String, String>{'pondName': pondName},
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Đo nước gần nhất',
                        style: AppTypography.display(
                          color: AppColors.ink,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                    ),
                    if (log != null) ...<Widget>[
                      const SizedBox(width: 8),
                      Text(
                        '${formatWaterTime(log.recordedAt)} · ${formatWaterDay(log.recordedAt)}',
                        style: const TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                state.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.ocean),
                    ),
                  ),
                  error: (_, _) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Không tải được dữ liệu đo nước.',
                      style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
                    ),
                  ),
                  data: (log) => log == null
                      ? const Padding(
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
                        )
                      : _LatestWaterGrid(log: log),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LatestWaterGrid extends StatelessWidget {
  const _LatestWaterGrid({required this.log});

  final WaterLog log;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      for (var row = 0; row < 2; row++) ...<Widget>[
        if (row > 0) const SizedBox(height: 8),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (var column = 0; column < 4; column++) ...<Widget>[
                if (column > 0) const SizedBox(width: 8),
                Expanded(
                  child: row * 4 + column < waterLogCardParams.length
                      ? _LatestWaterTile(
                          log: log,
                          param: waterLogCardParams[row * 4 + column],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      ],
    ],
  );
}

class _LatestWaterTile extends StatelessWidget {
  const _LatestWaterTile({required this.log, required this.param});

  final WaterLog log;
  final WaterLogParam param;

  @override
  Widget build(BuildContext context) {
    final exceeded = log.exceededParameters.contains(param.field);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: exceeded ? const Color(0xFFFBE6EA) : const Color(0xB3EEF1F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            param.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            formatWaterValue(log.valueOf(param.field)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.mono(
              color: exceeded ? AppColors.error : AppColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ).copyWith(height: 1.5),
          ),
          Text(
            param.unit,
            style: const TextStyle(
              color: AppColors.inkMuted,
              fontSize: 9,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayOperations extends ConsumerWidget {
  const _TodayOperations({required this.seasonId});
  final String seasonId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opState = ref.watch(operationListProvider(seasonId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(child: _Title('Cữ vận hành hôm nay')),
            TextButton(
              onPressed: () => context.push('/seasons/$seasonId/operations'),
              child: const Text('Xem tất cả'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        opState.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: AppColors.ocean),
            ),
          ),
          error: (_, _) => const SizedBox.shrink(),
          data: (result) {
            if (result.schedules.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.line),
                ),
                child: const Center(
                  child: Text(
                    'Chưa có lịch vận hành nào hôm nay',
                    style: TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }

            final topThree = result.schedules.take(3).toList(growable: false);
            return Column(
              children: <Widget>[
                for (final s in topThree) ...<Widget>[
                  OperationScheduleCard(
                    schedule: s,
                    onTap: () =>
                        context.push('/seasons/$seasonId/operations/${s.id}'),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
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
