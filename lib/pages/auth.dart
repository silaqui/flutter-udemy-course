import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String,dynamic>_formData = {
    'email':null,
    'password':null,
    'awsomeness':false
  };


  final GlobalKey<FormState> LOGIN = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Container(
        decoration: BoxDecoration(image: _buildBackgroundImage()),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: LOGIN,
            child: Container(
              width: targetWidth,
              child: SingleChildScrollView(
                child: Column(children: [
                  _buildPasswordTextFormField(),
                  SizedBox(height: 10),
                  _buildEmailTextFormField(),
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
        ),
      ),
    );
  }

  void _submitForm() {
//    if(!LOGIN.currentState.validate() || !_formData['awsomeness']){
//      return;
//    }
    Navigator.pushReplacementNamed(context, '/products');
  }

  SwitchListTile _buildAcceptSwitch() {
    return SwitchListTile(
        title: Text('Is this awsome'),
        value: _formData['awsomeness'],
        onChanged: (bool value) {
          setState(() {
            _formData['awsomeness'] = value;
          });
        });
  }

  TextFormField _buildPasswordTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value){
        if(value.isEmpty)
          return 'Password required';
      },
      onSaved: (String value) {
          _formData['password'] = value;
      },
    );
  }

  TextFormField _buildEmailTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'e-mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if(value.isEmpty || !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?").hasMatch(value))
          return 'Invalid e-mail';
      },
      onSaved: (String value) {
        _formData['email'] = value;
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
