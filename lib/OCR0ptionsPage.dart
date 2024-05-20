import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCROptionsPage extends StatefulWidget {
  final Function(Map<String, String>) onExtractedData;

  const OCROptionsPage({super.key, required this.onExtractedData});

  @override
  State<OCROptionsPage> createState() => _OCROptionsPageState();
}

class _OCROptionsPageState extends State<OCROptionsPage> {
  File? _image;
  String? text;
  Map<String, String>? patientData;

  Future<void> textRecognition(File img) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(img.path);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      text = recognizedText.text;
      patientData = parsePatientData(text!);
    });

    // Debug print to check extracted data
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
      if (_image != null) {
        await textRecognition(_image!);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Map<String, String> parsePatientData(String text) {
    final Map<String, String> patientData = {};

    final RegExp firstNameRegex = RegExp(r'Prénom\s*[:.,]*\s*(.*)');
    final RegExp lastNameRegex = RegExp(r'Nom\s*[:.,]*\s*(.*)');
    final RegExp phoneRegex = RegExp(r'Tél.\s*[:.,]*\s*([\d\s,\-;]+)');
    final RegExp birthDateRegex = RegExp(r'Date de Naissance\s*[:.,]*\s*(\d{4}-\d{2}-\d{2}|\d{4}/\d{2}/\d{2})');
    final RegExp addressRegex = RegExp(r'Adresse\s*[:.,]*\s*(.*)');
    final RegExp professionRegex = RegExp(r'Profession\s*[:.,]*\s*(.*)');
    final RegExp referenceRegex = RegExp(r'Adressé par\s*[:.,]*\s*(.*)');

    final matchFirstName = firstNameRegex.firstMatch(text);
    final matchLastName = lastNameRegex.firstMatch(text);
    final matchPhone = phoneRegex.firstMatch(text);
    final matchBirthDate = birthDateRegex.firstMatch(text);
    final matchAddress = addressRegex.firstMatch(text);
    final matchProfession = professionRegex.firstMatch(text);
    final matchReference = referenceRegex.firstMatch(text);

    if (matchFirstName != null) patientData['firstName'] = matchFirstName.group(1)?.trim() ?? '';
    if (matchLastName != null) patientData['lastName'] = matchLastName.group(1)?.trim() ?? '';
    if (matchPhone != null) {
      String rawPhoneNumber = matchPhone.group(1)?.replaceAll(RegExp(r'[^0-9]'), '') ?? '';
      patientData['phoneNumber'] = rawPhoneNumber;
    }
    if (matchBirthDate != null) patientData['birthDate'] = matchBirthDate.group(1)?.trim() ?? '';
    if (matchAddress != null) patientData['address'] = matchAddress.group(1)?.trim() ?? '';
    if (matchProfession != null) patientData['profession'] = matchProfession.group(1)?.trim() ?? '';
    if (matchReference != null) patientData['reference'] = matchReference.group(1)?.trim() ?? '';

    // Debug print to check parsed data

    return patientData;
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff91C8E4),
        title: const Center(child: Text('OCR Options')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'OCR Options',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff4A6572),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color(0xff91C8E4), // foreground (text) color
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      _pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take Photo'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color(0xff91C8E4), // foreground (text) color
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.photo),
                    label: const Text('Import from Gallery'),
                  ),
                ),
              ],
            ),
            if (text != null) ...[
              const SizedBox(height: 20),
              const Text(
                'Extracted Text:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4A6572),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  text!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff4A6572),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xff91C8E4), // foreground (text) color
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, patientData); // Return the extracted data
                },
                child: const Text('Return to Form with Extracted Data'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
