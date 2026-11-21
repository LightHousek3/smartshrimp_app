import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/core/widgets/app_error_state.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/core/widgets/sticky_page_header.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/view_models/assigned_season_controller.dart';
import 'package:smartshrimp_app/features/assigned_season/presentation/widgets/assigned_season_progress.dart';
import 'package:smartshrimp_app/features/season/presentation/widgets/season_ui.dart';
import 'package:smartshrimp_app/features/season/domain/entities/aquaculture_season.dart'
    show shrimpTypeLabel;
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log.dart';
import 'package:smartshrimp_app/features/water_log/domain/entities/water_log_metadata.dart';
import 'package:smartshrimp_app/features/water_log/presentation/view_models/water_log_controller.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_card.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_param_tiles.dart';
import 'package:smartshrimp_app/features/water_log/presentation/widgets/water_log_refresh_boundary.dart';
import 'package:smartshrimp_app/features/operation/domain/entities/operation_models.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_meal_group_card.dart';
import 'package:smartshrimp_app/features/operation/presentation/widgets/operation_schedule_card.dart';

class AssignedSeasonDetailPage extends ConsumerWidget {
  const AssignedSeasonDetailPage({required this.seasonId, super.key});
  final String seasonId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(assignedSeasonDetailProvider(seasonId));
    Future<void> refresh() async {
      invalidateWaterLogViews(ref, seasonId);
      ref.invalidate(assignedSeasonTodayOperationsProvider(seasonId));
      await ref.read(assignedSeasonDetailProvider(seasonId).notifier).refresh();
    }

