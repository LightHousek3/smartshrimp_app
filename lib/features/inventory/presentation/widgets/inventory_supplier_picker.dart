import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/supplier_controller.dart';

class InventorySupplierPicker extends ConsumerStatefulWidget {
  const InventorySupplierPicker({required this.farmId, super.key});
  final String farmId;

  @override
  ConsumerState<InventorySupplierPicker> createState() =>
      _InventorySupplierPickerState();
}

class _InventorySupplierPickerState
    extends ConsumerState<InventorySupplierPicker> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supplierListControllerProvider(widget.farmId));
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Chọn nhà cung cấp',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Tìm tên hoặc điện thoại',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) =>
                    setState(() => _search = value.trim().toLowerCase()),
              ),
            ),
            Expanded(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        error is AppException
                            ? error.message
                            : 'Không thể tải nhà cung cấp.',
                      ),
                      TextButton(
                        onPressed: () => ref.invalidate(
                          supplierListControllerProvider(widget.farmId),
                        ),
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
                data: (suppliers) {
                  final items = suppliers
                      .where(
                        (s) =>
                            s.name.toLowerCase().contains(_search) ||
                            (s.phone?.contains(_search) ?? false),
                      )
                      .toList();
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('Chưa có nhà cung cấp phù hợp.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final supplier = items[index];
                      return ListTile(
                        leading: const Icon(Icons.local_shipping_outlined),
                        title: Text(supplier.name),
                        subtitle: supplier.phone == null
                            ? null
                            : Text(supplier.phone!),
                        onTap: () => Navigator.pop(context, supplier),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
