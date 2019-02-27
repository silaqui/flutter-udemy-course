import 'package:flutter/material.dart';
import 'package:flutter_app/product.dart';

class ProductsList extends StatelessWidget {
  final List<String> _products;

  ProductsList(this._products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
      child: Product(_products[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _products.length > 0
        ? ListView.builder(
            itemBuilder: _buildProductItem, itemCount: _products.length)
        : Center(
            child: Text('Nothing on the list :c'),
          );
  }
}
