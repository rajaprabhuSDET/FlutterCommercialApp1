import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/productinfo.dart';
import '../model/userinfo.dart';

class ConnectedProductsModel extends Model {
  List<ProductInfo> _products = [];
  int _selProductIndex;
  UserInfo _authUser;
  bool _isLoading = false;

  Future<Null> addGlass(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    Map<String, dynamic> newproductt = {
      'title': title,
      'description': description,
      'image':
          'https://s3.ap-south-1.amazonaws.com/zoom-blog-image/2015/10/155670-3.jpg',
      'price': price,
      'email': _authUser.email,
      'userID': _authUser.userid
    };

    return http
        .post('https://fluttertrial.firebaseio.com/product.json',
            body: json.encode(newproductt))
        .then((http.Response response) {
      final Map<String, dynamic> responsedata = json.decode(response.body);
      final newproductinfo = ProductInfo(
          id: responsedata['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          email: _authUser.email,
          userID: _authUser.userid);
      _products.add(newproductinfo);
      _isLoading = false;
      notifyListeners();
    });
  }
}

class ProductModel extends ConnectedProductsModel {
  bool _showFavourites = false;

  List<ProductInfo> get allproducts {
    return List.from(_products);
  }

  List<ProductInfo> get displayedProducts {
    if (_showFavourites) {
      return _products.where((ProductInfo info) => info.isFavourite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  ProductInfo get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return _products[selectedProductIndex];
  }

  bool get displayFavouritesOnly {
    return _showFavourites;
  }

  Future<Null> updateGlass(
      String title, String description, String image, double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updatedProduct = {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'email': selectedProduct.email,
      'userID': selectedProduct.userID
    };
    return http
        .put(
            'https://fluttertrial.firebaseio.com/product/${selectedProduct.id}.json',
            body: json.encode(updatedProduct))
        .then((http.Response response) {
      final updatedproductinfo = ProductInfo(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          email: selectedProduct.email,
          userID: selectedProduct.userID);
      _products[selectedProductIndex] = updatedproductinfo;
      _isLoading = false;
      notifyListeners();
    });
  }

  void deleteGlass() {
    _isLoading=true;
    final deleteProductID = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selProductIndex=null;
    notifyListeners();
    http
        .delete(
            'https://fluttertrial.firebaseio.com/product/${deleteProductID}.json')
        .then((http.Response response) {
          _isLoading=false;
      notifyListeners();
    });
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    notifyListeners();
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    return http
        .get('https://fluttertrial.firebaseio.com/product.json')
        .then((http.Response response) {
      final Map<String, dynamic> fetchedProducts = json.decode(response.body);
      final List<ProductInfo> fetchedProductList = [];
      if (fetchedProducts == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      fetchedProducts.forEach((String key, dynamic value) {
        final ProductInfo productinfos = ProductInfo(
            title: value['title'],
            description: value['description'],
            image: value['image'],
            price: value['price'],
            id: key,
            email: value['email'],
            userID: value['userID']);
        fetchedProductList.add(productinfos);
      });
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
    });
  }

  void toggleFavouriteStatus() {
    final currentFavouriteStatus = selectedProduct.isFavourite;
    final updatedFavouriteStatus = !currentFavouriteStatus;

    final ProductInfo updatedproduct = ProductInfo(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        image: selectedProduct.image,
        price: selectedProduct.price,
        email: selectedProduct.email,
        userID: selectedProduct.userID,
        isFavourite: updatedFavouriteStatus);
    _products[selectedProductIndex] = updatedproduct;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavourites = !_showFavourites;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  void login(String email, String password) {
    _authUser = UserInfo(email: email, password: password, userid: 'TestUser');
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
