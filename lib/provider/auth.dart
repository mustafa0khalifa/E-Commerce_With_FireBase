import 'package:flutter/cupertino.dart';

class Auth extends ChangeNotifier {
  bool _isLooding = false;

  bool get isLooding => isLooding;

  void changeIsLooding() {
    _isLooding = !_isLooding;
    notifyListeners();
  }
}
