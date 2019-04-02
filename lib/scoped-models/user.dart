import 'package:flutter_app/models/user.dart';
import 'package:flutter_app/scoped-models/connected_products.dart';

mixin UserModel on ConnectedProducts{

  void login(String email, String password){
    authenticatedUser = User(id:'1',email: email,password: password);
  }



}