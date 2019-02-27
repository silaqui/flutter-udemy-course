import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {

  final String title;
  final String imageUrl;


  ProductPage({this.title='', this.imageUrl=''});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Product detail'),
        ),
        body: Column(
          children: <Widget>[
            Image.asset("assets/bee.jpg"),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(title),
            ),
            Container(
                padding: EdgeInsets.all(10.0),
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text('BACK'),
                  onPressed: () => Navigator.pop(context),
                ))
          ],
        ));
  }
}
