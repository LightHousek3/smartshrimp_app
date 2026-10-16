import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'package:smartshrimp_app/features/protocol/domain/entities/protocol.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_empty_state.dart';
import 'package:smartshrimp_app/features/protocol/presentation/view_models/protocol_controller.dart';
import 'package:smartshrimp_app/features/protocol/presentation/widgets/protocol_ui.dart';

class ProtocolListPage extends ConsumerStatefulWidget {
  const ProtocolListPage({
    this.seasonId,
    this.subtitle,
    this.pendingOnly = false,
    this.initialType = ProtocolType.production,
    super.key,
  });
  final String? seasonId;
  final String? subtitle;
  final bool pendingOnly;
  final ProtocolType initialType;
  @override
  ConsumerState<ProtocolListPage> createState() => _ProtocolListPageState();
}

class _ProtocolListPageState extends ConsumerState<ProtocolListPage> {
  late ProtocolType _type = widget.initialType;
  bool _loadingMore = false;
  @override
  Widget build(BuildContext context) {
    final scope = (
      seasonId: widget.seasonId,
      type: _type,
      pendingOnly: widget.pendingOnly,
    );
    final state = ref.watch(protocolListProvider(scope));
    final data = state.value;
    final subtitle =
        widget.subtitle ??
        (data != null && data.items.isNotEmpty && widget.seasonId != null
            ? '${data.items.first.pondName} · ${data.items.first.seasonName}'
            : null);
    return ProtocolFrame(
      title: widget.pendingOnly ? 'Phác đồ chờ duyệt' : 'Phác đồ',
      subtitle: subtitle,
      bottom: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xB3D3E8FF),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              for (final (type, label, count) in [
                (
                  ProtocolType.production,
                  'Phác đồ nuôi',
                  data?.productionCount,
                ),
                (ProtocolType.treatment, 'Điều trị', data?.treatmentCount),
              ])
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: type == ProtocolType.treatment ? 4 : 0,
                    ),
                    child: Semantics(
                      selected: _type == type,
                      button: true,
                      child: GestureDetector(
                        onTap: () => setState(() => _type = type),
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: _type == type
                                ? const Color(0xFF1D7AD6)
                                : const Color(0x8CFFFFFF),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: _type == type
                                ? const [
                                    BoxShadow(
                                      color: Color(0x1A000000),
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            '$label${count == null ? '' : ' ($count)'}',
                            style: TextStyle(
                              color: _type == type
                                  ? Colors.white
                                  : AppColors.inkSoft,
                              fontSize: 13,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(protocolListProvider(scope));
          await ref.read(protocolListProvider(scope).future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ...state.when(
              loading: () => [
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              error: (error, _) => [
                ProtocolFailure(
                  error: error,
                  onRetry: () => ref.invalidate(protocolListProvider(scope)),
                ),
              ],
              data: (page) => page.items.isEmpty
                  ? [const ProtocolEmptyState()]
                  : [
                      for (final item in page.items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProtocolCard(
                            data: item,
                            onTap: () => context.push('/protocols/${item.id}'),
                          ),
                        ),
                      if (page.hasNextPage)
                        OutlinedButton(
                          onPressed: _loadingMore
                              ? null
                              : () async {
                                  setState(() => _loadingMore = true);
                                  try {
                                    await ref
                                        .read(
                                          protocolListProvider(scope).notifier,
                                        )
                                        .loadMore();
                                  } catch (error) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(protocolError(error)),
                                        ),
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() => _loadingMore = false);
                                    }
                                  }
                                },
                          child: Text(_loadingMore ? 'Đang tải…' : 'Xem thêm'),
                        ),
                    ],
            ),
          ],
        ),
      ),
    );
  }
}
