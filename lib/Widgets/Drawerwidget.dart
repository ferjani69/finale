import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import Cupertino for the CupertinoIcons
import 'package:search/Feedback.dart';
import 'package:search/Privacy.dart';
import 'package:search/main.dart';

class Drawerw extends StatelessWidget {
  const Drawerw({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            accountName: Text("Amine Mouneni"), // Replace with user's name
            accountEmail: Text('Aminemouneni@gmail.com'), // Replace with user's email
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/hassen.png'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today), // Add the calendar icon
            title: const Text('Appointments'), // Specify the title
            onTap: () {
              // Handle tap event
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
                MaterialPageRoute(builder: (context) => FeedbackFormPage(),));
              // Handle tap event
              // Handle tap event
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip), // Add the privacy icon
            title: const Text('Privacy and Policy'), // Specify the title
            onTap: () {Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Privacypolicy(),));
              // Handle tap event
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings), // Settings icon
            title: const Text('Settings'), // Specify the title
            onTap: () {
              // Handle tap event
            },
          ),
          ListTile(
            leading: const Icon(Icons.people), // Person icon
            title: const Text('View Patients'), // Specify the title
            onTap: () {
              // Handle tap event
            },
          ),
        ],
      ),
    );
  }
}
