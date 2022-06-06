import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/notifications_provider.dart';

class Dialogs{


  deleteNotifications(BuildContext context) async {
    final notificationsProvider = Provider.of<NotificationsProvider>(context, listen: false);
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text(
                'Are you sure?',
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: Text(
                'Are you sure you want to delete all your notifications?',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: (){
                     Navigator.of(ctx).pop();
                  },
                  child: Text('cancel'),
                ),
                TextButton(
                  onPressed: (){
                    notificationsProvider.deleteNotifications(context);
                    Navigator.of(ctx).pop();
                  },
                  child: Text('yes',style: TextStyle(color: Colors.red),),
                ),
              ],
            ),
          );
        });
  }


  aboutDialog(BuildContext context){
    showAboutDialog(context: context,applicationName: 'E-Store Web',applicationIcon: Image.asset('assets/icons/logo.png'),applicationVersion: '1.0.0',);
  }

  addImage(BuildContext context){
    showDialog(context: context, builder: (ctx){
      return AlertDialog(
        title: Text(
          'Add Image',
          style: TextStyle(
              color: Colors.deepPurple, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Text('You need to add an image before you can upload your product!', style: TextStyle(
            color: Colors.deepPurple),),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(ctx).pop();
          },child: Text('ok'),)
        ],
      );
    });
  }

  addProduct(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showCupertinoDialog(barrierDismissible: false,context: context, builder: (ctx){
           return  AlertDialog(
             contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
             title: Text(
               'Add Product',
               style: TextStyle(
                   color: Colors.deepPurple, fontWeight: FontWeight.bold),
               textAlign: TextAlign.center,
             ),
             content: Column(mainAxisSize: MainAxisSize.min,children:  [
              Image.asset('assets/icons/placeholder.jpg',width: width * 0.25,height: height * 0.35,),
               Row(
                 children: [
                   Padding(
                     padding:
                     EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                     child: Container(
                       width: width * 0.12,
                       decoration: BoxDecoration(
                         color: Colors.grey.withOpacity(0.1),
                         borderRadius: new BorderRadius.circular(16.0),
                       ),
                       child: Padding(
                         padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                         child: TextFormField(
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               labelText: 'Title',
                               hintText: 'enter a title',
                               hintStyle: TextStyle(color: Colors.grey)),
                           onSaved: (value) {
                             //title = value!;
                           },
                           validator: (value) {
                             if (value!.isEmpty) return 'Enter a title!';
                             if (value.length < 3)
                               return 'Please enter a valid title!';
                             else
                               return null;
                           },
                         ),
                       ),
                     ),
                   ),
                   Padding(
                     padding:
                     EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                     child: Container(
                       width: width * 0.12,
                       decoration: BoxDecoration(
                         color: Colors.grey.withOpacity(0.1),
                         borderRadius: new BorderRadius.circular(16.0),
                       ),
                       child: Padding(
                         padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                         child: TextFormField(
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               labelText: 'Price',
                               hintText: 'enter a price',
                               hintStyle: TextStyle(color: Colors.grey)),
                           onSaved: (value) {
                             //title = value!;
                           },
                           validator: (value) {
                             if (value!.isEmpty) return 'Enter a price!';
                             if (value.length < 3)
                               return 'Please enter a valid price!';
                             else
                               return null;
                           },
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
               Row(
                 children: [
                   Padding(
                     padding:
                     EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                     child: Container(
                       width: width * 0.12,
                       decoration: BoxDecoration(
                         color: Colors.grey.withOpacity(0.1),
                         borderRadius: new BorderRadius.circular(16.0),
                       ),
                       child: Padding(
                         padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                         child: TextFormField(
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               labelText: 'Barcode',
                               hintText: 'enter a barcode',
                               hintStyle: TextStyle(color: Colors.grey)),
                           onSaved: (value) {
                             //title = value!;
                           },
                           validator: (value) {
                             if (value!.isEmpty) return 'Enter a barcode!';
                             if (value.length < 3)
                               return 'Please enter a valid barcode!';
                             else
                               return null;
                           },
                         ),
                       ),
                     ),
                   ),
                   Padding(
                     padding:
                     EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                     child: Container(
                       width: width * 0.12,
                       decoration: BoxDecoration(
                         color: Colors.grey.withOpacity(0.1),
                         borderRadius: new BorderRadius.circular(16.0),
                       ),
                       child: Padding(
                         padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                         child: TextFormField(
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               labelText: 'Description',
                               hintText: 'enter a description',
                               hintStyle: TextStyle(color: Colors.grey)),
                           onSaved: (value) {
                             //title = value!;
                           },
                           validator: (value) {
                             if (value!.isEmpty) return 'Enter a description!';
                             if (value.length < 3)
                               return 'Please enter a valid description!';
                             else
                               return null;
                           },
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
             ],),

           );
        });
  }





}