import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class DatabaseHelper {
  String serverUrl = "https://parseapi.back4app.com";
  var status;

  var token;

  loginData(String email, String password) async {
    final user = ParseUser(email, password, email);
    var response = await user.login();

    if (response.success) {
      print("User was successfully login!");
      token = user.sessionToken;
      _save(token);
      _loggin();
    } else {
      print("User was Error login!");
    }
  }

  registerData(String email, String password) async {
    final user = ParseUser.createUser(email, password, email);

    var response = await user.signUp();

    if (response.success) {
      print('success signup');
      token = user.sessionToken;
      _save(token);
      _loggin();
    } else {
      print('Error signup');
    }
  }

  Future<List> getData() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/products/";
    http.Response response = await http.get(Uri.parse(myUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    });
    return json.decode(response.body);
  }

  void deleteData(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/products/$id";
    http.delete(Uri.parse(myUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  void addData(String name, String price) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "$serverUrl/products";
    http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": "$name",
      "price": "$price"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  void editData(int id, String name, String price) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = prefs.get(key) ?? 0;

    String myUrl = "http://flutterapitutorial.codeforiraq.org/api/products/$id";
    http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $value'
    }, body: {
      "name": "$name",
      "price": "$price"
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }

  _save(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'token';
    final value = token;
    prefs.setString(key, value);
  }

  read() async {
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
