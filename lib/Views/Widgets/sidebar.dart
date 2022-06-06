import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_web/Views/Widgets/Dialogs.dart';
import 'package:self_checkout_web/providers/auth_provider.dart';
import 'package:self_checkout_web/providers/notifications_provider.dart';
import 'package:self_checkout_web/providers/screens_provider.dart';

import '../../providers/products_provider.dart';
import 'CustomBottomSheet.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final sreenProvider = Provider.of<ScreensProvider>(context, listen: false);
    return Container(
      height: height,
      color: Colors.grey.withOpacity(0.2),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0,top: 15.0,left: 5.0),
          child: Image.asset('assets/icons/logo.png',width: 45.0,),
        ),
        SizedBox(height: height * 0.15,),
        GestureDetector(
              onTap: () {
                sreenProvider.changeScreen(Screen.homePage);
               // productsProvider.addProduct();
              },
          child: Icon(IconlyLight.home,color: sreenProvider.screen == Screen.homePage ? Colors.deepPurple : Colors.grey,size: 32.0,),
              // child: Image.asset(
              //   'assets/icons/add-product.png',
              //   width: 45.0,
              // )
        ),
        SizedBox(height: height * 0.05,),
        GestureDetector(
          onTap: () {
            sreenProvider.changeScreen(Screen.allProducts);
          },
          child: Icon(IconlyLight.document,color: sreenProvider.screen == Screen.allProducts ? Colors.deepPurple : Colors.grey,size: 32.0,),
        ),
        SizedBox(height: height * 0.05,),
          GestureDetector(
            child: Icon(IconlyLight.notification,color: Colors.deepPurple,size:32.0),
            onTap: (){
             Dialogs().deleteNotifications(context);
            },
          ),
          const Spacer(),
        IconButton(onPressed: (){
          bottomSheet(context);
        }, icon: const Icon(Icons.help_outline,color: Colors.deepPurple,)),
        GestureDetector(
          onTap: (){
            Dialogs().aboutDialog(context);
          },
          child: Container(
            //transparent to provide touch area
            color: Colors.transparent,
            child: const Padding(
              padding:  EdgeInsets.symmetric(vertical: 12.0),
              child:  Text('About',style: TextStyle(color: Colors.red,fontSize: 12.0,fontWeight: FontWeight.bold),),
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            authProvider.logOut();
          },
          child: Container(
            //transparent to provide touch area
            color: Colors.transparent,
            child: const Padding(
              padding:  EdgeInsets.symmetric(vertical: 12.0),
              child:  Text('LogOut',style: TextStyle(color: Colors.red,fontSize: 12.0,fontWeight: FontWeight.bold),),
            ),
          ),
        )

      ],),
    );
  }

  bottomSheet(BuildContext context) {
    showModalBottomSheet(backgroundColor: Colors.transparent,constraints: BoxConstraints(),context: context, builder: (context){
      return  CustomBottomSheet();
    });
  }
}
