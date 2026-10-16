import 'dart:typed_data';

abstract interface class InventoryImageStorage {
  Future<String> upload({required Uint8List bytes, required String fileName});
}
