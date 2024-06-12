import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';



class Forgotpw extends StatelessWidget {
   Forgotpw({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(

                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Recuperation Password Email Sent Succesfully ")));
                  } catch (e) {
                  // Handle error, show error message
                  }
                  }
                },
                child: const Text('Submit'),
              ),
              const SizedBox(height: 16.0),

            ],
          ),
        ),
      ),
    );
  }
}
