import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart';

final inventoryTestLot = InventoryLot(
  id: 'lot-1',
  productId: 'product-1',
  lotNumber: 'LOT-001',
  receivedAt: DateTime.utc(2026, 10, 1),
  quantity: 80,
  unitPrice: 35000,
  supplierName: 'Nhà cung cấp A',
  inventoryValue: 2800000,
  createdAt: DateTime.utc(2026, 10, 1),
  updatedAt: DateTime.utc(2026, 10, 1),
);

final inventoryTestProduct = InventoryProduct(
  id: 'product-1',
  farmId: 'farm-1',
  name: 'Thức ăn CP 9004',
  category: InventoryProductCategory.feed,
  unit: InventoryProductUnit.kg,
  minAlertQuantity: 100,
  isArchived: false,
  isDeleted: false,
  createdAt: DateTime.utc(2026, 10, 1),
  updatedAt: DateTime.utc(2026, 10, 1),
  currentStock: 80,
  inventoryValue: 2800000,
  activeLotCount: 1,
  isLowStock: true,
  lots: <InventoryLot>[inventoryTestLot],
  plannedUseCount: 0,
  canArchive: false,
);

final inventoryTestStockResult = InventoryStockResult(
  transactionId: 'transaction-1',
  balance: inventoryTestLot,
  currentStock: 80,
  idempotentReplay: false,
);

final inventoryTestTransaction = InventoryTransaction(
  id: 'transaction-1',
  transactionGroupId: 'group-1',
  productId: inventoryTestProduct.id,
  inventoryBalanceId: inventoryTestLot.id,
  transactionType: InventoryTransactionType.stockIn,
  quantity: 80,
  unitSnapshot: InventoryProductUnit.kg,
  totalAmount: 2800000,
  reason: 'Nhập hàng đầu vụ',
  performedBy: 'owner-1',
  createdAt: DateTime.utc(2026, 10, 1),
  product: const InventoryTransactionProduct(
    id: 'product-1',
    name: 'Thức ăn CP 9004',
    category: InventoryProductCategory.feed,
    unit: InventoryProductUnit.kg,
    isDeleted: false,
  ),
  inventoryBalance: inventoryTestLot,
  performer: const InventoryTransactionPerformer(
    id: 'owner-1',
    fullName: 'Chủ trại',
    email: 'owner@smartshrimp.vn',
  ),
);

InventoryProductPage inventoryTestProductPage({
  List<InventoryProduct>? items,
  int page = 1,
  bool hasNextPage = false,
}) => InventoryProductPage(
  items: items ?? <InventoryProduct>[inventoryTestProduct],
  page: page,
  limit: 100,
  totalResults: 2,
  totalPages: hasNextPage ? 2 : 1,
  hasNextPage: hasNextPage,
  summary: const InventorySummary(
    totalProducts: 2,
    lowStockCount: 1,
    inventoryValue: 2800000,
  ),
);

const inventoryTestHistoryPage = InventoryHistoryPage(
  items: <InventoryTransaction>[],
  limit: 100,
  totalResults: 0,
  hasNextPage: false,
  summary: InventoryHistorySummary(totalInboundValue: 0, totalOutboundValue: 0),
);
