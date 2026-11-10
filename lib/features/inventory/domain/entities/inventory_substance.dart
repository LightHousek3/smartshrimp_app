import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smartshrimp_app/core/errors/app_exception.dart';

part 'inventory_substance.freezed.dart';
part 'inventory_substance.g.dart';

bool _validSubstance(InventorySubstance item) =>
    item.id.trim().isNotEmpty &&
    item.name.trim().isNotEmpty &&
    item.group.trim().isNotEmpty &&
    item.sourceRow.trim().isNotEmpty &&
    item.page >= 2 &&
    ((item.status == 'banned' && item.appendix == 'I') ||
        (item.status == 'listed' && item.appendix == 'II'));

@freezed
abstract class InventorySubstance with _$InventorySubstance {
  const factory InventorySubstance({
    required String id,
    required String name,
    required String status,
    required String group,
    required String appendix,
    required String sourceRow,
    required int page,
    required String note,
    String? mention,
  }) = _InventorySubstance;
  factory InventorySubstance.fromJson(Map<String, dynamic> json) =>
      _$InventorySubstanceFromJson(json);
}

@freezed
abstract class InventorySubstancePage with _$InventorySubstancePage {
  const factory InventorySubstancePage({
    required List<InventorySubstance> items,
    required bool hasNextPage,
    String? nextCursor,
  }) = _InventorySubstancePage;
  factory InventorySubstancePage.fromJson(Map<String, dynamic> json) =>
      _$InventorySubstancePageFromJson(json);

  static InventorySubstancePage parse(
    Object? data,
    Map<String, dynamic>? meta,
  ) {
    try {
      final page = InventorySubstancePage.fromJson({
        'items': data,
        'hasNextPage': meta?['hasNextPage'],
        'nextCursor': meta?['nextCursor'],
      });
      if (page.items.length > 5 ||
          !page.items.every(_validSubstance) ||
          page.items.map((item) => item.id).toSet().length !=
              page.items.length ||
          (page.hasNextPage &&
              (page.items.isEmpty ||
                  page.nextCursor == null ||
                  !RegExp(r'^[1-9]\d*$').hasMatch(page.nextCursor!))) ||
          (!page.hasNextPage && page.nextCursor != null)) {
        throw const InvalidResponseException();
      }
      return page;
    } catch (_) {
      throw const InvalidResponseException();
    }
  }
}

@freezed
abstract class InventorySubstanceCheck with _$InventorySubstanceCheck {
  const InventorySubstanceCheck._();
  const factory InventorySubstanceCheck({
    required String status,
    required String message,
    @Default(<InventorySubstance>[]) List<InventorySubstance> matches,
  }) = _InventorySubstanceCheck;
  factory InventorySubstanceCheck.fromJson(Map<String, dynamic> json) =>
      _$InventorySubstanceCheckFromJson(json);

  bool get blocksUse => status != 'not_detected';
  static InventorySubstanceCheck parse(Map<String, dynamic> json) {
    try {
      final check = InventorySubstanceCheck.fromJson(json);
      if (!const {
            'blocked',
            'needs_review',
            'not_detected',
          }.contains(check.status) ||
          check.message.trim().isEmpty ||
          json['matches'] is! List ||
          !check.matches.every(
            (item) =>
                _validSubstance(item) &&
                item.status == 'banned' &&
                const {'present', 'negated'}.contains(item.mention),
          ) ||
          (check.status == 'not_detected' && check.matches.isNotEmpty) ||
          (check.status == 'blocked' &&
              !check.matches.any((item) => item.mention == 'present')) ||
          (check.status == 'needs_review' &&
              (check.matches.isEmpty ||
                  check.matches.any((item) => item.mention != 'negated')))) {
        throw const InvalidResponseException();
      }
      return check;
    } catch (_) {
      throw const InvalidResponseException();
    }
  }
}

@freezed
abstract class InventorySubstanceState with _$InventorySubstanceState {
  const factory InventorySubstanceState({
    @Default(<InventorySubstance>[]) List<InventorySubstance> items,
    @Default('') String query,
    @Default(false) bool isSearching,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasNextPage,
    String? nextCursor,
    String? searchError,
    @Default(false) bool isChecking,
    InventorySubstanceCheck? check,
    String? checkError,
  }) = _InventorySubstanceState;
}
