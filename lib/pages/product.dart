import 'dart:async';

import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {

  final Map<String, String> product;

  ProductPage(this.product);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (() {
          Navigator.pop(context,false);
          return Future.value(false);
        }),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Product detail'),
          ),
          body: Column(
            children: <Widget>[
              Image.asset(product['image']),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text((product['title'])),
              ),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text('DELETE'),
                    onPressed: () => Navigator.pop(context, true),
                  ))
            ],
          ),
        ));
  }
}
