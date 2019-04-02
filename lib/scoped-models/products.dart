import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/scoped-models/connected_products.dart';

mixin ProductsModel on ConnectedProducts {
  bool _showFavorite = false;

  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayedProducts {
    return _showFavorite
        ? List.from(
            products.where((Product product) => product.isFavorite).toList())
        : List.from(products);
  }

  bool get displayFavoritesOnly {
    return _showFavorite;
  }

  int getSelectedProductIndex() {
    return selProductIndex;
  }

  Product get selectedProduct {
    return selProductIndex != null ? products[selProductIndex] : null;
  }

  void deleteProduct() {
    products.removeAt(selProductIndex);
    selProductIndex = null;
    notifyListeners();
  }

  void updateProduct(
      String title, String description, double price, String imageUrl) {
    Product updatedProduct = new Product(
        title: title,
        description: description,
        price: price,
        image: imageUrl,
        userEmail: authenticatedUser.email,
        userId: authenticatedUser.id);
    products[selProductIndex] = updatedProduct;
    selProductIndex = null;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isCurentlyFavorite = products[selProductIndex].isFavorite;
    final bool newFavoriteState = !isCurentlyFavorite;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteState);
    products[selProductIndex] = updatedProduct;
    notifyListeners();
    selProductIndex = null;
  }

  void selectProduct(int index) {
    selProductIndex = index;
  }

  void toggleDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}
