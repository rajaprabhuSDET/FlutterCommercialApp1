import 'package:flutter/material.dart';
import './pages/home.dart';
import './pages/productdetails.dart';
import './pages/products_admin.dart';
import './pages/auth.dart';

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
  final List<Map<String, dynamic>> products = [];

  void addGlass(Map<String, dynamic> glassproduct) {
    setState(() {
      products.add(glassproduct);
      print('inside');
    });
  }

  void _updateGlass(int index, Map<String, dynamic> updatedproduct) {
    setState(() {
      products[index] = updatedproduct;
    });
  }

  void _deleteGlass(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          buttonColor: Colors.deepOrangeAccent),
      //home: Auth(),
      routes: {
        '/': (BuildContext context) => Auth(),
        '/home': (BuildContext context) => HomePage(products),
        '/admin': (BuildContext context) =>
            ProductsAdmin(addGlass, _updateGlass, _deleteGlass, products),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElement = settings.name.split('/');
        if (pathElement[0] != '') {
          return null;
        }
        if (pathElement[1] == 'product') {
          final int index = int.parse(pathElement[2]);
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) => ProductDetails(
                products[index]['title'],
                products[index]['imageURL'],
                products[index]['price'],
                products[index]['description']),
          );
        }
        return null;
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            builder: (BuildContext context) => HomePage(products));
      },
    );
  }
}
