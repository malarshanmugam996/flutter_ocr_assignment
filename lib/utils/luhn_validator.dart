
bool isValidCard(String cardNumber) {
  final digits = cardNumber.replaceAll(RegExp(r'\D'), '');

  if (digits.length < 13 || digits.length > 19) {
    return false;
  }

  int sum = 0;
  bool alternate = false;

  for (int i = digits.length - 1; i >= 0; i--) {
    int n = int.parse(digits[i]);

    if (alternate) {
      n *= 2;
      if (n > 9) n -= 9;
    }

    sum += n;
    alternate = !alternate;
  }

  return sum % 10 == 0;
}
