import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';
import 'package:rubi_bank_api_sdk/rubi_bank_api_sdk.dart';

extension DecimalPrecisionExtensions on DecimalPrecision {
  Decimal toDecimal() {
    final coeffInt = BigInt.parse(coefficient);

    if (scale == 0) {
      return Decimal.fromBigInt(coeffInt);
    }

    final coeffStr = coeffInt.toString();
    final padded = coeffStr.padLeft(scale + 1, '0');
    final integerPart = padded.substring(0, padded.length - scale);
    final fractionPart = padded.substring(padded.length - scale);

    return Decimal.parse('$integerPart.$fractionPart');
  }

  /// From Decimal → may lose trailing zeros (Decimal doesn't preserve them)
  static DecimalPrecision fromDecimal(Decimal value, {int? scaleHint}) {
    final str = value.toString();

    if (!str.contains('.')) {
      return DecimalPrecision((b) => b
        ..coefficient = BigInt.parse(str).toString()
        ..scale = scaleHint ?? 0);
    }

    final parts = str.split('.');
    final integerPart = parts[0];
    var fractionPart = parts[1];

    // Use scaleHint if provided, else actual fraction length
    final targetScale = scaleHint ?? fractionPart.length;

    // Pad fractionPart to target scale
    if (fractionPart.length < targetScale) {
      fractionPart = fractionPart.padRight(targetScale, '0');
    } else if (fractionPart.length > targetScale) {
      fractionPart = fractionPart.substring(0, targetScale); // trim extra
    }

    final coefficient = BigInt.parse(integerPart + fractionPart).toString();

    return DecimalPrecision((b) => b
      ..coefficient = coefficient
      ..scale = targetScale);
  }

  /// From raw string → preserves all digits including trailing zeros
  static DecimalPrecision fromString(String input) {
    if (!input.contains('.')) {
      return DecimalPrecision((b) => b
        ..coefficient = BigInt.parse(input).toString()
        ..scale = 0);
    }

    final parts = input.split('.');
    final integerPart = parts[0];
    final fractionPart = parts[1];
    final scale = fractionPart.length;

    final coefficient = BigInt.parse(integerPart + fractionPart).toString();

    return DecimalPrecision((b) => b
      ..coefficient = coefficient
      ..scale = scale);
  }
}

extension DecimalFormatting on Decimal {
  String toFormattedString() {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(toDouble());
  }

  String toCurrencyString({String symbol = '\$'}) {
    final formatter = NumberFormat('$symbol #,##0.00', 'en_US');
    return formatter.format(toDouble());
  }
}

extension DecimalPrecisionparse on Decimal {
  DecimalPrecision toDecimalPrecision() {
    final str = toString();

    if (!str.contains('.')) {
      return DecimalPrecision((b) => b
        ..coefficient = BigInt.parse(str).toString()
        ..scale = scale);
    }

    final parts = str.split('.');
    final integerPart = parts[0];
    var fractionPart = parts[1];

    // Use scaleHint if provided, else actual fraction length
    final targetScale = scale;

    // Pad fractionPart to target scale
    if (fractionPart.length < targetScale) {
      fractionPart = fractionPart.padRight(targetScale, '0');
    } else if (fractionPart.length > targetScale) {
      fractionPart = fractionPart.substring(0, targetScale); // trim extra
    }

    final coefficient = BigInt.parse(integerPart + fractionPart).toString();

    return DecimalPrecision((b) => b
      ..coefficient = coefficient
      ..scale = targetScale);
  }
}