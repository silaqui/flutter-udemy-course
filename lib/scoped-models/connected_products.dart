import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/models/auth.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/models/location_data.dart';

mixin ConnectedProducts on Model {
  String _selectedProductId;
  List<Product> _products = [];
  User _authenticatedUser;
  bool _isLoading = false;

  Future<bool> addProduct(String title, String description, double price,
      String imageUrl, LocationData locData) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productDate = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          "https://www.sciencemag.org/sites/default/files/styles/inline__450w__no_aspect/public/bee_16x9_0.jpg?itok=Ko9BdUND",
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address
    };
    try {
      final http.Response response = await http.post(
          'https://flutterudemycourse.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productDate));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      Product newProduct = new Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          location: locData,
          image: imageUrl,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

mixin ProductsModel on ConnectedProducts {
  bool _showFavorite = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    return _showFavorite
        ? List.from(
            _products.where((Product product) => product.isFavorite).toList())
        : List.from(_products);
  }

  bool get displayFavoritesOnly {
    return _showFavorite;
  }

  String get selectedProductId {
    return _selectedProductId;
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product p) {
      return p.id == _selectedProductId;
    });
  }

  Product get selectedProduct {
    return _selectedProductId != null
        ? _products.firstWhere((Product product) {
            return product.id == _selectedProductId;
          })
        : null;
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    final int selectedProductIndex = _products.indexWhere((Product p) {
      return p.id == _selectedProductId;
    });
    _products.removeAt(selectedProductIndex);
    _selectedProductId = null;
    notifyListeners();
    return http
        .delete(
            'https://flutterudemycourse.firebaseio.com/products/$deletedProductId.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<Null> fetchProducts([onlyUsersProducts = true]) {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
            'https://flutterudemycourse.firebaseio.com/products.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response value) {
      final List<Product> fetchedProductList = [];
      final dynamic productListDate = json.decode(value.body);
      if (productListDate == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListDate.forEach((String productId, dynamic value) {
        Product newProduct = new Product(
          id: productId,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          image: value['image'],
          userEmail: value['userEmail'],
          userId: value['userId'],
          location: LocationData(
              value['loc_lat'], value['loc_lng'], value['loc_address']),
          isFavorite: value['wishlistUsers'] != null
              ? (value['wishlistUsers'] as Map<String, dynamic>)
                  .containsKey(_authenticatedUser.id)
              : false,
        );
        fetchedProductList.add(newProduct);
      });
      _products = onlyUsersProducts
          ? fetchedProductList.where((Product p) {
              return p.userId == _authenticatedUser.id;
            }).toList()
          : fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selectedProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> updateProduct(
      String title, String description, double price, String imageUrl, LocationData locData) {
    _isLoading = true;
    final Map<String, dynamic> updateData = {
      'id': selectedProduct.id,
      'title': title,
      'description': description,
      'price': price,
      'loc_lng': locData.longitude,
      'loc_lat': locData.latitude,
      'loc_address': locData.address,
      'image':
          "https://www.sciencemag.org/sites/default/files/styles/inline__450w__no_aspect/public/bee_16x9_0.jpg?itok=Ko9BdUND",
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    return http
        .put(
            'https://flutterudemycourse.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Product updatedProduct = new Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: imageUrl,
          location: locData,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      final int selectedProductIndex = _products.indexWhere((Product p) {
        return p.id == _selectedProductId;
      });
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void toggleProductFavoriteStatus() async {
    final bool isCurentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteState = !isCurentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        location: selectedProduct.location,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteState);

    final int selectedProductIndex = _products.indexWhere((Product p) {
      return p.id == _selectedProductId;
    });
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
    http.Response response;
    if (newFavoriteState) {
      response = await http.put(
          'https://flutterudemycourse.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: jsonEncode(true));
    } else {
      response = await http.delete(
          'https://flutterudemycourse.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          location: selectedProduct.location,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId,
          isFavorite: !newFavoriteState);
      final int selectedProductIndex = _products.indexWhere((Product p) {
        return p.id == _selectedProductId;
      });
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void selectProduct(String productId) {
    _selectedProductId = productId;
    if (_selectedProductId != null) {
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProducts {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDvqPP7LGbFvl97ti-blDHmEP2KNoYwzDI',
          body: json.encode(authData),
          headers: {'Content-Tupe': 'application/json'});
    } else {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDvqPP7LGbFvl97ti-blDHmEP2KNoYwzDI',
          body: json.encode(authData),
          headers: {'Content-Tupe': 'application/json'});
    }
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    bool hasError = true;
    var message = 'Something is no yes';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
      _authenticatedUser = User(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      print(responseData['expiresIn']);
      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
      final now = DateTime.now();
      final expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Invalid password';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Email not found';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parseExpiryTime = DateTime.parse(expiryTimeString);
      if (parseExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String email = prefs.getString('userEmail');
      final String id = prefs.getString('userId');
      final int tokenLifespan = parseExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: id, email: email, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
    _userSubject.add(false);
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

mixin UtilityModel on ConnectedProducts {
  bool get isLoading {
    return _isLoading;
  }
}
