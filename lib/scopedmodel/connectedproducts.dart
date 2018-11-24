import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/productinfo.dart';
import '../model/userinfo.dart';
import '../model/authmodel.dart';
import '../model/location_data.dart';

mixin ConnectedProductsModel on Model {
  List<ProductInfo> _products = [];
  String _selproductId;
  UserInfo _authUser;
  bool _isLoading = false;
}

mixin ProductModel on ConnectedProductsModel {
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

  String get selectedProductId {
    return _selproductId;
  }

  ProductInfo get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((ProductInfo info) {
      return info.id == _selproductId;
    });
  }

  bool get displayFavouritesOnly {
    return _showFavourites;
  }

  int get selectedProductIndex {
    return _products.indexWhere((ProductInfo info) {
      return info.id == _selproductId;
    });
  }

  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-fluttertrial.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );
    imageUploadRequest.files.add(file);
    if (imagePath != null) {
      imageUploadRequest.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imageUploadRequest.headers['Authorization'] = 'Bearer ${_authUser.token}';

    try {
      final streamedResponses = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponses);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('something went wrong');
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

  Future<bool> addGlass(String title, String description, File image,
      double price, LocationData locData) async {
    _isLoading = true;
    print(locData.latitude);
    print(locData.longitude);
    notifyListeners();

    final uploadData = await uploadImage(image);
    if (uploadData == null) {
      print('upload failed');
      return false;
    }

    Map<String, dynamic> newproductt = {
      'title': title,
      'description': description,
      'price': price,
      'email': _authUser.email,
      'userID': _authUser.userid,
      'imagePath': uploadData['imagePath'],
      'imageURL': uploadData['imageUrl'],
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address
    };
    try {
      final http.Response response = await http.post(
          'https://fluttertrial.firebaseio.com/product.json?auth=${_authUser.token}',
          body: json.encode(newproductt));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responsedata = json.decode(response.body);
      final ProductInfo newproductinfo = ProductInfo(
          id: responsedata['name'],
          title: title,
          description: description,
          imagePath: uploadData['imagePath'],
          image: uploadData['imageUrl'],
          price: price,
          location: locData,
          email: _authUser.email,
          userID: _authUser.userid);
      _products.add(newproductinfo);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateGlass(String title, String description, File image,
      double price, LocationData locData) async {
    _isLoading = true;
    notifyListeners();
    String imageURL = selectedProduct.image;
    String imagePath = selectedProduct.imagePath;
    if (image != null) {
      final uploadData = await uploadImage(image);
      if (uploadData == null) {
        print('upload failed');
        return false;
      }

      imageURL = uploadData['imageUrl'];
      imagePath = uploadData['imagePath'];
    }
    final Map<String, dynamic> updatedProduct = {
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'imageURL': imageURL,
      'price': price,
      'email': selectedProduct.email,
      'userID': selectedProduct.userID,
      'loc_lat': locData.latitude,
      'loc_lng': locData.longitude,
      'loc_address': locData.address
    };
    try {
      await http.put(
          'https://fluttertrial.firebaseio.com/product/${selectedProduct.id}.json?auth=${_authUser.token}',
          body: json.encode(updatedProduct));
      _isLoading = false;
      final ProductInfo updatedproductinfo = ProductInfo(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: imageURL,
          imagePath: imagePath,
          price: price,
          location: locData,
          email: selectedProduct.email,
          userID: selectedProduct.userID);
      _products[selectedProductIndex] = updatedproductinfo;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteGlass() {
    _isLoading = true;
    final deleteProductID = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _selproductId = null;
    notifyListeners();
    return http
        .delete(
            'https://fluttertrial.firebaseio.com/product/$deleteProductID.json?auth=${_authUser.token}')
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

  void selectProduct(String productId) {
    _selproductId = productId;
    if (productId != null) {
      notifyListeners();
    }
  }

  Future<Null> fetchProducts({onlyForUser = false, clearExisting = false}) {
    _isLoading = true;
    if (clearExisting) {
      _products = [];
    }
    notifyListeners();
    return http
        .get(
            'https://fluttertrial.firebaseio.com/product.json?auth=${_authUser.token}')
        .then<Null>((http.Response response) {
      final List<ProductInfo> fetchedProductList = [];
      final Map<String, dynamic> fetchedProducts = json.decode(response.body);
      if (fetchedProducts == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      fetchedProducts.forEach(
        (String key, dynamic value) {
          print(value);
          final ProductInfo productinfos = ProductInfo(
            title: value['title'],
            description: value['description'],
            imagePath: value['imagePath'],
            image: value['imageURL'],
            price: value['price'],
            location: LocationData(
              address: value['loc_address'],
              latitude: value['loc_lat'],
              longitude: value['loc_lng'],
            ),
            id: key,
            email: value['email'],
            userID: value['userID'],
            isFavourite: value['wishlistusers'] == null
                ? false
                : (value['wishlistusers'] as Map<String, dynamic>)
                    .containsKey(_authUser.userid),
          );
          fetchedProductList.add(productinfos);
        },
      );
      _products = onlyForUser
          ? fetchedProductList.where((ProductInfo productinfo) {
              return productinfo.userID == _authUser.userid;
            }).toList()
          : fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selproductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  void toggleFavouriteStatus(ProductInfo toggledProduct) async {
    final bool currentFavouriteStatus = toggledProduct.isFavourite;
    final bool updatedFavouriteStatus = !currentFavouriteStatus;
    final int toggledProductIndex =
        _products.indexWhere((ProductInfo productin) {
      return productin.id == toggledProduct.id;
    });
    final ProductInfo updatedproduct = ProductInfo(
        id: toggledProduct.id,
        title: toggledProduct.title,
        description: toggledProduct.description,
        imagePath: toggledProduct.imagePath,
        image: toggledProduct.image,
        price: toggledProduct.price,
        location: toggledProduct.location,
        email: toggledProduct.email,
        userID: toggledProduct.userID,
        isFavourite: updatedFavouriteStatus);
    _products[toggledProductIndex] = updatedproduct;
    notifyListeners();

    http.Response response;
    if (updatedFavouriteStatus) {
      response = await http.put(
          'https://fluttertrial.firebaseio.com/product/${toggledProduct.id}/wishlistusers/${_authUser.userid}.json?auth=${_authUser.token}',
          body: json.encode(true),
          headers: {'Content-Type': 'application/json'});
    } else {
      response = await http.delete(
          'https://fluttertrial.firebaseio.com/product/${toggledProduct.id}/wishlistusers/${_authUser.userid}.json?auth=${_authUser.token}',
          headers: {'Content-Type': 'application/json'});
    }
    if (response.statusCode != 200 && response.statusCode != 201) {
      final ProductInfo updatedproduct = ProductInfo(
          id: toggledProduct.id,
          title: toggledProduct.title,
          description: toggledProduct.description,
          image: toggledProduct.image,
          imagePath: toggledProduct.imagePath,
          price: toggledProduct.price,
          email: toggledProduct.email,
          location: toggledProduct.location,
          userID: toggledProduct.userID,
          isFavourite: !updatedFavouriteStatus);
      _products[toggledProductIndex] = updatedproduct;
      notifyListeners();
    }
    //_selproductId = null;
  }

  void toggleDisplayMode() {
    _showFavourites = !_showFavourites;
    notifyListeners();
  }
}

mixin UserModel on ConnectedProductsModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  UserInfo get user {
    return _authUser;
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
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyA62ORhyJdB1rZQ_yIAPayGhjIKyYUHp1s',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyA62ORhyJdB1rZQ_yIAPayGhjIKyYUHp1s',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }
    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something Went Wrong !';
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authendication succeeded!';
      _authUser = UserInfo(
          userid: responseData['localId'],
          email: email,
          token: responseData['idToken']);
      setAuthTimeOut(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('email', email);
      prefs.setString('userid', responseData['localId']);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email not found !';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Password in invalid !';
    } else if (responseData['error']['message'] == 'USER_DISABLED') {
      message = 'This User was Disabled !';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists !';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String expiryTimeString = prefs.getString('expiryTime');
    final String token = prefs.getString('token');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedexpiryTime = DateTime.parse(expiryTimeString);
      if (parsedexpiryTime.isBefore(now)) {
        _authUser = null;
        notifyListeners();
        return;
      }
      final String userid = prefs.getString('userid');
      final String email = prefs.getString('email');
      final int tokenLifeSpan = parsedexpiryTime.difference(now).inSeconds;
      _authUser = UserInfo(userid: userid, email: email, token: token);
      _userSubject.add(true);
      setAuthTimeOut(tokenLifeSpan);
      notifyListeners();
    }
  }

  void logout() async {
    _authUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    _selproductId = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('email');
    prefs.remove('userid');
  }

  void setAuthTimeOut(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }
}

mixin UtilityModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
