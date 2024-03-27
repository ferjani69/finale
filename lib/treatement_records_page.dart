import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search/treatement.dart';
import 'package:search/treatmentlist.dart';
import 'package:search/patient.dart';

class TreatmentRecordsPage extends StatefulWidget {
  final Patient patient;

  const TreatmentRecordsPage({super.key, required this.patient});

  @override
  State<TreatmentRecordsPage> createState() => _TreatmentRecordsPageState();
}

class _TreatmentRecordsPageState extends State<TreatmentRecordsPage> {
 
  void updateList(String value) {
    setState(() {
      display_list = treatment_list.where((treatment) =>
      treatment.natureinterv
          .toString()
          .toLowerCase()
          .contains(value.toLowerCase()) ||
          DateFormat('yyyy-MM-dd')
              .format(treatment.datetreat!)
              .contains(value.toLowerCase())).toList();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treatment Records - ${widget.patient.pname} ${widget.patient.plname}'),
        backgroundColor: const Color(0xff91C8E4),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),


          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [const Center(
              child: Text(
                "Search for a Patient ",
                style: TextStyle(
                  color: Color(0xff4682A9),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
              const SizedBox(height: 10.00,),
              TextField(

                onChanged: (value) => updateList(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xff91C8E4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "eg Youssef Ferjani",
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.white,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {

                          // Action to perform when the "Add Patient" button is pressed
                          // For example, you can navigate to a new screen to add a patient
                        },

                        icon: const Icon(Icons.person_add),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              Text(
                'Treatments for ${widget.patient.pname} ${widget.patient.plname}:',
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Color(0xff4682A9)),
              ),
              const SizedBox(height: 16.0), // Add some space before treatments list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Disable ListView scrolling
                itemCount: treatment_list.length,
                itemBuilder: (context, index) {
                  final treatment = treatment_list[index];
                  return _buildTreatmentItem(treatment);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTreatmentItem(treatment) {
    return Card(
      color: const Color(0xffECF9FF),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${DateFormat('yyyy-MM-dd').format(treatment.datetreat!)}',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff4682A9)),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Dent: ${treatment.dent}',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff4682A9)),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Nature of Intervention: ${treatment.natureinterv}',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff4682A9)),
            ),
          ],
        ),
      ),
    );
  }
}
