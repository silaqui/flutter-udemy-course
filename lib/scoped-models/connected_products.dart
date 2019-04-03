import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

mixin ConnectedProducts on Model {
  int _selProductIndex;
  List<Product> _products = [];
  User _authenticatedUser;


  void addProduct(String title, String description, double price,
      String imageUrl) {
    Product product = new Product(
        title: title,
        description: description,
        price: price,
        image: imageUrl,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id);
    _products.add(product);
    notifyListeners();
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

  void updateProduct(String title, String description, double price,
      String imageUrl) {
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

mixin UserModel on ConnectedProducts{

  void login(String email, String password) {
    _authenticatedUser = User(id: '1', email: email, password: password);
  }

}