import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/products_provider.dart';

class CustomGrid extends StatefulWidget {


  @override
  State<CustomGrid> createState() => _CustomGridState();
}

class _CustomGridState extends State<CustomGrid> {

  List<Map<String,dynamic>> products = [];

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    final phoneNumber = Provider.of<AuthProvider>(context, listen: false).userCredentials['phoneNumber'];

    products = productsProvider.products;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').where('phoneNumber',isEqualTo: phoneNumber).snapshots(),
      builder: (
          BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot,
          ) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SizedBox(height: 25.0,width: 25.0,child: CircularProgressIndicator()));
        } else if (snapshot.connectionState == ConnectionState.active
            || snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: const Text('Error, could not load data, refresh page!'));
          } else if (snapshot.hasData) {
            return gridList(context,snapshot);
          } else {
            return Center(child: const Text('Data not available!'));
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }

  Widget gridList(BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    products = [];
    for(int i = 0; i < snapshot.data!.docs.length;i++) {
      //adding a map on the fly
      products.add(
        {
         'title' : snapshot.data!.docs[i].get('title'),
         'barCode' : snapshot.data!.docs[i].get('barCode'),
         'price' : snapshot.data!.docs[i].get('price'),
         'saleCount' : snapshot.data!.docs[i].get('saleCount'),
        }
      );
    }
    //sorting map according to salec count
    products.sort((a, b) => a['saleCount'].compareTo(b['saleCount']));

    products = List.from(products.reversed);

    return Container(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('MOST SOLD PRODUCTS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0,color: Colors.deepPurple),),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(height: 50.0,width: 200.0,child: Text('Product name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple),),),
            Container(height: 50.0,width: 200.0,child: Text('Barcode',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple),)),
            Container(height: 50.0,width: 200.0,child: Text('Price K',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple),)),
            Container(height: 50.0,width: 200.0,child: Text('Sales',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple),))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('1. ${products[0]['title']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('2. ${products[1]['title']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('3. ${products[2]['title']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
              ],
            ),
            Container(height: 100.0,width: 0.5,color: Colors.grey,),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('${products[0]['barCode']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('${products[1]['barCode']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('${products[2]['barCode']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
              ],
            ),
            Container(height: 100.0,width: 0.5,color: Colors.grey,),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('${products[0]['price']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('${products[1]['price']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('${products[2]['price']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
              ],
            ),
            Container(height: 100.0,width: 0.5,color: Colors.grey,),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('${products[0]['saleCount']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('${products[1]['saleCount']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Container(height: 30.0,width: 200.0,child: Text('${products[2]['saleCount']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('View all',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurple),),
              Icon(Icons.arrow_forward_sharp,color: Colors.deepPurple,size: 15.0,)
            ],
          ),
        )
      ],),
      width: width * 0.7,
      height: height * 0.35,
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
    );
  }

  List<Widget> customGrid = <Widget>[];

  List<Widget> customRows = <Widget>[];

  SingleChildScrollView makeGrid(List<dynamic> list){
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);

    int productsPerRow = 2;

    if(productsProvider.addPdt){
      productsPerRow = 1;
    }else{
      productsPerRow = 2;
    }

    customGrid = [];
    int count = 0;
    for(int i = 0;i < list.length; i++){
      customRows.add(_product(BuildContext, i));
      if(count == productsPerRow){
        //if three items across
        customGrid.add(Padding(
          padding: const EdgeInsets.only(top: 20.0,bottom: 18.0,left: 12,right: 12),
          child: Row(children: customRows,),
        ));
        customRows = <Widget>[];
      }else if(i+1 == list.length){
        customGrid.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 15.0),

          child: Row(children: customRows),
        ));
        customRows = <Widget>[];
      }
      if(count == productsPerRow) {
        count = 0;
      } else {
        count = count + 1;
      }
    }


    return SingleChildScrollView(scrollDirection: Axis.vertical,child: Column(children: customGrid,),);

  }

  Widget _product(BuildContext,int i){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.18,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.10,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Image.asset(
                          'assets/icons/placeholder.jpg', fit: BoxFit.cover,),
                    imageUrl:  products[i]['imageUrl']),
              )),
          const SizedBox(width: 12.0,),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200.0,
                child: Text(
                  products[i]['title'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5.0,),
              Row(
                children:  [
                  Text('price K' + products[i]['price'].toString(),
                    style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 12.0),),
                ],
              ),
              const SizedBox(height: 5.0,),
              Container(
                width: 200.0,
                child: Text('barcode: ' + products[i]['barCode'].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 12.0),),
              ),
            ],
          ),
        ],
      ),);
  }
}
