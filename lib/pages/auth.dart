import 'package:flutter/material.dart';
import 'package:flutter_app/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

enum AuthMode { Signup, Login }

class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'awsomeness': false
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    return Scaffold(
      appBar:
          AppBar(title: Text(_authMode == AuthMode.Login ? 'Login' : 'Signup')),
      body: Container(
        decoration: BoxDecoration(image: _buildBackgroundImage()),
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              width: targetWidth,
              child: SingleChildScrollView(
                child: Column(children: [
                  _buildEmailTextFormField(),
                  SizedBox(height: 10),
                  _buildPasswordTextFormField(),
                  SizedBox(height: 10),
                  _authMode == AuthMode.Signup
                      ? _buildPasswordConfrimTextFormField()
                      : Container(),
                  SizedBox(height: 10),
                  _buildAcceptSwitch(),
                  SizedBox(height: 20.0),
                  FlatButton(
                    child: Text(
                        'Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}'),
                    onPressed: () {
                      setState(() {
                        _authMode = _authMode == AuthMode.Login
                            ? AuthMode.Signup
                            : AuthMode.Login;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  ScopedModelDescendant<MainModel>(builder:
                      (BuildContext context, Widget child, MainModel model) {
                    return model.isLoading
                        ? CircularProgressIndicator()
                        : RaisedButton(
                            onPressed: () =>
                                _submitForm(model.login, model.signup),
                            child: Text(_authMode == AuthMode.Login
                                ? 'LOGIN'
                                : 'SIGNUP'),
                          );
                  })
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm(Function login, Function signup) async {
    if (!_formKey.currentState.validate() || !_formData['awsomeness']) {
      return;
    }
    _formKey.currentState.save();
    if (_authMode == AuthMode.Login) {
      login(_formData['email'], _formData['password']);
    } else {
      final Map<String, dynamic> successInformation =
          await signup(_formData['email'], _formData['password']);

      if (successInformation['success']) {
        Navigator.pushReplacementNamed(context, '/products');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('An Error Occured!'),
                content: Text(successInformation['message']),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    }
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
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) return 'Password required';
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  TextFormField _buildPasswordConfrimTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'confirm passwor', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) return 'Invalid password';
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
      controller: _emailTextController,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) return 'Invalid e-mail';
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
