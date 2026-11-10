import 'dart:convert';

import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/data/services/inventory_label_api_service.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_label.dart';
import 'package:smartshrimp_app/features/inventory/domain/inventory_rules.dart';
import 'package:smartshrimp_app/features/inventory/domain/repositories/inventory_label_repository.dart';

final class InventoryLabelRepositoryImpl implements InventoryLabelRepository {
  InventoryLabelRepositoryImpl(this._api);

  final InventoryLabelApiService _api;

  @override
  Future<InventoryLabelResult> scan({
    required String farmId,
    required List<InventoryLabelImage> images,
  }) {
    if (images.isEmpty || images.length > InventoryRules.maxProductImages) {
      throw const ApiException(
        'Chọn từ 1 đến 3 ảnh nhãn của cùng một sản phẩm.',
      );
    }
    var totalBytes = 0;
    final payload = <Map<String, String>>[];
    for (final image in images) {
      if ((image.bytes == null) == (image.url == null)) {
        throw const ApiException('Ảnh nhãn không hợp lệ. Hãy chọn lại ảnh.');
      }
      final bytes = image.bytes;
      if (bytes != null) {
        InventoryRules.validateImage(bytes);
        totalBytes += bytes.length;
        payload.add({'data': base64Encode(bytes)});
      } else {
        final url = image.url!;
        final uri = Uri.tryParse(url);
        if (uri == null ||
            uri.scheme != 'https' ||
            uri.host.isEmpty ||
            url.length > 2048) {
          throw const ApiException('Đường dẫn ảnh nhãn không hợp lệ.');
        }
        payload.add({'url': url});
      }
    }
    if (totalBytes > InventoryRules.maxOcrTotalBytes) {
      throw const ApiException(
        'Tổng ảnh OCR không được vượt quá 5 MB. Hãy chọn ít ảnh hơn hoặc giảm dung lượng.',
      );
    }
    return _api.scan(farmId, payload);
  }
}
