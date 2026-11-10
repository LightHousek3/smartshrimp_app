import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';
import 'package:smartshrimp_app/features/inventory/domain/entities/inventory_substance.dart';

part 'inventory_label.freezed.dart';
part 'inventory_label.g.dart';

typedef InventoryLabelImage = ({Uint8List? bytes, String? url});

/// Suggestions remain separate from saved product and compliance records.
@freezed
abstract class InventoryLabelResult with _$InventoryLabelResult {
  const InventoryLabelResult._();

  const factory InventoryLabelResult({
    String? name,
    String? manufacturerName,
    String? regulatoryType,
    String? registrationNumber,
    String? ingredientsText,
    String? usageInstructions,
    bool? containsAntibiotic,
    double? withdrawalDays,
    InventorySubstanceCheck? substanceCheck,
    @Default(<String, String>{}) Map<String, String> evidence,
    @Default(<String>[]) List<String> warnings,
  }) = _InventoryLabelResult;

  factory InventoryLabelResult.fromJson(Map<String, dynamic> json) =>
      _$InventoryLabelResultFromJson(json);

  static InventoryLabelResult parse(Map<String, dynamic> json) {
    try {
      const fields = [
        'name',
        'manufacturerName',
        'regulatoryType',
        'registrationNumber',
        'ingredientsText',
        'usageInstructions',
        'containsAntibiotic',
        'withdrawalDays',
        'evidence',
        'warnings',
      ];
      if (!fields.every(json.containsKey) ||
          json['evidence'] is! Map ||
          json['warnings'] is! List) {
        throw const InvalidResponseException();
      }
      if (json['substanceCheck'] != null) {
        InventorySubstanceCheck.parse(
          Map<String, dynamic>.from(json['substanceCheck'] as Map),
        );
      }
      final result = InventoryLabelResult.fromJson(json);
      if (result.regulatoryType != null &&
          !const {
            'unclassified',
            'feed',
            'environment',
            'dual_purpose',
            'medicine',
          }.contains(result.regulatoryType)) {
        throw const InvalidResponseException();
      }
      if (result.withdrawalDays != null &&
          (!result.withdrawalDays!.isFinite ||
              result.withdrawalDays! < 0 ||
              result.withdrawalDays! > 9999.999)) {
        throw const InvalidResponseException();
      }
      for (final field in fields.take(8)) {
        if (json[field] != null &&
            (result.evidence[field]?.trim().isEmpty ?? true)) {
          throw const InvalidResponseException();
        }
      }
      return result;
    } on AppException {
      rethrow;
    } catch (_) {
      throw const InvalidResponseException();
    }
  }
}
