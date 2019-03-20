import 'dart:async';

import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  final String productName;
  final String productImageUrl;
  final double productPrice;
  final String productDescription;

  ProductPage(this.productName, this.productImageUrl, this.productPrice,
      this.productDescription);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (() {
          Navigator.pop(context, false);
          return Future.value(false);
        }),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Product detail'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(productImageUrl),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    productName,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald'),
                  )),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Text('\$ ' + productPrice.toString(),
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.white)))
                ]),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(productDescription,
                    style: TextStyle(fontFamily: 'Oswald', fontSize: 20.0)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: IconButton(
                      color: Theme.of(context).accentColor,
                      icon: Icon(Icons.delete_forever),
                      onPressed: () {
                        _showWarningDialog(context);
                      }))
                ],
              )
            ],
          ),
        ));
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure'),
            content: Text('This cant be undone 1'),
            actions: <Widget>[
              FlatButton(
                child: Text('DELETE'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              ),
              FlatButton(
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
        context: context);
  }
}
