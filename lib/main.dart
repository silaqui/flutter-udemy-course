import 'package:flutter/material.dart';
import 'package:flutter_app/productsManager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
        appBar: AppBar(
          title: Text('Nice App Bro'),
        ),
//        body: ProductManager(['a']),
        body: ProductManager([]),
    ));
  }
}
