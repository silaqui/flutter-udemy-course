import 'package:flutter_app/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  int _selectedProductIndex;

  List<Product> get products {
    return List.from(_products);
  }

  int getSelectedProductIndex(){
    return _selectedProductIndex;
  }

  Product getSelectedProduct(){
    return _selectedProductIndex != null ?_products[_selectedProductIndex] : null;
  }

  void addProduct(Product products) {
    _products.add(products);
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
  }

  void updateProduct(Product products) {
    _products[_selectedProductIndex] = products;
    _selectedProductIndex = null;
  }

  void selectProduct(int index){
    _selectedProductIndex = index;
  }
}
