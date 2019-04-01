import 'package:flutter/material.dart';
import 'package:flutter_app/pages/product_edit.dart';
import 'package:flutter_app/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatelessWidget {
//  final List<Product> products;
//  final Function updateProduct;
//  final Function deleteProduct;
//
//  const ProductListPage(this.products, this.updateProduct, this.deleteProduct);

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            model.selectProduct(index);
            return ProductEditPage();
          }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(model.products[index].title),
            background: Container(color: Colors.red),
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.horizontal)
                model.selectProduct(index);
              model.deleteProduct();
            },
            child: Column(
              children: <Widget>[
                ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(model.products[index].image),
                    ),
                    title: Text(model.products[index].title),
                    subtitle: Text('\$${model.products[index].price}'),
                    trailing: _buildEditButton(context, index, model)),
                Divider(),
              ],
            ),
          );
        },
        itemCount: model.products.length,
      );
    });
  }
}
