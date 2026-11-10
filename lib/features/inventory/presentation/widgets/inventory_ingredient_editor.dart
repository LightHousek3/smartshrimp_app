import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_substance.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/presentation/view_models/inventory_controller.dart';
import 'package:smartshrimp_app/features/inventory/presentation/widgets/inventory_ui.dart';

/// The editable label text remains authoritative; suggestions append rather than replace it.
class InventoryIngredientEditor extends ConsumerStatefulWidget {
  const InventoryIngredientEditor({
    required this.farmId,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });
  final String farmId;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  @override
  ConsumerState<InventoryIngredientEditor> createState() =>
      _InventoryIngredientEditorState();
}

class _InventoryIngredientEditorState
    extends ConsumerState<InventoryIngredientEditor> {
  late final _text = TextEditingController(text: widget.value ?? '');
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  final _ingredientsFocus = FocusNode();
  final _scroll = ScrollController();
  final _ingredientScroll = ScrollController();
  bool _showSuggestions = false;

  InventorySubstanceController get _controller =>
      ref.read(inventorySubstanceControllerProvider(widget.farmId).notifier);

  @override
  void initState() {
    super.initState();
    _searchFocus.addListener(() {
      if (_searchFocus.hasFocus && widget.enabled) {
        setState(() => _showSuggestions = true);
        _controller.searchChanged(_search.text);
      }
    });
    _scroll.addListener(() {
      if (_scroll.hasClients && _scroll.position.extentAfter < 64) {
        _controller.loadMore();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.ingredientsChanged(_text.text);
    });
  }

  @override
  void didUpdateWidget(covariant InventoryIngredientEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.value ?? '';
    if (next != _text.text) {
      _text.text = next;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.ingredientsChanged(next);
      });
    }
  }

  @override
  void dispose() {
    _text.dispose();
    _search.dispose();
    _searchFocus.dispose();
    _ingredientsFocus.dispose();
    _scroll.dispose();
    _ingredientScroll.dispose();
    super.dispose();
  }

  void _scrollIngredients(double direction) {
    if (!_ingredientScroll.hasClients) return;
    final position = _ingredientScroll.position;
    final target =
        (position.pixels + direction * position.viewportDimension * .8)
            .clamp(position.minScrollExtent, position.maxScrollExtent)
            .toDouble();
    _ingredientScroll.animateTo(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _changed(String text) {
    widget.onChanged(text.trim().isEmpty ? null : text);
    _controller.ingredientsChanged(text);
    setState(() {});
  }

  void _add(InventorySubstance item) {
    final literal = InventoryRules.ingredientLiteral(item.name);
    final existing = InventoryRules.ingredientSegments(
      _text.text,
    ).map((segment) => segment.text.toLowerCase()).toSet();
    if (!existing.contains(item.name.toLowerCase()) &&
        !existing.contains(literal.toLowerCase())) {
      final next = [
        _text.text.trimRight(),
        literal,
      ].where((line) => line.isNotEmpty).join('\n');
      if (next.length > 50000) return;
      _text.text = next;
      _changed(next);
    }
    _search.clear();
    _searchFocus.unfocus();
    setState(() => _showSuggestions = false);
  }

  @override
  Widget build(BuildContext context) {
    final state =
        ref.watch(inventorySubstanceControllerProvider(widget.farmId)).value ??
        const InventorySubstanceState();
    final segments = InventoryRules.ingredientSegments(_text.text);
    final lines = segments.map((segment) => segment.text).toList();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: InventoryField(
        label: 'Thành phần / hoạt chất *',
        labelSize: 12,
        spacing: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              key: const ValueKey('inventory-ingredients-text'),
              controller: _text,
              focusNode: _ingredientsFocus,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              enabled: widget.enabled,
              minLines: 3,
              maxLines: 6,
              maxLength: 50000,
              style: inventoryInputTextStyle,
              decoration: inventoryInputDecoration(
                hintText: 'Nhập thành phần',
              ).copyWith(counterText: ''),
              onChanged: _changed,
              onTapOutside: (_) => _ingredientsFocus.unfocus(),
              validator: (value) =>
                  widget.enabled && (value == null || value.trim().isEmpty)
                  ? 'Vui lòng nhập thành phần / hoạt chất'
                  : null,
            ),
            if (lines.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                '${lines.length} thành phần',
                style: const TextStyle(fontSize: 10, color: AppColors.inkMuted),
              ),
              const SizedBox(height: 4),
              SizedBox(
                height: 52,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Cuộn thành phần sang trái',
                      onPressed: lines.length > 1
                          ? () => _scrollIngredients(-1)
                          : null,
                      icon: const Icon(Icons.chevron_left),
                      visualDensity: VisualDensity.compact,
                    ),
                    Expanded(
                      child: Scrollbar(
                        controller: _ingredientScroll,
                        thumbVisibility: true,
                        child: ListView.separated(
                          key: const ValueKey('inventory-ingredient-chips'),
                          controller: _ingredientScroll,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(bottom: 8),
                          itemCount: lines.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 6),
                          itemBuilder: (context, index) => Center(
                            child: InputChip(
                              tooltip: lines[index],
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              deleteButtonTooltipMessage: 'Xóa ${lines[index]}',
                              onPressed: () => showDialog<void>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Thành phần / hoạt chất'),
                                  content: SingleChildScrollView(
                                    child: SelectableText(lines[index]),
                                  ),
                                  actions: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle: inventoryTextButtonTextStyle,
                                      ),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text('Đóng'),
                                    ),
                                  ],
                                ),
                              ),
                              label: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 210,
                                ),
                                child: Text(
                                  lines[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              onDeleted: !widget.enabled
                                  ? null
                                  : () {
                                      final segment = segments[index];
                                      final next = _text.text.replaceRange(
                                        segment.start,
                                        segment.end,
                                        '',
                                      );
                                      _text.value = TextEditingValue(
                                        text: next,
                                        selection: TextSelection.collapsed(
                                          offset: segment.start.clamp(
                                            0,
                                            next.length,
                                          ),
                                        ),
                                      );
                                      _changed(_text.text);
                                    },
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Cuộn thành phần sang phải',
                      onPressed: lines.length > 1
                          ? () => _scrollIngredients(1)
                          : null,
                      icon: const Icon(Icons.chevron_right),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 10),
            TextField(
              key: const ValueKey('inventory-ingredient-search'),
              controller: _search,
              focusNode: _searchFocus,
              enabled: widget.enabled,
              maxLength: 150,
              style: inventoryInputTextStyle,
              decoration: inventoryInputDecoration(hintText: 'Tìm thành phần')
                  .copyWith(
                    counterText: '',
                    prefixIcon: const Icon(Icons.search, size: 19),
                    suffixIcon: !_showSuggestions
                        ? null
                        : IconButton(
                            tooltip: 'Đóng gợi ý',
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              _searchFocus.unfocus();
                              setState(() => _showSuggestions = false);
                            },
                          ),
                  ),
              onChanged: (text) {
                setState(() => _showSuggestions = true);
                if (_scroll.hasClients) _scroll.jumpTo(0);
                _controller.searchChanged(text);
              },
            ),
            if (_showSuggestions) ...[
              const SizedBox(height: 4),
              Container(
                key: const ValueKey('inventory-ingredient-suggestions'),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state.isSearching)
                      const Padding(
                        padding: EdgeInsets.all(14),
                        child: Text('Đang tìm…'),
                      ),
                    if (!state.isSearching && state.items.isNotEmpty)
                      SizedBox(
                        height: math.min(
                          300,
                          math.min(5, state.items.length) * 58.0 +
                              (state.hasNextPage ? 30 : 0),
                        ),
                        child: ListView.builder(
                          controller: _scroll,
                          padding: EdgeInsets.zero,
                          itemCount:
                              state.items.length + (state.hasNextPage ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == state.items.length) {
                              return SizedBox(
                                height: 30,
                                child: Center(
                                  child: Text(
                                    state.isLoadingMore
                                        ? 'Đang tải thêm…'
                                        : 'Cuộn để xem thêm',
                                  ),
                                ),
                              );
                            }
                            final item = state.items[index];
                            return SizedBox(
                              height: 58,
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                title: Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: item.status == 'banned'
                                        ? Colors.red.shade800
                                        : AppColors.ink,
                                  ),
                                ),
                                subtitle: Text(
                                  item.status == 'banned'
                                      ? 'Cấm sử dụng · Phụ lục I'
                                      : '${item.group} · Phụ lục II',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                trailing: Icon(
                                  item.status == 'banned'
                                      ? Icons.block
                                      : Icons.add_circle_outline,
                                  size: 18,
                                ),
                                onTap: () => _add(item),
                              ),
                            );
                          },
                        ),
                      ),
                    if (!state.isSearching &&
                        state.items.isEmpty &&
                        state.searchError == null)
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Không tìm thấy thành phần.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    if (state.searchError != null)
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: inventoryTextButtonTextStyle,
                        ),
                        onPressed: () => state.items.isEmpty
                            ? _controller.searchChanged(_search.text)
                            : _controller.loadMore(),
                        child: Text('${state.searchError} Thử lại'),
                      ),
                  ],
                ),
              ),
            ],
            if (state.isChecking)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Đang kiểm tra…', style: TextStyle(fontSize: 12)),
              ),
            if (state.check?.blocksUse == true)
              Container(
                key: const ValueKey('inventory-ingredient-check'),
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDE9E7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  state.check!.message,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: Colors.red.shade900,
                  ),
                ),
              ),
            if (state.checkError != null)
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: inventoryTextButtonTextStyle,
                ),
                onPressed: () => _controller.checkNow(_text.text),
                child: Text('${state.checkError} Kiểm tra lại'),
              ),
          ],
        ),
      ),
    );
  }
}
