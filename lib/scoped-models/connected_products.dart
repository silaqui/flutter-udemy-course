import 'dart:convert';
import 'dart:async';

import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

mixin ConnectedProducts on Model {
  int _selProductIndex;
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

  int getSelectedProductIndex() {
    return _selProductIndex;
  }

  Product get selectedProduct {
    return _selProductIndex != null ? _products[_selProductIndex] : null;
  }

  void deleteProduct() {
    _products.removeAt(_selProductIndex);
    notifyListeners();
  }

  void fetchProducts(){
    _isLoading = true;
    notifyListeners();
    http.get('https://flutterudemycourse.firebaseio.com/products.json')
        .then((http.Response value){
          final List<Product> fetchedProductList = [];
        final dynamic productListDate = json.decode(value.body);
        if(productListDate == null){
          _isLoading = false;
          notifyListeners();
          return;
        }

        productListDate.forEach((String productId, dynamic value) {
          Product newProduct = new Product(
              id: value['name'],
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

  void updateProduct(
      String title, String description, double price, String imageUrl) {
    Product updatedProduct = new Product(
        title: title,
        description: description,
        price: price,
        image: imageUrl,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);
    _products[_selProductIndex] = updatedProduct;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isCurentlyFavorite = _products[_selProductIndex].isFavorite;
    final bool newFavoriteState = !isCurentlyFavorite;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteState);
    _products[_selProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    if (index != null) {
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