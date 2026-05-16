import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<String> extractText(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);

    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );

    final buffer = StringBuffer();

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        buffer.writeln(line.text);
      }
    }

    return buffer.toString();
  }

  void dispose() {
    textRecognizer.close();
  }
}
