import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:self_checkout_web/Views/Widgets/add_product.dart';
import 'package:self_checkout_web/Views/Widgets/app_bar.dart';
import 'package:self_checkout_web/Views/Widgets/custom_grid.dart';
import 'package:self_checkout_web/Views/Widgets/notifications.dart';
import 'package:self_checkout_web/Views/Widgets/sidebar.dart';
import 'package:self_checkout_web/models/productModel.dart';
import 'package:self_checkout_web/providers/products_provider.dart';

import 'Widgets/CustomBottomSheet.dart';
import 'Widgets/Dialogs.dart';
import 'Widgets/graph.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'homePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    if(productsProvider.products.isEmpty) {
      productsProvider.getDocs(context);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final productsProvider = Provider.of<ProductsProvider>(context);

    return Scaffold(
      body: Responsive(
          children :[
            Container(
              height: height,
              width: width,
              child: Row(
                children: [
                  const SideBar(),
                  Expanded(
                child: productsProvider.gettingProducts
                    ? Center(
                        child: Container(
                          height: 30.0,
                          width: 30.0,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Container(
                            width: width * 0.7,
                            height: height * 0.58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white70,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 5,
                                  blurRadius: 8,
                                  offset: Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Graph(),
                          ),
                            SizedBox(height: 15.0,),
                            CustomGrid()
                        ],
                      ),
                    ),
                  ),
                  // productsProvider.addPdt ? Container(
                  //     height: height,
                  //     child: AddProduct()
                  // ) : Container()
                 productsProvider.gettingProducts ? Container() : Padding(
                    padding: const EdgeInsets.only(right:15.0),
                    child: Notifications()
                  )
                ],
              ),
            ),
          ]
      ),




      //old body
      // body: Responsive(
      //   children :[
      //     Container(
      //       height: height,
      //       width: width,
      //       child: Row(
      //         children: [
      //           const SideBar(),
      //           Expanded(
      //             child: productsProvider.gettingProducts ? Center(child: Container(height: 30.0,width: 30.0,child: CircularProgressIndicator(),),) : Column(
      //               children: [
      //                 CustomAppBar(),
      //                 Responsive(children:[ CustomGrid()])
      //               ],
      //             ),
      //           ),
      //          productsProvider.addPdt ? Container(
      //             height: height,
      //             child: AddProduct()
      //           ) : Container()
      //         ],
      //       ),
      //     ),
      //   ]
      // ),
    );
  }


}
