
class CardDetails {
  final String? cardNumber;
  final String? expiryDate;
  final String? holderName;

  CardDetails({
    this.cardNumber,
    this.expiryDate,
    this.holderName,
  });

  String get maskedCardNumber {
    if (cardNumber == null || cardNumber!.length < 4) {
      return '';
    }

    return 'XXXX XXXX XXXX ${cardNumber!.substring(cardNumber!.length - 4)}';
  }
}
