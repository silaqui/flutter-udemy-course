import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_app/models/auth.dart';
import 'package:flutter_app/models/location_data.dart';
import 'package:flutter_app/models/product.dart';
import 'package:flutter_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin ConnectedProducts on Model {
  String _selectedProductId;
  List<Product> _products = [];
  User _authenticatedUser;
  bool _isLoading = false;

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeDate = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-flutterudemycourse.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(
        mimeTypeDate[0],
        mimeTypeDate[1],
      ),
    );

    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] =
        'Bearer ${_authenticatedUser.token}';

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('Something whent wrong while uploading image');
        print(json.decode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> addProduct(String title, String description, double price,
      File image, LocationData locData) async {
    print('Add Product started');
    _isLoading = true;
    notifyListeners();
    final uploadData = await uploadImage(image);
    if (uploadData == null) {
      print('Image upload failed');
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final Map<String, dynamic> productDate = {
      'title': title,
      'description': description,
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id,
      'imageUrl': uploadData['imageUrl'],
      'imagePath': uploadData['imagePath'],
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
          image: uploadData['imageUrl'],
          imagePath: uploadData['imagePath'],
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
          image: value['imageUrl'],
          imagePath: value['imagePath'],
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

  Future<bool> updateProduct(String title, String description, File image,
      double price, LocationData locData) async {
    print('Update product started');
    _isLoading = true;

    String imageUrl = selectedProduct.image;
    String imagePath = selectedProduct.imagePath;

    if (image != null) {
      final uploadData = await uploadImage(image);
      if (uploadData == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }

      imageUrl = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }

    final Map<String, dynamic> updateData = {
      'id': selectedProduct.id,
      'title': title,
      'description': description,
      'price': price,
      'loc_lng': locData.longitude,
      'loc_lat': locData.latitude,
      'loc_address': locData.address,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    try {
      final http.Response response = await http
          .put(
          'https://flutterudemycourse.firebaseio.com/products/${selectedProduct
              .id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(updateData));

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
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
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
        imagePath: selectedProduct.imagePath,
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
          imagePath: selectedProduct.imagePath,
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
    if (productId == null) {
      return;
    }
    notifyListeners();
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
