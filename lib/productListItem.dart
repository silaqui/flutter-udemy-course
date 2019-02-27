import 'package:flutter/material.dart';

@immutable
class ProductListItem extends StatelessWidget{

  String name;

  ProductListItem(String name){
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