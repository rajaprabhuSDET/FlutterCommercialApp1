import 'package:flutter/material.dart';
import './price_tag.dart';
import './title_default.dart';
import './address_tag.dart';
import '../../model/productinfo.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../scopedmodel/mainmodel.dart';

class ProductsCard extends StatelessWidget {
  final ProductInfo productslist;

  ProductsCard(this.productslist);

  Widget _buildaddressPricetag() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(child: TitleDefault(productslist.title)),
          Flexible(child: SizedBox(width: 8.0)),
          Flexible(child: PriceTag(productslist.price.toString()))
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                model.selectProduct(productslist.id);
                Navigator.pushNamed<bool>(
                        context, '/product/' + productslist.id)
                    .then((_) => model.selectProduct(null));
              },
            ),
            IconButton(
              icon: Icon(productslist.isFavourite
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                //model.selectProduct(productslist.id);
                model.toggleFavouriteStatus(productslist);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Hero(
            tag: productslist.id,
            child: FadeInImage(
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/glass.jpg'),
              image: NetworkImage(productslist.image),
            ),
          ),
          _buildaddressPricetag(),
          SizedBox(height: 10.0),
          AddressTag(productslist.location.address),
          _buildButtons(context),
        ],
      ),
    );
  }
}
