import 'package:flutter/material.dart';
import 'package:flutter_app/productsManager.dart';

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: Text('Home Page'),
          ),
          body: ProductManager({'title':'Bee title','image':'./assets/bee.jpg'}),
        );
  }

}