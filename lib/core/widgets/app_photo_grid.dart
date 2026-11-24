import 'package:flutter/material.dart';
import 'package:smartshrimp_app/app/theme/app_theme.dart';

/// Square image thumbnails with a shared layout for evidence and diagnosis photos.
class AppPhotoGrid extends StatelessWidget {
  const AppPhotoGrid({
    required this.itemCount,
    required this.imageBuilder,
    required this.labelBuilder,
    required this.onOpen,
    this.overlayBuilder,
    super.key,
  });

  final int itemCount;
  final Widget Function(int index) imageBuilder;
  final String Function(int index) labelBuilder;
  final ValueChanged<int> onOpen;
  final Widget Function(int index)? overlayBuilder;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const gap = 8.0;
      final minWidth = MediaQuery.textScalerOf(context).scale(68);
      final columns = ((constraints.maxWidth + gap) / (minWidth + gap))
          .floor()
          .clamp(1, 3);
      final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (var index = 0; index < itemCount; index++)
            SizedBox.square(
              dimension: width,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Semantics(
                    button: true,
                    label: 'Xem ảnh ${labelBuilder(index).toLowerCase()}',
                    child: Material(
                      color: const Color(0xFFEEF1F6),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.line),
                      ),
                      child: InkWell(
                        onTap: () => onOpen(index),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            imageBuilder(index),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                color: const Color(0x99000000),
                                child: Text(
                                  labelBuilder(index),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (overlayBuilder case final buildOverlay?)
                    Positioned(top: 4, right: 4, child: buildOverlay(index)),
                ],
              ),
            ),
        ],
      );
    },
  );
}
