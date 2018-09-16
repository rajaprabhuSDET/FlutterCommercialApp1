import 'package:flutter/material.dart';

import './product_create.dart';

class ProductList extends StatelessWidget {
  final Function updateProduct;
  final Function deleteProduct;
  final List<Map<String, dynamic>> products;

  ProductList(this.products, this.updateProduct, this.deleteProduct);

  Widget _buildIconButton(BuildContext context, int index) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return CreateProduct(
                product: products[index],
                updateProduct: updateProduct,
                productIndex: index,
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: Key(products[index]['title']),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              deleteProduct(index);
            } else if (direction == DismissDirection.startToEnd) {
              deleteProduct(index);
            }
          },
          background: Container(color: Colors.red),
          child: Column(
            children: <Widget>[
              ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(products[index]['imageURL']),
                  ),
                  title: Text(products[index]['title']),
                  subtitle: Text('\$${products[index]['price'].toString()}'),
                  trailing: _buildIconButton(context, index)),
              Divider()
            ],
          ),
        );
      },
      itemCount: products.length,
    );
  }
}
