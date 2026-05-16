import '../models/card_details.dart';
import '../utils/luhn_validator.dart';

class SmartCardParser {
  CardDetails parse(String rawText) {
    print("rawtext $rawText");
    final cleaned = _normalizeOCR(rawText);

    final lines =
        cleaned
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    return CardDetails(
      cardNumber: _extractCardNumber(cleaned),
      expiryDate: _extractExpiry(cleaned),
      holderName: _extractName(lines),
    );
  }

  // ---------------------------------
  // NORMALIZATION (LESS AGGRESSIVE)
  // ---------------------------------

  String _normalizeOCR(String text) {
    return text
        .toUpperCase()
        .replaceAll(RegExp(r'[^\w0-9\n/ -]'), ' ')
        .replaceAll('  ', ' ');
  }

  // ---------------------------------
  // CARD NUMBER (ROBUST)
  // ---------------------------------

  String? _extractCardNumber(String text) {
    // extract digit groups first
    final matches = RegExp(r'(\d[ -]*?){13,19}').allMatches(text);

    for (final m in matches) {
      final raw = m.group(0)!;

      final number = raw.replaceAll(RegExp(r'[^0-9]'), '');

      if (number.length >= 13 &&
          number.length <= 19 &&
          _looksLikeCard(number)) {
        if (isValidCard(number)) {
          return number;
        }
      }
    }

    return null;
  }

  bool _looksLikeCard(String number) {
    // avoid obvious OCR junk
    if (RegExp(r'^(.)\1+$').hasMatch(number)) return false;
    if (number.startsWith('0000')) return false;
    return true;
  }

  // ---------------------------------
  // EXPIRY (STRICT VALIDATION)
  // ---------------------------------

  String? _extractExpiry(String text) {
    final match = RegExp(r'(0[1-9]|1[0-2])[\/\-]([0-9]{2})').firstMatch(text);

    if (match == null) return null;

    final month = int.parse(match.group(1)!);
    final year = int.parse(match.group(2)!);

    if (month < 1 || month > 12) return null;

    // optional: reject impossible years
    if (year < 0 || year > 40) return null;

    return '${match.group(1)}/${match.group(2)}';
  }

  // ---------------------------------
  // NAME (MULTI-LINE IMPROVED)
  // ---------------------------------

  String? _extractName(List<String> lines) {
    for (int i = 0; i < lines.length; i++) {
      final text = lines[i];

      if (_isNoise(text)) continue;

      final cleaned =
          text
              .replaceAll(RegExp(r'[0-9]'), '')
              .replaceAll('0', 'O')
              .replaceAll('5', 'S')
              .trim();

      if (_isValidName(cleaned)) {
        return cleaned;
      }

      // 🔥 fallback: sometimes name spans 2 lines
      if (i + 1 < lines.length) {
        final combined =
            '$cleaned ${lines[i + 1]}'.replaceAll(RegExp(r'[0-9]'), '').trim();

        if (_isValidName(combined)) {
          return combined;
        }
      }
    }
    return null;
  }

  bool _isValidName(String text) {
    if (text.length < 5 || text.length > 26) return false;

    return RegExp(r'^[A-Z ]+$').hasMatch(text);
  }

  // ---------------------------------
  // NOISE FILTER
  // ---------------------------------

  bool _isNoise(String text) {
    const noise = [
      'BANK',
      'VALID',
      'THRU',
      'VISA',
      'MASTERCARD',
      'CARD',
      'DEBIT',
      'CREDIT',
      'MYZONE',
      'CONTACTLESS',
      'EXPIRY',
      'EXPIRES',
    ];

    return noise.any((n) => text.contains(n));
  }
}
