# Flutter OCR Assignment

A Flutter application that scans cards and bank passbooks using OCR and extracts structured information.

---

# Features

## Card Scanner
- Scan card using device camera
- Extract:
    - Card Number
    - Expiry Date
    - Card Holder Name
- Card validation using Luhn Algorithm
- Masked card number display

## Passbook Scanner
- Scan bank passbook using device camera
- Extract:
    - Account Number
    - IFSC Code
    - Account Holder Name

---

# Steps to Run the Project

## 1. Clone Repository

```bash
git clone <repository_url>
```

## 2. Navigate to Project

```bash
cd flutter_ocr_assignment
```

## 3. Install Dependencies

```bash
flutter pub get
```

## 4. Run Application

```bash
flutter run
```

---

# Environment

## Flutter Version

```bash
Flutter 3.29.1
```

## Dart Version

```bash
Dart 3.7.0
```

## Flutter SDK Path

```text
C:\flutter_windows_3.29.1-stable\flutter
```

---

# Libraries Used

| Library | Purpose |
|---|---|
| google_mlkit_text_recognition | OCR text extraction |
| image_picker | Capture image from camera |
| flutter_test | Unit testing |

---

# Testing

Run all tests:

```bash
flutter test
```

---

# Assumptions Made

- OCR text is mainly English/Latin characters
- Card numbers contain 13–19 digits
- Expiry date format follows MM/YY
- Passbook account numbers are numeric
- IFSC code follows standard Indian bank IFSC format
- Longest numeric sequence in passbook is considered as account number
- Card holder names are uppercase alphabetic text

---

# What Was Skipped and Why

| Skipped Feature | Reason |
|---|---|
| Real-time OCR scanning | Time constraint |
| Multi-language OCR | Scope limited to English OCR |
| Backend/API validation | Not required for assignment |
| OCR confidence scoring | Kept implementation lightweight |
| Image preprocessing | Time limitation |
| Production-level encryption/security | Demo application only |
| iOS testing | Android mandatory, iOS optional |

---

# Project Structure

```text
lib/
├── models/
├── parsers/
├── services/
├── utils/
└── main.dart

test/
├── card_parser_test.dart
├── passbook_parser_test.dart
└── luhn_validator_test.dart
```

---

# Author

Malar"# flutter_ocr_assignment" 
