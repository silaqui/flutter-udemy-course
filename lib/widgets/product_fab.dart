import "package:flutter/material.dart";
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductFab extends StatefulWidget {
  final Product product;

  ProductFab(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFabState();
  }
}

class _ProductFabState extends State<ProductFab> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: 70,
              width: 56,
              alignment: FractionalOffset.topCenter,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).cardColor,
                heroTag: 'contact',
                mini: true,
                onPressed: () {},
                child: Icon(
                  Icons.mail,
                  color: Theme.of(context).accentColor,
                ),
              )),
          Container(
            height: 70,
            width: 56,
            alignment: FractionalOffset.topCenter,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).cardColor,
              mini: true,
              heroTag: 'favorite',
              onPressed: () {
                model.toggleProductFavoriteStatus();
              },
              child: Icon(
                  model.selectedProduct.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Theme.of(context).accentColor),
            ),
          ),
          Container(
            height: 70,
            width: 56,
            child: FloatingActionButton(
              heroTag: 'options',
              onPressed: () {},
              child: Icon(Icons.more_vert),
            ),
          ),
        ],
      );
    });
  }
}
