import 'package:flutter/material.dart';

@immutable
class Product extends StatelessWidget{

  String name;

  Product(String name){
    this.name=name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset("assets/bee.jpg"),
        Text(name)
      ],
    );
  }

}