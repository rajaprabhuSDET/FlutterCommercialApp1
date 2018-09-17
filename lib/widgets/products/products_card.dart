import 'package:flutter/material.dart';
import './price_tag.dart';
import './title_default.dart';
import './address_tag.dart';
import '../../model/productinfo.dart';

class ProductsCard extends StatelessWidget {
  final ProductInfo productslist;
  final int productIndex;

  ProductsCard(this.productslist, this.productIndex);

  Widget _buildaddressPricetag() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(productslist.title),
          SizedBox(
            width: 8.0,
          ),
          PriceTag(productslist.price.toString())
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.info),
          onPressed: () => Navigator.pushNamed<bool>(
              context, '/product/' + productIndex.toString()),
        ),
        IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(productslist.image),
          _buildaddressPricetag(),
          AddressTag('Balaji Nagar Vandiyur Madurai 625020.'),
          _buildButtons(context),
        ],
      ),
    );
  }
}
