import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
String? text;
class OCROptionsPage extends StatefulWidget {
  @override
  State<OCROptionsPage> createState() => _OCROptionsPageState();
}

class _OCROptionsPageState extends State<OCROptionsPage> {

  File? _image;
  Future textRecognition(File img) async{
    final textRecognizer=TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage=InputImage.fromFilePath(img.path);
    final RecognizedText recognizedText =
    await textRecognizer.processImage(inputImage);
 setState(() {
   text=recognizedText.text;
 });
  }

  Future _pickimage(ImageSource source) async{
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      setState(() {
        _image = File(image.path);
      });
    }
    catch(e){
      if(kDebugMode){
        print(e);
      }
    }


  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OCR Options'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('OCR Options'),
            ElevatedButton.icon(
              onPressed: () {
                _pickimage(ImageSource.camera).then((value) {
                  if (_image !=null){
                    textRecognition(_image!);
                  }
                });
              },
              icon: Icon (Icons.camera_alt),
              label: Text('Take Photo'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _pickimage(ImageSource.gallery).then((value) {
                  if (_image !=null){
                    textRecognition(_image!);
                  }
                });},
              icon: Icon(Icons.photo),
              label: Text('Import from Gallery'),
            ),
            Text(text.toString())
          ],
        ),
      ),
    );
  }

  void _navigateToCameraScreen(BuildContext context) {
    // Navigate to camera screen or perform OCR directly
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
  }

  void _importFromGallery(BuildContext context) {
    // Navigate to gallery screen or import image for OCR
    // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => GalleryScreen()));
  }
}
