import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search/OCR0ptionsPage.dart';
import 'package:search/patient.dart';
import 'package:intl/intl.dart';


import 'ptientsList.dart';
class AddPatientPage extends StatefulWidget {

  final Function(Patient) onPatientAdded; // Define the callback function

  AddPatientPage({required this.onPatientAdded});

  @override
  State<AddPatientPage> createState() => _AddPatientPageState();
}

class _AddPatientPageState extends State<AddPatientPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController birthDateController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController professionController = TextEditingController();

  final TextEditingController referenceController = TextEditingController();

  void _submitForm() {
    if (_formkey.currentState!.validate()) {
      // Retrieve values from controllers
      String firstName = firstNameController.text;
      String lastName = lastNameController.text;
      String phoneNumber = phoneNumberController.text;
      String birthDateString = birthDateController.text; // Get the birth date string

      // Convert the birth date string into a DateTime object
      DateTime? birthDate;
      try {
        birthDate = DateFormat('yyyy-MM-dd').parse(birthDateString);
      } catch (e) {
        print('Error parsing birth date: $e');
      }

      String address = addressController.text;
      String profession = professionController.text;
      String reference = referenceController.text;

      // Create a new Patient object with the form data
      Patient newPatient = Patient(
        "unique_id", // Generate or assign a unique ID for the new patient
        firstName,
        lastName,
        int.parse(phoneNumber),
        birthDate, // Assign the parsed birth date
        address,
        profession,
        reference,
      );


      // Add the new patient to the patient_list
      widget.onPatientAdded(newPatient);
      ScaffoldMessenger.of(_formkey.currentContext!).showSnackBar(
        const SnackBar(content: Text("Patient added successfully")),
      );

      // Clear form fields after submission (if needed)
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
                  controller: firstNameController,
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
                  controller: lastNameController,
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
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  validator: _validatePhonenumber,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: birthDateController,
                  decoration: InputDecoration(
                      labelText: 'Birth Date (YYYY-MM-DD)', // Specify the expected format
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                      )
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a birth date";
                    }
                    // Validate the date format using a regular expression
                    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                      return "Please enter a valid date in the format YYYY-MM-DD";
                    }
                    // Convert the string date into a DateTime object
                    try {
                      DateTime parsedDate = DateTime.parse(value);
                      return null; // Return null if the date is valid
                    } catch (e) {
                      return "Please enter a valid date in the format YYYY-MM-DD";
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: addressController,
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
                  controller: professionController,
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
                  controller: referenceController,
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
