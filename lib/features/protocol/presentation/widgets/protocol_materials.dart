import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/view_models/protocol_controller.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart';

/// Evidence is paged locally; catalog queries run only when the Owner opens a selector.
class ProtocolMaterials extends StatefulWidget {
  const ProtocolMaterials({
    required this.detail,
    this.onSelectionsChanged,
    this.busy = false,
    super.key,
  });
  final ProtocolDetail detail;
  final ValueChanged<Map<String, String>>? onSelectionsChanged;
  final bool busy;
  @override
  State<ProtocolMaterials> createState() => _ProtocolMaterialsState();
}

class _ProtocolMaterialsState extends State<ProtocolMaterials> {
  final _selected = <String, ProtocolMaterialOption>{};
  int _page = 0;
  static const _pageSize = 20;
  @override
  Widget build(BuildContext context) {
    final rows = widget.detail.materialReviews;
    final canChoose =
        widget.onSelectionsChanged != null && widget.detail.canReview;
    return ProtocolSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vật tư và căn cứ đề xuất (${rows.length} hạng mục)',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (widget.detail.sourceTemplateVersionNo case final version?)
            Text(
              'Khởi tạo từ mẫu phiên bản $version; nội dung phác đồ được lưu độc lập.',
            ),
          if (canChoose)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Đề xuất chưa phải vật tư được phép thực thi. Chọn catalog đủ hồ sơ của trang trại trước khi duyệt. Hệ thống không tự tạo sản phẩm hoặc nhà sản xuất.',
              ),
            ),
          ...rows.skip(_page * _pageSize).take(_pageSize).map((row) {
            final chosen = _selected[row.itemId];
            final pending = row.requiresResolution && chosen == null;
            return ExpansionTile(
              key: ValueKey('${row.itemId}:$_page'),
              tilePadding: EdgeInsets.zero,
              title: Text(row.name),
              subtitle: Text(
                'DOC ${row.firstDay}–${row.lastDay} · ${row.mealNumber == null ? 'Môi trường' : 'Cữ ${row.mealNumber}'} · ${row.plannedTime?.substring(0, 5) ?? 'Chưa đặt giờ'}',
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${row.doseValue} ${protocolUnit(row.doseUnit)} · ${_basis(row.doseBasis)} / lần',
                    ),
                    Text(
                      'Lặp mỗi ${row.repeatIntervalDays} ngày, mốc DOC ${row.recurrenceAnchorDay}.',
                    ),
                    Text(
                      'Tăng ${row.dailyDoseIncrement} ${protocolUnit(row.doseUnit)}/ngày, liều gốc tại DOC ${row.doseAnchorDay}.',
                    ),
                    if (row.proposed case final proposed?)
                      _MaterialEvidence(
                        title: 'Đề xuất gốc của Expert',
                        material: proposed,
                        manufacturerId: row.recommendedManufacturerId,
                      ),
                    if (row.catalog case final catalog?)
                      _MaterialEvidence(
                        title: 'Vật tư catalog',
                        material: catalog,
                      ),
                    if (chosen?.material case final material?)
                      _MaterialEvidence(
                        title: 'Vật tư Owner chọn để thực thi',
                        material: material,
                      ),
                    if (pending)
                      Text(
                        row.resolutionMessage ??
                            'Cần chọn vật tư đủ điều kiện.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    if (canChoose)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: OutlinedButton(
                          onPressed: widget.busy
                              ? null
                              : () async {
                                  final option =
                                      await showModalBottomSheet<
                                        ProtocolMaterialOption
                                      >(
                                        context: context,
                                        isScrollControlled: true,
                                        useSafeArea: true,
                                        builder: (_) => _MaterialOptions(
                                          id: widget.detail.card.id,
                                          itemId: row.itemId,
                                        ),
                                      );
                                  if (!mounted || option == null) return;
                                  setState(
                                    () => _selected[row.itemId] = option,
                                  );
                                  widget.onSelectionsChanged?.call(
                                    _selected.map(
                                      (key, value) => MapEntry(key, value.id),
                                    ),
                                  );
                                },
                          child: Text(
                            chosen == null
                                ? 'Chọn catalog đủ điều kiện'
                                : 'Đổi vật tư đã chọn: ${chosen.name}',
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            );
          }),
          if (rows.length > _pageSize)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _page == 0 ? null : () => setState(() => _page--),
                  child: const Text('Trước'),
                ),
                Text('${_page + 1}/${(rows.length / _pageSize).ceil()}'),
                TextButton(
                  onPressed: (_page + 1) * _pageSize >= rows.length
                      ? null
                      : () => setState(() => _page++),
                  child: const Text('Tiếp'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

String _basis(String value) => switch (value) {
  'FIXED_QUANTITY' => 'liều cố định',
  'PER_KG_BIOMASS' => 'trên kg sinh khối',
  'PERCENT_BIOMASS' => '% sinh khối',
  'PER_M3_WATER' => 'trên m³ nước',
  _ => value,
};

class _MaterialEvidence extends StatelessWidget {
  const _MaterialEvidence({
    required this.title,
    required this.material,
    this.manufacturerId,
  });
  final String title;
  final ProtocolMaterialSnapshot material;
  final String? manufacturerId;
  @override
  Widget build(BuildContext context) {
    final profile = material.productCompliance;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            '${material.name} · ${material.category} · ${protocolUnit(material.unit)}',
          ),
          if (material.description case final description?) Text(description),
          Text(
            'Nhà sản xuất: ${material.manufacturer?.name ?? material.manufacturerId ?? manufacturerId ?? 'Chưa xác định'}',
          ),
          if (material.manufacturer?.address case final address?) Text(address),
          if (material.conversionQuantity case final quantity?)
            Text(
              'Quy đổi: $quantity ${material.conversionUnit ?? ''} / ${material.unit}',
            ),
          Text(
            'Hồ sơ: ${profile?.complianceStatus ?? 'Chưa được kiểm duyệt'} · ${profile?.regulatoryType ?? 'Chưa phân loại'}',
          ),
          if (profile?.registrationNumber case final number?)
            Text('Số tiếp nhận/ĐKLH: $number'),
          if (profile?.ingredientsText case final ingredients?)
            Text('Thành phần: $ingredients'),
          Text(
            'Kháng sinh: ${profile?.containsAntibiotic == null
                ? 'Chưa xác định'
                : profile!.containsAntibiotic!
                ? 'Có'
                : 'Không'}',
          ),
          if (profile?.usageInstructions case final instructions?)
            Text('Theo nhãn: $instructions'),
          if (profile?.withdrawalDays case final days?)
            Text('Ngừng thuốc: $days ngày'),
          if (profile?.checkedAt case final checked?)
            Text('Đối chiếu: ${protocolDate(checked, year: true, time: true)}'),
          if (profile?.reviewNote case final note?) Text(note),
          if (material.recommendationReason case final reason?)
            Text('Lý do: $reason'),
          for (final evidence in profile?.evidenceUrls ?? <String>[])
            SelectableText('Nguồn hồ sơ: $evidence'),
        ],
      ),
    );
  }
}

