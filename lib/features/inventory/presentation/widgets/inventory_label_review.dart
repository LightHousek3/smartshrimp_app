import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_label.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_product_image.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

const inventoryLabelFieldNames = {
  'name': 'Tên vật tư',
  'regulatoryType': 'Loại sản phẩm',
  'registrationNumber': 'Số đăng ký / tiếp nhận',
  'ingredientsText': 'Thành phần / hoạt chất',
  'usageInstructions': 'Hướng dẫn sử dụng',
  'containsAntibiotic': 'Có chứa kháng sinh?',
  'withdrawalDays': 'Thời gian ngừng (ngày)',
};

Map<String, Object?> inventoryLabelValues(InventoryLabelResult result) => {
  'name': result.name,
  'regulatoryType': result.regulatoryType,
  'registrationNumber': result.registrationNumber,
  'ingredientsText': result.ingredientsText,
  'usageInstructions': result.usageInstructions,
  'containsAntibiotic': result.containsAntibiotic,
  'withdrawalDays': result.withdrawalDays,
};

/// Apply OCR suggestions only after individual or bulk confirmation.
class InventoryLabelReview extends StatefulWidget {
  const InventoryLabelReview({
    required this.result,
    this.images = const [],
    super.key,
  });
  final InventoryLabelResult result;
  final List<InventoryLabelImage> images;

  @override
  State<InventoryLabelReview> createState() => _InventoryLabelReviewState();
}

class _InventoryLabelReviewState extends State<InventoryLabelReview> {
  final _selected = <String>{};

  String _display(Object value) => switch (value) {
    true => 'Có kháng sinh',
    false => 'Không có kháng sinh',
    'feed' => 'Thức ăn',
    'environment' => 'Xử lý môi trường',
    'dual_purpose' => 'Thức ăn và xử lý môi trường',
    'medicine' => 'Thuốc thú y',
    'unclassified' => 'Chưa phân loại',
    _ => value.toString(),
  };

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final fields = inventoryLabelValues(
      result,
    ).entries.where((entry) => entry.value != null).toList();
    final canApply = _selected.isNotEmpty;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: AppDialog(
          title: 'Kiểm tra kết quả đọc nhãn',
          titleStyle: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            color: AppColors.ink,
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            height: 1.3,
          ),
          description:
              'Đối chiếu với ảnh và chọn thông tin muốn điền vào vật tư.',
          icon: Icons.document_scanner_outlined,
          separatedActions: true,
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.images.isNotEmpty) ...[
                  _sectionTitle(
                    'Ảnh nhãn đã đọc',
                    '${widget.images.length} ảnh',
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 168,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.images.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (_, index) {
                        final image = widget.images[index];
                        return Container(
                          width: 224,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F7FB),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.line),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: InteractiveViewer(
                                  child: image.bytes != null
                                      ? Image.memory(
                                          image.bytes!,
                                          fit: BoxFit.contain,
                                        )
                                      : InventoryProductImage(
                                          category:
                                              InventoryProductCategory.other,
                                          url: image.url,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                              Positioned(
                                left: 8,
                                bottom: 8,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      'Ảnh ${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.inkSoft,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (result.substanceCheck?.blocksUse == true)
                  _ReviewNotice(
                    title: 'Thành phần cần kiểm tra',
                    level: AppNoticeLevel.danger,
                    children: [Text(result.substanceCheck!.message)],
                  ),
                if (result.warnings.isNotEmpty)
                  _ReviewNotice(
                    title: 'Cần đối chiếu thêm',
                    level: AppNoticeLevel.warning,
                    children: [
                      for (final warning in result.warnings)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(warning),
                        ),
                    ],
                  ),
                if (result.manufacturerName != null)
                  _ReviewNotice(
                    title: 'Nhà sản xuất đọc được: ${result.manufacturerName}',
                    level: AppNoticeLevel.info,
                    children: [
                      const Text(
                        'Hãy chọn bản ghi tương ứng trong danh mục nhà sản xuất.',
                      ),
                    ],
                  ),
                if (fields.isNotEmpty) ...[
                  _sectionTitle(
                    'Thông tin đọc được',
                    '${fields.length} trường',
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Chọn từng mục hoặc chọn tất cả. Bạn có thể chỉnh sửa lại trên form.',
                    style: TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                for (final entry in fields)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: _selected.contains(entry.key)
                          ? const Color(0xFFF0F7FD)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selected.contains(entry.key)
                            ? AppColors.oceanLight
                            : AppColors.line,
                      ),
                    ),
                    child: CheckboxListTile(
                      key: ValueKey('inventory-label-field-${entry.key}'),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      titleAlignment: ListTileTitleAlignment.center,
                      activeColor: AppColors.ocean,
                      checkColor: Colors.white,
                      side: const BorderSide(
                        color: AppColors.oceanLight,
                        width: 1.5,
                      ),
                      checkboxShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      value: _selected.contains(entry.key),
                      title: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${inventoryLabelFieldNames[entry.key]}: ',
                              style: const TextStyle(color: AppColors.inkMuted),
                            ),
                            TextSpan(
                              text: _display(entry.value!),
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        softWrap: true,
                        style: const TextStyle(fontSize: 13, height: 1.55),
                      ),
                      onChanged: (checked) => setState(() {
                        if (checked == true) {
                          _selected.add(entry.key);
                        } else {
                          _selected.remove(entry.key);
                        }
                      }),
                    ),
                  ),
                if (fields.isEmpty)
                  const _ReviewNotice(
                    title: 'Chưa đọc được thông tin',
                    level: AppNoticeLevel.info,
                    children: [
                      Text(
                        'Không có trường nào có thể điền. Hãy chụp rõ nhãn hoặc nhập tay.',
                      ),
                    ],
                  ),
              ],
            ),
          ),
          actions: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Đã chọn ${_selected.length}/${fields.length} trường để điền',
                style: const TextStyle(
                  color: AppColors.inkSoft,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              key: const ValueKey('inventory-label-select-all'),
              contentPadding: EdgeInsets.zero,
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.ocean,
              value: fields.isNotEmpty && _selected.length == fields.length,
              onChanged: fields.isEmpty
                  ? null
                  : (checked) => setState(() {
                      _selected.clear();
                      if (checked == true) {
                        _selected.addAll(fields.map((entry) => entry.key));
                      }
                    }),
              title: const Text(
                'Chọn tất cả',
                style: inventoryTextButtonTextStyle,
              ),
            ),
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: canApply
                      ? const [AppColors.oceanLight, AppColors.tealLight]
                      : const [Color(0xFFBAC6D1), Color(0xFFBAC6D1)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    disabledForegroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 13,
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: canApply
                      ? () => Navigator.pop(context, Set<String>.of(_selected))
                      : null,
                  icon: const Icon(Icons.check_rounded, size: 18),
                  label: Text('Xác nhận & điền ${_selected.length} trường'),
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.inkSoft,
                  textStyle: inventoryTextButtonTextStyle,
                ),
                child: const Text('Đóng'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, String count) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF4FF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          count,
          style: const TextStyle(
            color: AppColors.ocean,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ],
  );
}

class _ReviewNotice extends StatelessWidget {
  const _ReviewNotice({
    required this.title,
    required this.level,
    required this.children,
  });
  final String title;
  final AppNoticeLevel level;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final visual = appNoticeVisualFor(level);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: visual.background,
        border: Border.all(color: visual.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(visual.icon, size: 18, color: visual.foreground),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: visual.foreground,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 4),
                DefaultTextStyle.merge(
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 12,
                    height: 1.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
