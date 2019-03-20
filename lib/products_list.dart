import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/product_card_widget.dart';

class ProductsList extends StatelessWidget {
  final List<Map<String, dynamic>> _products;

  ProductsList(this._products);

  @override
  Widget build(BuildContext context) {
    return _products.length > 0
        ? ListView.builder(
            itemBuilder: (BuildContext context, int index) =>
                ProductCard(_products[index], index),
            itemCount: _products.length)
        : Center(
            child: Text('Nothing on the list :c'),
          );
  }
}
