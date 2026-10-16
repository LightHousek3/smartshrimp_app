import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_notice.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

class InventoryAdjustmentPage extends ConsumerStatefulWidget {
  const InventoryAdjustmentPage({
    required this.farmId,
    required this.productId,
    required this.balanceId,
    this.isStockOut = false,
    super.key,
  });

  final String farmId;
  final String productId;
  final String balanceId;
  final bool isStockOut;

  @override
  ConsumerState<InventoryAdjustmentPage> createState() =>
      _InventoryAdjustmentPageState();
}

class _InventoryAdjustmentPageState
    extends ConsumerState<InventoryAdjustmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();
  bool _increase = true;
  bool get _isDecrease => widget.isStockOut || !_increase;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _submit(InventoryLot lot) async {
    if (_formKey.currentState?.validate() != true) return;
    final quantity = InventoryRules.parseNumber(_quantityController.text)!;
    if (_isDecrease && quantity > lot.quantity) {
      AppNoticeService.show(
        context,
        message:
            'Số lượng giảm không thể lớn hơn tồn của lô (${formatInventoryQuantity(lot.quantity)}).',
        level: AppNoticeLevel.warning,
      );
      return;
    }
    try {
      final notifier = ref.read(
        inventoryMutationControllerProvider(widget.farmId).notifier,
      );
      if (widget.isStockOut) {
        await notifier.stockOut(
          productId: widget.productId,
          inventoryBalanceId: widget.balanceId,
          quantity: quantity,
          reason: _reasonController.text,
        );
      } else {
        await notifier.adjust(
          productId: widget.productId,
          inventoryBalanceId: widget.balanceId,
          increase: _increase,
          quantity: quantity,
          reason: _reasonController.text,
        );
      }
      if (!mounted) return;
      AppNoticeService.success(
        context,
        widget.isStockOut
            ? 'Đã xuất kho thành công.'
            : 'Đã điều chỉnh tồn kho thành công.',
      );
      context.pop();
    } on AppException catch (error) {
      if (!mounted) return;
      AppNoticeService.show(
        context,
        message: error.message,
        level: AppNoticeLevel.danger,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final detail = ref.watch(
      inventoryDetailControllerProvider((
        farmId: widget.farmId,
        productId: widget.productId,
      )),
    );
    final mutation = ref.watch(
      inventoryMutationControllerProvider(widget.farmId),
    );

    return InventoryPageFrame(
      title: widget.isStockOut ? 'Xuất kho' : 'Điều chỉnh tồn kho',
      onBack: context.pop,
      child: detail.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _LoadError(
          message: _errorMessage(error),
          onRetry: () => ref
              .read(
                inventoryDetailControllerProvider((
                  farmId: widget.farmId,
                  productId: widget.productId,
                )).notifier,
              )
              .refresh(),
        ),
        data: (product) {
          if (product.isArchived) {
            return Center(
              child: Text(
                widget.isStockOut
                    ? 'Khôi phục vật tư trước khi xuất kho.'
                    : 'Khôi phục vật tư trước khi điều chỉnh tồn kho.',
              ),
            );
          }
          final lot = _findLot(product.lots, widget.balanceId);
          if (lot == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Lô hàng không còn tồn tại hoặc đã hết hàng.'),
              ),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: <Widget>[
                InventorySurface(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _InformationRow(label: 'Vật tư', value: product.name),
                      const SizedBox(height: 10),
                      _InformationRow(label: 'Mã lô', value: lot.lotNumber),
                      const SizedBox(height: 10),
                      _InformationRow(
                        label: 'Tồn hiện tại',
                        value:
                            '${formatInventoryQuantity(lot.quantity)} ${product.unit.label}',
                      ),
                      const SizedBox(height: 18),
                      if (!widget.isStockOut)
                        InventoryField(
                          label: 'Loại điều chỉnh *',
                          child: SegmentedButton<bool>(
                            segments: const <ButtonSegment<bool>>[
                              ButtonSegment(
                                value: true,
                                label: Text('Tăng tồn'),
                                icon: Icon(Icons.add_circle_outline),
                              ),
                              ButtonSegment(
                                value: false,
                                label: Text('Giảm tồn'),
                                icon: Icon(Icons.remove_circle_outline),
                              ),
                            ],
                            selected: <bool>{_increase},
                            onSelectionChanged: (value) => setState(() {
                              _increase = value.single;
                              _formKey.currentState?.validate();
                            }),
                          ),
                        ),
                      const SizedBox(height: 16),
                      InventoryField(
                        label: 'Số lượng *',
                        child: TextFormField(
                          controller: _quantityController,
                          style: inventoryInputTextStyle,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration:
                              inventoryInputDecoration(
                                hintText: 'VD: 10',
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Center(
                                    widthFactor: 1,
                                    child: Text(product.unit.label),
                                  ),
                                ),
                              ).copyWith(
                                suffixIconConstraints: const BoxConstraints(
                                  minHeight: 0,
                                ),
                              ),
                          validator: (value) {
                            final error = InventoryRules.quantityError(value);
                            if (error != null) return error;
                            final quantity = InventoryRules.parseNumber(value)!;
                            if (_isDecrease && quantity > lot.quantity) {
                              return widget.isStockOut
                                  ? 'Không thể xuất quá số lượng đang tồn'
                                  : 'Không thể giảm quá số lượng đang tồn';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      InventoryField(
                        label: widget.isStockOut
                            ? 'Ghi chú (tùy chọn)'
                            : 'Lý do điều chỉnh *',
                        child: TextFormField(
                          controller: _reasonController,
                          style: inventoryInputTextStyle,
                          maxLength: InventoryRules.maxReasonLength,
                          minLines: 3,
                          maxLines: 5,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: inventoryInputDecoration(
                            hintText: widget.isStockOut
                                ? 'Mục đích xuất kho…'
                                : 'VD: Kiểm kê thực tế, hư hỏng hoặc nhập sai số lượng',
                          ).copyWith(counterText: ''),
                          validator: (value) =>
                              !widget.isStockOut &&
                                  (value == null || value.trim().isEmpty)
                              ? 'Vui lòng nhập lý do điều chỉnh'
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                InventoryGradientButton(
                  label: mutation.isLoading
                      ? 'Đang xử lý…'
                      : widget.isStockOut
                      ? 'Xác nhận xuất kho'
                      : 'Xác nhận điều chỉnh',
                  iconAsset: InventoryAssets.save,
                  onPressed: mutation.isLoading ? null : () => _submit(lot),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.isStockOut
                      ? 'Giao dịch xuất kho được ghi vào lịch sử.'
                      : 'Mọi điều chỉnh đều được ghi vào lịch sử và không thể xóa.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.inkMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        width: 105,
        child: Text(
          label,
          style: const TextStyle(color: AppColors.inkMuted, fontSize: 13),
        ),
      ),
      Expanded(
        child: Text(
          value,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    ),
  );
}

String _errorMessage(Object error) {
  return error is AppException
      ? error.message
      : 'Không thể tải thông tin lô hàng. Vui lòng thử lại.';
}

InventoryLot? _findLot(List<InventoryLot> lots, String balanceId) {
  for (final lot in lots) {
    if (lot.id == balanceId) return lot;
  }
  return null;
}
