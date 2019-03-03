import 'package:flutter/material.dart';
import 'package:flutter_app/pages/product_create.dart';
import 'package:flutter_app/pages/product_list.dart';

class ProductAdminPage extends StatelessWidget {

  final Function addProduct;
  final Function deleteProduct;

  const ProductAdminPage(this.addProduct, this.deleteProduct);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                AppBar(
                  title: Text('Choosen'),
                ),
                ListTile(
                  title: Text("All Products"),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                )
              ],
            ),
          ),
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
              ProductCreatePage(addProduct),
              ProductListPage(),
            ]),
          ),
        ));
  }
}
