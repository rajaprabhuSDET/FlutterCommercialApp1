import 'package:flutter/material.dart';
import 'location_data.dart';

class ProductInfo {
  final String id;
  final String image;
  final String title;
  final double price;
  final String description;
  final bool isFavourite;
  final String email;
  final String userID;
  final LocationData location;

  ProductInfo(
      {@required this.id,
        @required this.image,
      @required this.title,
      @required this.price,
      @required this.email,
      @required this.userID,
      @required this.description,
      @required this.location,
      this.isFavourite=false});
}
