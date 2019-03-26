import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/price_tag_widget.dart';
import 'package:flutter_app/widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final String productName;
  final String productImageUrl;
  final double productPrice;
  final String location = 'Unknown';
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
                  Expanded(child:TitleDefault(productName)),
                  PriceTag(productPrice.toString())
                ]),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text('This bee is from: ' + location,
                    style: TextStyle(color: Colors.grey,fontFamily: 'Oswald', fontSize: 20.0)),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(productDescription,
                    style: TextStyle(fontFamily: 'Oswald', fontSize: 20.0)),
              ),
            ],
          ),
        ));
  }

}
