import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:search/AddPatientPage.dart';
import 'package:search/Widgets/Drawerwidget.dart';
import 'package:search/Patients%20class/patient.dart';
import 'package:search/edit_patient_page.dart';
import 'Patients class/ptientsList.dart';
import 'package:search/ViewPatientPage.dart';
import 'Widgets/Drawerwidget.dart'; // Import the AppDrawer widget

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SearchPage(patientadd: null,),
    );
  }
}


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.patientadd}) : super(key: key);

  final dynamic patientadd;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void updatelist(String value) {
    setState(() {
      display_list = patient_list.where((element) =>
      element.pname.toString().toLowerCase().contains(value.toLowerCase()) ||
          element.telnum.toString().toLowerCase().contains(value.toLowerCase())
      ).toList();
    });
  }

  void editPatientDetails(Patient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPatientPage(
          patient: patient,
          onUpdate: updatePatientList,
        ),
      ),
    );
  }

  void updatePatientList(Patient updatedPatient) {
    setState(() {
      int index = display_list.indexWhere((patient) => patient.id == updatedPatient.id);
      if (index != -1) {
        display_list[index] = updatedPatient;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF6F4EB),
      appBar: AppBar(
        backgroundColor: const Color(0xff91C8E4),
        elevation: 0.0,
      ),
      drawer: const Drawerw(), // Use the AppDrawer widget here

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => updatelist(value),
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
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPatientPage(
                          patientadd: (newPatient) {
                            setState(() {
                              display_list.add(newPatient);
                            });
                            print('Patient added: $newPatient');
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.person_add),
                  color: const Color(0xff91C8E4),
                  iconSize: 30,
                ),
              ],
            ),
            const SizedBox(height: 10.00,),
            Expanded(
              child: ListView.builder(
                itemCount: display_list.length,
                itemBuilder: (BuildContext context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewPatientPage(patient: display_list[index]),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      color: const Color(0xffECF9FF),
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  display_list[index].pname.toString(),
                                  style: const TextStyle(
                                    color: Color(0xff4682A9),
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  display_list[index].plname.toString(),
                                  style: const TextStyle(color: Color(0xff4682A9)),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16.0),
                            Text(
                              "${display_list[index].telnum}",
                              style: const TextStyle(fontSize: 18.0, color: Color(0xff4682A9)),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: const Color(0xff4682A9),
                                  onPressed: () => editPatientDetails(display_list[index]),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: const Text('Are you sure you want to delete this patient?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('No'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  display_list.removeAt(index);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

