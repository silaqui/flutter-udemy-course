import 'package:flutter_app/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedProductIndex;
  bool _showFavorite = false;

  List<Product> get products {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    return _showFavorite
        ? List.from(
            _products.where((Product product) => product.isFavorite).toList())
        : List.from(_products);
  }

  bool get displayFavoritesOnly{
    return _showFavorite;
  }

  int getSelectedProductIndex() {
    return _selectedProductIndex;
  }

  Product get selectedProduct {
    return _selectedProductIndex != null
        ? _products[_selectedProductIndex]
        : null;
  }

  void addProduct(Product products) {
    _products.add(products);
    notifyListeners();
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
    notifyListeners();
  }

  void updateProduct(Product products) {
    _products[_selectedProductIndex] = products;
    _selectedProductIndex = null;
    notifyListeners();
  }

  void toggleProductFavoriteStatus() {
    final bool isCurentlyFavorite = _products[_selectedProductIndex].isFavorite;
    final bool newFavoriteState = !isCurentlyFavorite;
    final Product updatedProduct = Product(
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        isFavorite: newFavoriteState);
    updateProduct(updatedProduct);
    notifyListeners();
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
  }

  void toggleDisplayMode() {
    _showFavorite = !_showFavorite;
    notifyListeners();
  }
}
