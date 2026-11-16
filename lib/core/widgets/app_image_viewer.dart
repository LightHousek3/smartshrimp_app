import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';
import 'app_svg_icon.dart';

/// Open the gallery above shell navigation, using the diagnosis photo sheet layout.
Future<void> showAppImageViewer(
  BuildContext context, {
  required WidgetBuilder builder,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
    ),
    builder: builder,
  );
}

/// Shared gallery presentation; each feature owns image loading and URL refresh.
class AppImageViewer extends StatefulWidget {
  const AppImageViewer({
    required this.itemCount,
    required this.initialIndex,
    required this.imageBuilder,
    this.selectionColor = AppColors.ocean,
    this.titleStyle,
    this.closeIcon,
    this.footer,
    super.key,
  }) : assert(itemCount >= 0),
       assert(initialIndex >= 0);

  final int itemCount;
  final int initialIndex;
  final Widget Function(int index, BoxFit fit) imageBuilder;
  final Color selectionColor;
  final TextStyle? titleStyle;
  final Widget? closeIcon;
  final Widget? footer;

  @override
  State<AppImageViewer> createState() => _AppImageViewerState();
}

class _AppImageViewerState extends State<AppImageViewer> {
  late int _index = widget.initialIndex;

  int get _currentIndex =>
      widget.itemCount == 0 ? 0 : _index.clamp(0, widget.itemCount - 1);

  @override
  void didUpdateWidget(covariant AppImageViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _index = widget.initialIndex;
    }
    _index = _currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * .78,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.itemCount == 0
                          ? 'Không có ảnh'
                          : 'Ảnh ${index + 1}/${widget.itemCount}',
                      style:
                          widget.titleStyle ??
                          AppTypography.display(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            height: 1.5,
                          ).copyWith(
                            fontFamilyFallback: const ['PlusJakartaSans'],
                          ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Đóng',
                    onPressed: () => Navigator.pop(context),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFEEF1F6),
                    ),
                    icon:
                        widget.closeIcon ??
                        const AppSvgIcon(AppSvgIconName.close, size: 18),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEEF1F6)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox.expand(
                    child: widget.itemCount > 0
                        ? InteractiveViewer(
                            key: ValueKey(index),
                            maxScale: 4,
                            child: widget.imageBuilder(index, BoxFit.contain),
                          )
                        : const Center(child: Text('Không tải được ảnh.')),
                  ),
                ),
              ),
            ),
            if (widget.footer != null) widget.footer!,
            if (widget.itemCount > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: SizedBox(
                  height: 66,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.itemCount,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => Semantics(
                      button: true,
                      selected: i == index,
                      label: 'Xem ảnh ${i + 1} trong thư viện',
                      child: GestureDetector(
                        onTap: () => setState(() => _index = i),
                        child: Container(
                          width: 64,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: i == index
                                  ? widget.selectionColor
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Opacity(
                            opacity: i == index ? 1 : .6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: widget.imageBuilder(i, BoxFit.cover),
                            ),
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
    );
  }
}
