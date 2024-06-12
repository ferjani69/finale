// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image_picker/image_picker.dart';
//
// class OCR extends StatefulWidget {
//   final Function(Map<String, String>) onDataCollected;
//
//   const OCR({super.key, required this.onDataCollected});
//
//   @override
//   State<OCR> createState() => _OCRState();
// }
//
// class _OCRState extends State<OCR> {
//   File? _image;
//   Map<String, List<String>> dataGroups = {};
//   final TextEditingController indexController = TextEditingController();
//
//   Future<void> _pickImage(ImageSource source) async {
//     final image = await ImagePicker().pickImage(source: source);
//     if (image != null) {
//       setState(() {
//         _image = File(image.path);
//       });
//       await _processImage(_image!);
//     }
//   }
//
//   Future<void> _processImage(File image) async {
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final inputImage = InputImage.fromFilePath(image.path);
//     final RecognizedText recognizedText = await textRecognizer.processImage(
//         inputImage);
//
//     Map<String, List<String>> tempDataGroups = {
//       'Date': [],
//       'Dent': [],
//       'Nature des interventions': [],
//       'Doit': [],
//       'Reçu': []
//     };
//
//     String? currentHeader;
//     List<String> lines = recognizedText.text.split('\n');
//     for (var line in lines) {
//       if (tempDataGroups.containsKey(line.trim())) {
//         currentHeader = line.trim();
//       } else if (currentHeader != null && line
//           .trim()
//           .isNotEmpty) {
//         tempDataGroups[currentHeader]?.add(line.trim());
//       }
//     }
//
//     setState(() {
//       dataGroups = tempDataGroups;
//     });
//   }
//
//   void _returnDataToForm() {
//     int index = int.tryParse(indexController.text) ??
//         1; // Default to 1 if parse fails
//     index = index - 1; // Convert to zero-based index
//     Map<String, String> selectedData = {
//       'Date': dataGroups['Date']?.elementAt(index) ?? '',
//       'Dent': dataGroups['Dent']?.elementAt(index) ?? '',
//       'Nature des interventions': dataGroups['Nature des interventions']
//           ?.elementAt(index) ?? '',
//       'Doit': dataGroups['Doit']?.elementAt(index) ?? '',
//       'Reçu': dataGroups['Reçu']?.elementAt(index) ?? '',
//     };
//
//     widget.onDataCollected(selectedData);
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xff91C8E4),
//         title: const Text('OCR Data Collection', style: TextStyle(color: Colors.white)),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.white, backgroundColor: const Color(0xff91C8E4), // button background color
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                       ),
//                       onPressed: () => _pickImage(ImageSource.gallery),
//                       icon: const Icon(Icons.photo, size: 20),
//                       label: const Text('Import from Gallery', style: TextStyle(fontSize: 14)),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.white, backgroundColor: const Color(0xff91C8E4), // button background color
//                         padding: const EdgeInsets.symmetric(vertical: 10),
//                       ),
//                       onPressed: () => _pickImage(ImageSource.camera),
//                       icon: const Icon(Icons.camera_alt, size: 20),
//                       label: const Text('Take Photo', style: TextStyle(fontSize: 14)),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             if (_image != null) Container(
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               height: MediaQuery.of(context).size.width * 0.6, // Adjust the size to make the image smaller
//               child: Image.file(_image!, fit: BoxFit.cover),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: indexController,
//                 decoration: InputDecoration(
//                   labelText: 'Enter index number (starting from 1)',
//                   labelStyle: TextStyle(color: Colors.grey[600]),
//                   enabledBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xff91C8E4)),
//                   ),
//                   focusedBorder: const OutlineInputBorder(
//                     borderSide: BorderSide(color: Color(0xff91C8E4)),
//                   ),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white, backgroundColor: const Color(0xff91C8E4),
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                 ),
//                 onPressed: _returnDataToForm,
//                 child: const Text('Return Data to Form', style: TextStyle(fontSize: 14)),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: dataGroups.keys.length,
//                 itemBuilder: (context, index) {
//                   String key = dataGroups.keys.elementAt(index);
//                   return ExpansionTile(
//                     title: Text(key, style: const TextStyle(color: Color(0xff4A6572))),
//                     children: dataGroups[key]!.map((e) => ListTile(title: Text(e, style: const TextStyle(color: Color(0xff4A6572))))).toList(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class OCR extends StatefulWidget {
  final Function(Map<String, String>) onDataCollected;

  const OCR({super.key, required this.onDataCollected});

  @override
  State<OCR> createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  File? _image;
  Map<String, List<String>> dataGroups = {};
  final TextEditingController indexController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      await _processImage(_image!);
    }
  }

  Future<void> _processImage(File image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(image.path);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    if (recognizedText.text.isEmpty) {
      setState(() {
        dataGroups.clear(); // Clear data if no text found
      });
    } else {
      Map<String, List<String>> tempDataGroups = {
        'Date': [],
        'Dent': [],
        'Nature des interventions': [],
        'Doit': [],
        'Reçu': []
      };

      String? currentHeader;
      List<String> lines = recognizedText.text.split('\n');
      for (var line in lines) {
        if (tempDataGroups.containsKey(line.trim())) {
          currentHeader = line.trim();
        } else if (currentHeader != null && line.trim().isNotEmpty) {
          tempDataGroups[currentHeader]?.add(line.trim());
        }
      }

      setState(() {
        dataGroups = tempDataGroups;
      });
    }
  }

  void _returnDataToForm() {
    int index = int.tryParse(indexController.text) ?? 1; // Default to 1 if parse fails
    index = index - 1;
    Map<String, String> selectedData = {
      'Date': dataGroups['Date']?.elementAt(index) ?? '',
      'Dent': dataGroups['Dent']?.elementAt(index) ?? '',
      'Nature des interventions': dataGroups['Nature des interventions']?.elementAt(index) ?? '',
      'Doit': dataGroups['Doit']?.elementAt(index) ?? '',
      'Reçu': dataGroups['Reçu']?.elementAt(index) ?? '',
    };

    widget.onDataCollected(selectedData);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff91C8E4),
        title: const Text('OCR Data Collection', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: const Color(0xff91C8E4), // button background color
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo, size: 20),
                      label: const Text('Import from Gallery', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: const Color(0xff91C8E4), // button background color
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, size: 20),
                      label: const Text('Take Photo', style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
              ],
            ),
            if (_image != null) Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: MediaQuery.of(context).size.width * 0.6, // Adjust the size to make the image smaller
              child: Image.file(_image!, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: indexController,
                decoration: InputDecoration(
                  labelText: 'Enter index number (starting from 1)',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff91C8E4)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff91C8E4)),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xff91C8E4),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: _returnDataToForm,
                child: const Text('Return Data to Form', style: TextStyle(fontSize: 14)),
              ),
            ),
            Expanded(
              child: dataGroups.isEmpty
                  ? const Center(child: Text('No relevant data found or OCR failed.', style: TextStyle(color: Colors.red)))
                  : ListView.builder(
                itemCount: dataGroups.keys.length,
                itemBuilder: (context, index) {
                  String key = dataGroups.keys.elementAt(index);
                  return ExpansionTile(
                    title: Text(key, style: const TextStyle(color: Color(0xff4A6572))),
                    children: dataGroups[key]!.map((e) => ListTile(title: Text(e, style: const TextStyle(color: Color(0xff4A6572))))).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
