import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './pages/home.dart';
import './pages/productdetails.dart';
import './pages/products_admin.dart';
import './pages/auth.dart';
import './scopedmodel/mainmodel.dart';
import './model/productinfo.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppStateless();
  }
}

class MyAppStateless extends State<MyApp> {
  Widget build(BuildContext context) {
    MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple,
            buttonColor: Colors.deepOrangeAccent),
        //home: Auth(),
        routes: {
          '/': (BuildContext context) => Auth(),
          '/home': (BuildContext context) => HomePage(model),
          '/admin': (BuildContext context) => ProductsAdmin(model),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElement = settings.name.split('/');
          if (pathElement[0] != '') {
            return null;
          }
          if (pathElement[1] == 'product') {
            final String productId = pathElement[2];
            final ProductInfo productinfos =model.allproducts.firstWhere((ProductInfo productss){
              return productss.id == productId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  ProductDetails(productinfos),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => HomePage(model));
        },
      ),
    );
  }
}
