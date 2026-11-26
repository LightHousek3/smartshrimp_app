import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

const _teal = Color(0xFF008F83);
const _metadataStyle = TextStyle(
  color: AppColors.inkMuted,
  fontSize: 11,
  height: 1.5,
);

class InventoryReceiptCard extends StatelessWidget {
  const InventoryReceiptCard({
    required this.lot,
    required this.unit,
    required this.now,
    required this.hasPriority,
    this.onSetExpiry,
    super.key,
  });

  final InventoryLot lot;
  final InventoryProductUnit unit;
  final DateTime now;
  final bool hasPriority;
  final VoidCallback? onSetExpiry;

  @override
  Widget build(BuildContext context) {
    final expiry = lot.expiryDate;
    final expired =
        expiry != null && InventoryRules.isExpiredOn(expiry, at: now);
    final received = lot.receivedQuantity;
    final ratio = lot.usageRatio;
    final percent = ratio == null
        ? null
        : ratio == 1
        ? 100
        : (ratio * 100).round().clamp(0, 99);
    final usageLabel = switch (ratio) {
      null => 'Chưa có số lượng nhập',
      > 0 && < 0.01 => 'Đã xuất kho < 1%',
      _ => 'Đã xuất kho $percent%',
    };
    final (label, foreground, background) = switch ((
      lot.quantity > 0,
      expiry,
      expired,
      lot.receivedAt.isAfter(now),
      hasPriority,
    )) {
      (false, _, _, _, _) => (
        'Hết hàng',
        AppColors.inkSoft,
        const Color(0xFFEDF1F6),
      ),
      (true, null, _, _, _) => (
        'Thiếu hạn dùng',
        const Color(0xFF9A5700),
        const Color(0xFFFFF1DB),
      ),
      (true, _, true, _, _) => (
        'Hết hạn',
        AppColors.error,
        const Color(0xFFFBE6EA),
      ),
      (true, _, false, true, _) => (
        'Chưa đến giờ nhập',
        AppColors.ocean,
        const Color(0xFFEAF4FF),
      ),
      (true, _, false, false, true) => (
        'Ưu tiên dùng',
        _teal,
        const Color(0xFFE2F6F3),
      ),
      _ => ('Còn hạn', _teal, const Color(0xFFE2F6F3)),
    };
    final receiptTime = InventoryRules.vietnamTime(lot.receivedAt);
    final receiptDate = '${_two(receiptTime.day)}–${_two(receiptTime.month)}';
    final receiptYear = receiptTime.year == InventoryRules.vietnamTime(now).year
        ? ''
        : '–${receiptTime.year}';
    final receivedAt =
        '${_two(receiptTime.hour)}:${_two(receiptTime.minute)} $receiptDate$receiptYear';
    final supplier = lot.supplierName.trim();
    return InventorySurface(
      radius: 18,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Lô ${lot.lotNumber}',
                  style: AppTypography.mono(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ).copyWith(fontFamilyFallback: const ['PlusJakartaSans']),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.topRight,
                  child: InventoryStatusBadge(
                    label: label,
                    foreground: foreground,
                    background: background,
                    showDot: !hasPriority,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              text: 'Nhập $receivedAt',
              children: [
                if (expiry != null) ...[
                  const TextSpan(text: ' · HSD '),
                  TextSpan(
                    text:
                        '${_two(expiry.day)}/${_two(expiry.month)}/${expiry.year}',
                    style: expired
                        ? const TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                          )
                        : null,
                  ),
                ],
              ],
            ),
            style: _metadataStyle,
          ),
          const SizedBox(height: 4),
          InventoryCompanyLine(
            text: supplier.isEmpty
                ? 'Bên bán chưa cập nhật'
                : 'Bên bán: $supplier',
            style: _metadataStyle,
          ),
          if (expiry == null && onSetExpiry != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: TextButton.styleFrom(
                  textStyle: inventoryTextButtonTextStyle,
                ),
                onPressed: onSetExpiry,
                child: const Text('Bổ sung hạn dùng'),
              ),
            ),
          const SizedBox(height: 12),
          Table(
            defaultVerticalAlignment:
                TableCellVerticalAlignment.intrinsicHeight,
            children: [
              TableRow(
                children: [
                  _ReceiptMetric(
                    label: 'Đã nhập',
                    value: received == null ? '—' : _quantity(received),
                    margin: const EdgeInsets.only(right: 4),
                  ),
                  _ReceiptMetric(
                    label: 'Còn lại',
                    value: _quantity(lot.quantity, exact: lot.quantityExact),
                    color: _teal,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                  _ReceiptMetric(
                    label: 'Đơn giá',
                    value:
                        '${formatInventoryMoney(lot.unitPrice)}/${unit.label}',
                    margin: const EdgeInsets.only(left: 4),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (ratio != null) ...[
            LinearProgressIndicator(
              value: ratio,
              minHeight: 6,
              borderRadius: BorderRadius.circular(99),
              color: const Color(0xFF1D7AD6),
              backgroundColor: const Color(0xFFEEF3F8),
              semanticsLabel: 'Tỷ lệ đã xuất kho',
            ),
            const SizedBox(height: 6),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(usageLabel, style: _metadataStyle)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Giá trị còn ${formatInventoryMoney(lot.inventoryValue)}',
                  textAlign: TextAlign.end,
                  style: _metadataStyle.copyWith(
                    color: AppColors.inkSoft,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _quantity(double value, {String? exact}) =>
      '${formatInventoryExactQuantity(value, exact: exact)} ${unit.label}';
}

String _two(int value) => value.toString().padLeft(2, '0');

class _ReceiptMetric extends StatelessWidget {
  const _ReceiptMetric({
    required this.label,
    required this.value,
    required this.margin,
    this.color = AppColors.ink,
  });

  final String label;
  final String value;
  final EdgeInsets margin;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    margin: margin,
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    decoration: BoxDecoration(
      color: const Color(0xFFEDF1F6),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _metadataStyle),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 12,
            height: 1.3,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}
