import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  Product({
    this.id = "",
    this.title = "",
    this.description = "",
    this.price = 0,
    this.imageUrl = "",
    this.isFavorite = false,
  });

   static Product fromMap (dynamic id,Map<String,dynamic> prod){
    return Product(id: id,
                  title: prod["title"], 
                  description: prod["description"],
                  price: prod["price"],
                  imageUrl: prod["imageUrl"],
                  isFavorite: prod['isFavorite']);

  }

}
