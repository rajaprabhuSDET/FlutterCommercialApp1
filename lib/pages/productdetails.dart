import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import '../widgets/products/title_default.dart';
import '../scopedmodel/mainmodel.dart';
import '../model/productinfo.dart';

class ProductDetails extends StatelessWidget {
  final productIndex;
  ProductDetails(this.productIndex) {
    print('inside constructor');
  }

  _alertDialoug(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you Sure?'),
          content: Text('These cannot be undone'),
          actions: <Widget>[
            FlatButton(
              child: Text('Discard'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('Continue'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context, true);
              },
            )
          ],
        );
      },
    );
  }

  Widget _buildAddressPrice(double price) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Address to display',
          style: TextStyle(fontFamily: 'Symbol', color: Colors.grey),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: 'Symbol', color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
    }, child: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          final ProductInfo info= model.allproducts[productIndex];
      return Scaffold(
        appBar: AppBar(
          title: Text(info.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(info.image),
            Container(
              padding: EdgeInsets.all(10.0),
              child: TitleDefault(info.title),
            ),
            /* Container(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text('Delete'),
                color: Theme.of(context).primaryColorDark,
                onPressed: () => _alertDialoug(context),
              ),
            ),*/
            _buildAddressPrice(info.price),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                info.description,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }));
  }
}
