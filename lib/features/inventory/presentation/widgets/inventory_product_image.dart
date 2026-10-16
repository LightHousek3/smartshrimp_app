import 'package:flutter/material.dart';

class InventoryProductImage extends StatelessWidget {
  const InventoryProductImage({
    this.url,
    this.size = 48,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    super.key,
  });
  final String? url;
  final double size;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: SizedBox(
      width: width ?? size,
      height: height ?? size,
      child: url == null
          ? _placeholder()
          : Image.network(
              url!,
              fit: fit,
              semanticLabel: 'Ảnh vật tư',
              loadingBuilder: (_, child, progress) =>
                  progress == null ? child : _placeholder(),
              errorBuilder: (_, error, stackTrace) => _placeholder(),
            ),
    ),
  );

  Widget _placeholder() => ColoredBox(
    color: const Color(0xFFEAF4FF),
    child: Center(
      child: Icon(
        Icons.inventory_2_outlined,
        size: size > 80 ? 44 : 24,
        color: const Color(0xFF1D7AD6),
      ),
    ),
  );
}
