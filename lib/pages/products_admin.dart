import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/pages/product_edit.dart';
import 'package:flutter_app/pages/product_list_.dart';

class ProductAdminPage extends StatelessWidget {

  final Function addProduct;
  final Function updateProduct;
  final Function deleteProduct;
  final List<Product> products;

  const ProductAdminPage(this.products,this.updateProduct, this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: _buildDrawer(context),
          appBar: AppBar(
            title: Text("Products Management"),
            bottom: TabBar(tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Create Product',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Products',
              ),
            ]),
          ),
          body: Center(
            child: TabBarView(children: [
              ProductEditPage(),
              ProductListPage(),
            ]),
          ),
        ));
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Choosen'),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("All Products"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          )
        ],
      ),
    );
  }
}
