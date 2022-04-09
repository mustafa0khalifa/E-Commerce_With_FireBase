import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';


class AuthScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AuthScreenState();
  }

}

class AuthScreenState extends State<AuthScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Center(child: Text('AuthScreen'),),
    );
  }

}