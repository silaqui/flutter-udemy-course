import 'package:flutter/material.dart';
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
  List<Map<String, dynamic>> _products = [
    {
      'title': 'bee',
      'description': 'This is very nice lorem ipsum descrioption of bee',
      'image': 'assets/bee.jpg',
      'price': 100.0,
      'location':
          'Squere Garden, New York, Or somwhere this one is quite long to see what gona happend'
    }
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
        '/admin': (BuildContext context) =>
            ProductAdminPage(_products,_updateProduct, _addProduct, _deleteProduct)
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
                _products[index]['title'],
                _products[index]['image'],
                _products[index]['price'],
                _products[index]['location'].toString(),
                _products[index]['description']),
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

  void _addProduct(Map<String, dynamic> products) {
    setState(() {
      _products.add(products);
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  void _updateProduct(int index, Map<String, dynamic> products) {
    setState(() {
      _products[index] = products;
    });
  }
}
