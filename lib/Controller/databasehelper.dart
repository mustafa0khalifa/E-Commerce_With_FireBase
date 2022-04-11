import 'package:e_commerce/provider/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';

class DatabaseHelper {
  String serverUrl = "https://parseapi.back4app.com";
  var status;

  var token;

  loginData(String email, String password) async {
    final user = ParseUser(email, password, email);
    var response = await user.login();

    if (response.success) {
      print("User was successfully login!");
      token = user.objectId;
      _save(token);
      _loggin();
    } 
    else throw Exception("Login Error !!!");
  }

  registerData(String email, String password) async {
    final user = ParseUser.createUser(email, password, email);

    var response = await user.signUp();

    if (response.success) {
      print('success signup');
      token = user.objectId;
      _save(token);
      _loggin();
    } 
    else throw Exception("Signup Error !!!");
  }


  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  void read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;
    print('read : $value');
  }

  _loggin() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'isLogged';
    final value = true;
    prefs.setBool(key, value);
  }

  loggout() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = '';
    prefs.setString(key, value);

    final key2 = 'isLogged';
    final value2 = false;
    prefs.setBool(key2, value2);
  }
}
