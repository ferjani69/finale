import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search/main.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  _FeedbackFormPageState createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  File? _image;
  double? _progress;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Us Feedback', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchPage(patientadd: null)),
            );
          },
        ),
        backgroundColor: const Color(0xff4682A9),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "We'd love to hear your thoughts!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Select Feedback Category",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: <String>['General', 'Feature Request', 'Bug Report']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _feedbackController,
                  decoration: InputDecoration(
                    hintText: 'Describe your issue or suggestion',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 5, // Adjust the number of lines to make the text box bigger
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your feedback';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (pickedImage != null) {
                        setState(() {
                          _image = File(pickedImage.path);
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4682A9), // Set button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.image, color: Colors.white),
                    label: const Text('Select Image', style: TextStyle(color: Colors.white)),
                  ),
                ),
                if (_image != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: Image.file(_image!, height: 200, width: 200)),
                  ),
                if (_isUploading)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: LinearProgressIndicator(value: _progress),
                  ),
                const SizedBox(height: 16), // Added spacing between buttons
                Center(
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : () async {
                      setState(() {
                        _isUploading = true;
                        _progress = 0;
                      });
                      await uploadImageAndSubmitFeedback();
                      setState(() {
                        _isUploading = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff4682A9), // Set button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Send', style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> uploadImageAndSubmitFeedback() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Upload image to Firebase Storage
        var imageName = DateTime.now().millisecondsSinceEpoch.toString();
        var storageRef = FirebaseStorage.instance.ref().child('feedback_images/$imageName.jpg');
        var uploadTask = storageRef.putFile(_image!);
        uploadTask.snapshotEvents.listen((snapshot) {
          setState(() {
            _progress = snapshot.bytesTransferred / snapshot.totalBytes;
          });
        }, onError: (e) {
          // Handle error
        });
        await uploadTask.whenComplete(() async {
          // Upload complete
          var downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
          // Submit feedback to Firestore
          await FirebaseFirestore.instance.collection('feedback').add({
            'category': 'General', // Placeholder, replace with actual selected category
            'feedback': _feedbackController.text,
            'timestamp': FieldValue.serverTimestamp(),
            'image': downloadUrl, // Store the image URL
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Feedback sent successfully')),
          );
          _feedbackController.clear();
          setState(() {
            _image = null;
          });
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error sending feedback')),
        );
      }
    }
  }
}
