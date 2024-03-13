import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search/treatmentlist.dart';
import 'package:search/patient.dart';

class ViewPatientPage extends StatelessWidget {
  final Patient patient;

  const ViewPatientPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
        backgroundColor: const Color(0xff91C8E4),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem(title: 'First Name', value: patient.pname ?? "N/A"),
              _buildInfoItem(title: 'Last Name', value: patient.plname ?? "N/A"),
              _buildInfoItem(title: 'Phone Number', value: patient.telnum?.toString() ?? "N/A"),
              _buildInfoItem(
                title: 'Date of Birth',
                value: patient.daten != null ? DateFormat('yyyy-MM-dd').format(patient.daten!) : 'N/A',
              ),
              _buildInfoItem(title: 'Address', value: patient.adress ?? "N/A"),
              _buildInfoItem(title: 'Profession', value: patient.proff ?? "N/A"),
              _buildInfoItem(title: 'Reference', value: patient.ref ?? "N/A"),
              const SizedBox(height: 16.0), // Add some space between patient details and treatments
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      ' Treatments:  ',
                      style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, color: Color(0xff4682A9)),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle adding treatment
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff93cdea)),
                      child: const Text('Add Treatment', style: TextStyle(color: Color(0xff4682A9))),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // Disable ListView scrolling
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
              style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,
                color: Color(0xff4682A9),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Dent: ${treatment.dent}',
              style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,
                color: Color(0xff4682A9),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Nature of Intervention: ${treatment.natureinterv}',
              style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold,
                color: Color(0xff4682A9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({required String title, required String value}) {
    return Card(

      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xffECF9FF),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xff4682A9),
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 18.0, color: Color(0xff4682A9)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}