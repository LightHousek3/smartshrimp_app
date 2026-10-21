import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/harvest/domain/entities/harvest_event.dart';
import 'package:smartshrimp_app/features/harvest/domain/repositories/harvest_submission_store.dart';

/// A single durable payload/key per owner and season survives form disposal and restart.
final class SecureHarvestSubmissionStore implements HarvestSubmissionStore {
  SecureHarvestSubmissionStore(this._storage);
  final FlutterSecureStorage _storage;

  // Serialize this slot across store instances so compare/delete cannot erase a newer write.
  static final _mutations = <String, Future<void>>{};

  Future<void> _mutate(String key, Future<void> Function() action) async {
    final previous = _mutations[key];
    final released = Completer<void>();
    _mutations[key] = released.future;
    try {
      if (previous != null) await previous;
      await action();
    } finally {
      released.complete();
      if (identical(_mutations[key], released.future)) _mutations.remove(key);
    }
  }

  String _key(String ownerId, String seasonId) =>
      'harvest_pending_v1_${base64Url.encode(utf8.encode(jsonEncode([ownerId, seasonId])))}';

  @override
  Future<PendingHarvestSubmission?> read(
    String ownerId,
    String seasonId,
  ) async {
    final raw = await _storage.read(key: _key(ownerId, seasonId));
    if (raw == null) return null;
    try {
      final submission = PendingHarvestSubmission.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      if (!RegExp(
            r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89aAbB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
          ).hasMatch(submission.key) ||
          !['PARTIAL', 'FINAL'].contains(submission.body['harvestType']) ||
          submission.body['harvestedAt'] is! String ||
          DateTime.tryParse(submission.body['harvestedAt'] as String) == null ||
          submission.body['totalWeightKg'] is! num) {
        throw const FormatException();
      }
      return submission;
    } on Object catch (_, stack) {
      // Never discard a corrupt pending key and silently enable another financial write.
      Error.throwWithStackTrace(
        const ApiException(
          'Không thể khôi phục lần thu hoạch đang chờ. Vui lòng liên hệ hỗ trợ trước khi ghi lại.',
        ),
        stack,
      );
    }
  }

  @override
  Future<void> write(
    String ownerId,
    String seasonId,
    PendingHarvestSubmission submission,
  ) => _mutate(
    _key(ownerId, seasonId),
    () => _storage.write(
      key: _key(ownerId, seasonId),
      value: jsonEncode(submission.toJson()),
    ),
  );

  @override
  Future<void> clear(
    String ownerId,
    String seasonId, {
    required String expectedKey,
  }) => _mutate(_key(ownerId, seasonId), () async {
    final current = await read(ownerId, seasonId);
    if (current?.key == expectedKey) {
      await _storage.delete(key: _key(ownerId, seasonId));
    }
  });
}
