import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/price_tag_widget.dart';
import 'package:flutter_app/widgets/ui_elements/title_default.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> _product;
  final int productIndex;

  const ProductCard(this._product, this.productIndex);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      Column(children: <Widget>[
        Image.asset(
          _product['image'],
          height: 100.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TitleDefault(_product['title']),
            PriceTag(_product['price'].toString())
          ],
        ),
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text('Union squere, Chicago'),
        )
      ]),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => Navigator.pushNamed<bool>(
                context, '/products/' + productIndex.toString()),
          ),
          IconButton(
              icon: Icon(
                Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {})
        ],
      )
    ]));
    ;
  }
}
