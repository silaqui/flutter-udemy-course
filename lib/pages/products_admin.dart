import 'package:flutter/material.dart';
import 'package:flutter_app/pages/products.dart';

class ProductAdminPage extends StatelessWidget {
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ProductsPage()));
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
                text: 'Create Product',),
              Tab(
                icon: Icon(Icons.list),
                text: 'My Products',),
            ]),
          ),
          body: Center(
            child: Text("Yup"),
          ),
        ));
  }
}
