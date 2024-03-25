import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search/treatmentlist.dart';
import 'package:search/patient.dart';

class TreatmentRecordsPage extends StatelessWidget {
  final Patient patient;

  const TreatmentRecordsPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treatment Records - ${patient.pname} ${patient.plname}'),
        backgroundColor: const Color(0xff91C8E4),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Treatments for ${patient.pname} ${patient.plname}:',
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
