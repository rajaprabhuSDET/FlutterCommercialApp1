import 'package:flutter/material.dart';

class ProductInfo {
  final String image;
  final String title;
  final double price;
  final String description;
  final bool isFavourite;
  final String email;
  final String userID;

  ProductInfo(
      {@required this.image,
      @required this.title,
      @required this.price,
      @required this.email,
      @required this.userID,
      @required this.description,
      this.isFavourite=false});
}
