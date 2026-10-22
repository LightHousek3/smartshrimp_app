import 'dart:typed_data';

/// Return a stored image URL without exposing the upload provider to the UI.
abstract interface class InventoryImageStorage {
  Future<String> upload({required Uint8List bytes, required String fileName});
}
