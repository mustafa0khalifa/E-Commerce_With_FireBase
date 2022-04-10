import 'package:e_commerce/Screen/products_overview_screen/products_item.dart';
import 'package:e_commerce/provider/product.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool _showFavorites;
  ProductsGrid(this._showFavorites);

  @override
  Widget build(BuildContext context) {

    final products = Provider.of<Products>(context);
    final productsList = _showFavorites? products.favoriteItems : products.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: productsList.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider<Product>.value(
        value: productsList[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
