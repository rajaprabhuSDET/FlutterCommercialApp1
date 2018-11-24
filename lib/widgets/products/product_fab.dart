import 'package:flutter/material.dart';
import '../../model/productinfo.dart';

class ProductFab extends StatefulWidget {

  final ProductInfo productinfo ;
  ProductFab(this.productinfo);

  @override
  State<StatefulWidget> createState() {
    return ProductFabState();
  }
}

class ProductFabState extends State<ProductFab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 56.0,
          height: 70.0,
          alignment: FractionalOffset.topCenter,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).cardColor,
            heroTag: 'Mail',
            mini: true,
            onPressed: () {},
            child: Icon(
              Icons.mail,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Container(
          width: 56.0,
          height: 70.0,
          alignment: FractionalOffset.topCenter,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).cardColor,
            heroTag: 'Favourite',
            mini: true,
            onPressed: () {},
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        ),
        Container(
          width: 56.0,
          height: 70.0,
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }
}
