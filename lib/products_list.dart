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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_products[index]['title'],
                style: TextStyle(fontFamily: 'Oswald', fontSize: 26.0)),
            SizedBox(
              width: 8,
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Text('\$ ' + _products[index]['price'].toString(),
                    style: TextStyle(fontSize: 18.0, color: Colors.white)))
          ],
        ),
        Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration( border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(6), ),
          child: Text('Union squere, Chicago'),

        )
      ]),
      ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.info, color: Theme.of(context).accentColor,),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ProductPage(
                      _products[index]['title'], _products[index]['image']),
                )),
          ),
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.red,),
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
