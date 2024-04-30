import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:search/treatement.dart'; // Corrected import statement
import 'package:search/treatement_chart.dart';
import 'package:search/treatmentlist.dart';
import 'package:search/Patients%20class/patient.dart';
import 'Edittreatement.dart';
import 'Widgets/Drawerwidget.dart'; // Import the AppDrawer widget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'package:get/get.dart';

class TreatmentRecordsPage extends StatefulWidget {
  final Patient patient;

   TreatmentRecordsPage({Key? key, required this.patient, required this.addtreat}) : super(key: key);
  final dynamic addtreat;



  @override
  State<TreatmentRecordsPage> createState() => _TreatmentRecordsPageState();
}

class _TreatmentRecordsPageState extends State<TreatmentRecordsPage> {  List<treatement> display_list = [];  // This holds the list of patients displayed in the UI

void initState() {
  super.initState();
  fetchTreatement();  // Fetch data when the widget initializes
}
void navigateToTreatmentChart() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TreatmentChart(
        patient: widget.patient,
        addtreat: addTreatmentToDisplayList,
      ),
    ),
  );

  if (result == true) {
    fetchTreatement();  // Re-fetch treatments to refresh the list
  }
}
void fetchTreatement() async {
  FirebaseFirestore.instance.collection("Treatements").get().then((querySnapshot) {
    List<treatement> tempList = [];  // Temporary list to hold fetched data
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      treatement treat = treatement.fromFirestore(data, doc.id);  // Assuming a correct fromFirestore method exists
      tempList.add(treat);
    }
    setState(() {
      display_list = tempList;  // Update the state with the new list
    });
  }).catchError((error) {
    print("Error fetching patients from Firestore: $error");
  });
}
  void updatedlist(treatement updatedtreat) {
    setState(() {
      int index1 = display_list.indexWhere((treatement) => treatement.id == updatedtreat.id);
      if (index1 != -1) {
        display_list[index1] =updatedtreat ;
      }
    });
  }
void addTreatmentToDisplayList(treatement newTreatment) {
  setState(() {
    display_list.add(newTreatment);
  });
}

  void edittreatmentdetails(treatement treat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => edittreatment(
          treatement1: treat,
          onUpdate: updatedlist
        ),
      ),
    );
  }
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
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TreatmentChart(
                                patient:widget.patient,
                                addtreat: addTreatmentToDisplayList ,



                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_box_rounded),
                        color: Colors.white,
                        iconSize: 30,
                      ),


                    ],
                  ),
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
                itemCount: display_list.length,
                // Use display_list instead of treatment_list
                itemBuilder: (context, index1) {
                  final treatment = display_list[index1]; // Use display_list instead of treatment_list
                  return _buildTreatmentItem(treatment,index1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTreatmentItem(treatment,int index1) {
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
            Row(
              children: [
                Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(treatment.datetreat!)}',
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color(0xff4682A9)),
                ),
        IconButton(
          icon: const Icon(Icons.edit),
          color: const Color(0xff4682A9),
          onPressed: () => edittreatmentdetails(display_list[index1]),
        ), IconButton(
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
                                  display_list.removeAt(index1);
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
