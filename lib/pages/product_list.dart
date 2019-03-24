import 'package:flutter/material.dart';
import 'package:flutter_app/pages/product_edit.dart';

class ProductListPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;
  final Function updateProduct;

  const ProductListPage(this.products, this.updateProduct);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Image(
              image: new AssetImage(products[index]['image']),
              fit: BoxFit.contain),
          title: Text(products[index]['title']),
          trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return ProductEditPage(product: products[index], updateProduct: updateProduct, productIndex: index,);
                    }));
              }),
        );
      },
      itemCount: products.length,
    );
  }
}