class _MaterialOptions extends ConsumerStatefulWidget {
  const _MaterialOptions({required this.id, required this.itemId});
  final String id, itemId;
  @override
  ConsumerState<_MaterialOptions> createState() => _MaterialOptionsState();
}

class _MaterialOptionsState extends ConsumerState<_MaterialOptions> {
  Timer? _debounce;
  String _search = '';
  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = (id: widget.id, itemId: widget.itemId, search: _search);
    final state = ref.watch(protocolMaterialOptionsProvider(scope));
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .65,
        child: Column(
          children: [
            Text(
              'Vật tư đủ điều kiện của trang trại',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Tìm theo tên vật tư',
              ),
              onChanged: (value) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  if (mounted) setState(() => _search = value.trim());
                });
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => ProtocolFailure(
                  error: error,
                  onRetry: () =>
                      ref.invalidate(protocolMaterialOptionsProvider(scope)),
                ),
                data: (rows) => rows.isEmpty
                    ? const Center(
                        child: Text(
                          'Chưa có vật tư phù hợp đủ hồ sơ. Hãy bổ sung catalog trước khi duyệt.',
                        ),
                      )
                    : ListView.builder(
                        itemCount: rows.length,
                        itemBuilder: (context, index) {
                          final row = rows[index];
                          return ListTile(
                            title: Text(row.name),
                            subtitle: Text(
                              '${row.manufacturerName} · ${protocolUnit(row.unit)}',
                            ),
                            onTap: () => Navigator.of(context).pop(row),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
