import 'package:smartshrimp_app/core/utils/vietnamese_number.dart';
import 'package:smartshrimp_app/core/utils/vietnamese_number_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_compliance.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ingredient_editor.dart';

/// Edit label facts and evidence links using the shared material declaration rules.
class InventoryComplianceEditor extends StatelessWidget {
  const InventoryComplianceEditor({
    required this.value,
    required this.onChanged,
    required this.imageSection,
    required this.showAntibioticField,
    this.enabled = true,
    this.farmId,
    super.key,
  });

  final InventoryCompliance value;
  final ValueChanged<InventoryCompliance> onChanged;
  final Widget imageSection;
  final bool showAntibioticField;
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
            initialValue:
                const {
                  'feed',
                  'environment',
                  'dual_purpose',
                  'medicine',
                }.contains(value.regulatoryType)
                ? value.regulatoryType
                : null,
            isExpanded: true,
            icon: _dropdownIcon,
            style: AppTypography.mono(fontSize: 14, color: AppColors.ink),
            decoration: inventoryInputDecoration(),
            hint: const Text('Chọn loại sản phẩm'),
            validator: (type) =>
                enabled &&
                    !const {
                      'feed',
                      'environment',
                      'dual_purpose',
                      'medicine',
                    }.contains(type)
                ? 'Chọn phân loại pháp lý theo hồ sơ vật tư.'
                : null,
            items: const [
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
                ? (type) => onChanged(
                    value.copyWith(
                      regulatoryType: type,
                      registrationNumber: InventoryRules.formatReceiptNumber(
                        type,
                        value.registrationNumber,
                      ),
                    ),
                  )
                : null,
          ),
        ),
        _text(
          value.regulatoryType == 'medicine'
              ? 'Số đăng ký lưu hành thuốc thú y *'
              : 'Mã số tiếp nhận *',
          value.registrationNumber,
          (text) =>
              onChanged(value.copyWith(registrationNumber: _nullable(text))),
          fieldKey: ValueKey(value.regulatoryType),
          hint: InventoryRules.registrationPlaceholder(value.regulatoryType),
          helperText: value.regulatoryType == null
              ? null
              : InventoryRules.registrationHint(value.regulatoryType),
          fieldEnabled: value.regulatoryType != null,
          inputFormatters: [
            TextInputFormatter.withFunction(
              (oldValue, newValue) =>
                  _formatReceiptInput(value.regulatoryType, oldValue, newValue),
            ),
          ],
          validator: (text) => InventoryRules.registrationNumberError(
            value.regulatoryType,
            text,
          ),
          maxLength: 100,
        ),
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
        if (showAntibioticField) ...[
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
              validator: (text) =>
                  enabled && (text == null || text == 'unknown')
                  ? 'Vui lòng xác nhận có chứa kháng sinh'
                  : null,
              items: const [
                DropdownMenuItem(
                  value: 'unknown',
                  child: Text('Chưa xác định'),
                ),
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
        ],
        const SizedBox(height: 16),
        InventoryField(
          label: 'Thời gian ngừng (ngày) *',
          labelSize: 12,
          spacing: 6,
          child: TextFormField(
            initialValue: formatVietnameseNumber(value.withdrawalDays),
            enabled: enabled,
            style: inventoryInputTextStyle,
            decoration: inventoryInputDecoration(
              hintText: '0 nếu không áp dụng',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: const [VietnameseNumberInputFormatter()],
            onChanged: (text) => onChanged(
              value.copyWith(withdrawalDays: parseVietnameseNumber(text)),
            ),
            validator: (text) {
              if (!enabled) return null;
              if (text == null || text.trim().isEmpty) {
                return 'Vui lòng nhập thời gian ngừng; nhập 0 nếu không áp dụng';
              }
              final number = parseVietnameseNumber(text);
              return number == null ||
                      !number.isFinite ||
                      number < 0 ||
                      number > 9999.999 ||
                      !RegExp(
                        r'^\d+(?:\.\d{1,3})?$',
                      ).hasMatch(normalizeVietnameseNumber(text) ?? '')
                  ? 'Nhập số từ 0 đến 9.999,999, tối đa 3 số lẻ'
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
    Key? fieldKey,
    String? hint,
    String? helperText,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLength = 50000,
    bool multiline = false,
    bool fieldEnabled = true,
  }) => Padding(
    padding: const EdgeInsets.only(top: 16),
    child: InventoryField(
      label: label,
      labelSize: 12,
      spacing: 6,
      child: TextFormField(
        key: fieldKey,
        initialValue: text,
        enabled: enabled && fieldEnabled,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        minLines: multiline ? 4 : 1,
        maxLines: multiline ? 8 : 1,
        style: inventoryInputTextStyle,
        decoration: inventoryInputDecoration(hintText: hint).copyWith(
          counterText: '',
          helperText: helperText,
          helperMaxLines: 5,
          errorMaxLines: 5,
        ),
        onChanged: changed,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (text) {
          if (!enabled || !fieldEnabled) return null;
          if (validator != null) return validator(text);
          return text == null || text.trim().isEmpty
              ? 'Vui lòng nhập ${label.replaceAll(' *', '').toLowerCase()}'
              : null;
        },
      ),
    ),
  );

  static TextEditingValue _formatReceiptInput(
    String? type,
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.composing.isCollapsed) return newValue;
    final formatted = InventoryRules.formatReceiptNumber(
      type,
      newValue.text,
      allowPartial: true,
    );
    if (formatted == null || formatted == newValue.text) return newValue;

    const separatorIndex = 2;
    final selection = newValue.selection;
    final deletedSeparator =
        oldValue.text == formatted &&
        oldValue.selection == const TextSelection.collapsed(offset: 3) &&
        selection == const TextSelection.collapsed(offset: separatorIndex);
    if (deletedSeparator) return newValue;

    int shiftOffset(int offset) =>
        offset < separatorIndex ? offset : offset + 1;
    return newValue.copyWith(
      text: formatted,
      selection: selection.copyWith(
        baseOffset: shiftOffset(selection.baseOffset),
        extentOffset: shiftOffset(selection.extentOffset),
      ),
      composing: TextRange.empty,
    );
  }

  static String? _nullable(String text) =>
      text.trim().isEmpty ? null : text.trim();
}
