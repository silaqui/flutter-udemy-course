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
  bool _awsomeness = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.dstATop),
                image: AssetImage('assets/grass.jpg'))),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              TextField(
                decoration: InputDecoration(
                    labelText: 'e-mail', filled: true, fillColor: Colors.white),
                keyboardType: TextInputType.emailAddress,
                onChanged: (String value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                    labelText: 'password',
                    filled: true,
                    fillColor: Colors.white),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              SwitchListTile(
                  title: Text('Is this awsome'),
                  value: _awsomeness,
                  onChanged: (bool value) {
                    setState(() {
                      _awsomeness = value;
                    });
                  }),
              SizedBox(
                height: 20.0,
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
        ),
      ),
    );
  }
}
