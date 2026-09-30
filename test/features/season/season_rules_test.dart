import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/features/season/domain/season_rules.dart';

void main() {
  group('replacement reason', () {
    test('is required after whitespace normalization', () {
      expect(
        SeasonRules.validateReplacementReason('   \n  '),
        'Vui lòng nhập lý do thay nhân sự.',
      );
    });

    test('accepts exactly the maximum length', () {
      expect(
        SeasonRules.validateReplacementReason(
          List<String>.filled(
            SeasonRules.replacementReasonMaxLength,
            'a',
          ).join(),
        ),
        isNull,
      );
    });

    test('rejects input beyond the maximum length', () {
      expect(
        SeasonRules.validateReplacementReason(
          List<String>.filled(
            SeasonRules.replacementReasonMaxLength + 1,
            'a',
          ).join(),
        ),
        isNotNull,
      );
    });
  });
}
