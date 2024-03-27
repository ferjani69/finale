import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search/OCR0ptionsPage.dart';
class AddPatientPage extends StatelessWidget {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  AddPatientPage({super.key});

  void _submitForm() {
    if (_formkey.currentState!.validate()) {
      ScaffoldMessenger.of(_formkey.currentContext!).showSnackBar(
          const SnackBar(content: Text("Form submitted successfully")));
    }
  }

  String? _validatePhonenumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }

    // Check if the value consists only of numeric characters
    if (!value.contains(RegExp(r'^[0-9]*$'))) {
      return 'Please enter a valid phone number (numbers only)';
    }

    // Check if the length of the phone number is not equal to 8 digits
    if (value.length != 8) {
      return 'Please enter a valid 8-digit phone number';
    }

    return null;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xff91C8E4),
        title: const Center(child: Text("Patient form")),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 30.0), // Adjust the padding as needed for spacing
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OCROptionsPage()),
              );
            },
            icon: const Icon(Icons.camera_alt),
          ),
        ],
      ),


      body:
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: 'First name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a first name";
                    }
                    // Check if the value contains only alphabetic characters, and optionally spaces
                    if (!RegExp(r'^[a-zA-Z]+(?:\s[a-zA-Z]+)*$').hasMatch(value)) {
                      return "Please enter a valid first name containing only alphabetic characters, and optionally separated by spaces";
                    }
                    return null;
                  },


                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: 'Last name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a first name";
                    }
                    // Check if the value contains only alphabetic characters
                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return "Please enter a valid first name containing only alphabetic characters";
                    }
                    return null;
                  },

                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: _validatePhonenumber,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: 'Birth Date ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "please enter a Birthdate";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: 'Adresse ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a first name";
                    }
                    // Check if the value contains only alphabetic characters, spaces, and periods (.)
                    if (!RegExp(r'^[a-zA-Z\s.]+$').hasMatch(value)) {
                      return "Please enter a valid first name containing only alphabetic characters, spaces, and periods";
                    }
                    return null;
                  },

                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: 'Profession',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a first name";
                    }
                    // Check if the value contains only alphabetic characters
                    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                      return "Please enter a valid first name containing only alphabetic characters";
                    }
                    return null;
                  },

                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: 'Reference',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff91C8E4)),
                      onPressed: _submitForm,
                      child: const Text("Submit Your Patient")),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
