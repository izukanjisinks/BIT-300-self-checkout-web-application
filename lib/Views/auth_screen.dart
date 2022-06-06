import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_web/Views/Widgets/all_products.dart';
import 'package:self_checkout_web/Views/home_page.dart';
import 'package:self_checkout_web/providers/auth_provider.dart';
import 'package:self_checkout_web/providers/screens_provider.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _form = GlobalKey<FormState>();
  String phoneNumber = '';
  String storeName = '';
  TextEditingController textControllerEmail = TextEditingController();
  double heightAdjustment = 0.51;
 void _onSaved(BuildContext context){
   final authProvider = Provider.of<AuthProvider>(context, listen: false);
   final valid = _form.currentState!.validate();
   if(valid){
     _form.currentState!.save();
     authProvider.userCredentials['phoneNumber'] = phoneNumber;
     authProvider.userCredentials['storeName'] = storeName;
     authProvider.googleSignIn();
   }
 }

 @override
  void initState() {

   WidgetsBinding.instance.addPostFrameCallback((_){
     final authProvider = Provider.of<AuthProvider>(context,listen: false);
     authProvider.status = AuthStatus.loading;
     authProvider.handleAuth(true);
   });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    Provider.of<ScreensProvider>(context);

    return Scaffold(
        body: authProvider.status == AuthStatus.loading
            ? Center(child: Container(
          height: 30.0, width: 30.0, child: CircularProgressIndicator(),),)
            : authProvider.status == AuthStatus.signedIn
            ? _screen(context)
            : _authScreenBody(context)
    );
  }

  Widget _screen(BuildContext context){
   final screenProvider = Provider.of<ScreensProvider>(context, listen: false);
   Widget screen = Container();
   if(screenProvider.screen == Screen.homePage) {
     screen = HomePage();
   }else if(screenProvider.screen == Screen.allProducts){
     screen = AllProducts();
   }
return screen;
  }

  Widget _authScreenBody(BuildContext context){

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Center(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: _decoration,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
                child: Center(
                  child: Container(
                    decoration: _boxShadow,
                    width: width * 0.25,
                    height: height * heightAdjustment,
                    child: Form(
                      key: _form,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Image.asset('assets/icons/logo.png',width: 45.0,),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            width: width * 0.2,
                            decoration: _textDecoration,
                            child: Padding(
                              padding: EdgeInsets.only(left: 13, right: 13, bottom: 2),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Phone number',
                                    hintText: '969678808',
                                    prefixText: '+260',
                                    hintStyle: TextStyle(color: Colors.grey)),
                                onSaved: (value) {
                                   phoneNumber = '+260${value!}';
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      heightAdjustment = 0.6;
                                    });
                                    return 'Enter a phone number!';
                                  }
                                  if (value.length < 9) {
                                    setState(() {
                                      heightAdjustment = 0.6;
                                    });
                                    return 'Please enter a valid phone number!';
                                  } else
                                    return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            width: width * 0.2,
                            decoration: _textDecoration,
                            child: Padding(
                              padding: EdgeInsets.only(left: 13, right: 13, bottom: 2),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Email',
                                    hintText: 'izukanjisinkolongo@gmail.com',
                                    hintStyle: TextStyle(color: Colors.grey)),
                                onSaved: (value) {

                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Email can\'t be empty';
                                  }
                                  if (!value.contains(RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
                                    return 'Enter a correct email address';
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            width: width * 0.2,
                            decoration: _textDecoration,
                            child: Padding(
                              padding: EdgeInsets.only(left: 13, right: 13, bottom: 2),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Store name',
                                    hintText: 'E-Store',
                                    hintStyle: TextStyle(color: Colors.grey)),
                                onSaved: (value) {
                                     storeName = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) return 'Enter a store name!';
                                  if (value.length < 3)
                                    return 'Please enter a valid store name!';
                                  else
                                    return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: GestureDetector(
                            onTap: (){
                             _onSaved(context);
                            },
                            child: Container(
                              color: Colors.transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/icons/google-logo.jpg',width: 20.0,),
                                  SizedBox(width: 5.0,),
                                  Text('Google Sign In',style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                          ),
                        )
                      ],),
                    ),
                  ),
                ),
              ),
            )));
  }

  final BoxDecoration _decoration = BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/images/grocery.jpg"),
      fit: BoxFit.cover,
    ),
  );

  final BoxDecoration _boxShadow = BoxDecoration(
    borderRadius: BorderRadius.circular(8.0),
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 5,
        blurRadius: 8,
        offset: Offset(0, 3), // changes position of shadow
      ),
    ],
  );

  final BoxDecoration _textDecoration = BoxDecoration(
    color: Colors.grey.withOpacity(0.2),
    borderRadius: new BorderRadius.circular(8.0),
  );

   _validateEmail(String value) {
    value = value.trim();

    if (textControllerEmail.text.isNotEmpty) {
      if (value.isEmpty) {
        return 'Email can\'t be empty';
      } else if (!value.contains(RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
        return 'Enter a correct email address';
      }
    }
  }
}
