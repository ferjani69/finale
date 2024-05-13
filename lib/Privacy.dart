
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:flutter/material.dart';
class Privacypolicy extends StatelessWidget {
  const Privacypolicy({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Privacy Policy')),
      ),
      body: Center(
        child: SizedBox(
          width: 1000, // Adjust width as needed
          child: FutureBuilder(
            future: rootBundle.loadString('assets/Privacypolicy.md'),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(16.0), // Adjust padding as needed
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