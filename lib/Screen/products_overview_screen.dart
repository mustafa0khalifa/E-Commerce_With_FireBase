import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';


class ProductsOverviewScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProductsOverviewScreenState();
  }

}

class ProductsOverviewScreenState extends State<ProductsOverviewScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('ProductsOverviewScreen'),),
    );
  }

}