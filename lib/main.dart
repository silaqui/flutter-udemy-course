import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/pages/auth.dart';
import 'package:flutter_app/pages/product.dart';
import 'package:flutter_app/pages/products.dart';
import 'package:flutter_app/pages/products_admin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
//    debugPaintSizeEnabled = true;
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  List<Product> _products = [
    Product(
      title: 'bee',
      description: 'This is very nice lorem ipsum descrioption of bee',
      image: 'assets/bee.jpg',
      price: 100.0,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lime,
        accentColor: Colors.blueAccent,
        buttonColor: Colors.blueAccent,
      ),
//        home: AuthPage(),
      routes: {
        '/': (BuildContext context) => AuthPage(),
        '/products': (BuildContext context) => ProductsPage(_products),
        '/admin': (BuildContext context) => ProductAdminPage(
            _products, _updateProduct, _addProduct, _deleteProduct)
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        if (pathElements[1] == 'products') {
          final int index = int.parse(pathElements[2]);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductPage(
                _products[index].title,
                _products[index].image,
                _products[index].price,
                _products[index].description),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(_products));
      },
    );
  }
}
