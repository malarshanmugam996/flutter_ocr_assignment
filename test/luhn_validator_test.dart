import 'package:flutter_ocr_assignment/utils/luhn_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Luhn Validator Tests', () {
    test('Valid card number should return true', () {
      const cardNumber = '4111111111111111';

      final result = isValidCard(cardNumber);

      expect(result, true);
    });

    test('Invalid card number should return false', () {
      const cardNumber = '4111111111111234';

      final result = isValidCard(cardNumber);

      expect(result, false);
    });

    test('Card number with spaces should validate', () {
      const cardNumber = '4111 1111 1111 1111';

      final result = isValidCard(cardNumber);

      expect(result, true);
    });

    test('Short card number should return false', () {
      const cardNumber = '12345';

      final result = isValidCard(cardNumber);

      expect(result, false);
    });
  });
}
