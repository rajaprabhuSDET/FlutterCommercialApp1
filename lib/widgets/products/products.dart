import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './products_card.dart';
import '../../scopedmodel/mainmodel.dart';
import '../../model/productinfo.dart';

class Products extends StatelessWidget {
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
       return _buildProductList(model.displayedProducts);
      },
    );
  }

  Widget _buildProductList(List<ProductInfo> productslist) {
    Widget productcard = Center(
      child: Text('No Items. Please add some idems'),
    );
    Widget listview = ListView.builder(
      itemBuilder: (BuildContext context, index) =>
          ProductsCard(productslist[index] ),
      itemCount: productslist.length,
    );

    if (productslist.length > 0) {
      return listview;
    } else {
      return productcard;
    }
  }
}
