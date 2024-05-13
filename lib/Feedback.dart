import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackFormPage extends StatefulWidget {
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
        title: const Text('Send Us Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                hint: const Text("Select Feedback Category"),
                items: <String>['General', 'Feature Request', 'Bug Report']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
              TextFormField(
                controller: _feedbackController,
                decoration: const InputDecoration(
                  labelText: 'Enter your feedback',
                  hintText: 'Describe your issue or suggestion',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your feedback';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedImage!= null) {
                    setState(() {
                      _image = File(pickedImage.path);
                    });
                  }
                },
                child: Text('Select Image'),
              ),
              if (_image!= null)
                Image.file(_image!, height: 200, width: 200),
              if (_isUploading)
                LinearProgressIndicator(value: _progress),
              ElevatedButton(
                onPressed: _isUploading? null : () async {
                  setState(() {
                    _isUploading = true;
                    _progress = 0;
                  });
                  await uploadImageAndSubmitFeedback();
                  setState(() {
                    _isUploading = false;
                  });
                },
                child: const Text('Send'),
              ),
            ],
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
          print(e);
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
