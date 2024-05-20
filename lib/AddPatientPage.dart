import 'package:flutter/material.dart';
import 'package:search/OCR0ptionsPage.dart';
import 'package:search/main.dart';
import 'package:search/Patients%20class/patient.dart';
import 'package:intl/intl.dart';
import 'package:search/Patients%20class/ptientsList.dart';
import 'Widgets/Drawerwidget.dart'; // Import the AppDrawer widget
import 'Widgets/Voicett.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPatientPage extends StatefulWidget {
  final Function(Patient) patientadd; // Define the callback function
  final Map<String, String>? initialData; // Add this line to accept initial data

  const AddPatientPage({super.key, required this.patientadd, this.initialData}); // Add initialData as an optional parameter

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

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      firstNameController.text = widget.initialData!['firstName'] ?? '';
      lastNameController.text = widget.initialData!['lastName'] ?? '';
      phoneNumberController.text = widget.initialData!['phoneNumber'] ?? '';
      birthDateController.text = widget.initialData!['birthDate'] ?? '';
      addressController.text = widget.initialData!['address'] ?? '';
      professionController.text = widget.initialData!['profession'] ?? '';
      referenceController.text = widget.initialData!['reference'] ?? '';
    }
  }

  void _showDatePicker() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2080),
    );
    if (selectedDate != null) {
      setState(() {
        final formattedDate = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
        birthDateController.text = formattedDate;
      });
    }
  }

  void _navigateToOCROptions() async {
    final patientData = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => OCROptionsPage(
          onExtractedData: (data) {
            Navigator.pop(context, data);
          },
        ),
      ),
    );

    if (patientData != null) {
      setState(() {
        firstNameController.text = patientData['firstName'] ?? '';
        lastNameController.text = patientData['lastName'] ?? '';
        phoneNumberController.text = patientData['phoneNumber'] ?? '';
        birthDateController.text = patientData['birthDate'] ?? '';
        addressController.text = patientData['address'] ?? '';
        professionController.text = patientData['profession'] ?? '';
        referenceController.text = patientData['reference'] ?? '';
      });
    }
  }

  void _submitForm() {
    if (_formkey.currentState!.validate()) {
      String firstName = firstNameController.text;
      String lastName = lastNameController.text;
      String phoneNumber = phoneNumberController.text;
      String birthDateString = birthDateController.text;

      DateTime? birthdate;
      try {
        birthdate = DateFormat('yyyy-MM-dd').parse(birthDateString.replaceAll('/', '-'));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid date format. Please use YYYY-MM-DD or YYYY/MM/DD.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      String formattedDate = DateFormat('yyyy-MM-dd').format(birthdate);

      String address = addressController.text;
      String profession = professionController.text;
      String reference = referenceController.text;

      Patient newPatient = Patient(
        "unique_id",
        firstName,
        lastName,
        int.parse(phoneNumber),
        birthdate,
        address,
        profession,
        reference,
      );

      firstNameController.clear();
      lastNameController.clear();
      addressController.clear();
      professionController.clear();
      referenceController.clear();
      phoneNumberController.clear();
      birthDateController.clear();

      widget.patientadd(newPatient);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patient added successfully'),
        ),
      );
      CollectionReference patients = FirebaseFirestore.instance.collection("Patients");
      patients.add({
        'firstname': firstName,
        'lastname': lastName,
        'phonenumber': phoneNumber,
        'dateOfBirth': formattedDate,
        'address': address,
        'profession': profession,
        'reference': reference,
      }).then((docRef) {
        newPatient.id = docRef.id;
      }).catchError((error) {
        // Handle error
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please check your inputs'),
        ),
      );
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }

    // Check if the value contains only alphabetic characters and optionally spaces if followed by another word
    if (!RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$').hasMatch(value)) {
      return 'Please enter a valid name containing only alphabetic characters and spaces if followed by another word';
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
            onPressed: _navigateToOCROptions, // Call the function here
            icon: const Icon(Icons.camera_alt),
          ),
        ],
      ),
      drawer: Drawerw(), // Use the AppDrawer widget here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: _validateName,
                      ),
                    ),
                    Voicett(controller: firstNameController),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Other TextFormField widgets...
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: _validateName,
                      ),
                    ),
                    Voicett(controller: lastNameController),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.phone,
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: _validatePhonenumber,
                      ),
                    ),
                    Voicett(controller: phoneNumberController),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  onTap: _showDatePicker,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: birthDateController,
                  decoration: InputDecoration(
                    labelText: 'Birth Date (YYYY-MM-DD)', // Specify the expected format
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
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
                      DateTime.parse(value);
                      return null; // Return null if the date is valid
                    } catch (e) {
                      return "Please enter a valid date in the format YYYY-MM-DD";
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter an address";
                          }
                          // Check if the value contains only alphabetic characters, spaces, and periods (.)
                          if (!RegExp(r'^[a-zA-Z\s.]+$').hasMatch(value)) {
                            return "Please enter a valid address containing only alphabetic characters, spaces, and periods";
                          }
                          return null;
                        },
                      ),
                    ),
                    Voicett(controller: addressController),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: professionController,
                        decoration: InputDecoration(
                          labelText: 'Profession',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter a profession";
                          }
                          // Check if the value contains only alphabetic characters
                          if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                            return "Please enter a valid profession containing only alphabetic characters";
                          }
                          return null;
                        },
                      ),
                    ),
                    Voicett(controller: professionController),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: referenceController,
                        decoration: InputDecoration(
                          labelText: 'Reference',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Voicett(controller: referenceController),
                  ],
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff91C8E4)),
                    onPressed: _submitForm,
                    child: const Text("Submit Your Patient"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
