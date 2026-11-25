import 'dart:typed_data';

typedef LocalCaseEvidence = ({Uint8List bytes, String fileName});

class CaseEvidenceDraft {
  List<LocalCaseEvidence> _images = const [];
  final _uploaded = <LocalCaseEvidence, String>{};

  List<LocalCaseEvidence> get images => _images;

  void replace(List<LocalCaseEvidence> images) {
    _images = List.unmodifiable(images);
    _uploaded.removeWhere((image, _) => !_images.contains(image));
  }

  Future<List<String>?> upload({
    required Future<String> Function(Uint8List, String) uploadImage,
    required bool Function() isActive,
  }) async {
    final urls = <String>[];
    for (final image in _images) {
      final url =
          _uploaded[image] ?? await uploadImage(image.bytes, image.fileName);
      if (!isActive()) return null;
      // Keep each completed upload available for a retry of the same draft.
      _uploaded[image] = url;
      urls.add(url);
    }
    return urls;
  }
}
