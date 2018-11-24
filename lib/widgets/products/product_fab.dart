import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/productinfo.dart';
import '../../scopedmodel/mainmodel.dart';

class ProductFab extends StatefulWidget {
  final ProductInfo productinfo;
  ProductFab(this.productinfo);

  @override
  State<StatefulWidget> createState() {
    return ProductFabState();
  }
}

class ProductFabState extends State<ProductFab> with TickerProviderStateMixin {
  AnimationController _aniController;

  @override
  void initState() {
    _aniController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 56.0,
              height: 70.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _aniController,
                  curve: Interval(0.0, 1.0, curve: Curves.easeOut),
                ),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).cardColor,
                  heroTag: 'Mail',
                  mini: true,
                  onPressed: () async {
                    final url = 'mailto:${widget.productinfo.email}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'could not launch !';
                    }
                  },
                  child: Icon(
                    Icons.mail,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Container(
              width: 56.0,
              height: 70.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _aniController,
                  curve: Interval(0.0, 0.5, curve: Curves.easeOut),
                ),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).cardColor,
                  heroTag: 'Favourite',
                  mini: true,
                  onPressed: () {
                    model.toggleFavouriteStatus();
                  },
                  child: Icon(
                    model.selectedProduct.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Container(
              width: 56.0,
              height: 70.0,
              child: FloatingActionButton(
                onPressed: () {
                  if (_aniController.isDismissed) {
                    _aniController.forward();
                  } else {
                    _aniController.reverse();
                  }
                },
                child: AnimatedBuilder(
                  animation: _aniController,
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.rotationZ(
                          _aniController.value * 0.5 * math.pi),
                      child: Icon(_aniController.isDismissed
                          ? Icons.more_vert
                          : Icons.close),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
