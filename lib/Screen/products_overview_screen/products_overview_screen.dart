import 'package:e_commerce/Screen/cart_screen/cart.dart';
import 'package:e_commerce/Screen/drawer.dart';
import 'package:e_commerce/Screen/products_overview_screen/badge.dart';
import 'package:e_commerce/Screen/products_overview_screen/products_grid.dart';
import 'package:e_commerce/provider/cart.dart';
import 'package:e_commerce/provider/order.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



enum menuSelectionOptions{
  All,
  Favorites,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoritesOnly = false;

  Future<void> fetchAndSetData() async
  {
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts();
    await Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (_,cart,consumerChild) => Badge(
              child: consumerChild!,
              value: cart.cartItems.length.toString()
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: (){
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            child: Icon(Icons.more_vert),
            itemBuilder: (_)=>[
              PopupMenuItem(child: Text('Show All'),value: menuSelectionOptions.All,),
              PopupMenuItem(child: Text('Show Favorites'),value: menuSelectionOptions.Favorites,),
            ],
            onSelected: (menuSelectionOptions option){
              setState(() {
                if(option == menuSelectionOptions.Favorites){ _showFavoritesOnly = true; }
                else{ _showFavoritesOnly = false; }
              });
            },
          ),
        ],
      ),
      drawer: MyAppDrawer(),
      body:FutureBuilder(
            future: fetchAndSetData(),
            builder: (ctx,snapShot){
              return snapShot.connectionState == ConnectionState.waiting
                     ? Center(child: CircularProgressIndicator())
                     : ProductsGrid(_showFavoritesOnly);
            },
      ),
    );
  }
}
