import 'package:scoped_model/scoped_model.dart';

import '../model/productinfo.dart';
import '../model/userinfo.dart';

class ConnectedProductsModel extends Model {
  List<ProductInfo> _products = [];
   int _selProductIndex;
  UserInfo _authUser;

  void addGlass(String title, String description,String image, double price) {
    final newproductinfo = ProductInfo(
        title: title,
        description: description,
        image: image,
        price: price,
        email: _authUser.email,
        userID: _authUser.userid);
    _products.add(newproductinfo);
    notifyListeners();
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

  void updateGlass(String title, String description,String image, double price) {
    final updatedproductinfo = ProductInfo(
        title: title,
        description: description,
        image: image,
        price: price,
        email: selectedProduct.email,
        userID: selectedProduct.userID);
    _products[selectedProductIndex] = updatedproductinfo;
    notifyListeners();
  }

  void deleteGlass() {
    _products.removeAt(selectedProductIndex);
    notifyListeners();
  }

  void selectProduct(int index) {
    _selProductIndex = index;
    notifyListeners();
  }

  void toggleFavouriteStatus() {
    final currentFavouriteStatus = selectedProduct.isFavourite;
    final updatedFavouriteStatus = !currentFavouriteStatus;

    final ProductInfo updatedproduct = ProductInfo(
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
