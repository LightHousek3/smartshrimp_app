import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/harvest/domain/entities/harvest_event.dart';
import 'package:smartshrimp_app/features/harvest/presentation/view_models/harvest_controller.dart';
import 'package:smartshrimp_app/features/harvest/presentation/widgets/harvest_ui.dart';

String _formatShortDateTime(DateTime date) {
  final local = date.toLocal();
  final h = local.hour.toString().padLeft(2, '0');
  final m = local.minute.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  final mo = local.month.toString().padLeft(2, '0');
  return '$h:$m $d-$mo';
}

class HarvestDetailPage extends ConsumerWidget {
  const HarvestDetailPage({
    required this.seasonId,
    required this.harvestId,
    super.key,
  });
  final String seasonId;
  final String harvestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = harvestDetailProvider((
      seasonId: seasonId,
      harvestId: harvestId,
    ));
    return ref
        .watch(provider)
        .when(
          loading: () => const HarvestScaffold(
            title: 'Chi tiết thu hoạch',
            children: [Center(child: CircularProgressIndicator())],
          ),
          error: (error, _) => HarvestScaffold(
            title: 'Chi tiết thu hoạch',
            children: [
              HarvestErrorView(
                error: error,
                retry: () => ref.invalidate(provider),
              ),
            ],
          ),
          data: (event) => HarvestScaffold(
            title: 'Chi tiết thu hoạch',
            subtitle:
                '${event.season.pond.name} · ${event.season.pond.farm?.name ?? ''}',
            children: [
              _HeroCard(event: event),
              const SizedBox(height: 16),
              _ProductionAndPriceCard(event: event),
              const SizedBox(height: 16),
              _InfoSectionCard(
                title: 'Thông tin vụ nuôi',
                items: [
                  ('Vụ nuôi', event.season.name),
                  ('Ao nuôi', event.season.pond.name),
                  ('Trang trại', event.season.pond.farm?.name ?? '—'),
                  ('Thời điểm thu', _formatShortDateTime(event.harvestedAt)),
                ],
              ),
              const SizedBox(height: 16),
              _InfoSectionCard(
                title: 'Người mua',
                items: [
                  ('Tên người mua', event.buyerName ?? 'Không ghi nhận'),
                  ('Liên hệ', event.buyerContact ?? 'Không ghi nhận'),
                ],
              ),
              const SizedBox(height: 16),
              _InfoSectionCard(
                title: 'Ghi nhận',
                items: [
                  ('Người ghi nhận', event.recorderName ?? 'Không ghi nhận'),
                  ('Tạo lúc', _formatShortDateTime(event.createdAt)),
                  if (event.varianceReason != null)
                    ('Lý do hiệu chỉnh', event.varianceReason!),
                ],
              ),
              if (event.note != null && event.note!.trim().isNotEmpty) ...[
                const SizedBox(height: 16),
                _NoteCard(note: event.note!.trim()),
              ],
            ],
          ),
        );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.topColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? topColor;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFF0F4F8)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x120F1C2E),
          blurRadius: 16,
          offset: Offset(0, 6),
        ),
        BoxShadow(
          color: Color(0x060F1C2E),
          blurRadius: 4,
          offset: Offset(0, 1),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topColor != null) Container(height: 4, color: topColor),
        Padding(padding: padding, child: child),
      ],
    ),
  );
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.event});
  final HarvestEvent event;

  @override
  Widget build(BuildContext context) {
    final isFinal = event.harvestType == HarvestType.finalHarvest;
    final dotColor = isFinal
        ? const Color(0xFF0F9B8E)
        : const Color(0xFF0C4E8F);
    final badgeBg = isFinal ? const Color(0xFFE2F6F3) : const Color(0xFFEAF4FF);
    final badgeFg = isFinal ? const Color(0xFF0F9B8E) : const Color(0xFF0C4E8F);

    return _DetailCard(
      topColor: const Color(0xFF1D7AD6),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      harvestTypeLabel(event.harvestType),
                      style: TextStyle(
                        color: badgeFg,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                _formatShortDateTime(event.harvestedAt),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.inkMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sản lượng',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.inkMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${harvestNumber(event.totalWeightKg)} kg',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Doanh thu',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.inkMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.totalRevenue == null
                          ? '—'
                          : '${harvestNumber(event.totalRevenue)} đ',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F9B8E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductionAndPriceCard extends StatelessWidget {
  const _ProductionAndPriceCard({required this.event});
  final HarvestEvent event;

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sản lượng và giá bán',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _GridCell(
                      label: 'KHỐI LƯỢNG',
                      value: '${harvestNumber(event.totalWeightKg)} kg',
                    ),
                    const SizedBox(height: 16),
                    _GridCell(
                      label: 'CỠ TÔM',
                      value: event.avgSizePerKg == null
                          ? 'Không ghi nhận'
                          : '${harvestNumber(event.avgSizePerKg)} con/kg',
                    ),
                    const SizedBox(height: 16),
                    _GridCell(
                      label: 'TỔNG DOANH THU',
                      value: event.totalRevenue == null
                          ? 'Không ghi nhận'
                          : '${harvestNumber(event.totalRevenue)} đ',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _GridCell(
                      label: 'SỐ LƯỢNG THU',
                      value: event.quantityCount ?? 'Không ghi nhận',
                    ),
                    const SizedBox(height: 16),
                    _GridCell(
                      label: 'GIÁ BÁN',
                      value: event.pricePerKg == null
                          ? 'Không ghi nhận'
                          : '${harvestNumber(event.pricePerKg)} đ/kg',
                    ),
                    const SizedBox(height: 16),
                    _GridCell(
                      label: 'CÒN LẠI ƯỚC TÍNH',
                      value: event.estimatedRemainingCount ?? 'Không ghi nhận',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  const _GridCell({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.inkMuted,
          letterSpacing: 0.3,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: const TextStyle(
          fontSize: 14.5,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    ],
  );
}

class _InfoSectionCard extends StatelessWidget {
  const _InfoSectionCard({required this.title, required this.items});

  final String title;
  final List<(String, String)> items;

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 14),
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              const Divider(height: 24, thickness: 1, color: Color(0xFFF1F5F9)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  items[i].$1,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.inkMuted,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Flexible(
                  child: Text(
                    items[i].$2,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});
  final String note;

  @override
  Widget build(BuildContext context) {
    return _DetailCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ghi chú',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            note,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.ink,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
