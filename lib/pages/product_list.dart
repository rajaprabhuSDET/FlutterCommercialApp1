import 'package:flutter/material.dart';

import './product_create.dart';

class ProductList extends StatelessWidget {
  final Function updateProduct;
  final List<Map<String, dynamic>> productsList;

  ProductList(this.productsList, this.updateProduct);
  Widget build(BuildContext context) {
    return Column( crossAxisAlignment: CrossAxisAlignment.center, 
      children: <Widget>[
        ListView.builder( addRepaintBoundaries: true,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(
                  backgroundImage: AssetImage(productsList[index]['imageURL'])
                 ), 
              title: Text(productsList[index]['title']),
              subtitle: Text('\$${productsList[index]['price'].toString()}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return CreateProduct(
                          product: productsList[index],
                          updateProduct: updateProduct,
                          productIndex: index,
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
          itemCount: productsList.length,
        ),
        Divider(),
      ],
    );
  }
}
