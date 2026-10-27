import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_compliance.freezed.dart';
part 'inventory_compliance.g.dart';

/// Keep label evidence separate from the product's business lifecycle.
/// The server derives readiness and audit fields from Owner-supplied facts.
@freezed
abstract class InventoryCompliance with _$InventoryCompliance {
  const InventoryCompliance._();

  const factory InventoryCompliance({
    @Default('unclassified') String regulatoryType,
    String? registrationNumber,
    String? ingredientsText,
    bool? containsAntibiotic,
    String? usageInstructions,
    double? withdrawalDays,
    @Default(<String>[]) List<String> evidenceUrls,
    @Default('draft') String complianceStatus,
    String? checkedBy,
    DateTime? checkedAt,
    String? reviewNote,
  }) = _InventoryCompliance;

  factory InventoryCompliance.fromJson(Map<String, dynamic> json) =>
      _$InventoryComplianceFromJson(json);

  /// Exclude server-managed review fields from an Owner's editable draft payload.
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
