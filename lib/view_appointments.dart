import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:search/Patients%20class/patient.dart';

// Meeting class
class Meeting {
  final String id;
  final String patient;
  final DateTime from;
  final DateTime to;
  final String description;
  final bool isAllDay;

  Meeting({
    required this.id,
    required this.patient,
    required this.from,
    required this.to,
    required this.description,
    required this.isAllDay,
  });
}

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Meeting>> getAppointmentsByPatient(String? firstName, String? lastName) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection("Appointments")
          .where("Patient", isEqualTo: "${firstName!} ${lastName!}")
          .get();

      List<Meeting> appointments = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        DateTime startDate = (data['StartDate'] as Timestamp).toDate();
        DateTime endDate = (data['EndDate'] as Timestamp).toDate();
        String startTimeStr = data['StartTime'] ?? '00:00';
        String endTimeStr = data['EndTime'] ?? '01:00';

        DateTime startDateTime = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
          int.parse(startTimeStr.split(':')[0]),
          int.parse(startTimeStr.split(':')[1]),
        );

        DateTime endDateTime = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          int.parse(endTimeStr.split(':')[0]),
          int.parse(endTimeStr.split(':')[1]),
        );

        return Meeting(
          id: doc.id,
          patient: '${data['PatientFirstName']} ${data['PatientLastName']}',
          from: startDateTime,
          to: endDateTime,
          description: data['Description'] ?? '',
          isAllDay: data['IsAllDay'] ?? false,
        );
      }).toList();

      return appointments;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting appointments: $e");
      }
      return [];
    }
  }
}

class ViewAppointmentsPage extends StatefulWidget {
  final Patient patient;

  const ViewAppointmentsPage({super.key, required this.patient});

  @override
  State<ViewAppointmentsPage> createState() => _ViewAppointmentsPageState();
}

class _ViewAppointmentsPageState extends State<ViewAppointmentsPage> {
  late Future<List<Meeting>> _appointmentsFuture;

  @override
  void initState() {
    super.initState();
    _appointmentsFuture = AppointmentService().getAppointmentsByPatient(widget.patient.pname, widget.patient.plname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Appointments'),
        backgroundColor: const Color(0xff91C8E4),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appointments for ${widget.patient.pname} ${widget.patient.plname}:',
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color(0xff4682A9)),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Meeting>>(
                future: _appointmentsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No appointments found"));
                  }

                  List<Meeting> appointments = snapshot.data!;

                  return ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      return _buildAppointmentItem(appointment);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentItem(Meeting appointment) {
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
              'Date: ${DateFormat('yyyy-MM-dd').format(appointment.from)}',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff4682A9)),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Time: ${DateFormat('HH:mm').format(appointment.from)} - ${DateFormat('HH:mm').format(appointment.to)}',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff4682A9)),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Description: ${appointment.description}',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff4682A9)),
            ),
            const SizedBox(height: 8.0),
            if (appointment.isAllDay)
              const Text(
                'All Day Event',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff4682A9)),
              ),
          ],
        ),
      ),
    );
  }
}
