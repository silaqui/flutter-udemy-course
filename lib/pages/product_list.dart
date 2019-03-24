import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductListPage(this.products);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Image(
              image: new AssetImage(products[index]['image']),
              fit: BoxFit.contain),
          title: Text(products[index]['title']),
          trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {}),
        );
      },
      itemCount: products.length,
    );
  }
}
