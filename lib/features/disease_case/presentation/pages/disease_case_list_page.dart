import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import '../../domain/domain.dart';
import '../view_models/disease_case_controller.dart';
import '../widgets/case_ui.dart';

class DiseaseCaseListPage extends ConsumerStatefulWidget {
  const DiseaseCaseListPage({super.key, required this.seasonId});
  final String seasonId;
  @override
  ConsumerState<DiseaseCaseListPage> createState() =>
      _DiseaseCaseListPageState();
}

class _DiseaseCaseListPageState extends ConsumerState<DiseaseCaseListPage> {
  int _page = 1;
  bool _resolved = false;
  @override
  Widget build(BuildContext context) {
    final provider = diseaseCaseListProvider((
      seasonId: widget.seasonId,
      page: _page,
      status: null,
      resolved: _resolved,
    ));
    final result = ref.watch(provider);
    final data = result.value;
    return CaseFrame(
      title: 'Ca bệnh',
      subtitle: data == null ? null : caseContext(data.season),
      child: Column(
        children: [
          if (data?.canCreate == true)
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 3, 5, 12),
              child: CasePrimaryButton(
                label: 'Tạo ca bệnh',
                icon: Icons.add,
                onPressed: () => context.push(
                  '/seasons/${widget.seasonId}/disease-cases/create',
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFD6EAF9),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  _tab(
                    false,
                    'Đang xử lý${data == null ? '' : ' (${data.ongoingCount})'}',
                  ),
                  _tab(
                    true,
                    'Đã giải quyết${data == null ? '' : ' (${data.resolvedCount})'}',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: result.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => CaseFailure(
                error: error,
                retry: () => ref.invalidate(provider),
              ),
              data: (page) => RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(provider);
                  await ref.read(provider.future);
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 24),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    if (!page.canCreate && page.existingCaseId != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextButton.icon(
                          onPressed: () => context.push(
                            '/seasons/${widget.seasonId}/disease-cases/${page.existingCaseId}',
                          ),
                          icon: const Icon(
                            Icons.medical_information_outlined,
                            size: 16,
                          ),
                          label: const Text(
                            'Mở ca đang xử lý của vụ',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    if (page.items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 56),
                        child: Column(
                          children: [
                            Icon(
                              Icons.health_and_safety_outlined,
                              color: AppColors.inkMuted.withValues(alpha: .6),
                              size: 38,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _resolved
                                  ? 'Chưa có ca bệnh đã giải quyết.'
                                  : 'Chưa có ca bệnh đang xử lý.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.inkMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    for (final item in page.items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CaseCard(
                          item: item,
                          onTap: () => context.push(
                            '/seasons/${widget.seasonId}/disease-cases/${item.id}',
                          ),
                        ),
                      ),
                    if (page.totalResults > 20 || _page > 1)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            tooltip: 'Trang trước',
                            onPressed: _page > 1
                                ? () => setState(() => _page--)
                                : null,
                            icon: const Icon(Icons.chevron_left),
                          ),
                          Text(
                            'Trang $_page • ${page.totalResults} ca bệnh',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Trang sau',
                            onPressed: page.hasNextPage
                                ? () => setState(() => _page++)
                                : null,
                            icon: const Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(bool resolved, String label) => Expanded(
    child: Semantics(
      selected: _resolved == resolved,
      button: true,
      child: TextButton(
        onPressed: () => setState(() {
          _resolved = resolved;
          _page = 1;
        }),
        style: TextButton.styleFrom(
          backgroundColor: _resolved == resolved
              ? const Color(0xFF187DD8)
              : const Color(0xFFEAF4FF),
          foregroundColor: _resolved == resolved
              ? Colors.white
              : AppColors.inkSoft,
          minimumSize: const Size(0, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        ),
        child: Text(
          label,
          maxLines: 1,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: 12,
            color: _resolved == resolved ? Colors.white : AppColors.inkSoft,
            fontWeight: _resolved == resolved
                ? FontWeight.w700
                : FontWeight.w500,
          ),
        ),
      ),
    ),
  );
}

class _CaseCard extends StatelessWidget {
  const _CaseCard({required this.item, required this.onTap});
  final DiseaseCase item;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final expert = item.expert?['fullName'];
    return Semantics(
      button: true,
      label: item.title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: CaseSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBE6EA),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.health_and_safety_rounded,
                        size: 17,
                        color: caseRose,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 110),
                      child: CaseStatusBadge(item.status),
                    ),
                  ],
                ),
                if (item.description?.isNotEmpty == true)
                  Padding(
                    padding: const EdgeInsets.only(left: 44, top: 4),
                    child: Text(
                      item.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: AppColors.inkSoft,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  '${expert is String && expert.isNotEmpty ? expert : 'Chưa có tên chuyên gia'} · ${item.responseCount} phản hồi',
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
