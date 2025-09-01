import 'package:flutter_test/flutter_test.dart';
import 'package:decimal/decimal.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';
import 'package:rubi_bank_app/core/utils/decimal_precision.dart';

void main() {
  group('DecimalPrecision Extensions', () {
    test('Convert DecimalPrecision to Decimal (basic)', () {
      final dp = DecimalPrecision((b) => b
        ..coefficient = '31410'
        ..scale = 2);

      final decimal = dp.toDecimal();
      expect(decimal, Decimal.parse('314.10')); // numeric compare
    });

    test('Convert Decimal to DecimalPrecision (fraction with trailing zero)', () {
      final decimal = Decimal.parse('314.10');
      final dp = DecimalPrecisionExtensions.fromDecimal(decimal, scaleHint: 2);

      expect(dp.coefficient, '31410');
      expect(dp.scale, 2);
      expect(dp.toDecimal(), Decimal.parse('314.10'));
    });

    test('Convert integer Decimal to DecimalPrecision', () {
      final decimal = Decimal.parse('42');
      final dp = DecimalPrecisionExtensions.fromDecimal(decimal);

      expect(dp.coefficient, '42');
      expect(dp.scale, 0);
      expect(dp.toDecimal(), Decimal.parse('42'));
    });

    test('Convert Decimal with multiple fraction digits', () {
      final decimal = Decimal.parse('123.456789');
      final dp = DecimalPrecisionExtensions.fromDecimal(decimal);

      expect(dp.coefficient, '123456789');
      expect(dp.scale, 6);
      expect(dp.toDecimal(), Decimal.parse('123.456789'));
    });

    test('Convert Decimal with leading zeros in fraction', () {
      final decimal = Decimal.parse('0.00123');
      final dp = DecimalPrecisionExtensions.fromDecimal(decimal);

      expect(dp.coefficient, '123');
      expect(dp.scale, 5);
      expect(dp.toDecimal(), Decimal.parse('0.00123'));
    });

    test('Convert negative Decimal to DecimalPrecision', () {
      final decimal = Decimal.parse('-987.65');
      final dp = DecimalPrecisionExtensions.fromDecimal(decimal, scaleHint: 2);

      expect(dp.coefficient, '-98765');
      expect(dp.scale, 2);
      expect(dp.toDecimal(), Decimal.parse('-987.65'));
    });

    test('Round trip conversion preserves numeric equality', () {
      final original = Decimal.parse('12345.6789');
      final dp = DecimalPrecisionExtensions.fromDecimal(original);
      final roundTrip = dp.toDecimal();

      expect(roundTrip, original);
    });

    test('fromDecimal respects scaleHint larger than fraction', () {
      final decimal = Decimal.parse('7.1');
      final dp = DecimalPrecisionExtensions.fromDecimal(decimal, scaleHint: 3);

      expect(dp.coefficient, '710');
      expect(dp.scale, 3);
      expect(dp.toDecimal(), Decimal.parse('7.10')); // numeric equality
    });

    test('fromDecimal with scale = 0 (integer only)', () {
      final decimal = Decimal.parse('1000');
      final dp = DecimalPrecisionExtensions.fromDecimal(decimal);

      expect(dp.coefficient, '1000');
      expect(dp.scale, 0);
      expect(dp.toDecimal(), Decimal.parse('1000'));
    });

    test('Convert small decimal with many fraction digits (scale limit)', () {
      final decimal = Decimal.parse('0.1234567890');
      final dp = DecimalPrecisionExtensions.fromDecimal(decimal);

      expect(dp.coefficient, '1234567890');
      expect(dp.scale, 10);
      expect(dp.toDecimal(), Decimal.parse('0.1234567890'));
    });
  });
}

