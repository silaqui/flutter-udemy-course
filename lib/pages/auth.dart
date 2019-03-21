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
        decoration: BoxDecoration(image: _buildBackgroundImage()),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              _buildEmailTextField(),
              SizedBox(height: 10),
              _buildPasswordTextField(),
              _buildAcceptSwitch(),
              SizedBox(height: 20.0),
              RaisedButton(
                onPressed: _submitForm,
                child: Text('Login'),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    print(_email);
    print(_password);
    Navigator.pushReplacementNamed(context, '/products');
  }

  SwitchListTile _buildAcceptSwitch() {
    return SwitchListTile(
        title: Text('Is this awsome'),
        value: _awsomeness,
        onChanged: (bool value) {
          setState(() {
            _awsomeness = value;
          });
        });
  }

  TextField _buildPasswordTextField() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'password', filled: true, fillColor: Colors.white),
      obscureText: true,
      onChanged: (String value) {
        setState(() {
          _password = value;
        });
      },
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
          labelText: 'e-mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      onChanged: (String value) {
        setState(() {
          _email = value;
        });
      },
    );
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
        image: AssetImage('assets/grass.jpg'));
  }
}
