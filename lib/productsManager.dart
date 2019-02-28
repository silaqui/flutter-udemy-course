import 'package:flutter/material.dart';
import 'package:flutter_app/productsList.dart';

class ProductManager extends StatefulWidget {

  final Map<String, String> startingProduct;

  ProductManager(this.startingProduct);

  @override
  State<StatefulWidget> createState() {
    return _productsManagerState();
  }
}

class _productsManagerState extends State<ProductManager> {
  List<Map<String, String>> _products = [];

  @override
  void initState() {
    _products.add(widget.startingProduct);
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
              _addProduct({'title':'Next Bee title','image':'./assets/bee.jpg'});
            }),
      ),
      Expanded(
        child: ProductsList(_products,_deleteProduct),
      )
    ]);
  }

  void _addProduct(Map<String, String> products) {
    setState(() {
      _products.add(products);
    });
  }
  void _deleteProduct(int index){
    setState((){
      _products.removeAt(index);
    });
  }
}
