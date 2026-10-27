import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

/// Return the selected lot to the caller before a stock-out is submitted.
class InventoryStockOutLotPicker extends StatelessWidget {
  const InventoryStockOutLotPicker({
    required this.productName,
    required this.unit,
    required this.lots,
    super.key,
  });

  final String productName;
  final InventoryProductUnit unit;
  final List<InventoryLot> lots;

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.78,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            decoration: BoxDecoration(
              color: AppColors.line,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 8, 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.outbox_outlined,
                    size: 21,
                    color: AppColors.inkSoft,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chọn lô xuất kho',
                        style: AppTypography.display(
                          color: AppColors.ink,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Ưu tiên xuất lô nhập trước',
                        style: TextStyle(
                          color: AppColors.inkMuted,
                          fontSize: 11,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Đóng chọn lô',
                  onPressed: () => Navigator.pop(context),
                  color: AppColors.inkSoft,
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${lots.length} lô còn hàng',
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              itemCount: lots.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _LotOption(
                lot: lots[index],
                unit: unit,
                firstOut: index == 0,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _LotOption extends StatelessWidget {
  const _LotOption({
    required this.lot,
    required this.unit,
    required this.firstOut,
  });

  final InventoryLot lot;
  final InventoryProductUnit unit;
  final bool firstOut;

  @override
  Widget build(BuildContext context) => InventorySurface(
    padding: EdgeInsets.zero,
    radius: 14,
    child: Material(
      color: firstOut ? const Color(0xFFF3FBFA) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: ValueKey('stock-out-lot-${lot.id}'),
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pop(context, lot),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (firstOut) ...[
                      Container(
                        key: const ValueKey('stock-out-first-lot'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE2F6F3),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Text(
                          'Xuất trước',
                          style: TextStyle(
                            color: Color(0xFF0F9B8E),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Text(
                      'Lô ${lot.lotNumber}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.mono(
                        color: AppColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Nhập ${formatInventoryDate(lot.receivedAt)}',
                      style: const TextStyle(
                        color: AppColors.inkMuted,
                        fontSize: 11,
                      ),
                    ),
                    if (lot.supplierName.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        lot.supplierName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.inkSoft,
                          fontSize: 11,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Text(
                      'Còn ${formatInventoryQuantity(lot.quantity)} ${unit.label}',
                      style: const TextStyle(
                        color: Color(0xFF0F9B8E),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
