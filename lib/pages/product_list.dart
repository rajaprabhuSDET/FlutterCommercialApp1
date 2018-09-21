import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedmodel/productmodel.dart';
import './product_create.dart';
import '../model/productinfo.dart';

class ProductList extends StatelessWidget {
  Widget _buildIconButton(BuildContext context, int index) {
    return ScopedModelDescendant<ProductModel>(
      builder: (BuildContext context, Widget child, ProductModel model) {
        return IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            model.selectProduct(index);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return CreateProduct();
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductModel>(
      builder: (BuildContext context, Widget child, ProductModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.products[index].title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectProduct(index);
                  model.deleteGlass();
                } else if (direction == DismissDirection.startToEnd) {
                  model.deleteGlass();
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            AssetImage(model.products[index].image),
                      ),
                      title: Text(model.products[index].title),
                      subtitle:
                          Text('\$${model.products[index].price.toString()}'),
                      trailing: _buildIconButton(context, index)),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.products.length,
        );
      },
    );
  }
}
