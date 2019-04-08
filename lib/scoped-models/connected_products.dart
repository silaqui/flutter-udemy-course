import 'dart:convert';
import 'dart:async';

import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

mixin ConnectedProducts on Model {
  String _selectedProductId;
  List<Product> _products = [];
  User _authenticatedUser;
  bool _isLoading = false;

  Future<Null> addProduct(
      String title, String description, double price, String imageUrl) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productDate = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          "https://www.sciencemag.org/sites/default/files/styles/inline__450w__no_aspect/public/bee_16x9_0.jpg?itok=Ko9BdUND",
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    return http
        .post('https://flutterudemycourse.firebaseio.com/products.json',
            body: json.encode(productDate))
        .then((http.Response response) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      Product newProduct = new Product(
          id: responseData['name'],
          title: title,
          description: description,
          price: price,
          image: imageUrl,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
    });
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

  int get selectedProductIndex{
    return _products.indexWhere((Product p){return p.id == _selectedProductId;});
  }

  Product get selectedProduct {
    return _selectedProductId != null
        ? _products.firstWhere((Product product) {
            return product.id == _selectedProductId;
          })
        : null;
  }

  void deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;
    final int selectedProductIndex = _products.indexWhere((Product p){return p.id == _selectedProductId;});
    _products.removeAt(selectedProductIndex);
    _selectedProductId = null;
    notifyListeners();
    http
        .delete(
            'https://flutterudemycourse.firebaseio.com/products/${deletedProductId}.json')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://flutterudemycourse.firebaseio.com/products.json')
        .then((http.Response value) {
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
            userId: value['userId']);
        fetchedProductList.add(newProduct);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<Null> updateProduct(
      String title, String description, double price, String imageUrl) {
    _isLoading = true;
    final Map<String, dynamic> updateData = {
      'id': selectedProduct.id,
      'title': title,
      'description': description,
      'price': price,
      'image':
          "https://www.sciencemag.org/sites/default/files/styles/inline__450w__no_aspect/public/bee_16x9_0.jpg?itok=Ko9BdUND",
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    return http
        .put(
            'https://flutterudemycourse.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final Product updatedProduct = new Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: imageUrl,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      final int selectedProductIndex = _products.indexWhere((Product p){return p.id == _selectedProductId;});
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteState = !isCurentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteState);
    final int selectedProductIndex = _products.indexWhere((Product p){return p.id == _selectedProductId;});
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
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
  void login(String email, String password) {
    _authenticatedUser = User(id: '1', email: email, password: password);
  }
}

mixin UtilityModel on ConnectedProducts {
  bool get isLoading {
    return _isLoading;
  }
}
