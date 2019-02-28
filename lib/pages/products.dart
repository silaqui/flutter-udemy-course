import 'package:flutter/material.dart';
import 'package:flutter_app/pages/products_admin.dart';
import 'package:flutter_app/products_manager.dart';

class ProductsPage extends StatelessWidget {
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
              title: Text("Manage Products"),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) => ProductAdminPage()),);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: ProductManager({'title': 'Bee title', 'image': './assets/bee.jpg'}),
    );
  }
}
