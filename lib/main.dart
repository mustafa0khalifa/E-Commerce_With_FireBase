import 'package:e_commerce/provider/auth.dart';
import 'package:e_commerce/provider/cart.dart';
import 'package:e_commerce/provider/order.dart';
import 'package:e_commerce/provider/product.dart';
import 'package:e_commerce/provider/products.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/auth_Screen.dart';
import 'Screen/products_overview_screen/products_overview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const keyApplicationId = 'ti7qp7KLngCCnRL6CxElT1xNGmR8NO8geX3IutUm';
  const keyClientKey = 'moLVF9FtAfINQv2KBMaUInVXGqjLZXvUH80Hwzwr';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Product()),
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProvider(create: (context) => Products()),
        ChangeNotifierProvider(create: (context) => Orders()),
        ChangeNotifierProvider(create: (context) => Cart()),
      ],
      child :MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();

    _prefs.then((SharedPreferences prefs) {
      print('prefs.getBool : ${prefs.getBool('isLogged')}');
      if (prefs.getBool('isLogged') != null) {
        context.read<Auth>().changeIsLogged(prefs.getBool('isLogged') as bool) ;
        print(prefs.getBool('isLogged') as bool);
      } else {
         prefs.setBool('isLogged', false).then((bool success) {
          context.read<Auth>().changeIsLogged(false) ;
          print('isLogged : false');
      });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.pink,
            fontFamily: 'Lato',
          ),
          home: Consumer<Auth>(builder: (context, value, child) => 
          value.isLogged ? ProductsOverviewScreen() : AuthScreen(),),
          routes: {}
    );
  }
}
