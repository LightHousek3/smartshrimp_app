import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_product_image.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';
import 'package:url_launcher/url_launcher.dart';

const _teal = Color(0xFF008F83);
const _blue = Color(0xFF0C4E8F);
const _separator = Divider(height: 1, color: Color(0xFFEDF1F6));
const _valueStyle = TextStyle(
  color: AppColors.ink,
  fontSize: 13,
  fontWeight: FontWeight.w600,
  height: 1.4,
);

class InventoryProductSummary extends StatelessWidget {
  const InventoryProductSummary({
    required this.product,
    this.onOpenManufacturer,
    super.key,
  });

  final InventoryProduct product;
  final VoidCallback? onOpenManufacturer;

  @override
  Widget build(BuildContext context) {
    final manufacturer = product.manufacturer['name'];
    final manufacturerName =
        manufacturer is String && manufacturer.trim().isNotEmpty
        ? manufacturer.trim()
        : null;
    final unit = product.unit.label;
    final usable = product.usableStock;
    final conversion = product.conversionQuantity;
    final conversionUnit = product.conversionUnit;
    final description = product.description?.trim();
    return InventorySurface(
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InventoryProductImage(
                    size: 32,
                    category: product.category,
                    isArchived: product.isArchived,
                    isLowStock: product.isLowStock,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: InventoryCategoryBadge(category: product.category),
                  ),
                ],
              ),
              InventoryStatusBadge(
                label: product.isArchived ? 'Tạm ngưng' : 'Đang sử dụng',
                foreground: product.isArchived ? AppColors.inkSoft : _teal,
                background: product.isArchived
                    ? const Color(0xFFEDF1F6)
                    : const Color(0xFFE2F6F3),
              ),
              if (product.isLowStock) const LowStockBadge(),
            ],
          ),
          const SizedBox(height: 14),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              const TableRow(
                children: [
                  _StockColumnLabel('Tồn dùng được'),
                  _StockColumnLabel('Tồn trên sổ'),
                  _StockColumnLabel('Giá trị tồn'),
                ],
              ),
              TableRow(
                children: [
                  _StockColumnValue(
                    usable == null
                        ? 'Chưa xác định'
                        : formatInventoryQuantity(usable),
                    unit,
                    color: product.isLowStock ? AppColors.error : _teal,
                  ),
                  _StockColumnValue(
                    formatInventoryQuantity(product.currentStock),
                    unit,
                  ),
                  _StockColumnValue(
                    formatInventoryCompactMoney(product.inventoryValue),
                    'Theo giá nhập',
                    color: _blue,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _separator,
          _FactRow(label: 'Đơn vị', value: unit),
          _separator,
          _FactRow(
            label: 'Ngưỡng cảnh báo',
            value:
                '${formatInventoryQuantity(product.minAlertQuantity)} ${product.alertUnitLabel}',
          ),
          if (conversion != null && conversionUnit != null) ...[
            _separator,
            _FactRow(
              label: 'Quy đổi',
              value:
                  '1 $unit = ${formatInventoryQuantity(conversion)} ${conversionUnit.label}',
            ),
          ],
          _separator,
          _FactRow(
            label: 'Nhà sản xuất',
            value: manufacturerName ?? 'Chưa cập nhật',
            showCompanyIcon: manufacturerName != null,
            onTap: onOpenManufacturer,
          ),
          if (description != null && description.isNotEmpty) ...[
            _separator,
            _FactText(label: 'Mô tả', value: description),
          ],
        ],
      ),
    );
  }
}

class InventoryComplianceDetails extends StatelessWidget {
  const InventoryComplianceDetails({
    required this.compliance,
    required this.productImages,
    super.key,
  });

  final InventoryCompliance? compliance;
  final List<String> productImages;

