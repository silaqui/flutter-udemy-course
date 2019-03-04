import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'e-mail',
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              _email = value;
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'password',
            ),
            obscureText: true,
            onChanged: (value) {
              _password = value;
            },
          ),
          RaisedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
            child: Text('Login'),
          ),
        ]),
      ),
    );
  }
}
