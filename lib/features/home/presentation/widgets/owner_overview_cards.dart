import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_svg_icon.dart';
import 'package:smartshrimp_app/features/home/domain/entities/owner_dashboard.dart';
import 'package:smartshrimp_app/features/home/presentation/widgets/dashboard_widgets.dart';

class DashboardSummaryRow extends StatelessWidget {
  const DashboardSummaryRow(this.summary, {super.key});
  final DashboardSummary summary;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _StatCard(
          summary.farms,
          'TRANG TRẠI',
          'Đang sở hữu',
          AppColors.ink,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _StatCard(
          summary.ponds,
          'AO NUÔI',
          'Đang quản lý',
          dashboardTeal,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _StatCard(
          summary.activeSeasons,
          'VỤ NUÔI',
          'Đang hoạt động',
          const Color(0xFFEB7800),
        ),
      ),
    ],
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.value, this.label, this.subtitle, this.color);
  final int value;
  final String label;
  final String subtitle;
  final Color color;
  @override
  Widget build(BuildContext context) => DashboardCard(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$value',
          style: dashboardDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: color,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.inkMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 10, color: AppColors.inkMuted),
        ),
      ],
    ),
  );
}

class DashboardAlertCard extends StatelessWidget {
  const DashboardAlertCard(this.alert, {super.key});
  final DashboardAlert alert;
  @override
  Widget build(BuildContext context) {
    final (label, icon, color, background, border) = switch (alert.kind) {
      DashboardAlertKind.urgentTask => (
        'nhiệm vụ khẩn cấp',
        AppSvgIconName.warning,
        const Color(0xFFD70040),
        const Color(0xFFFCE7EC),
        const Color(0xFFFFC7D3),
      ),
      DashboardAlertKind.pendingTreatment => (
        'phác đồ điều trị chờ phê duyệt',
        AppSvgIconName.document,
        const Color(0xFFD70040),
        const Color(0xFFFCE7EC),
        const Color(0xFFFFC7D3),
      ),
      DashboardAlertKind.pendingProduction => (
        'phác đồ nuôi chờ phê duyệt',
        AppSvgIconName.document,
        AppColors.ocean,
        const Color(0xFFE8F2FF),
        const Color(0xFFCFE5FF),
      ),
      DashboardAlertKind.lowStock => (
        'vật tư sắp hết',
        AppSvgIconName.shrimpFeed,
        const Color(0xFFE87800),
        const Color(0xFFFFF3DA),
        const Color(0xFFFFDF6A),
      ),
      DashboardAlertKind.inTreatment => (
        'ca bệnh đang điều trị',
        AppSvgIconName.shield,
        const Color(0xFFD70040),
        const Color(0xFFFCE7EC),
        const Color(0xFFFFC7D3),
      ),
      DashboardAlertKind.monitoring => (
        'ca bệnh đang theo dõi',
        AppSvgIconName.shield,
        dashboardPurple,
        const Color(0xFFF0EAFE),
        const Color(0xFFE0D5FF),
      ),
      DashboardAlertKind.unknown => (
        'cảnh báo',
        AppSvgIconName.warning,
        AppColors.inkMuted,
        dashboardPanel,
        AppColors.line,
      ),
    };
    final preview = alert.preview;
    final contextLabel = [
      preview.farmName,
      if (preview.pondName != null) preview.pondName!,
      if (preview.seasonName != null) preview.seasonName!,
    ].join(' · ');
    final detail = alert.kind == DashboardAlertKind.lowStock
        ? '${preview.title} · Còn ${dashboardQuantity(preview.quantity)}/${dashboardQuantity(preview.minAlertQuantity)} ${_unit(preview.unit)}'
        : preview.title;
    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: border, width: 1.2),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showAlert(context, alert, label),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                child: Center(child: AppSvgIcon(icon, color: color, size: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${alert.count} $label',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      contextLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    Text(
                      detail,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: color.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              AppSvgIcon(
                AppSvgIconName.chevron,
                size: 12,
                color: color.withValues(alpha: 0.65),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _unit(String? unit) => switch (unit) {
  'KG' => 'kg',
  'G' => 'g',
  'L' => 'l',
  'ML' => 'ml',
  'PACK' => 'gói',
  'BOTTLE' => 'chai',
  'PCS' => 'cái',
  _ => '',
};

void _showAlert(BuildContext context, DashboardAlert alert, String label) {
  final preview = alert.preview;
  if (alert.kind == DashboardAlertKind.pendingProduction ||
      alert.kind == DashboardAlertKind.pendingTreatment) {
    context.push('/protocols/${Uri.encodeComponent(preview.id)}');
    return;
  }
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${alert.count} $label',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 12),
            Text(preview.title),
            const SizedBox(height: 8),
            Text(
              [
                preview.farmName,
                if (preview.pondName != null) preview.pondName!,
                if (preview.seasonName != null) preview.seasonName!,
              ].join(' · '),
            ),
            if (alert.kind == DashboardAlertKind.lowStock)
              Text(
                'Còn ${dashboardQuantity(preview.quantity)} ${_unit(preview.unit)} · Ngưỡng cảnh báo ${dashboardQuantity(preview.minAlertQuantity)} ${_unit(preview.unit)}',
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pop(sheetContext);
                context.push(
                  preview.seasonId == null
                      ? '/farms/${preview.farmId}'
                      : _seasonPath(
                          preview.farmId,
                          preview.pondId!,
                          preview.seasonId!,
                        ),
                );
              },
              child: Text(
                preview.seasonId == null ? 'Xem trang trại' : 'Xem vụ nuôi',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

String _seasonPath(String farmId, String pondId, String seasonId) =>
    '/farms/$farmId/ponds/$pondId/seasons/$seasonId';

class DashboardSeasonCard extends StatelessWidget {
  const DashboardSeasonCard(this.season, {super.key});
  final DashboardSeason season;
  @override
  Widget build(BuildContext context) => DashboardCard(
    onTap: () => context.push(
      _seasonPath(season.farmId, season.pondId, season.seasonId),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        const DashboardIconTile(AppSvgIconName.shrimp),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    season.pondName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F6F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '●  DOC ${season.dayOfCulture ?? '—'}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: dashboardTeal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                '${season.farmName} · ${switch (season.shrimpType) {
                  'WHITELEG' => 'Tôm thẻ',
                  'BLACK_TIGER' => 'Tôm sú',
                  _ => 'Không xác định',
                }}',
                style: const TextStyle(fontSize: 11, color: AppColors.inkMuted),
              ),
            ],
          ),
        ),
        const AppSvgIcon(AppSvgIconName.chevron, size: 12),
      ],
    ),
  );
}

class DashboardInventoryCard extends StatelessWidget {
  const DashboardInventoryCard(this.inventory, {super.key});
  final DashboardInventory inventory;
  @override
  Widget build(BuildContext context) => DashboardCard(
    onTap: () => showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kho ${inventory.farmName}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${inventory.productCount} vật tư · ${inventory.lowStockCount} vật tư sắp hết',
              ),
              const SizedBox(height: 8),
              Text('Giá trị tồn kho: ${dashboardMoney(inventory.stockValue)}'),
            ],
          ),
        ),
      ),
    ),
    child: Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            const DashboardIconTile(
              AppSvgIconName.box,
              color: dashboardPurple,
              background: Color(0xFFF0EAFE),
            ),
            if (inventory.lowStockCount > 0)
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    '${inventory.lowStockCount}',
                    style: const TextStyle(fontSize: 9, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 3,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    inventory.farmName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  if (inventory.lowStockCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCE7EC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Sắp hết',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFD70040),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.inkMuted,
                  ),
                  children: [
                    TextSpan(
                      text: '${inventory.productCount}',
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(text: ' vật tư  •  Tồn '),
                    TextSpan(
                      text: dashboardMoney(inventory.stockValue),
                      style: const TextStyle(
                        color: AppColors.ocean,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const AppSvgIcon(AppSvgIconName.chevron, size: 12),
      ],
    ),
  );
}
