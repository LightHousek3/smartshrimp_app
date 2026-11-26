import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartshrimp_app/core/utils/vietnamese_number.dart';
import 'package:smartshrimp_app/core/utils/vietnamese_number_input_formatter.dart';

void main() {
  const formatter = VietnameseNumberInputFormatter();

  TextEditingValue edit(
    String old,
    String next, {
    int? caret,
    bool replace = false,
  }) => formatter.formatEditUpdate(
    TextEditingValue(
      text: old,
      selection: TextSelection(
        baseOffset: replace ? 0 : old.length,
        extentOffset: old.length,
      ),
    ),
    TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: caret ?? next.length),
    ),
  );

  test('parses Vietnamese groups and validates the entire value', () {
    expect(normalizeVietnameseNumber('500.000'), '500000');
    expect(normalizeVietnameseNumber('1.250,375'), '1250.375');
    expect(normalizeVietnameseNumber('1,250'), '1.250');
    expect(normalizeVietnameseNumber('0.001'), '0.001');
    expect(normalizeVietnameseNumber(',1'), '0.1');
    expect(normalizeVietnameseNumber('1.250', groupThousands: false), '1.250');
    expect(parseVietnameseInteger('10.000'), 10000);
    expect(parseVietnameseInteger('1,250'), isNull);
    for (final value in [
      '12.34,5',
      '1..250',
      '12abc3',
      '1.25.000',
      '1e6',
      'NaN',
    ]) {
      expect(normalizeVietnameseNumber(value), isNull, reason: value);
    }
  });

  test(
    'formats large numbers and tiny quantities without changing precision',
    () {
      expect(formatVietnameseNumber(500000), '500.000');
      expect(formatVietnameseNumber(-1250.375), '-1.250,375');
      expect(formatVietnameseNumber(0.000000001), '0,000000001');
      expect(formatVietnameseNumber(9007199254740991), '9.007.199.254.740.991');
      expect(
        formatVietnameseDecimal('99999999999.000000001'),
        '99.999.999.999,000000001',
      );
    },
  );

  test('groups live edits, preserves the caret and keeps decimal intent', () {
    expect(edit('500', '5000').text, '5.000');
    expect(edit('5.000', '5.0000').text, '50.000');
    final middle = edit('1.250', '1.9250', caret: 3);
    expect(middle.text, '19.250');
    expect(middle.selection.extentOffset, 2);
    expect(edit('1.250', '1.25').text, '125');
    expect(edit('1.250,00', '1.25,00', caret: 4).text, '125,00');
    expect(edit('1.250', '1.25050', caret: 5).text, '125.050');
    expect(edit('1.250', '1250', caret: 1).selection.extentOffset, 1);
    expect(edit('1.250', '1.250.').text, '1.250,');
    expect(edit('1', '1.').text, '1,');
    expect(edit('', '1.250').text, '1.250');
    expect(edit('1.250', '1.250,375', replace: true).text, '1.250,375');
    expect(edit('', '0001').text, '1');
    expect(edit('', '12.34,5').text, '12.34,5');
  });
}
