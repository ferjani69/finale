part of 'main.dart';

class AppointmentEditor extends StatefulWidget {
  const AppointmentEditor({super.key});

  @override
  AppointmentEditorState createState() => AppointmentEditorState();
}

class AppointmentEditorState extends State<AppointmentEditor> {

  final databaseReference = FirebaseFirestore.instance;


  Future<void> _addAppointment() async {
    await databaseReference.collection("Appointments").add({
      'Patient': _patient,
      'StartDate': _startDate,
      'EndDate': _endDate,
      'StartTime': _startTime.format(context),
      'EndTime': _endTime.format(context),
      'Description': _notes,
      'IsAllDay': _isAllDay,
    }).then((docRef) {
      if (kDebugMode) {
        print("Document written with ID: ${docRef.id}");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Error adding document: $error");
      }
    });
  }

  Future<void> _updateAppointment(String docId) async {
    await databaseReference.collection("Appointments").doc(docId).update({
      'Patient': _patient,
      'StartDate': _startDate,
      'EndDate': _endDate,
      'StartTime': _startTime.format(context),
      'EndTime': _endTime.format(context),
      'Description': _notes,
      'IsAllDay': _isAllDay,
    }).then((_) {
      if (kDebugMode) {
        print("Document updated");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Error updating document: $error");
      }
    });

  }

  Future<void> _deleteAppointment(String docId) async {
    await databaseReference.collection("Appointments").doc(docId).delete().then((_) {
      if (kDebugMode) {
        print("Document deleted");
      }
    }).catchError((error) {
      if (kDebugMode) {
        print("Error deleting document: $error");
      }
    });
  }

  Widget _getAppointmentEditor(BuildContext context) {
    return Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: const Text(''),
              title: TextField(
                controller: TextEditingController(text: _patient),
                onChanged: (String value) {
                  _patient = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add Patient Name',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Icon(
                  Icons.access_time,
                  color: Colors.black54,
                ),
                title: Row(children: <Widget>[
                  const Expanded(
                    child: Text('All-day'),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: _isAllDay,
                            onChanged: (bool value) {
                              setState(() {
                                _isAllDay = value;
                              });
                            },
                          ))),
                ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                                DateFormat('EEE, MMM dd yyyy')
                                    .format(_startDate),
                                textAlign: TextAlign.left),
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _startDate) {
                                setState(() {
                                  final Duration difference =
                                      _endDate.difference(_startDate);
                                  _startDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _startTime.hour,
                                      _startTime.minute,
                                      0);
                                  _endDate = _startDate.add(difference);
                                  _endTime = TimeOfDay(
                                      hour: _endDate.hour,
                                      minute: _endDate.minute);
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                                  child: Text(
                                    DateFormat('hh:mm a').format(_startDate),
                                    textAlign: TextAlign.right,
                                  ),
                                  onTap: () async {
                                    final TimeOfDay? time =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: _startTime.hour,
                                                minute: _startTime.minute));

                                    if (time != null && time != _startTime) {
                                      setState(() {
                                        _startTime = time;
                                        final Duration difference =
                                            _endDate.difference(_startDate);
                                        _startDate = DateTime(
                                            _startDate.year,
                                            _startDate.month,
                                            _startDate.day,
                                            _startTime.hour,
                                            _startTime.minute,
                                            0);
                                        _endDate = _startDate.add(difference);
                                        _endTime = TimeOfDay(
                                            hour: _endDate.hour,
                                            minute: _endDate.minute);
                                      });
                                    }
                                  })),
                    ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Text(''),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                              DateFormat('EEE, MMM dd yyyy').format(_endDate),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _endDate) {
                                setState(() {
                                  final Duration difference =
                                      _endDate.difference(_startDate);
                                  _endDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _endTime.hour,
                                      _endTime.minute,
                                      0);
                                  if (_endDate.isBefore(_startDate)) {
                                    _startDate = _endDate.subtract(difference);
                                    _startTime = TimeOfDay(
                                        hour: _startDate.hour,
                                        minute: _startDate.minute);
                                  }
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                                  child: Text(
                                    DateFormat('hh:mm a').format(_endDate),
                                    textAlign: TextAlign.right,
                                  ),
                                  onTap: () async {
                                    final TimeOfDay? time =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: _endTime.hour,
                                                minute: _endTime.minute));

                                    if (time != null && time != _endTime) {
                                      setState(() {
                                        _endTime = time;
                                        final Duration difference =
                                            _endDate.difference(_startDate);
                                        _endDate = DateTime(
                                            _endDate.year,
                                            _endDate.month,
                                            _endDate.day,
                                            _endTime.hour,
                                            _endTime.minute,
                                            0);
                                        if (_endDate.isBefore(_startDate)) {
                                          _startDate =
                                              _endDate.subtract(difference);
                                          _startTime = TimeOfDay(
                                              hour: _startDate.hour,
                                              minute: _startDate.minute);
                                        }
                                      });
                                    }
                                  })),
                    ])),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.subject,
                color: Colors.black87,
              ),
              title: TextField(
                controller: TextEditingController(text: _notes),
                onChanged: (String value) {
                  _notes = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add description',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(getTile()),
          backgroundColor: Colors.green,
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            IconButton(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              icon: const Icon(
                Icons.done,
                color: Colors.white,
              ),
              onPressed: () {
                final List<Meeting> meetings = <Meeting>[];
                meetings.add(Meeting(
                  from: _startDate,
                  to: _endDate,
                  background: Colors.teal.shade400,
                  description: _notes,
                  isAllDay: _isAllDay,
                  patient: _patient == '' ? '(No title)' : _patient,
                  id: _selectedAppointment?.id ?? '',
                ));
                if (_selectedAppointment != null) {
                  // Update existing appointment
                  _updateAppointment(_selectedAppointment!.id);
                } else {
                  // Add new appointment
                  _addAppointment();
                  _events.appointments!.add(meetings[0]);
                  _events.notifyListeners(
                      CalendarDataSourceAction.add, meetings);
                }


                _selectedAppointment = null;

                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          child: Stack(
            children: <Widget>[
              _getAppointmentEditor(context),
            ],
          ),
        ),
        floatingActionButton: _selectedAppointment == null
            ? const Text('')
            : FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text(
                      'Are you sure you want to delete this Appointment?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        if (_selectedAppointment != null) {
                          _deleteAppointment(_selectedAppointment!.id!);
                          _events.appointments!.removeAt(_events.appointments!.indexOf(_selectedAppointment));
                          _events.notifyListeners(CalendarDataSourceAction.remove, <Meeting>[_selectedAppointment!]);
                          _selectedAppointment = null;
                          Navigator.pop(context);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
          backgroundColor: Colors.red,
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
          ),
        ),
      ),
    );
  }


  String getTile() {
    return _patient.isEmpty ? 'New Appointment' : 'Appointment details';
  }
}
