import 'package:flutter/material.dart';

class AddressTag extends StatelessWidget {
  final String adress;

  AddressTag(this.adress);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey),
      ),
      child: Text(adress),
    );
  }
}
