import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// Import Cupertino for the CupertinoIcons
import 'package:search/Feedback.dart';
import 'package:search/Login.dart';
import 'package:search/Privacy.dart';
import 'package:search/appointment_module/main.dart';
import 'package:search/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
class Drawerw extends StatefulWidget {
   const Drawerw({super.key});

  @override
  State<Drawerw> createState() => _DrawerwState();
}

class _DrawerwState extends State<Drawerw> {
  @override

  final user = FirebaseAuth.instance.currentUser;
  String? userEmail;
  @override
   void initState() {
     super.initState();
     final user = FirebaseAuth.instance.currentUser;
     userEmail = user?.email;
   }

   Future<void> signOut(BuildContext context) async {

    try {


      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()), // Replace AuthPage with your login page
            (route) => false,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      } // Handle any errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
           UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            accountName: const Text("Dentist Rim"), // Replace with user's name
            accountEmail: Text(userEmail!), // Replace with user's email
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/female.png'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today), // Add the calendar icon
            title: const Text('Appointments'), // Specify the title
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AppointmentCalendar()),
              );
              },
          ),
          ListTile(
            leading: const Icon(Icons.people), // Person icon
            title: const Text('View Patients'), // Specify the title
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchPage(patientadd: null)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback), // Add the feedback icon
            title: const Text('Send Feedback'), // Specify the title
            onTap: () {Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const FeedbackFormPage(),));
              // Handle tap event
              // Handle tap event
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip), // Add the privacy icon
            title: const Text('Privacy and Policy'), // Specify the title
            onTap: () {Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Privacypolicy(),));
              // Handle tap event
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.settings), // Settings icon
          //   title: const Text('Settings'), // Specify the title
          //   onTap: () {
          //     // Handle tap event
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.logout_rounded), // logout
            title: const Text('Log Out '), // Specify the title
            onTap: ()   {
              signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
