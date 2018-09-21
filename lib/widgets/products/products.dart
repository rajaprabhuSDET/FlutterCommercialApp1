import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './products_card.dart';
import '../../scopedmodel/productmodel.dart';
import '../../model/productinfo.dart';

class Products extends StatelessWidget {
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductModel>(
      builder: (BuildContext context, Widget child, ProductModel model) {
       return _buildProductList(model.products);
      },
    );
  }

  Widget _buildProductList(List<ProductInfo> productslist) {
    Widget productcard = Center(
      child: Text('No Items. Please add some idems'),
    );
    Widget listview = ListView.builder(
      itemBuilder: (BuildContext context, index) =>
          ProductsCard(productslist[index], index),
      itemCount: productslist.length,
    );

    if (productslist.length > 0) {
      return listview;
    } else {
      return productcard;
    }
  }
}
