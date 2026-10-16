import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory.dart'
    as domain;
import 'package:smartshrimp_app/features/inventory/presentation/inventory_view_data.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_history_filters.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

class InventoryHistoryPage extends ConsumerStatefulWidget {
  const InventoryHistoryPage({required this.farmId, super.key});

  final String farmId;

  @override
  ConsumerState<InventoryHistoryPage> createState() =>
      _InventoryHistoryPageState();
}

class _InventoryHistoryPageState extends ConsumerState<InventoryHistoryPage> {
  final _searchController = TextEditingController();
  Timer? _searchDebounce;
  var _searchQuery = '';
  var _filtersExpanded = true;
  var _draftFilters = const domain.InventoryHistoryFilters();
  var _appliedFilters = const domain.InventoryHistoryFilters();
  String? _filterError;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_refreshSearch);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController
      ..removeListener(_refreshSearch)
      ..dispose();
    super.dispose();
  }

  void _refreshSearch() {
    _searchDebounce?.cancel();
    final query = _searchController.text.trim().toLowerCase();
    if (query == _searchQuery) return;
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) setState(() => _searchQuery = query);
    });
  }

  void _applyFilters() {
    FocusScope.of(context).unfocus();
    if (!_draftFilters.isValidDateRange) {
      setState(() {
        _filterError = 'Ngày bắt đầu không được sau ngày kết thúc.';
      });
      return;
    }
    setState(() {
      _filterError = null;
      _appliedFilters = _draftFilters;
    });
  }

  void _resetFilters() {
    _searchController.clear();
    _searchDebounce?.cancel();
    FocusScope.of(context).unfocus();
    setState(() {
      _draftFilters = const domain.InventoryHistoryFilters();
      _appliedFilters = const domain.InventoryHistoryFilters();
      _filterError = null;
      _searchQuery = '';
    });
  }

  Future<void> _refreshHistory() async {
    final refresh = ref
        .read(inventoryHistoryControllerProvider(widget.farmId).notifier)
        .refresh();
    if (_appliedFilters.isEmpty) {
      await refresh;
      return;
    }
    await Future.wait(<Future<void>>[
      refresh,
      ref
          .read(
            filteredInventoryHistoryControllerProvider((
              farmId: widget.farmId,
              filters: _appliedFilters,
            )).notifier,
          )
          .refresh(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // The unfiltered history keeps dropdown choices stable when a result is
    // empty, and retains archived/deleted materials referenced by the ledger.
    final allHistoryState = ref.watch(
      inventoryHistoryControllerProvider(widget.farmId),
    );
    final historyState = _appliedFilters.isEmpty
        ? allHistoryState
        : ref.watch(
            filteredInventoryHistoryControllerProvider((
              farmId: widget.farmId,
              filters: _appliedFilters,
            )),
          );
    final history = historyState.value;
    final products = <String, domain.InventoryTransactionProduct>{};
    final seasons = <String, domain.InventoryTransactionSeason>{};
    for (final transaction
        in allHistoryState.value?.items ?? <domain.InventoryTransaction>[]) {
      products[transaction.product.id] = transaction.product;
      final season = transaction.season;
      if (season != null) seasons[season.id] = season;
    }
    final productOptions = products.values.toList()
      ..sort((left, right) => left.name.compareTo(right.name));
    final seasonOptions = seasons.values.toList()
      ..sort((left, right) => left.label.compareTo(right.label));

    return InventoryPageFrame(
      title: 'Lịch sử kho',
      onBack: context.pop,
      child: RefreshIndicator(
        onRefresh: _refreshHistory,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          children: <Widget>[
            InventoryHistoryFilterPanel(
              filters: _draftFilters,
              products: productOptions,
              seasons: seasonOptions,
              expanded: _filtersExpanded,
              loading: historyState.isLoading,
              hasPendingChanges: _draftFilters != _appliedFilters,
              errorMessage: _filterError,
              onToggle: () =>
                  setState(() => _filtersExpanded = !_filtersExpanded),
              onChanged: (filters) => setState(() {
                _draftFilters = filters;
                _filterError = null;
              }),
              onApply: _applyFilters,
              onReset: _resetFilters,
            ),
            const SizedBox(height: 14),
            if (historyState.hasError)
              InventorySurface(
                child: _HistoryError(
                  message: _errorMessage(historyState.error),
                  onRetry: _refreshHistory,
                ),
              )
            else if (history == null)
              const InventorySurface(
                child: Padding(
                  padding: EdgeInsets.all(28),
                  child: Center(child: CircularProgressIndicator()),
                ),
              )
            else
              _HistoryContent(
                history: history,
                searchController: _searchController,
                searchQuery: _searchQuery,
              ),
          ],
        ),
      ),
    );
  }
}

class _HistoryContent extends StatelessWidget {
  const _HistoryContent({
    required this.history,
    required this.searchController,
    required this.searchQuery,
  });

  final domain.InventoryHistoryPage history;
  final TextEditingController searchController;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final query = searchQuery;
    final transactions = history.items
        .where((transaction) {
          if (query.isEmpty) return true;
          return transaction.product.name.toLowerCase().contains(query) ||
              transaction.inventoryBalance.lotNumber.toLowerCase().contains(
                query,
              ) ||
              (transaction.inventoryBalance.supplierName.toLowerCase().contains(
                query,
              )) ||
              (transaction.reason?.toLowerCase().contains(query) ?? false);
        })
        .toList(growable: false);
    final displayedHistory = query.isEmpty
        ? history
        : history.copyWith(
            totalResults: transactions.length,
            summary: domain.InventoryHistorySummary(
              totalInboundValue: transactions
                  .where((item) => item.transactionType.isInbound)
                  .fold(0, (total, item) => total + item.totalAmount),
              totalOutboundValue: transactions
                  .where(
                    (item) =>
                        item.transactionType ==
                            domain.InventoryTransactionType.stockOut ||
                        item.transactionType ==
                            domain.InventoryTransactionType.adjustmentOut,
                  )
                  .fold(0, (total, item) => total + item.totalAmount),
            ),
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _Summary(history: displayedHistory),
        const SizedBox(height: 14),
        TextField(
          controller: searchController,
          style: inventoryInputTextStyle,
          textAlignVertical: TextAlignVertical.center,
          decoration:
              inventoryInputDecoration(
                hintText: 'Tìm theo vật tư, mã lô, nhà cung cấp…',
              ).copyWith(
                prefixIcon: const Icon(Icons.search, color: AppColors.inkMuted),
                suffixIcon: searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Xóa tìm kiếm',
                        onPressed: searchController.clear,
                        icon: const Icon(Icons.close),
                      ),
              ),
        ),
        const SizedBox(height: 14),
        if (transactions.isEmpty)
          const InventorySurface(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: Text(
                  'Không có giao dịch phù hợp.',
                  style: TextStyle(color: AppColors.inkMuted),
                ),
              ),
            ),
          )
        else
          ...transactions.map(
            (transaction) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TransactionCard(transaction: transaction),
            ),
          ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.history});

  final domain.InventoryHistoryPage history;

  @override
  Widget build(BuildContext context) => InventorySurface(
    child: Row(
      children: <Widget>[
        Expanded(
          child: _SummaryItem(
            label: 'Giao dịch',
            value: formatInventoryQuantity(history.totalResults),
            color: AppColors.ink,
          ),
        ),
        const SizedBox(
          height: 42,
          child: VerticalDivider(color: AppColors.line),
        ),
        Expanded(
          child: _SummaryItem(
            label: 'Giá trị nhập',
            value: formatInventoryMoney(history.summary.totalInboundValue),
            color: const Color(0xFF0F9B8E),
          ),
        ),
        const SizedBox(
          height: 42,
          child: VerticalDivider(color: AppColors.line),
        ),
        Expanded(
          child: _SummaryItem(
            label: 'Giá trị xuất',
            value: formatInventoryMoney(history.summary.totalOutboundValue),
            color: const Color(0xFFE05638),
          ),
        ),
      ],
    ),
  );
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.display(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 3),
      Text(
        label,
        style: const TextStyle(color: AppColors.inkMuted, fontSize: 10),
      ),
    ],
  );
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction});

  final domain.InventoryTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final type = transaction.transactionType;
    final signedQuantity = type.isInbound ? '+' : '−';
    final performer = transaction.performer.fullName?.trim();
    return InventorySurface(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: type.backgroundColor,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  type.label,
                  style: TextStyle(
                    color: type.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '$signedQuantity${formatInventoryQuantity(transaction.quantity)} ${transaction.unitSnapshot.label}',
                style: AppTypography.display(
                  color: type.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            transaction.product.name,
            style: AppTypography.display(
              color: AppColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Lô ${transaction.inventoryBalance.lotNumber} · ${formatInventoryDate(transaction.createdAt, includeTime: true)}',
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
          ),
          const SizedBox(height: 8),
          _Metadata(
            label: 'Người thực hiện',
            value: performer == null || performer.isEmpty
                ? transaction.performer.email
                : performer,
          ),
          if (transaction.transactionType ==
              domain.InventoryTransactionType.stockIn)
            _Metadata(
              label: 'Nhà cung cấp',
              value: transaction.inventoryBalance.supplierName,
            ),
          if (transaction.season != null)
            _Metadata(label: 'Vụ nuôi', value: transaction.season!.label),
          if ((transaction.reason ?? '').trim().isNotEmpty)
            _Metadata(label: 'Lý do', value: transaction.reason!.trim()),
          if (transaction.totalAmount > 0)
            _Metadata(
              label: 'Giá trị',
              value: formatInventoryMoney(transaction.totalAmount),
            ),
        ],
      ),
    );
  }
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 102,
          child: Text(
            label,
            style: const TextStyle(color: AppColors.inkMuted, fontSize: 11),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: AppColors.inkSoft, fontSize: 11),
          ),
        ),
      ],
    ),
  );
}

class _HistoryError extends StatelessWidget {
  const _HistoryError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
      ],
    ),
  );
}

String _errorMessage(Object? error) => error is AppException
    ? error.message
    : 'Không thể tải lịch sử kho. Vui lòng thử lại.';
