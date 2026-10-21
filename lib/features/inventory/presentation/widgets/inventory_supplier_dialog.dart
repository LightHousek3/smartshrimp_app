import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/widgets/app_dialog.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_supplier.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

enum InventorySupplierAction { edit, delete }

/// Renders the directory snapshot without reading a detail provider.
class InventorySupplierDialog extends StatelessWidget {
  const InventorySupplierDialog({required this.supplier, super.key});

  final InventorySupplier supplier;

  @override
  Widget build(BuildContext context) => AppDialog(
    title: supplier.name,
    description: 'Cửa hàng phân phối',
    icon: Icons.storefront_outlined,
    separatedActions: true,
    content: SizedBox(
      width: 440,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _InformationRow(
            icon: Icons.circle_outlined,
            label: 'Trạng thái',
            value: supplier.isActive ? 'Đang hoạt động' : 'Tạm ngưng',
          ),
          _InformationRow(
            icon: Icons.person_outline_rounded,
            label: 'Người liên hệ',
            value: supplier.contactName,
          ),
          _InformationRow(
            icon: Icons.phone_outlined,
            label: 'Điện thoại',
            value: supplier.phone,
          ),
          _InformationRow(
            icon: Icons.mail_outline_rounded,
            label: 'Email',
            value: supplier.email,
          ),
          _InformationRow(
            icon: Icons.location_on_outlined,
            label: 'Địa chỉ cửa hàng',
            value: supplier.address,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ghi chú',
                  style: TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                SelectableText(
                  _display(supplier.note),
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    actions: [
      Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pop(context, InventorySupplierAction.delete),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.line),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text('Xóa'),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: InventoryGradientButton(
              label: 'Chỉnh sửa',
              iconAsset: InventoryAssets.edit,
              iconColor: Colors.white,
              height: 44,
              radius: 12,
              onPressed: () =>
                  Navigator.pop(context, InventorySupplierAction.edit),
            ),
          ),
        ],
      ),
      const SizedBox(height: 6),
      SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: AppColors.inkSoft),
          child: const Text('Đóng'),
        ),
      ),
    ],
  );
}

String _display(String? value) =>
    value == null || value.trim().isEmpty ? 'Chưa cập nhật' : value;

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.inkMuted),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                _display(value),
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
