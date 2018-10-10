import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedmodel/mainmodel.dart';
import './product_create.dart';

class ProductList extends StatefulWidget {
  final MainModel model;
  ProductList(this.model);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductListBuild();
  }
}

class _ProductListBuild extends State<ProductList> {
  @override
  initState() {
    widget.model.fetchProducts(onlyForUser: true);
    super.initState();
  }

  Widget _buildIconButton(BuildContext context, int index) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return IconButton(
          icon: Icon(Icons.edit),
          onPressed: () {
            model.selectProduct(model.allproducts[index].id);
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
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.allproducts[index].title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectProduct(model.allproducts[index].id);
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
                            NetworkImage(model.allproducts[index].image),
                      ),
                      title: Text(model.allproducts[index].title),
                      subtitle: Text(
                          '\$${model.allproducts[index].price.toString()}'),
                      trailing: _buildIconButton(context, index)),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.allproducts.length,
        );
      },
    );
  }
}
