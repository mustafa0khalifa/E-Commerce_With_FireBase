import 'dart:async';
import 'dart:convert';

import 'package:e_commerce/provider/product.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Products with ChangeNotifier{

   String token ='';
   String userId = '';
  List _items = [];



  List get items => [..._items];

  List get favoriteItems => _items.where((element) => (element as Product).isFavorite ==true ).toList();

  Future<void> fetchAndSetProducts([bool filterByCreatorId = false]) async
  {
    

    _items.clear();
    QueryBuilder<ParseObject> queryUsers =
        QueryBuilder<ParseObject>(ParseObject('StudentTest'));
    final ParseResponse parseResponse = await queryUsers.query();
    if (parseResponse.success && parseResponse.results != null) {
      for(int i = 0 ; i< parseResponse.results!.length ;i++){
        _items.add(Product.fromMap(parseResponse.results![i].objectId,parseResponse.results![i].get<Map<String, dynamic>>('jsonField')));
        print('id');
        print(parseResponse.results![i].objectId!);
      }
    }
    print('End fetchAndSetProducts');

    notifyListeners();
  }


 Future<void> toggleFavoriteForProduct(Product product) async
  {
    print('toggleFavoriteForProduct');
    product.isFavorite = !product.isFavorite;
    
    final parseObject = ParseObject("StudentTest")
      ..objectId = product.id
      ..set("jsonField",  {"title":product.title ,"description": product.description,
      "price":product.price,"imageUrl":product.imageUrl,
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


  Future<void> addProduct(Product product,parseFile) async
  {
    print('addProduct on ');

    final gallery = ParseObject('Gallery')
                            ..set('file', parseFile);
    final galleryResponse =  await gallery.save();

    if (galleryResponse.success) {
      var objectId = (galleryResponse.results!.first as ParseObject).objectId!;
      print('gallery created: $objectId');

     var parseObject = ParseObject("StudentTest")
      ..set("jsonField", {"title":product.title ,"description": product.description,
      "price":product.price,"imageUrl":product.imageUrl,
      "isFavorite": product.isFavorite,
      });
      
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

  Future<void> editProduct(Product product) async
  {
    
    print('editProduct');
    
    final parseObject = ParseObject("StudentTest")
      ..objectId = product.id
      ..set("jsonField",  {"title":product.title ,"description": product.description,
      "price":product.price,"imageUrl":product.imageUrl,
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
 
 Future<void> removeProduct(dynamic objectId,Product product) async
  {
    print('removeProduct');

     final parseObject = ParseObject("StudentTest")
      ..objectId = objectId;
    var response = await parseObject.delete();

    if(response.success){
      print('success deleted ');

      print('addProduct on deleted');
     var parseObject = ParseObject("StudentTestDeleted")
      ..set("jsonField", {"title":product.title ,"description": product.description,
      "price":product.price,"imageUrl":product.imageUrl,
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
