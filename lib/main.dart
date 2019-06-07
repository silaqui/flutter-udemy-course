import 'package:flutter/material.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/pages/auth.dart';
import 'package:flutter_app/pages/product.dart';
import 'package:flutter_app/pages/products.dart';
import 'package:flutter_app/pages/products_admin.dart';
import 'package:flutter_app/scoped-models/main.dart';
import 'package:flutter_app/shared/globel_config.dart';
import 'package:map_view/map_view.dart';
import 'package:scoped_model/scoped_model.dart';

import './widgets/helpers/custom_route.dart';

void main() {
//    debugPaintSizeEnabled = true;
  MapView.setApiKey(apiKey);
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
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
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductsPage(_model),
          '/admin': (BuildContext context) =>
              !_isAuthenticated ? AuthPage() : ProductAdminPage(_model)
        },
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            AuthPage();
          }
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
            return CustomRoute<bool>(
                builder: (BuildContext context) =>
                    !_isAuthenticated ? AuthPage() : ProductPage(product));
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) =>
                  !_isAuthenticated ? AuthPage() : ProductsPage(_model));
        },
      ),
    );
  }
}
