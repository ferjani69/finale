import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:search/Widgets/Drawerwidget.dart';

class Privacypolicy extends StatelessWidget {
  const Privacypolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),
        backgroundColor: Colors.blue[700], // Matching the SearchPage AppBar background color
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu), // Adding a menu icon similar to SearchPage
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Assuming you have a Drawer setup
            },
          ),
        ),
        title:

        const Text('Privacy Policy'), // Keeping the original title
        centerTitle: true, // Centering the title
      ),
      drawer:  Drawerw(),

      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width, // Dynamic width
          child: FutureBuilder(
            future: rootBundle.loadString('assets/Privacypolicy.md'),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0), // Increased padding
                  child: MarkdownWidget(
                    data: snapshot.data!,
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
