import 'package:e_commerce/Controller/databasehelper.dart';
import 'package:e_commerce/Screen/products_overview_screen/products_overview_screen.dart';
import 'package:e_commerce/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/provider/auth.dart';



class AuthScreen extends StatelessWidget {
  static const routeName = '/auth-screen';
  

  

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.tealAccent, Colors.pinkAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 1],
              ),
            ),
          ),
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                    transform: Matrix4.rotationZ(-0.14)..translate(-8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.pink.shade900,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.pinkAccent,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      'MyShop',
                      style: TextStyle(
                        color:
                            Theme.of(context).accentTextTheme.headline6!.color,
                        fontSize: 50,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: deviceSize.width > 600 ? 2 : 1,
                  child: AuthCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  DatabaseHelper databaseHelper =new DatabaseHelper();
  final GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode password = FocusNode();
  FocusNode confirmFassword = FocusNode();
  
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void alert(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error Occurred'),
            content: Text(message),
            actions: [
              TextButton(
                child: Text('ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
     print('play');
    context.read<Auth>().changeIsLooding();

    if (context.read<Auth>().authMode == AuthMode.Login) {
      try {
        print('login');
        await databaseHelper.loginData(_authData['email']!,_authData['password']!);
        print('end login');
        Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder:(_)=>MyApp()), (route) => false);
        databaseHelper.read();
        } catch (e) {
        alert(e.toString());
      }
    } else {
      try {
        print('signup');
        await databaseHelper.registerData(_authData['email']!,_authData['password']!);
        print('end signup');
       Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder:(_)=>MyApp()), (route) => false);
       databaseHelper.read();
      } catch (e) {
        alert(e.toString());
      }
    }

    context.read<Auth>().changeIsLooding();

  }

  void _switchAuthMode() {
   context.read<Auth>().changeAuthMode();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: context.read<Auth>().authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: context.read<Auth>().authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'E-Mail',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onFieldSubmitted: (_){ FocusScope.of(context).requestFocus(password); },
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  focusNode: password,
                  onFieldSubmitted: (_){ FocusScope.of(context).requestFocus(confirmFassword); },
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                Consumer<Auth>(builder: (context, valuee, child) => 
                valuee.authMode ==AuthMode.Signup?
                  TextFormField(
                    enabled: valuee.authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    focusNode: confirmFassword,
                    validator: valuee.authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ):SizedBox(
                  height: 0,
                ),
                ),
                SizedBox(
                  height: 20,
                ),
                Consumer<Auth>(
                  builder: (context, value, child) => value.isLooding
                      ? CircularProgressIndicator()
                      : FlatButton(
                          child: Text(context.read<Auth>().authMode == AuthMode.Login
                              ? 'LOGIN'
                              : 'SIGN UP'),
                          onPressed: _submit,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          color: Theme.of(context).primaryColor,
                          textColor:
                              Theme.of(context).primaryTextTheme.button!.color,
                        ),
                ),
                FlatButton(
                  child: Consumer<Auth>(builder: (context, value, child) => 
                  Text(
                      '${value.authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'}'),
                      ),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
