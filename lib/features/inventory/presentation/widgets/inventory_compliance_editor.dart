import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_compliance.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ingredient_editor.dart';

/// Keep optional photos and label facts together for completeness checks.
class InventoryComplianceEditor extends StatelessWidget {
  const InventoryComplianceEditor({
    required this.value,
    required this.onChanged,
    required this.imageSection,
    this.enabled = true,
    this.farmId,
    super.key,
  });

  final InventoryCompliance value;
  final ValueChanged<InventoryCompliance> onChanged;
  final Widget imageSection;
  final bool enabled;
  final String? farmId;

  Widget get _dropdownIcon => const Center(
    widthFactor: 1,
    heightFactor: 1,
    child: SizedBox(
      width: 10,
      height: 6,
      child: InventorySvgIcon(InventoryAssets.formDropdown, size: 10),
    ),
  );

  @override
  Widget build(BuildContext context) => InventorySurface(
    radius: 18,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: InventorySvgIcon(
                  InventoryAssets.formCompliance,
                  size: 21,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhãn & hồ sơ tuân thủ',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        imageSection,
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(height: 1, color: AppColors.line),
        ),
        const Text(
          'Thông tin theo nhãn',
          style: TextStyle(
            color: AppColors.ink,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        InventoryField(
          label: 'Loại sản phẩm *',
          labelSize: 12,
          spacing: 6,
          child: DropdownButtonFormField<String>(
            initialValue: value.regulatoryType,
            isExpanded: true,
            icon: _dropdownIcon,
            style: AppTypography.mono(fontSize: 14, color: AppColors.ink),
            decoration: inventoryInputDecoration(),
            validator: (type) =>
                enabled && (type == null || type == 'unclassified')
                ? 'Vui lòng chọn loại sản phẩm'
                : null,
            items: const [
              DropdownMenuItem(
                value: 'unclassified',
                child: Text('Chọn loại sản phẩm'),
              ),
              DropdownMenuItem(value: 'feed', child: Text('Thức ăn thủy sản')),
              DropdownMenuItem(
                value: 'environment',
                child: Text('Xử lý môi trường'),
              ),
              DropdownMenuItem(
                value: 'dual_purpose',
                child: Text('Hai mục đích'),
              ),
              DropdownMenuItem(value: 'medicine', child: Text('Thuốc thú y')),
            ],
            onChanged: enabled
                ? (type) => onChanged(value.copyWith(regulatoryType: type!))
                : null,
          ),
        ),
        _text(
          'Mã số tiếp nhận *',
          value.registrationNumber,
          (text) =>
              onChanged(value.copyWith(registrationNumber: _nullable(text))),
          hint: 'Nhập mã số',
          maxLength: 100,
        ),
        if (value.regulatoryType == 'unclassified') ...[
          const SizedBox(height: 6),
          const Text(
            'Chưa đủ căn cứ xác định loại sản phẩm.',
            style: TextStyle(
              fontSize: 11,
              height: 1.5,
              color: AppColors.inkMuted,
            ),
          ),
        ],
        if (farmId != null)
          InventoryIngredientEditor(
            farmId: farmId!,
            value: value.ingredientsText,
            enabled: enabled,
            onChanged: (text) =>
                onChanged(value.copyWith(ingredientsText: text)),
          )
        else
          _text(
            'Thành phần / hoạt chất *',
            value.ingredientsText,
            (text) =>
                onChanged(value.copyWith(ingredientsText: _nullable(text))),
            hint: 'Nhập thành phần',
            multiline: true,
          ),
        _text(
          'Hướng dẫn sử dụng *',
          value.usageInstructions,
          (text) =>
              onChanged(value.copyWith(usageInstructions: _nullable(text))),
          hint: 'Nhập cách dùng',
          multiline: true,
        ),
        const SizedBox(height: 16),
        InventoryField(
          label: 'Có chứa kháng sinh? *',
          labelSize: 12,
          spacing: 6,
          child: DropdownButtonFormField<String>(
            initialValue: value.containsAntibiotic?.toString() ?? 'unknown',
            isExpanded: true,
            icon: _dropdownIcon,
            style: AppTypography.mono(fontSize: 14, color: AppColors.ink),
            decoration: inventoryInputDecoration(),
            validator: (text) => enabled && (text == null || text == 'unknown')
                ? 'Vui lòng xác nhận có chứa kháng sinh'
                : null,
            items: const [
              DropdownMenuItem(value: 'unknown', child: Text('Chưa xác định')),
              DropdownMenuItem(value: 'true', child: Text('Có kháng sinh')),
              DropdownMenuItem(
                value: 'false',
                child: Text('Không có kháng sinh'),
              ),
            ],
            onChanged: enabled
                ? (text) => onChanged(
                    value.copyWith(
                      containsAntibiotic: text == 'unknown'
                          ? null
                          : text == 'true',
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
        InventoryField(
          label: 'Thời gian ngừng (ngày) *',
          labelSize: 12,
          spacing: 6,
          child: TextFormField(
            initialValue: value.withdrawalDays?.toString(),
            enabled: enabled,
            style: inventoryInputTextStyle,
            decoration: inventoryInputDecoration(
              hintText: '0 nếu không áp dụng',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (text) => onChanged(
              value.copyWith(
                withdrawalDays: double.tryParse(text.replaceAll(',', '.')),
              ),
            ),
            validator: (text) {
              if (!enabled) return null;
              if (text == null || text.trim().isEmpty) {
                return 'Vui lòng nhập thời gian ngừng; nhập 0 nếu không áp dụng';
              }
              final number = double.tryParse(text.replaceAll(',', '.'));
              return number == null ||
                      !number.isFinite ||
                      number < 0 ||
                      number > 9999.999 ||
                      !RegExp(r'^\d+(?:[.,]\d{1,3})?$').hasMatch(text)
                  ? 'Nhập số từ 0 đến 9999,999, tối đa 3 số lẻ'
                  : null;
            },
          ),
        ),
      ],
    ),
  );

  Widget _text(
    String label,
    String? text,
    ValueChanged<String> changed, {
    String? hint,
    int maxLength = 50000,
    bool multiline = false,
  }) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: InventoryField(
      label: label,
      labelSize: 12,
      spacing: 6,
      child: TextFormField(
        initialValue: text,
        enabled: enabled,
        maxLength: maxLength,
        minLines: multiline ? 4 : 1,
        maxLines: multiline ? 8 : 1,
        style: inventoryInputTextStyle,
        decoration: inventoryInputDecoration(
          hintText: hint,
        ).copyWith(counterText: ''),
        onChanged: changed,
        validator: (text) => enabled && (text == null || text.trim().isEmpty)
            ? 'Vui lòng nhập ${label.replaceAll(' *', '').toLowerCase()}'
            : null,
      ),
    ),
  );

  static String? _nullable(String text) =>
      text.trim().isEmpty ? null : text.trim();
}
