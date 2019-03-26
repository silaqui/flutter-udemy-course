import 'package:flutter_app/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsModel extends Model {
  List<Product> _products = [];

  List<Product> get products {
    return List.from(_products);
  }

  void _addProduct(Product products) {
    _products.add(products);
  }

  void _deleteProduct(int index) {
    _products.removeAt(index);
  }

  void _updateProduct(int index, Product products) {
    _products[index] = products;
  }
}
