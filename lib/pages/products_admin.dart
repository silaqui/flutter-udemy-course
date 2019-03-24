import 'package:flutter/material.dart';
import 'package:flutter_app/pages/product_edit.dart';
import 'package:flutter_app/pages/product_list.dart';

class ProductAdminPage extends StatelessWidget {

  final Function addProduct;
  final Function deleteProduct;
  final List<Map<String, dynamic>> products;

  const ProductAdminPage(this.products, this.addProduct, this.deleteProduct);

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
              ProductEditPage(addProduct: addProduct),
              ProductListPage(products),
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
