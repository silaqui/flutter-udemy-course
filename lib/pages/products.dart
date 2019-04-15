import 'package:flutter/material.dart';
import 'package:flutter_app/pages/products_list.dart';
import 'package:flutter_app/scoped-models/main.dart';
import 'package:flutter_app/widgets/ui_elements/logout_list_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;

  const ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductPageState();
  }
}

class _ProductPageState extends State<ProductsPage> {
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
            ),
            Divider(),
            LogoutListTile()
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      body: _buildProductList(),
    );
  }

  Widget _buildProductList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, MainModel model) {
        Widget content = Center(
          child: Text('No Product Found'),
        );
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = ProductsList();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: model.fetchProducts,
          child: content,
        );
      },
    );
  }

  @override
  void initState() {
    widget.model.fetchProducts();
    super.initState();
  }
}
