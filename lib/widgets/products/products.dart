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
    Widget productcard ;
    if (productslist.length > 0) {
      productcard = ListView.builder(
      itemBuilder: (BuildContext context, index) =>
          ProductsCard(productslist[index], index),
      itemCount: productslist.length,
    );
    } else {
      productcard = Container(child: Center(child: Text("No Items Found"),),);
    }
    return productcard;
  }
}
