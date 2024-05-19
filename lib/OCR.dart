import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCR extends StatefulWidget {
  final Function(Map<String, String>) onTextSelected;

  OCR({required this.onTextSelected});

  @override
  State<OCR> createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  File? _image;
  List<Map<String, String>>? parsedTreatments;
  Map<String, String>? selectedTreatment;
  String? recognizedText;

  Future textRecognition(File img) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(img.path);
    final RecognizedText recognizedTextResult = await textRecognizer.processImage(inputImage);
    setState(() {
      recognizedText = recognizedTextResult.text;
      parsedTreatments = parseExtractedText(recognizedTextResult.text);
    });
    print('Recognized text: ${recognizedTextResult.text}');
    print('Parsed treatments: $parsedTreatments');
  }

  Future _pickImage(ImageSource source) async {
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

  List<Map<String, String>> parseExtractedText(String extractedText) {
    List<Map<String, String>> treatments = [];
    List<String> lines = extractedText.split('\n');

    for (String line in lines) {
      print('Processing line: $line');
      List<String> columns = line.split(RegExp(r'\s{2,}'));
      if (columns.length >= 5) {
        final treatment = {
          'date': columns[0],
          'dent': columns[1],
          'natureInterv': columns[2],
          'doit': columns[3],
          'recu': columns[4],
        };
        print('Parsed treatment: $treatment');
        treatments.add(treatment);
      } else if (columns.isNotEmpty) {
        print('Skipped line due to insufficient columns: $line');
      }
    }

    return treatments;
  }

  void _onSelectRow(Map<String, String> treatment) {
    setState(() {
      selectedTreatment = treatment;
    });
  }

  void _confirmSelection() {
    if (selectedTreatment != null) {
      widget.onTextSelected(selectedTreatment!);
      Navigator.pop(context); // Navigate back to the previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No treatment selected. Please select a line.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Options'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('OCR Options'),
          ElevatedButton.icon(
            onPressed: () {
              _pickImage(ImageSource.camera);
            },
            icon: const Icon(Icons.camera_alt),
            label: const Text('Take Photo'),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _pickImage(ImageSource.gallery);
            },
            icon: const Icon(Icons.photo),
            label: const Text('Import from Gallery'),
          ),
          if (_image != null) Image.file(_image!), // Display the selected image
          if (recognizedText != null && parsedTreatments != null)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Dent')),
                    DataColumn(label: Text('Nature')),
                    DataColumn(label: Text('Doit')),
                    DataColumn(label: Text('Recu')),
                  ],
                  rows: parsedTreatments!.map((treatment) {
                    return DataRow(
                      selected: selectedTreatment == treatment,
                      onSelectChanged: (selected) {
                        if (selected == true) {
                          _onSelectRow(treatment);
                        }
                      },
                      cells: [
                        DataCell(Text(treatment['date'] ?? '')),
                        DataCell(Text(treatment['dent'] ?? '')),
                        DataCell(Text(treatment['natureInterv'] ?? '')),
                        DataCell(Text(treatment['doit'] ?? '')),
                        DataCell(Text(treatment['recu'] ?? '')),
                      ],
                    );
                  }).toList(),
                ),
              ),
            )
          else if (recognizedText != null && parsedTreatments == null)
            const CircularProgressIndicator()
          else
            const Text('No text recognized. Please try again.'),
          ElevatedButton(
            onPressed: _confirmSelection,
            child: const Text('Confirm and Return'),
          ),
        ],
      ),
    );
  }
}
