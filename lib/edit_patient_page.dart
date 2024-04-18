import 'package:flutter/material.dart';
import 'package:search/patient.dart';
import 'package:intl/intl.dart';
import 'Drawerwidget.dart'; // Import the AppDrawer widget


class EditPatientPage extends StatefulWidget {
  final Patient patient;
  final Function(Patient) onUpdate;

  const EditPatientPage({super.key, required this.patient, required this.onUpdate});

  @override
  _EditPatientPageState createState() => _EditPatientPageState();
}

class _EditPatientPageState extends State<EditPatientPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF9FF),
      appBar: AppBar(

        backgroundColor: const Color(0xff91C8E4),
        title: const Text('Edit Patient'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: widget.patient.pname,
                  decoration: InputDecoration(
                      labelText: 'First name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  onChanged: (value) {
                    setState(() {
                      widget.patient.pname = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: widget.patient.plname,
                  decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  onChanged: (value) {
                    setState(() {
                      widget.patient.plname = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: widget.patient.telnum.toString(),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  onChanged: (value) {
                    setState(() {
                      widget.patient.telnum = int.tryParse(value);
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: widget.patient.daten != null
                      ? DateFormat('yyyy-MM-dd').format(widget.patient.daten!)
                      : null,
                  decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  onChanged: (value) {
                    setState(() {
                      if (value.isNotEmpty) {
                        widget.patient.daten = DateTime.parse(value);
                      } else {
                        // Handle empty input if needed
                      }
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: widget.patient.adress,
                  decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  onChanged: (value) {
                    setState(() {
                      widget.patient.adress = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: widget.patient.proff,
                  decoration: InputDecoration(
                      labelText: 'Profession',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  onChanged: (value) {
                    setState(() {
                      widget.patient.proff = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  initialValue: widget.patient.ref,
                  decoration: InputDecoration(
                      labelText: 'Reference',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0))),
                  onChanged: (value) {
                    setState(() {
                      widget.patient.ref = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff91C8E4)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onUpdate(widget.patient);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Save Changes'),
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
