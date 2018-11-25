import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:map_view/map_view.dart';
import 'dart:async';
import './pages/home.dart';
import './pages/productdetails.dart';
import './pages/products_admin.dart';
import './pages/auth.dart';
import './scopedmodel/mainmodel.dart';
import './model/productinfo.dart';
import './widgets/helper/custom_route.dart';
import './shared/global_config.dart';

void main() {
  //debugPaintSizeEnabled = true;
  MapView.setApiKey(apiKey);
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
  final _platformChannerl = MethodChannel('flutter/battery');

  Future<Null> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await _platformChannerl.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery Level is $result %.';
    } catch (error) {
      print(error);
      batteryLevel = 'failed to get battery level';
    }
    print(batteryLevel);
  }
  
  @override
  void initState() {
    _getBatteryLevel();
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
        title: 'EasyList',
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
