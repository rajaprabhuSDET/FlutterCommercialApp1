import 'package:flutter/material.dart';
import './product_create.dart';
import './product_list.dart';
import '../scopedmodel/mainmodel.dart';
import '../ui_element/logout_list_tile.dart';

class ProductsAdmin extends StatelessWidget {
  final MainModel model;

  ProductsAdmin(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(automaticallyImplyLeading: false, title: Text('Chose')),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('HomePage'),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          Divider(),
          LogoutListTile()
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
          children: <Widget>[CreateProduct(), ProductList(model)],
        ),
      ),
    );
  }
}
