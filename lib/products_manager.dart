import 'package:flutter/material.dart';
import 'package:flutter_app/products_list.dart';

class ProductManager extends StatelessWidget {

  final List<Map<String,String>> products;
  final Function addProduct;
  final Function deleteProduct;

  ProductManager(this.products, this.addProduct, this.deleteProduct);


  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        margin: EdgeInsets.all(10.0),
        child: RaisedButton(
            child: Text('Add more awsome stuff'),
            onPressed: () {
              addProduct({'title':'Next Bee title','image':'./assets/bee.jpg'});
            }),
      ),
      Expanded(
        child: ProductsList(products,deleteProduct),
      )
    ]);
  }
}
