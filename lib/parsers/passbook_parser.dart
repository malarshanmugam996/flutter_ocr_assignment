
import '../models/bank_details.dart';

BankDetails parsePassbook(String rawText) {
  final cleaned = rawText.toUpperCase();

  final ifscRegex = RegExp(r'[A-Z]{4}0[A-Z0-9]{6}');
  final accountRegex = RegExp(r'\d{9,18}');

  String? ifsc;
  String? account;
  String? name;

  final ifscMatch = ifscRegex.firstMatch(cleaned);

  if (ifscMatch != null) {
    ifsc = ifscMatch.group(0);
  }

  final accountMatches = accountRegex.allMatches(cleaned);

  int maxLength = 0;

  for (final match in accountMatches) {
    final value = match.group(0)!;

    if (value.length > maxLength) {
      maxLength = value.length;
      account = value;
    }
  }

  final lines = cleaned.split('\n');

  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];

    if (line.contains('NAME')) {
      if (i + 1 < lines.length) {
        name = lines[i + 1].trim();
        break;
      }
    }
  }

  return BankDetails(
    accountHolderName: name,
    accountNumber: account,
    ifscCode: ifsc,
  );
}
