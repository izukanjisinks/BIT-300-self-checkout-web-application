import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

enum AddOrEdit{noSelected,edit, add}

class ProductsProvider with ChangeNotifier{

  bool gettingProducts = true;

  List<Map<String,dynamic>> products = [];
  List<String> docIds = [];

  bool addPdt = false;

  AddOrEdit addOrEdit = AddOrEdit.noSelected;

  void addOrEditProduct(AddOrEdit value){
    addOrEdit = value;
    notifyListeners();
  }


  void getDocs(BuildContext context) async{
    var collection = FirebaseFirestore.instance.collection('products');
    var snapshots = await collection.get();
    convert(snapshots);
  }
  void convert(QuerySnapshot<Map<String,dynamic>> snapShot){

    for(int i = 0; i < snapShot.docs.length; i++){
      products.add(snapShot.docs[i].data());
      docIds.add(snapShot.docs[i].id);
    }

      //refresh
      gettingProducts = false;
      notifyListeners();
  }

  // void addProduct(){
  //   if(addPdt) {
  //     addPdt = false;
  //   }else{
  //     addPdt = true;
  //   }
  //   notifyListeners();
  // }

  bool uploading = false;
  String downUrl = '';
  int productIndex = 0;
  Map<String,dynamic> product = {
    'title' : '',
    'description' : '',
    'imageUrl' : '',
    'barCode' : 0,
    'price' : 0.0,
    'sellCount' : 0,
    'storeName' : '',
  };

  Map<String, dynamic> selectedProduct = {};
  String selectedDocId = '';

  void setSelectedProduct(Map<String, dynamic> product, int index){
    selectedProduct = product;
    selectedDocId = docIds[index];
    productIndex = index;
  }

  uploadImageToStorage(PickedFile? pickedFile, String productId) async {
    uploading = true;
    notifyListeners();
    String? pId = const Uuid().v4();
    Reference reference =
    FirebaseStorage.instance.ref().child('Products/$productId/product_$pId');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();
    downUrl = value;
    product['imageUrl'] = downUrl;
    addProduct();
  }

  updateImageToStorage(PickedFile? pickedFile, String productId) async {
    uploading = true;
    notifyListeners();
    String? pId = const Uuid().v4();
    Reference reference =
    FirebaseStorage.instance.ref().child('Products/$productId/product_$pId');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();
    downUrl = value;
    selectedProduct['imageUrl'] = downUrl;
    updateProduct();
  }

  updateProduct() async{
    uploading = true;
    notifyListeners();
    var collection = FirebaseFirestore.instance.collection('products');
    await collection.doc(selectedDocId).update(selectedProduct).then((value) {
      // notifications.add(notification);
      // docIds.add(value.id);
      uploading = false;
      products[productIndex] = selectedProduct;
      addOrEditProduct(AddOrEdit.noSelected);
      print('done uploading');
    });
  }

  void addProduct() async{
    var collection = FirebaseFirestore.instance.collection('products');
    await collection.add(product).then((value) {
      // notifications.add(notification);
      // docIds.add(value.id);
      uploading = false;
      products.add(product);
      addOrEditProduct(AddOrEdit.noSelected);
      print('done uploading');
    });
  }

  deleteProduct() async{
    uploading = true;
    notifyListeners();
    //delete image if it exists
    if(products[productIndex]['imageUrl'] != ''){
      Reference? existingImageRef;
      
        //delete existing image
        existingImageRef = FirebaseStorage.instance.refFromURL(products[productIndex]['imageUrl']);
        await existingImageRef.delete().then((_) {
          print('image deleted!');
        });
      }

    var collection = FirebaseFirestore.instance.collection('products');
    await collection.doc(selectedDocId).delete().then((value) {
      // notifications.add(notification);
      // docIds.add(value.id);
      uploading = false;
      products.removeAt(productIndex);
      addOrEditProduct(AddOrEdit.noSelected);
      print('done uploading');
      notifyListeners();
    });
      
    }




}