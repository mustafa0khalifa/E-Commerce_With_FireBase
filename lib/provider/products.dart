import 'dart:async';
import 'dart:convert';

import 'package:e_commerce/Controller/databasehelper.dart';
import 'package:e_commerce/provider/product.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Products with ChangeNotifier {
  List _items = [];
  List _myItems = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();

  String userId = '';

  List get items => [..._items];

   List get myItems => [..._myItems];

  List get favoriteItems => _items
      .where((element) => (element as Product).isFavorite == true)
      .toList();

  String get UserID => userId;

  void setUserId(String userID) {
    userId = userID;
  }

  Future<void> fetchAndSetProducts([bool filterByCreatorId = false]) async {
    print('fetchAndSetProducts');
    QueryBuilder<ParseObject> queryUsers =
        QueryBuilder<ParseObject>(ParseObject('products'));
    final ParseResponse parseResponse = await queryUsers.query();
    if (parseResponse.success) {
      _items.clear();
      if (parseResponse.results != null) {
        for (int i = 0; i < parseResponse.results!.length; i++) {
          _items.add(Product.fromMap(
              parseResponse.results![i].objectId,
              parseResponse.results![i]
                  .get<Map<String, dynamic>>('jsonField')));
          print('id');
          print(parseResponse.results![i].objectId!);
        }
      }
    }
    print('End fetchAndSetProducts');

    notifyListeners();
  }

  Future<void> fetchAndSetMyProducts([bool filterByCreatorId = false]) async {
    print('fetchAndSet MyProducts');
    QueryBuilder<ParseObject> queryUsers =
        QueryBuilder<ParseObject>(ParseObject('products'));
    final ParseResponse parseResponse = await queryUsers.query();
    if (parseResponse.success) {
      _myItems.clear();
      if (parseResponse.results != null) {
        for (int i = 0; i < parseResponse.results!.length; i++) {
          if(userId == parseResponse.results![i].get<String>('userCreater')){
            _myItems.add(Product.fromMap(
              parseResponse.results![i].objectId,
              parseResponse.results![i]
                  .get<Map<String, dynamic>>('jsonField')));
          print('id');
          print(parseResponse.results![i].objectId!);
          }
        }
      }
    }
    print('End fetchAndSet MyProducts');

    notifyListeners();
  }


  Future<void> toggleFavoriteForProduct(Product product) async {
    print('toggleFavoriteForProduct');
    product.isFavorite = !product.isFavorite;

    final parseObject = ParseObject("products")
      ..objectId = product.id
      ..set("jsonField", {
        "title": product.title,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        "isFavorite": product.isFavorite,
      });

    final ParseResponse parseResponse = await parseObject.save();

    if (parseResponse.success) {
      print('success');
      notifyListeners();
    } else {
      print('error !!!!');
    }

    print('toggleFavoriteForProduct   End !!!');
  }

  Future<void> addProduct(Product product, parseFile) async {
    print('addProduct on ');

    final gallery = ParseObject('Gallery')..set('file', parseFile);
    final galleryResponse = await gallery.save();

    if (galleryResponse.success) {
      var objectId = (galleryResponse.results!.first as ParseObject).objectId!;
      print('gallery created: $objectId');

      var parseObject = ParseObject("products")
        ..set("jsonField", {
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        })
        ..set('userCreater', userId);

      final ParseResponse parseResponse = await parseObject.save();

      if (parseResponse.success) {
        var objectId = (parseResponse.results!.first as ParseObject).objectId!;
        print('Object created: $objectId');
        product.id = objectId;
        items.add(product);
        notifyListeners();
      } else {
        print('Object created with failed: ${parseResponse.error.toString()}');
      }
    } else {
      print('gallery created with failed: ${galleryResponse.error.toString()}');
    }
  }

  Future<void> editProduct(Product product) async {
    print('editProduct');

    final parseObject = ParseObject("products")
      ..objectId = product.id
      ..set("jsonField", {
        "title": product.title,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        "isFavorite": product.isFavorite,
      });

    final ParseResponse parseResponse = await parseObject.save();

    if (parseResponse.success) {
      print('success');
      notifyListeners();
    } else {
      print('error !!!!');
    }

    print('editProduct   End !!!');
  }

  Future<void> removeProduct(Product product) async {
    print('removeProduct');

    final parseObject = ParseObject("products")..objectId = product.id;
    var response = await parseObject.delete();

    if (response.success) {
      print('success deleted ');

      print('addProduct on deleted');
      var parseObject = ParseObject("ProductsDeleted")
        ..set("jsonField", {
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        });

      final ParseResponse parseResponse = await parseObject.save();

      if (parseResponse.success) {
        var objectId = (parseResponse.results!.first as ParseObject).objectId!;
        print('Object created: $objectId');
      }

      notifyListeners();
    }

    print('removeProduct End !!!');
  }
}
