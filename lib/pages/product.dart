import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped-models/main.dart';
import 'package:flutter_app/widgets/price_tag_widget.dart';
import 'package:flutter_app/widgets/ui_elements/title_default.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: (() {
      Navigator.pop(context, false);
      return Future.value(false);
    }), child: ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Product product = model.products[productIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text('Product detail'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(product.image),
              Container(
                padding: EdgeInsets.all(10),
                child: Row(children: [
                  Expanded(
                      child: TitleDefault(product.title)),
                  PriceTag(product.price.toString())
                ]),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text('This bee is from: Minesota',
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Oswald',
                        fontSize: 20.0)),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(product.description,
                    style: TextStyle(fontFamily: 'Oswald', fontSize: 20.0)),
              ),
            ],
          ),
        );
      },
    ));
  }
}
