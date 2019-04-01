import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped-models/products.dart';
import 'package:flutter_app/widgets/product_card_widget.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsList extends StatelessWidget {

  Widget _buildContent(List<Product> _products) {
    return _products.length > 0
        ? ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(_products[index], index),
        itemCount: _products.length)
        : Center(
      child: Text('Nothing on the list :c'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(builder: (BuildContext context, Widget child, ProductsModel model){
      return _buildContent(model.displayedProducts);

    });


  }
}
