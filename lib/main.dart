import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/pages/auth.dart';
import 'package:flutter_app/pages/product.dart';
import 'package:flutter_app/pages/products.dart';
import 'package:flutter_app/pages/products_admin.dart';
import 'package:flutter_app/scoped-models/products.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
//    debugPaintSizeEnabled = true;
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<ProductsModel>(
      model: ProductsModel(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.lime,
          accentColor: Colors.blueAccent,
          buttonColor: Colors.blueAccent,
        ),
//        home: AuthPage(),
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/products': (BuildContext context) => ProductsPage(),
          '/admin': (BuildContext context) =>
              ProductAdminPage(null, null, null, null)
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'products') {
            final int index = int.parse(pathElements[2]);
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) =>
                    ProductPage(null, null, null, null));
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage());
        },
      ),
    );
  }
}
