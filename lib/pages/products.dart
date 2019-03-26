import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/products_list.dart';

class ProductsPage extends StatelessWidget {
  final List<Product> products;

  ProductsPage(this.products);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text("Choosen"),
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Manage Products"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/admin');
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          )
        ],
      ),
      body: ProductsList(products),
    );
  }
}
