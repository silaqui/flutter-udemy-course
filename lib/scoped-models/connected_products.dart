import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

mixin ConnectedProducts on Model {
  int selProductIndex;
  List<Product> products = [];
  User authenticatedUser;


  void addProduct(String title, String description,double price, String imageUrl
      ) {
    Product product = new Product(
        title: title,
        description: description,
        price: price,
        image: imageUrl,
        userEmail: authenticatedUser.email,
        userId: authenticatedUser.id);
    products.add(product);
    selProductIndex = null;
    notifyListeners();
  }


}