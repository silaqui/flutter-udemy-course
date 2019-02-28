import 'package:flutter/material.dart';
import 'package:flutter_app/pages/auth.dart';

void main() => runApp(MyApp());

//just to check
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primarySwatch: Colors.deepOrange, accentColor: Colors.orangeAccent),
      home: AuthPage(),
    );
  }
}
