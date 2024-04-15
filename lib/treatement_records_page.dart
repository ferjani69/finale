import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search/treatement.dart'; // Corrected import statement
import 'package:search/treatmentlist.dart';
import 'package:search/patient.dart';

class TreatmentRecordsPage extends StatefulWidget {
  final Patient patient;


  const TreatmentRecordsPage({Key? key, required this.patient}) : super(key: key);

  @override
  State<TreatmentRecordsPage> createState() => _TreatmentRecordsPageState();
}

class _TreatmentRecordsPageState extends State<TreatmentRecordsPage> {
  void updateList1(String value) {
    setState(() {
      display_list = treatment_list.where((treatment) =>
      treatment.natureinterv!
          .toLowerCase()
          .contains(value.toLowerCase()) ||
          DateFormat('yyyy-MM-dd').format(treatment.datetreat!).contains(value.toLowerCase())).toList();
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
            children: [
              const Center(
                child: Text(
                  "Search for a Treatment",
                  style: TextStyle(
                    color: Color(0xff4682A9),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                onChanged: (value) => updateList1(value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xff91C8E4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "eg Detartrage",
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Treatments for ${widget.patient.pname} ${widget.patient.plname}:',
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xff4682A9)),
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: display_list.length, // Use display_list instead of treatment_list
                itemBuilder: (context, index) {
                  final treatment = display_list[index]; // Use display_list instead of treatment_list
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
