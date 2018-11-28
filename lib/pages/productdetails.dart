import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/products/title_default.dart';
import '../model/productinfo.dart';
import '../widgets/products/product_fab.dart';
import 'package:map_view/map_view.dart';

class ProductDetails extends StatelessWidget {
  final ProductInfo productinfos;

  ProductDetails(this.productinfos);
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

  void _showMap() {
    final List<Marker> marker = <Marker>[
      Marker('position', 'position', productinfos.location.latitude,
          productinfos.location.longitude)
    ];
    final camerapositon = CameraPosition(
        Location(
            productinfos.location.latitude, productinfos.location.longitude),
        14.0);
    final mapview = MapView();
    mapview.show(
        MapOptions(
            initialCameraPosition: camerapositon,
            mapViewType: MapViewType.normal,
            title: 'Product Location'),
        toolbarActions: [ToolbarAction('Close', 1)]);
    mapview.onToolbarAction.listen((int id) {
      if (id == 1) {
        mapview.dismiss();
      }
    });
    mapview.onMapReady.listen((_) {
      mapview.setMarkers(marker);
    });
  }

  Widget _buildAddressPrice(String address, double price) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: _showMap,
          child: Text(
            address,
            style: TextStyle(fontFamily: 'Symbol', color: Colors.grey),
          ),
        ),
        Container(
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        /* appBar: AppBar(
          title: Text(productinfos.title),
        ), */
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 256.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(productinfos.title),
                background: Hero(
                  tag: productinfos.id,
                  child: FadeInImage(
                    height: 300.0,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/glass.jpg'),
                    image: NetworkImage(productinfos.image),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: TitleDefault(productinfos.title),
                  ),
                  /* Container(
              padding: EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text('Delete'),
                color: Theme.of(context).primaryColorDark,
                onPressed: () => _alertDialoug(context),
              ),
            ),*/
                  _buildAddressPrice(
                      productinfos.location.address, productinfos.price),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      productinfos.description,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: ProductFab(productinfos),
      ),
    );
  }
}
