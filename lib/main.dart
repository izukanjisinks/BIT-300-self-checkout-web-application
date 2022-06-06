import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_web/Views/auth_screen.dart';
import 'package:self_checkout_web/providers/add_product.dart';
import 'package:self_checkout_web/providers/auth_provider.dart';
import 'package:self_checkout_web/providers/notifications_provider.dart';
import 'package:self_checkout_web/providers/products_provider.dart';
import 'package:self_checkout_web/providers/screens_provider.dart';

import 'Views/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductsProvider()),
        ChangeNotifierProvider(create: (ctx) => NotificationsProvider()),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => ScreensProvider()),
        ChangeNotifierProvider(create: (ctx) => AddProductProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: _initialization,
          builder: (context,snapshot){
            if(snapshot.hasError){
              print("error");
            }
            if(snapshot.connectionState == ConnectionState.done){
              return AuthScreen();
            }
            return const CircularProgressIndicator();
          },
        ),
        routes:{
          HomePage.routeName: (ctx) => HomePage(),
        },
      ),
    );
  }
}

