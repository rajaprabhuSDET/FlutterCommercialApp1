import 'package:flutter/material.dart';
import './price_tag.dart';
import './title_default.dart';
import './address_tag.dart';
import '../../model/productinfo.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scopedmodel/mainmodel.dart';

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
        ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            return IconButton(
                icon: Icon(model.allproducts[productIndex].isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.selectProduct(productIndex);
                  model.toggleFavouriteStatus();
                });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/glass.jpg'),
              image: NetworkImage(productslist.image)),
          _buildaddressPricetag(),
          AddressTag('Balaji Nagar Vandiyur Madurai 625020.'),
          Text(productslist.email),
          _buildButtons(context),
        ],
      ),
    );
  }
}
