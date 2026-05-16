import 'package:flutter_ocr_assignment/parsers/passbook_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Passbook Parser Tests', () {
    test('Should extract passbook details correctly', () {
      const rawText = '''
      STATE BANK OF INDIA
      NAME
      JOHN DOE

      ACCOUNT NUMBER
      123456789012

      IFSC CODE
      SBIN0001234
      ''';

      final result = parsePassbook(rawText);

      expect(result.accountHolderName, 'JOHN DOE');
      expect(result.accountNumber, '123456789012');
      expect(result.ifscCode, 'SBIN0001234');
    });

    test('Should return null if IFSC not found', () {
      const rawText = '''
      NAME
      JOHN DOE

      ACCOUNT NUMBER
      123456789012
      ''';

      final result = parsePassbook(rawText);

      expect(result.ifscCode, null);
    });

    test('Should detect longest account number', () {
      const rawText = '''
      TEMP 12345
      ACCOUNT 1234567890123456
      ''';

      final result = parsePassbook(rawText);

      expect(result.accountNumber, '1234567890123456');
    });
  });
}
