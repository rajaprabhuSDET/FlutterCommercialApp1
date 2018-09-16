import 'package:flutter/material.dart';
import '../widgets/products/products.dart';

class HomePage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  HomePage(this.products); // {}

  Widget _buildSideDrawerr(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(automaticallyImplyLeading: false, title: Text('Chose')),
          ListTile(
              leading: Icon(Icons.edit),
              title: Text('ManageProducts'),
              onTap: () => Navigator.pushReplacementNamed(context, '/admin'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawerr(context),
      appBar: AppBar(
        title: Text('Raja Prabhu Trial1'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          )
        ],
      ),
      body: Products(products),
    );
  }
}
