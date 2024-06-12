import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../Widgets/Drawerwidget.dart';

part 'appointment-editor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: AppointmentCalendar(),
    debugShowCheckedModeBanner: false,
  ));
}

class AppointmentCalendar extends StatefulWidget {
  const AppointmentCalendar({super.key});

  @override
  AppointmentCalendarState createState() => AppointmentCalendarState();
}

late DataSource _events;
Meeting? _selectedAppointment;
DateTime _startDate = DateTime.now();
TimeOfDay _startTime = TimeOfDay.now();
DateTime _endDate = DateTime.now().add(const Duration(hours: 1));
TimeOfDay _endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 1);
bool _isAllDay = false;
String _patient = '';
String _notes = '';

class AppointmentCalendarState extends State<AppointmentCalendar> {
  AppointmentCalendarState();
  late List<String> patientCollection;
  late List<Meeting> appointments;
  CalendarController calendarController = CalendarController();
  final databaseReference = FirebaseFirestore.instance;
  @override
  void initState() {
    appointments = <Meeting>[];
    _events = DataSource(appointments);
    _selectedAppointment = null;
    _patient = '';
    _notes = '';
    getDataFromFirestore().then((results) {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }



  // Future<void> getDataFromFireStore() async {
  //   try {
  //     var snapShotsValue = await databaseReference.collection("Appointments").get();
  //
  //     List<Meeting> list = snapShotsValue.docs.map((e) {
  //       try {
  //         var data = e.data();
  //         String patient = data['Patient'] ?? '';
  //         String description = data['Description'] ?? '';
  //         bool isAllDay = data['IsAllDay'] ?? false;
  //
  //         // Default to current date if date is not provided
  //         DateTime currentDate = DateTime.now();
  //         String startTimeStr = data['StartTime'] ?? '00:00';
  //         String endTimeStr = data['EndTime'] ?? '01:00';
  //
  //         DateTime startDateTime = DateTime(
  //           currentDate.year,
  //           currentDate.month,
  //           currentDate.day,
  //           int.parse(startTimeStr.split(':')[0]),
  //           int.parse(startTimeStr.split(':')[1]),
  //         );
  //         DateTime endDateTime = DateTime(
  //           currentDate.year,
  //           currentDate.month,
  //           currentDate.day,
  //           int.parse(endTimeStr.split(':')[0]),
  //           int.parse(endTimeStr.split(':')[1]),
  //         );
  //
  //         return Meeting(
  //           id: e.id,
  //           patient: patient,
  //           from: startDateTime,
  //           to: endDateTime,
  //           description: description,
  //           isAllDay: isAllDay,
  //         );
  //       } catch (parseError) {
  //         if (kDebugMode) {
  //           print("Error parsing document ${e.id}: $parseError");
  //         }
  //         return null;
  //       }
  //     }).where((meeting) => meeting != null).toList().cast<Meeting>();
  //
  //
  //       setState(() {
  //         _events = DataSource(list);
  //       });
  //
  //   } catch (fetchError) {
  //     if (kDebugMode) {
  //       print("Error fetching appointments: $fetchError");
  //     }
  //   }
  // }
  Future<void> getDataFromFirestore() async {
    try {
      var snapshots = await databaseReference.collection("Appointments").get();

      List<Meeting> list = snapshots.docs.map((e) {
        try {
          var data = e.data();
          String patient = data['Patient'] ?? '';
          String description = data['Description'] ?? '';
          bool isAllDay = data['IsAllDay'] ?? false;

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
            id: e.id,
            patient: patient,
            from: startDateTime,
            to: endDateTime,
            description: description,
            isAllDay: isAllDay,
          );
        } catch (parseError) {
          if (kDebugMode) {
            print("Error parsing document ${e.id}: $parseError");
          }
          return null;
        }
      }).where((meeting) => meeting != null).toList().cast<Meeting>();

      setState(() {
        _events = DataSource(list);
      });
    } catch (fetchError) {
      if (kDebugMode) {
        print("Error fetching appointments: $fetchError");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),  // Drawer icon
                onPressed: () {
                  Scaffold.of(context).openDrawer();  // Open the drawer
                },
              );
            }
        ),
        title: Image.asset(
          'assets/appbar_logo.png', // Ensure the asset path is correct
          height: 55,  // Adjusted for visibility
        ),
        centerTitle: true,
      ),
      drawer: const Drawerw(),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
        child: _events.appointments!.isNotEmpty
            ? getAppointmentCalendar(_events, onCalendarTapped)
            : const Center(child: CircularProgressIndicator()),      ),
    );
  }

  SfCalendar getAppointmentCalendar(
      CalendarDataSource calendarDataSource,
      CalendarTapCallback calendarTapCallback,
      ) {
    return SfCalendar(
      view: CalendarView.week,
      controller: calendarController,
      allowedViews: const [
        CalendarView.week,
        CalendarView.timelineWeek,
        CalendarView.month,
        CalendarView.schedule
      ],
      dataSource: calendarDataSource,
      onTap: calendarTapCallback,
      timeSlotViewSettings: const TimeSlotViewSettings(
        startHour: 8,
        endHour: 16,
        timeIntervalHeight: -1,
        timeIntervalWidth: -1,
        minimumAppointmentDuration: Duration(minutes: 60),
      ),
      appointmentBuilder: (context, calendarAppointmentDetails) {
        final Meeting meeting = calendarAppointmentDetails.appointments.first;
        return Container(
          color: meeting.background.withOpacity(0.8),
          child: Text(meeting.patient),
        );
      },
      initialDisplayDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        0,
        0,
        0,
      ),
      monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
    );
  }

  void onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement != CalendarElement.calendarCell &&
        calendarTapDetails.targetElement != CalendarElement.appointment) {
      return;
    }

    setState(() {
      _selectedAppointment = null;
      _isAllDay = false;
      _patient = '';
      _notes = '';
      if (calendarController.view == CalendarView.month) {
        calendarController.view = CalendarView.day;
      } else {
        if (calendarTapDetails.appointments != null &&
            calendarTapDetails.appointments!.length == 1) {
          final Meeting meetingDetails = calendarTapDetails.appointments![0];
          _startDate = meetingDetails.from;
          _endDate = meetingDetails.to;
          _isAllDay = meetingDetails.isAllDay;
          _patient = meetingDetails.patient == '(No title)' ? '' : meetingDetails.patient;
          _notes = meetingDetails.description;
          _selectedAppointment = meetingDetails;
        } else {
          final DateTime date = calendarTapDetails.date!;
          _startDate = date;
          _endDate = date.add(const Duration(hours: 1));
        }
        _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
        Navigator.push<Widget>(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const AppointmentEditor(),
          ),
        );
      }
    });
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;

  @override
  String getSubject(int index) => appointments![index].patient;

  @override
  String getStartTimeZone(int index) => appointments![index].startTimeZone;

  @override
  String getNotes(int index) => appointments![index].description;

  @override
  String getEndTimeZone(int index) => appointments![index].endTimeZone;

  @override
  Color getColor(int index) => appointments![index].background;

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;
}

class Meeting {
  Meeting({
    required this.from,
    required this.to,
    this.background = Colors.green,
    this.isAllDay = false,
    this.patient = '',
    this.startTimeZone = '',
    this.endTimeZone = '',
    this.description = '',
    required this.id,
  });

  final String patient;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
  final String id;
}
