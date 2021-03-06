import 'package:e_commerce/Model/loading_spinner.dart';
import 'package:e_commerce/Screen/drawer.dart';
import 'package:e_commerce/Screen/user_products/edait_product_screen.dart';
import 'package:e_commerce/provider/product.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshUserProducts(BuildContext context) async
  {
    await Provider.of<Products>(context, listen: false).fetchAndSetMyProducts(true);
  }

  void deleteBtnClick(Product prod, BuildContext context){
    Provider.of<Products>(context, listen: false).removeProduct(prod)
    .then((_){
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product is deleted successfully'),
        duration: Duration(seconds: 2),
      ));
      Navigator.of(context).pop();
      _refreshUserProducts(context);
    })
    .catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to delete'),
        duration: Duration(seconds: 2),
      ));
      Navigator.of(context).pop();
    });
    LoadingSpinner(context);
  }


  @override
  Widget build(BuildContext context) {

    print('hi');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){ Navigator.of(context).pushNamed(EditProductScreen.routeName); },
          ),
        ],
      ),
      drawer: MyAppDrawer(),
      body: RefreshIndicator(
        onRefresh: ()=> _refreshUserProducts(context),
        color: Colors.white,
        backgroundColor: Colors.teal,
        displacement: 20,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FutureBuilder(
            future: _refreshUserProducts(context),
            builder: (ctx,snapShot){
              return snapShot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<Products>(
                  builder: (context, productsData, child) => ListView.builder(
                    itemCount: productsData.myItems.length,
                    itemBuilder: (_, i) => Column(
                      children: [
                        ListTile(
                          title: Text(productsData.myItems[i].title),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(productsData.myItems[i].imageUrl),
                            onBackgroundImageError:(o,s) {return;},
                          ),
                          trailing: FittedBox(
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: productsData.myItems[i].id);
                                  },
                                  color: Theme.of(context).primaryColor,
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: ()=> deleteBtnClick(productsData.myItems[i],context),
                                  color: Theme.of(context).errorColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                );
            },
          )
        ),
      ),
    );
  }
}
