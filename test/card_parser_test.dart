import 'package:flutter_ocr_assignment/parsers/card_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Smart Card Parser Tests', () {
    final parser = SmartCardParser();

    test('Should extract card details correctly', () {
      const rawText = '''
      VISA
      4111 1111 1111 1111
      VALID THRU 12/28
      JOHN DOE
      ''';

      final result = parser.parse(rawText);

      expect(result.cardNumber, '4111111111111111');
      expect(result.expiryDate, '12/28');
      expect(result.holderName, 'JOHN DOE');
    });

    test('Should return null for invalid card number', () {
      const rawText = '''
              VISA
              4111 1111 1111 1234
              VALID THRU 12/28
              JOHN DOE
              ''';

      final result = parser.parse(rawText);

      expect(result.cardNumber, null);
    });

    test('Should ignore noise text', () {
      const rawText = '''
      BANK
      CREDIT CARD
      VISA
      4111 1111 1111 1111
      ''';

      final result = parser.parse(rawText);

      expect(result.cardNumber, '4111111111111111');
    });

    test('Should extract multiline holder name', () {
      const rawText = '''
      4111 1111 1111 1111
      JOHN
      DOE
      12/28
      ''';

      final result = parser.parse(rawText);

      expect(result.holderName, 'JOHN DOE');
    });
  });
}
