import 'package:flutter/material.dart';
import 'package:flutter_app/productsList.dart';

class ProductManager extends StatefulWidget {
  final List<String> startingProducts;

  ProductManager(this.startingProducts);

  @override
  State<StatefulWidget> createState() {
    return _productsManagerState();
  }
}

class _productsManagerState extends State<ProductManager> {
  List<String> _products = [];

  @override
  void initState() {
    _products.addAll(widget.startingProducts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.all(10.0),
        child: RaisedButton(
            child: Text('Add more awsome stuff'),
            onPressed: () {
              setState(() {
                _products.add('To bee or not to bee');
              });
            }),
      ),
      Expanded(
        child: ProductsList(_products),
      )
    ]);
  }
}
