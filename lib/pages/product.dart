import 'dart:async';

import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {

  final String productName;
  final String productImageUrl;

  ProductPage(this.productName, this.productImageUrl);

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
              Image.asset(productImageUrl),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text((productName)),
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
