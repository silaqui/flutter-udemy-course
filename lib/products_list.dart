import 'package:flutter/material.dart';
import 'package:flutter_app/pages/product.dart';

class ProductsList extends StatelessWidget {
  final List<Map<String, dynamic>> _products;

//  final Function _deleteProduct;

  ProductsList(this._products);

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
        child: Column(children: <Widget>[
      Column(children: <Widget>[
        Image.asset(
          _products[index]['image'],
          height: 100.0,
        ),
        Text(_products[index]['title'])
      ]),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text('Details'),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ProductPage(
                      _products[index]['title'], _products[index]['image']),
                )),
          )
        ],
      )
    ]));
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
