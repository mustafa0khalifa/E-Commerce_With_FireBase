import 'package:e_commerce/provider/product.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screen/auth_Screen.dart';
import 'Screen/products_overview_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final keyApplicationId = 'ti7qp7KLngCCnRL6CxElT1xNGmR8NO8geX3IutUm';
  final keyClientKey = 'moLVF9FtAfINQv2KBMaUInVXGqjLZXvUH80Hwzwr';
  final keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String currentUserToken;
  late String currentUserId;
  bool isLog = false;

  @override
  void initState() {
    super.initState();

    _prefs.then((SharedPreferences prefs) {
      print('prefs.getBool : ${prefs.getBool('isLogged')}');
      if (prefs.getBool('isLogged') != null) {
        isLog = prefs.getBool('isLogged') as bool;
      } else {
         isLog = false;
         prefs.setBool('isLogged', false).then((bool success) {
          print('isLogged : false');
      });
      }
      print('isLog:${isLog}');
    });

  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Product()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            accentColor: Colors.pink,
            fontFamily: 'Lato',
          ),
          home: isLog ? ProductsOverviewScreen() : AuthScreen(),
          routes: {}),
    );
  }
}
