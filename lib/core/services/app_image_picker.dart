import 'package:image_picker/image_picker.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

Future<List<XFile>> pickAppImages(
  ImagePicker picker, {
  required ImageSource source,
  required int limit,
}) async {
  if (limit <= 0) return const [];
  if (source == ImageSource.camera || limit == 1) {
    final file = await picker.pickImage(
      source: source,
      requestFullMetadata: false,
    );
    return [?file];
  }

  final files = await picker.pickMultiImage(
    limit: limit,
    requestFullMetadata: false,
  );
  // Some platforms ignore the native selection limit.
  if (files.length > limit) {
    throw ApiException('Bạn chỉ có thể thêm tối đa $limit ảnh trong lần này.');
  }
  return files;
}
