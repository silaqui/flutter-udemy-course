import 'package:flutter/material.dart';
import 'package:flutter_app/products_list.dart';

class ProductManager extends StatelessWidget {
  final List<Map<String, String>> products;

  ProductManager(this.products);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Expanded(
      child: ProductsList(products),
    ));
  }
}