  @override
  Widget build(BuildContext context) {
    final profile = compliance;
    final withdrawal = profile?.withdrawalDays;
    final documents = {
      for (final url in profile?.evidenceUrls ?? const <String>[])
        if (Uri.tryParse(url.trim()) case final Uri uri
            when uri.scheme == 'https' &&
                uri.host.isNotEmpty &&
                !productImages.contains(url.trim()))
          uri,
    };
    return InventorySurface(
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Hồ sơ tuân thủ',
            style: AppTypography.display(
              color: AppColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ).copyWith(fontFamilyFallback: const ['PlusJakartaSans']),
          ),
          const SizedBox(height: 6),
          if (profile == null)
            const Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                'Chưa có hồ sơ tuân thủ.',
                style: TextStyle(color: AppColors.inkMuted, fontSize: 12),
              ),
            )
          else ...[
            _FactRow(
              label: 'Loại hồ sơ',
              value: switch (profile.regulatoryType?.toLowerCase()) {
                'feed' => 'Thức ăn thủy sản',
                'environment' => 'Xử lý môi trường',
                'dual_purpose' => 'Hai mục đích',
                'medicine' => 'Thuốc thú y',
                _ => 'Chưa xác định',
              },
            ),
            _separator,
            _FactRow(
              label: profile.regulatoryType?.toLowerCase() == 'medicine'
                  ? 'Số đăng ký lưu hành'
                  : 'Mã số tiếp nhận',
              value: _savedText(profile.registrationNumber),
            ),
            _separator,
            _FactRow(
              label: 'Kháng sinh',
              value: switch (profile.containsAntibiotic) {
                true => 'Có',
                false => 'Không',
                null => 'Chưa xác định',
              },
            ),
            _separator,
            _FactRow(
              label: 'Thời gian ngừng',
              value: withdrawal == null
                  ? 'Chưa xác định'
                  : '${formatInventoryQuantity(withdrawal)} ngày',
            ),
            _separator,
            _FactText(
              label: 'Thành phần / hoạt chất',
              value: _savedText(profile.ingredientsText),
            ),
            _separator,
            _FactText(
              label: 'Hướng dẫn sử dụng',
              value: _savedText(profile.usageInstructions),
            ),
            if (documents.isNotEmpty) ...[
              _separator,
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text('Tài liệu minh chứng', style: _factLabelStyle),
              ),
              for (final (index, uri) in documents.indexed)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: () => _openEvidence(context, uri),
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: Text('Tài liệu ${index + 1} · ${uri.host}'),
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _openEvidence(BuildContext context, Uri uri) async {
    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) return;
    } on Exception {
      // Keep the dossier available when the device cannot open the link.
    }
    if (context.mounted) {
      AppNoticeService.warning(context, 'Không thể mở tài liệu minh chứng.');
    }
  }
}

String _savedText(String? text) =>
    text == null || text.trim().isEmpty ? 'Chưa cập nhật' : text.trim();

const _factLabelStyle = TextStyle(
  color: AppColors.inkMuted,
  fontSize: 12.5,
  height: 1.4,
);

class _FactRow extends StatelessWidget {
  const _FactRow({
    required this.label,
    required this.value,
    this.showCompanyIcon = false,
    this.onTap,
  });

  final String label;
  final String value;
  final bool showCompanyIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(label, maxLines: 1, style: _factLabelStyle),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: showCompanyIcon
                ? InventoryCompanyLine(
                    text: value,
                    style: _valueStyle.copyWith(color: _blue),
                    alignRight: true,
                  )
                : Tooltip(
                    message: value,
                    excludeFromSemantics: true,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(value, maxLines: 1, style: _valueStyle),
                    ),
                  ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 6),
            const InventorySvgIcon(
              InventoryAssets.supplierChevron,
              size: 14,
              colorFilter: ColorFilter.mode(_blue, BlendMode.srcIn),
            ),
          ],
        ],
      ),
    );
    if (onTap == null) return content;
    return Semantics(
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: content,
          ),
        ),
      ),
    );
  }
}

class _FactText extends StatelessWidget {
  const _FactText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: _factLabelStyle),
        const SizedBox(height: 4),
        Text(value, style: _valueStyle),
      ],
    ),
  );
}

class _StockColumnLabel extends StatelessWidget {
  const _StockColumnLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 6, bottom: 8),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text(
        label.toUpperCase(),
        maxLines: 1,
        style: const TextStyle(
          color: AppColors.inkMuted,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class _StockColumnValue extends StatelessWidget {
  const _StockColumnValue(
    this.value,
    this.caption, {
    this.color = AppColors.ink,
  });

  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTypography.display(
              color: color,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ).copyWith(fontFamilyFallback: const ['PlusJakartaSans']),
          ),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            caption,
            maxLines: 1,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
          ),
        ),
      ],
    ),
  );
}
