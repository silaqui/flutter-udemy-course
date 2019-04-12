import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/pages/auth.dart';
import 'package:flutter_app/pages/product.dart';
import 'package:flutter_app/pages/products.dart';
import 'package:flutter_app/pages/products_admin.dart';
import 'package:flutter_app/scoped-models/main.dart';
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
  final MainModel _model = MainModel();

  @override
  initState() {
    _model.autoAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.lime,
          accentColor: Colors.blueAccent,
          buttonColor: Colors.blueAccent,
        ),
//        home: AuthPage(),
        routes: {
          '/': (BuildContext context) => ScopedModelDescendant(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return model.user != null ? ProductsPage(_model) : AuthPage();
                },
              ),
          '/products': (BuildContext context) => ProductsPage(_model),
          '/admin': (BuildContext context) => ProductAdminPage(_model)
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'products') {
            final String productId = pathElements[2];
            final Product product = _model.allProducts.firstWhere((Product p) {
              return p.id == productId;
            });
            _model.selectProduct(productId);
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => ProductPage(product));
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(_model));
        },
      ),
    );
  }
}
