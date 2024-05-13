/*import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SMSPage(),
    );
  }
}

class SMSPage extends StatefulWidget {
  @override
  _SMSPageState createState() => _SMSPageState();
}

class _SMSPageState extends State<SMSPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _sendSMS() async {
    String _result = await sendSMS(
      message: _messageController.text,
      recipients: [_phoneNumberController.text],
    ).catchError((onError) {
      print(onError);
    });
    print(_result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send SMS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'SMS Message',
              ),
            ),
            ElevatedButton(
              child: Text('Send SMS'),
              onPressed: _sendSMS,
            ),
          ],
        ),
      ),
    );
  }
}
*/