import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_compliance.freezed.dart';
part 'inventory_compliance.g.dart';

/// Label facts and the account that confirmed them at the write boundary.
@freezed
abstract class InventoryCompliance with _$InventoryCompliance {
  const InventoryCompliance._();

  const factory InventoryCompliance({
    String? regulatoryType,
    String? registrationNumber,
    String? ingredientsText,
    bool? containsAntibiotic,
    String? usageInstructions,
    double? withdrawalDays,
    @Default(<String>[]) List<String> evidenceUrls,
    String? checkedBy,
    DateTime? checkedAt,
  }) = _InventoryCompliance;

  factory InventoryCompliance.fromJson(Map<String, dynamic> json) =>
      _$InventoryComplianceFromJson(json);

  /// Exclude server-owned declaration stamps from client write payloads.
  Map<String, dynamic> toDraftJson() => {
    'regulatoryType': regulatoryType,
    'registrationNumber': registrationNumber,
    'ingredientsText': ingredientsText,
    'containsAntibiotic': containsAntibiotic,
    'usageInstructions': usageInstructions,
    'withdrawalDays': withdrawalDays,
    'evidenceUrls': evidenceUrls,
  };
}
