import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ocr_assignment/parsers/card_parser.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import 'models/bank_details.dart';
import 'models/card_details.dart';
import 'parsers/passbook_parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OCR Scanner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  File? imageFile;
  CardDetails? cardDetails;
  BankDetails? bankDetails;
  String rawText = "";
  late TabController _tabController;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        clearData();
      }
    });
  }

  void clearData() {
    setState(() {
      imageFile = null;
      cardDetails = null;
      bankDetails = null;
      rawText = "";
    });
  }

  Future<void> scanImage(bool isCard) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked == null) return;

    final file = File(picked.path);

    final inputImage = InputImage.fromFile(file);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final recognizedText = await textRecognizer.processImage(inputImage);

    rawText = recognizedText.text;
    var SmartCardParse = SmartCardParser();

    final buffer = StringBuffer();

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        buffer.writeln(line.text);
      }
    }

    setState(() {
      imageFile = file;

      if (isCard) {
        cardDetails = SmartCardParse.parse(rawText);
        bankDetails = null;
      } else {
        bankDetails = parsePassbook(rawText);
        cardDetails = null;
      }
    });

    textRecognizer.close();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("OCR Scanner"),
          bottom: TabBar(
            controller: _tabController,
            tabs: [Tab(text: "Card"), Tab(text: "Passbook")],
          ),
        ),
        body: TabBarView(
          children: [buildCardScanner(), buildPassbookScanner()],
        ),
      ),
    );
  }

  Widget buildCardScanner() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => scanImage(true),
            child: const Text("Scan Card"),
          ),
          if (imageFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(imageFile!, height: 200),
            ),
          if (cardDetails != null)
            Card(
              child: ListTile(
                title: const Text("Card Details"),
                subtitle: Text(
                  "Card: ${cardDetails!.maskedCardNumber ?? ""}\n"
                  "Expiry: ${cardDetails!.expiryDate ?? ""}\n"
                  "Name: ${cardDetails!.holderName ?? ""}",
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPassbookScanner() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => scanImage(false),
            child: const Text("Scan Passbook"),
          ),
          if (imageFile != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(imageFile!, height: 200),
            ),
          if (bankDetails != null)
            Card(
              child: ListTile(
                title: const Text("Bank Details"),
                subtitle: Text(
                  "Account: ${bankDetails!.accountNumber ?? ""}\n"
                  "IFSC: ${bankDetails!.ifscCode ?? ""}\n"
                  "Name: ${bankDetails!.accountHolderName ?? ""}",
                ),
              ),
            ),
        ],
      ),
    );
  }
}