    return WaterLogRefreshBoundary(
      onRefresh: refresh,
      child: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: state.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.ocean),
            ),
            error: (error, _) => AppErrorState(
              error: error,
              onRetry: () => ref
                  .read(assignedSeasonDetailProvider(seasonId).notifier)
                  .refresh(),
            ),
            data: (season) => RefreshIndicator(
              onRefresh: refresh,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: <Widget>[
                  StickyPageHeader(
                    title: season.pondName,
                    subtitle:
                        '${season.name}${season.dayOfCulture == null ? '' : ' · DOC ${season.dayOfCulture}'}',
                    onBack: context.pop,
                    trailing: SeasonStatusBadge(status: season.status),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _Breadcrumb(season),
                          const SizedBox(height: 16),
                          _PondCard(season),
                          const SizedBox(height: 18),
                          _Card(child: AssignedSeasonProgress(season: season)),
                          if (season.status == AssignedSeasonStatus.active ||
                              season.status ==
                                  AssignedSeasonStatus.completed) ...<Widget>[
                            const SizedBox(height: 18),
                            _FeatureActions(
                              seasonId: season.id,
                              farmName: season.farmName,
                              seasonName: season.name,
                              pondName: season.pondName,
                              readOnly:
                                  season.status ==
                                  AssignedSeasonStatus.completed,
                            ),
                          ],
                          if (season.status != AssignedSeasonStatus.active &&
                              season.status != AssignedSeasonStatus.planning &&
                              season.status != AssignedSeasonStatus.completed)
                            TextButton.icon(
                              onPressed: () => context.push(
                                '/seasons/${season.id}/disease-cases',
                              ),
                              icon: const Icon(
                                Icons.medical_information_outlined,
                              ),
                              label: const Text('Xem ca bệnh'),
                            ),
                          if (season.status != AssignedSeasonStatus.active &&
                              season.status != AssignedSeasonStatus.planning &&
                              season.status != AssignedSeasonStatus.completed)
                            TextButton(
                              onPressed: () async {
                                await context.push(
                                  '/seasons/${season.id}/water-logs',
                                  extra: <String, String>{
                                    'pondName': season.pondName,
                                    'farmName': season.farmName,
                                    'seasonName': season.name,
                                  },
                                );
                                if (context.mounted) {
                                  invalidateWaterLogViews(ref, season.id);
                                }
                              },
                              child: const Text('Nhật ký đo nước'),
                            ),
                          if (season.status != AssignedSeasonStatus.active &&
                              season.status != AssignedSeasonStatus.planning &&
                              season.status != AssignedSeasonStatus.completed)
                            TextButton(
                              onPressed: () => context.push(
                                '/seasons/${season.id}/ai-diagnoses',
                              ),
                              child: const Text('Lịch sử nhận diện AI'),
                            ),
                          if (season.status != AssignedSeasonStatus.planning &&
                              season.status !=
                                  AssignedSeasonStatus.completed) ...<Widget>[
                            const SizedBox(height: 22),
                            _LatestWaterMeasurement(
                              seasonId: season.id,
                              pondName: season.pondName,
                              seasonName: season.name,
                            ),
                          ],
                          if (season.status ==
                              AssignedSeasonStatus.active) ...<Widget>[
                            const SizedBox(height: 22),
                            _TodayOperations(seasonId: season.id),
                          ],
                          const SizedBox(height: 18),
                          const _Title('Nhân sự vụ nuôi'),
                          const SizedBox(height: 10),
                          _PersonnelCard(season),
                          if (season
                              .otherAssignedSeasons
                              .isNotEmpty) ...<Widget>[
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

/// Both health entry points must refresh the summary after create/void actions.
Future<void> _openShrimpHealth(
  BuildContext context,
  WidgetRef ref, {
  required String seasonId,
  required Map<String, dynamic> extra,
}) async {
  await context.push('/seasons/$seasonId/shrimp-health', extra: extra);
  if (!context.mounted) return;
  // The list stays mounted behind detail and otherwise keeps its old assessment.
  ref.invalidate(assignedSeasonListProvider);
  ref.invalidate(assignedSeasonDetailProvider(seasonId));
  // Voiding biomass measurements can also cancel derived operation schedules.
  ref.invalidate(assignedSeasonTodayOperationsProvider(seasonId));
}

class _PondCard extends ConsumerWidget {
  const _PondCard(this.season);
  final AssignedSeasonDetail season;
  @override
  Widget build(BuildContext context, WidgetRef ref) => _Card(
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
              child: const AppSvgIcon(
                AppSvgIconName.shrimp,
                size: 32,
                color: Colors.white,
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
                    '${shrimpTypeLabel(season.shrimpType, unknownLabel: 'Không rõ')} · ${_num(season.areaM2)} m² · ${_num(season.volumeM3)} m³',
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
                'SỐ LƯỢNG THẢ',
                season.initialQuantity == null
                    ? '—'
                    : '${season.initialQuantity} con',
              ),
              const SizedBox(width: 10),
              _Metric(
                'SỨC KHỎE ĐÀN',
                'Xem chi tiết',
                subtitle: 'Nhật ký & thể trạng',
                onTap: () => _openShrimpHealth(
                  context,
                  ref,
                  seasonId: season.id,
                  extra: <String, dynamic>{
                    'farmName': season.farmName,
                    'seasonName': season.name,
                    'pondName': season.pondName,
                    'isSeasonActive':
                        season.status == AssignedSeasonStatus.active,
                  },
                ),
              ),
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

class _FeatureActions extends ConsumerWidget {
  const _FeatureActions({
    required this.seasonId,
    required this.farmName,
    required this.seasonName,
    required this.pondName,
    this.readOnly = false,
  });

  final String seasonId;
  final String farmName;
  final String seasonName;
  final String pondName;
  final bool readOnly;

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
      icon: Icons.event_note_rounded,
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
      label: 'Trợ lý Aquabot',
      icon: Icons.chat_bubble_outline_rounded,
      background: Color(0xFFEAF4FF),
      foreground: Color(0xFF1378D1),
    ),
    // Keep the entry visible without inventing a disease-case count.
    _FeatureActionData(
      label: 'Ca bệnh',
      icon: Icons.emergency_outlined,
      background: Color(0xFFFBE6EA),
      foreground: AppColors.error,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
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
          0 => () async {
            await context.push(
              '/seasons/$seasonId/water-logs',
              extra: <String, String>{
                'farmName': farmName,
                'seasonName': seasonName,
                'pondName': pondName,
              },
            );
            if (context.mounted) invalidateWaterLogViews(ref, seasonId);
          },
          1 => () => _openShrimpHealth(
            context,
            ref,
            seasonId: seasonId,
            extra: <String, dynamic>{
              'farmName': farmName,
              'seasonName': seasonName,
              'pondName': pondName,
              'isSeasonActive': !readOnly,
            },
          ),
          2 => () async {
            await context.push('/seasons/$seasonId/operations');
            if (context.mounted) {
              ref.invalidate(assignedSeasonTodayOperationsProvider(seasonId));
            }
          },
          3 => () => context.push('/seasons/$seasonId/ai-diagnoses'),
          4 => () => context.push('/seasons/$seasonId/rag'),
          5 => () => context.push('/seasons/$seasonId/disease-cases'),
          _ => null,
        },
      ),
    );
  }
}

class _FeatureActionData {
  const _FeatureActionData({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
}

class _FeatureAction extends StatelessWidget {
  const _FeatureAction(this.data, {this.onTap});
  final _FeatureActionData data;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Container(
    decoration: _seasonCardDecoration,
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap:
            onTap ??
            () => AppNoticeService.info(
              context,
              '${data.label} đang được phát triển.',
            ),
        borderRadius: BorderRadius.circular(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
    ),
  );
}

class _LatestWaterMeasurement extends ConsumerWidget {
  const _LatestWaterMeasurement({
    required this.seasonId,
    required this.pondName,
    required this.seasonName,
  });

  final String seasonId;
  final String pondName;
  final String seasonName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(latestWaterLogProvider(seasonId));
    final log = state.asData?.value;
    final metadata = log == null
        ? null
        : ref.watch(waterLogMetadataProvider(seasonId));
    final borderRadius = BorderRadius.circular(18);
    return Container(
      decoration: _seasonCardDecoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: () async {
            await context.push(
              '/seasons/$seasonId/water-logs/statistics',
              extra: <String, String>{
                'pondName': pondName,
                'seasonName': seasonName,
              },
            );
            if (context.mounted) invalidateWaterLogViews(ref, seasonId);
          },
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
                      : _LatestWaterGrid(
                          log: log,
                          metadata: metadata?.asData?.value,
                        ),
                ),
                if (log != null && metadata?.hasError == true)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          metadata?.error is AppException
                              ? (metadata!.error! as AppException).message
                              : 'Không tải được ngưỡng Min/Max.',
                          style: const TextStyle(
                            color: AppColors.inkMuted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            ref.invalidate(waterLogMetadataProvider(seasonId)),
                        child: const Text('Thử lại ngưỡng'),
                      ),
                    ],
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
  const _LatestWaterGrid({required this.log, this.metadata});

  final WaterLog log;
  final WaterLogMetadata? metadata;

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
                  child: row * 4 + column < waterLogFormParams.length
                      ? _LatestWaterTile(
                          log: log,
                          param: waterLogFormParams[row * 4 + column],
                          metric: metadata?.metrics
                              .where(
                                (metric) =>
                                    metric.field ==
                                    waterLogFormParams[row * 4 + column].field,
                              )
                              .firstOrNull,
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
  const _LatestWaterTile({required this.log, required this.param, this.metric});

  final WaterLog log;
  final WaterLogParam param;
  final WaterMetricMetadata? metric;

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
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatWaterValue(log.valueOf(param.field)),
              style: AppTypography.mono(
                color: exceeded ? AppColors.error : AppColors.ink,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ).copyWith(height: 1.5),
            ),
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
          const SizedBox(height: 4),
          for (final bound in [
            (label: 'Min', value: metric?.warningMin),
            (label: 'Max', value: metric?.warningMax),
          ])
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${bound.label}: ${metric == null ? '…' : formatWaterValue(bound.value)}',
                key: Key(
                  'latest_water_threshold_${param.field}_${bound.label.toLowerCase()}',
                ),
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 9,
                  height: 1.5,
                ),
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
    final provider = assignedSeasonTodayOperationsProvider(seasonId);
    final opState = ref.watch(provider);

    // Returning from execution must refresh the preview's independent state.
    Future<void> openOperations(String path, {Object? extra}) async {
      await context.push(path, extra: extra);
      if (context.mounted) ref.invalidate(provider);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const Expanded(child: _Title('Cữ vận hành hôm nay')),
            TextButton(
              onPressed: () => openOperations('/seasons/$seasonId/operations'),
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
          error: (error, _) => AppErrorState(
            error: error,
            message: 'Không thể tải cữ vận hành hôm nay.',
            onRetry: () => ref.invalidate(provider),
          ),
          data: (schedules) {
            if (schedules.isEmpty) {
              return _Card(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
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

            final mealGroups = FeedingMedicineMealGroup.group(schedules);
            final otherSchedules = schedules
                .where(
                  (s) =>
                      !s.isTreatment &&
                      s.operationType != OperationType.feeding &&
                      s.operationType != OperationType.medicine,
                )
                .toList(growable: false);
            final nearestMealGroupKey = FeedingMedicineMealGroup.pickNearestKey(
              mealGroups,
            );

            return Column(
              children: <Widget>[
                for (final group in mealGroups) ...<Widget>[
                  OperationMealGroupCard(
                    key: ValueKey<String>('today_${group.key}'),
                    group: group,
                    initiallyExpanded: group.key == nearestMealGroupKey,
                    onTapDetail: (s) => openOperations(
                      '/seasons/$seasonId/operations/${s.id}',
                      extra: group,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                for (final s in otherSchedules) ...<Widget>[
                  OperationScheduleCard(
                    schedule: s,
                    decoration: _seasonCardDecoration,
                    onTap: () =>
                        openOperations('/seasons/$seasonId/operations/${s.id}'),
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
              assignedSeasonPersonnelRoleLabel(season.personnel[i].role),
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
    final status = seasonStatusFromJson(season.status);
    final label = seasonStatusLabel(status);
    final color = seasonStatusColors(status).foreground;
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
              child: const AppSvgIcon(
                AppSvgIconName.pond,
                size: 24,
                color: AppColors.ocean,
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

final _seasonCardDecoration = BoxDecoration(
  color: const Color(0xF7FFFFFF),
  borderRadius: BorderRadius.circular(18),
  border: Border.all(color: AppColors.line),
  boxShadow: const <BoxShadow>[
    BoxShadow(color: Color(0x300F1C2E), blurRadius: 16, offset: Offset(0, 8)),
  ],
);

class _Card extends StatelessWidget {
  const _Card({required this.child, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: padding,
    decoration: _seasonCardDecoration,
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
  const _Metric(this.label, this.value, {this.subtitle, this.onTap});
  final String label, value;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: onTap != null ? const Color(0xFFFAFBFC) : Colors.transparent,
        border: Border.all(
          color: onTap != null ? const Color(0xFFC4E0FF) : AppColors.line,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
              ),
              if (onTap != null)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10,
                  color: AppColors.ocean,
                ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: onTap != null ? AppColors.ocean : AppColors.ink,
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
    );

    return Expanded(
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: body,
              ),
            )
          : body,
    );
  }
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
