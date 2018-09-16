import 'package:flutter/material.dart';
import './products_card.dart';

class Products extends StatelessWidget {
  final List<Map<String, dynamic>> productslist;
  Products(this.productslist);

  Widget build(BuildContext context) {
    return _buildProductList();
  }

  Widget _buildProductList() {
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
