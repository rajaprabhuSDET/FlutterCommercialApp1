import 'package:flutter/material.dart';
import './product_create.dart';
import './product_list.dart';

class ProductsAdmin extends StatelessWidget {
  final Function addProduct;
  final Function deleteProduct;
  final Function updateProduct;
  final List<Map<String, dynamic>> productsList;

  ProductsAdmin(this.addProduct, this.updateProduct, this.deleteProduct,
      this.productsList);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(automaticallyImplyLeading: false, title: Text('Chose')),
          ListTile(
              leading: Icon(Icons.shop),
              title: Text('HomePage'),
              onTap: () => Navigator.pushReplacementNamed(context, '/home'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Products Admin'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Create Product',
                icon: Icon(Icons.create),
              ),
              Tab(
                text: 'List Products',
                icon: Icon(Icons.list),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            CreateProduct(
              addProduct: addProduct,
            ),
            ProductList(productsList, updateProduct)
          ],
        ),
      ),
    );
  }
}
