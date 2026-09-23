import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/core/widgets/app_gradient_background.dart';
import 'package:smartshrimp_app/features/farm/presentation/widgets/farm_ui.dart';
import 'package:smartshrimp_app/features/pond/domain/entities/pond.dart';
import 'package:smartshrimp_app/features/pond/presentation/view_models/pond_controller.dart';

const _allFilterValue = Object();

class PondListPage extends ConsumerStatefulWidget {
  const PondListPage({required this.farmId, super.key});
  final String farmId;

  @override
  ConsumerState<PondListPage> createState() => _PondListPageState();
}

class _PondListPageState extends ConsumerState<PondListPage> {
  final _searchController = TextEditingController();
  PondStatus? _status;
  PondType? _type;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pondListControllerProvider(widget.farmId));
    final page = state.value;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/farms/${widget.farmId}/ponds/create'),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Thêm ao'),
      ),
      body: AppGradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              _header(context),
              _filters(),
              Expanded(
                child: page == null
                    ? state.when(
                        data: (_) => const SizedBox.shrink(),
                        loading: () => const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.ocean,
                          ),
                        ),
                        error: (error, _) => _PondError(
                          message: _message(error),
                          onRetry: () => ref
                              .read(
                                pondListControllerProvider(
                                  widget.farmId,
                                ).notifier,
                              )
                              .refresh(),
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.ocean,
                        onRefresh: ref
                            .read(
                              pondListControllerProvider(
                                widget.farmId,
                              ).notifier,
                            )
                            .refresh,
                        child: page.items.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: <Widget>[
                                  SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height * .5,
                                    child: const _PondEmpty(),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  8,
                                  20,
                                  100,
                                ),
                                itemCount:
                                    page.items.length +
                                    (page.hasNextPage ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == page.items.length) {
                                    return Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Center(
                                        child: state.isLoading
                                            ? const CircularProgressIndicator(
                                                color: AppColors.ocean,
                                              )
                                            : OutlinedButton(
                                                onPressed: ref
                                                    .read(
                                                      pondListControllerProvider(
                                                        widget.farmId,
                                                      ).notifier,
                                                    )
                                                    .loadMore,
                                                child: const Text(
                                                  'Tải trang tiếp theo',
                                                ),
                                              ),
                                      ),
                                    );
                                  }
                                  return _PondListCard(
                                    pond: page.items[index],
                                    onTap: () => context.push(
                                      '/farms/${widget.farmId}/ponds/${page.items[index].id}',
                                    ),
                                  );
                                },
                              ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
    child: Row(
      children: <Widget>[
        FarmCircleButton(
          icon: Icons.arrow_back_rounded,
          tooltip: 'Quay lại',
          onPressed: context.pop,
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Text(
            'Danh sách ao',
            style: TextStyle(
              color: AppColors.ink,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _filters() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: <Widget>[
        TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _applyFilters(),
          decoration: InputDecoration(
            hintText: 'Tìm theo tên ao',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: IconButton(
              tooltip: 'Tìm kiếm',
              onPressed: _applyFilters,
              icon: const Icon(Icons.arrow_forward_rounded),
            ),
          ),
        ),
        const SizedBox(height: 9),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              _MenuFilter<PondStatus>(
                label: 'Trạng thái',
                value: _status,
                values: const <PondStatus>[
                  PondStatus.available,
                  PondStatus.maintenance,
                  PondStatus.inactive,
                ],
                text: pondStatusLabel,
                onChanged: (value) {
                  setState(() => _status = value);
                  _applyFilters();
                },
              ),
              const SizedBox(width: 8),
              _MenuFilter<PondType>(
                label: 'Loại ao',
                value: _type,
                values: const <PondType>[
                  PondType.aquaculture,
                  PondType.waterTreatment,
                ],
                text: pondTypeLabel,
                onChanged: (value) {
                  setState(() => _type = value);
                  _applyFilters();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
      ],
    ),
  );

  void _applyFilters() {
    ref
        .read(pondListControllerProvider(widget.farmId).notifier)
        .applyFilters(
          search: _searchController.text,
          status: _status,
          type: _type,
          clearStatus: _status == null,
          clearType: _type == null,
        );
  }

  static String _message(Object error) =>
      error is AppException ? error.message : 'Không thể tải danh sách ao.';
}

class _MenuFilter<T> extends StatelessWidget {
  const _MenuFilter({
    required this.label,
    required this.value,
    required this.values,
    required this.text,
    required this.onChanged,
  });
  final String label;
  final T? value;
  final List<T> values;
  final String Function(T) text;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) => PopupMenuButton<Object>(
    initialValue: value,
    onSelected: (selected) =>
        onChanged(identical(selected, _allFilterValue) ? null : selected as T),
    itemBuilder: (_) => <PopupMenuEntry<Object>>[
      const PopupMenuItem<Object>(
        value: _allFilterValue,
        child: Text('Tất cả'),
      ),
      ...values.map(
        (item) => PopupMenuItem<Object>(value: item, child: Text(text(item))),
      ),
    ],
    child: Chip(
      avatar: const Icon(Icons.filter_alt_outlined, size: 17),
      label: Text(value == null ? label : text(value as T)),
    ),
  );
}

class _PondListCard extends StatelessWidget {
  const _PondListCard({required this.pond, required this.onTap});
  final Pond pond;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFE6F4FF),
        child: Icon(
          Icons.water_drop_rounded,
          color: AppColors.ocean,
        ),
      ),
      title: Text(
        pond.name,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      subtitle: Text(
        '${pondTypeLabel(pond.type)} • ${pondStatusLabel(pond.status)}\n'
        '${formatCompactNumber(pond.areaM2)} m² • ${formatCompactNumber(pond.volumeM3)} m³',
      ),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right_rounded),
    ),
  );
}

class _PondEmpty extends StatelessWidget {
  const _PondEmpty();
  @override
  Widget build(BuildContext context) => const Center(
    child: Padding(
      padding: EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.water_drop_outlined, size: 44, color: AppColors.inkMuted),
          SizedBox(height: 12),
          Text(
            'Không có ao phù hợp',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 5),
          Text('Hãy thay đổi bộ lọc hoặc tạo ao mới.'),
        ],
      ),
    ),
  );
}

class _PondError extends StatelessWidget {
  const _PondError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.cloud_off_rounded, size: 44),
        const SizedBox(height: 10),
        Text(message, textAlign: TextAlign.center),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Thử lại'),
        ),
      ],
    ),
  );
}

String pondTypeLabel(PondType type) => switch (type) {
  PondType.aquaculture => 'Ao nuôi',
  PondType.waterTreatment => 'Ao xử lý nước',
  PondType.unknown => 'Không xác định',
};

String pondStatusLabel(PondStatus status) => switch (status) {
  PondStatus.available => 'Sẵn sàng',
  PondStatus.maintenance => 'Bảo trì',
  PondStatus.inactive => 'Ngừng hoạt động',
  PondStatus.unknown => 'Không xác định',
};
