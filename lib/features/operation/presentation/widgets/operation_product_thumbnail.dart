import 'package:flutter/material.dart';

/// Hiển thị ảnh vật tư (từ `products.image_urls`), tự fallback về icon theo loại
/// khi vật tư chưa có ảnh, đang tải hoặc tải lỗi.
class OperationProductThumbnail extends StatelessWidget {
  const OperationProductThumbnail({
    required this.fallbackIcon,
    required this.fallbackBg,
    required this.fallbackFg,
    this.imageUrl,
    this.size = 36,
    this.borderRadius = 10,
    this.iconSize = 18,
    super.key,
  });

  final String? imageUrl;
  final IconData fallbackIcon;
  final Color fallbackBg;
  final Color fallbackFg;
  final double size;
  final double borderRadius;
  final double iconSize;

  Widget _buildFallback() => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: fallbackBg,
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    child: Icon(fallbackIcon, color: fallbackFg, size: iconSize),
  );

  @override
  Widget build(BuildContext context) {
    final trimmed = imageUrl?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return _buildFallback();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: Image.network(
          trimmed,
          fit: BoxFit.cover,
          semanticLabel: 'Ảnh vật tư',
          loadingBuilder: (_, child, progress) =>
              progress == null ? child : _buildFallback(),
          errorBuilder: (_, _, _) => _buildFallback(),
        ),
      ),
    );
  }
}
