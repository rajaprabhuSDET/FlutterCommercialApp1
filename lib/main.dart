import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';
import './pages/home.dart';
import './pages/productdetails.dart';
import './pages/products_admin.dart';
import './pages/auth.dart';
import './scopedmodel/mainmodel.dart';
import './model/productinfo.dart';
import './widgets/helper/custom_route.dart';

void main() {
  //debugPaintSizeEnabled = true;
  MapView.setApiKey("AIzaSyAeHEf-EYT6L7vGrr13rHyYgYbloB3BTzk");
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppStateless();
  }
}

class MyAppStateless extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;
  
  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepOrangeAccent),
        //home: Auth(),
        routes: {
          '/': (BuildContext context) =>
              !_isAuthenticated ? Auth() : HomePage(_model),
          '/admin': (BuildContext context) => !_isAuthenticated ? Auth() : ProductsAdmin(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          if(!_isAuthenticated){
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => Auth(),
            );
          }
          final List<String> pathElement = settings.name.split('/');
          if (pathElement[0] != '') {
            return null;
          }
          if (pathElement[1] == 'product') {
            final String productId = pathElement[2];
            final ProductInfo productinfos =
                _model.allproducts.firstWhere((ProductInfo productss) {
              return productss.id == productId;
            });
            return CustomRoute<bool>(
              builder: (BuildContext context) => ProductDetails(productinfos),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => HomePage(_model));
        },
      ),
    );
  }
}
