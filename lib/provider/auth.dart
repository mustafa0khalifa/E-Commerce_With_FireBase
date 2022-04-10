import 'package:flutter/cupertino.dart';

 enum AuthMode { Signup, Login }

class Auth extends ChangeNotifier {
  bool _isLooding = false;

  bool _isLogged =false;

  AuthMode _authMode = AuthMode.Login;


  bool get isLogged => _isLogged;

  AuthMode get authMode => _authMode;

  bool get isLooding => _isLooding;

  

 

  void changeIsLooding() {
    _isLooding = !_isLooding;
    notifyListeners();
  }

  void changeAuthMode(){
     if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.Signup;
    } else {
        _authMode = AuthMode.Login;
    }
    notifyListeners();
  }

  void changeIsLogged(bool newISLogged){
    _isLogged = newISLogged;

    notifyListeners();
  }


}
