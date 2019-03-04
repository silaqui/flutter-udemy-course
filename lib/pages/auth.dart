import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
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
            onChanged: (String value) {
              setState(() {
                _email = value;
              });
            },
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'password',
            ),
            obscureText: true,
            onChanged: (String value) {
              setState(() {
                _password = value;
              });
            },
          ),
          RaisedButton(
            onPressed: () {
              print(_email);
              print(_password);
              Navigator.pushReplacementNamed(context, '/products');
            },
            child: Text('Login'),
          ),
        ]),
      ),
    );
  }
}
