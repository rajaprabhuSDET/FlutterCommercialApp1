import 'package:flutter/material.dart';

class ProductInfo {
  final String image;
  final String title;
  final double price;
  final String description;

  ProductInfo(
      {@required this.image,
      @required this.title,
      @required this.price,
      @required this.description});
}
