import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'cart.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class OrderItem {
  final String id;
  final int amount;
  final List<CartItem> products;
  final DateTime dateTime;
  bool isExpanded = false;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime,
      this.isExpanded = false});

  static OrderItem fromMap(dynamic id, Map<String, dynamic> orederIte) {
    return OrderItem(
        id: id,
        amount: orederIte['amount'],
        products: (orederIte['products list'] as List<dynamic>)
            .map((item) => CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price']))
            .toList(),
        dateTime: DateTime.parse(orederIte['dateTime']));
  }
}

class Orders with ChangeNotifier {
  String userId = '';

  List<OrderItem> _orders = [];

  String get UserID => userId;

  void setUserId(String userID) {
    userId = userID;
  }

  List<OrderItem> get orders => [..._orders];

  Future<void> fetchAndSetOrders() async {
    print('fetchAndSetProducts');
    QueryBuilder<ParseObject> queryUsers =
        QueryBuilder<ParseObject>(ParseObject('orders'));
    final ParseResponse parseResponse = await queryUsers.query();
    if (parseResponse.success) {
      _orders.clear();
      if (parseResponse.results != null) {
        for (int i = 0; i < parseResponse.results!.length; i++) {
          if (userId == parseResponse.results![i].get<String>('orderCreater')) {
            _orders.add(OrderItem.fromMap(
                parseResponse.results![i].objectId,
                parseResponse.results![i]
                    .get<Map<String, dynamic>>('jsonField')));
            print('id');
            print(parseResponse.results![i].objectId!);
          }
        }
      }
    }
    print('End fetchAndSetProducts');

    notifyListeners();
  }

  Future<void> placeNewOrder(List<CartItem> cartItems, int total) async {
    final DateTime dateTimeNow = DateTime.now();

    var parseObject = ParseObject("orders")
      ..set("jsonField", {
        'products list': cartItems
            .map((cartItem) => {
                  'id': cartItem.id,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price,
                })
            .toList(),
        'amount': total,
        'dateTime': dateTimeNow.toIso8601String(),
        'isExpanded': false
      })
      ..set('orderCreater', userId);

    final ParseResponse parseResponse = await parseObject.save();

    if (parseResponse.success) {
      var objectId = (parseResponse.results!.first as ParseObject).objectId!;
      print('Object created: $objectId');
      _orders.insert(
          0,
          OrderItem(
            id: objectId,
            amount: total,
            products: cartItems,
            dateTime: dateTimeNow,
          ));
      notifyListeners();
    } else {
      print('Object created with failed: ${parseResponse.error.toString()}');
    }
  }
}
