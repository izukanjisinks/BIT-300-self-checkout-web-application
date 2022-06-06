import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:self_checkout_web/Views/Widgets/add_product.dart';
import 'package:self_checkout_web/Views/Widgets/edit_product.dart';
import 'package:self_checkout_web/Views/Widgets/sidebar.dart';
import 'package:self_checkout_web/providers/products_provider.dart';

class AllProducts extends StatefulWidget {

  const AllProducts({Key? key}) : super(key: key);

  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {

  List<Map<String,dynamic>> products = [];

  Timer? _timer;
  int _start = 2;

  void startTimer() {
    const oneSec =  Duration(seconds: 1);
    _timer =  Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
            _start--;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  void duplicateList(){
    for(int i = 0; i < 95; i++){
      products.add(products[0]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final productsProvider = Provider.of<ProductsProvider>(context);
    products = productsProvider.products;

    //duplicateList();


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
                      child: Container(
                        width: width * 0.7,
                        height: height * 0.94,
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
                        child: SingleChildScrollView(child: _products(context)),
                      ),
                    ),
                  ),
                 productsProvider.addOrEdit == AddOrEdit.noSelected ? _addOrEdit(context) :  productsProvider.addOrEdit == AddOrEdit.add ? _addProduct(context) : _editProduct(context)
                ],
              ),
            ),
          ]
      ),
    );
  }

  Widget _addOrEdit(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: width * 0.22,
        height: height * 0.94,
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
        child:Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
            Text('select a product to edit \n or',textAlign: TextAlign.center,),
            Center(
              child: SizedBox(
                  width: width * 0.1,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0.0),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple.withOpacity(0.8)),
                      ),
                      onPressed: () {
                        productsProvider.addOrEditProduct(AddOrEdit.add);
                      },
                      child: Text('Add Product'))),
            )
          ],),
        ),
      ),
    );
  }

  Widget _addProduct(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: width * 0.22,
        height: height * 0.94,
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
        child: AddProduct(),
      ),
    );
  }

  Widget _editProduct(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    startTimer();

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        width: width * 0.22,
        height: height * 0.94,
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
        child: _start == 0 ? EditProduct() : Center(child: Container(height: 25.0,width: 25.0,child: CircularProgressIndicator(),),),
      ),
    );
  }

  Widget _products(BuildContext context){
    double height = MediaQuery.of(context).size.height;
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);

    List<Widget> list = [];
    //adding headers of the table
    list.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text('ALL PRODUCTS',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0,color: Colors.deepPurple),),
    ),);

    list.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(height: 50.0,width: 200.0,child: Text('Product name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple),),),
        Container(height: 50.0,width: 200.0,child: Text('Barcode',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple),)),
        Container(height: 50.0,width: 200.0,child: Text('Price K',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple),))
      ],
    ),);

    List<Widget> titles = [];
    List<Widget> barCodes = [];
    List<Widget> prices = [];

    for(int i = 0; i < products.length; i++){
      titles.add(Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(height: 30.0,width: 200.0,child: Text('${i + 1}. ${products[i]['title']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
      ),);

      barCodes.add(Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(height: 30.0,width: 200.0,child: Text('${products[i]['barCode']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),),
      ),);

      prices.add(Padding(
        padding: const EdgeInsets.all(3.0),
        child: Container(height: 30.0,width: 200.0,child: Row(
          children: [
            Text('${products[i]['price']}',overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.deepPurple)),
          Spacer(),
            TextButton(
            onPressed: (){
              _start = 2;
              productsProvider.setSelectedProduct(products[i], i);
              productsProvider.addOrEditProduct(AddOrEdit.edit);
            },
            child: Text('view'),
          )
          ],
        ),),
      ),);
    }

    list.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(children: titles,),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Container(height: products.length < 14 ? height * 0.80 : (35.0 * products.length),width: 0.3,color: Colors.grey,),
        ),
        Column(children: barCodes,),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Container(height: products.length < 14 ? height * 0.80 : (35.0 * products.length),width: 0.3,color: Colors.grey,),
        ),
        Column(children: prices,),
      ],
    ));

   return Column(children: list,);

  }


}
