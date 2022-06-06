import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel{
  int barCode;
  String storeName;
  String phoneNumber;
  String title;
  String imageUrl;
  String description;
  ProductModel(this.barCode,this.description,this.imageUrl,this.phoneNumber,this.storeName,this.title);

  List<Map<String,dynamic>> _products = [];

  List<Map<String,dynamic>> products(QuerySnapshot<Map<String,dynamic>> snapShot){

    for(int i = 0; i < snapShot.docs.length; i++){
      _products.add(snapShot.docs[i].data());
    }
    return _products;
  }

}