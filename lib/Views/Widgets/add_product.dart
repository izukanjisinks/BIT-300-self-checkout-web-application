import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_web/Views/Widgets/Dialogs.dart';
import 'package:self_checkout_web/providers/add_product.dart';
import 'package:self_checkout_web/providers/auth_provider.dart';
import 'package:self_checkout_web/providers/products_provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/notifications_provider.dart';

class AddProduct extends StatefulWidget {

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  final _form = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];

  List<String> downloadUrl = <String>[];

  bool uploading = false;

  Widget? _imageWidget;

  Map<String, dynamic> product = {
    'title' : '',
    'description' : '',
    'imageUrl' : '',
    'barCode' : 0,
    'price' : 0.0,
    'saleCount' : 0,
    'storeName' : '',
    'quantity' : 0,
    'phoneNumber' : ''
  };

  void _onSaved(BuildContext context){
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false).userCredentials;
    final valid = _form.currentState!.validate();
    if(photo!.isEmpty){
      Dialogs().addImage(context);
    }else if(valid){
      _form.currentState!.save();
      product['storeName'] = authProvider['storeName'];
      product['phoneNumber'] = authProvider['phoneNumber'];
      productsProvider.product = product;
      uplaodImageAndSaveItemInfo(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProductsProvider>(context);
    return _addproduct(context);
  }



  Widget _addproduct(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final uploading = Provider.of<ProductsProvider>(context,listen: false).uploading;
    return Form(
      key: _form,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async{
               pickPhotoFromGallery();
              },
              child: photo!.isEmpty ? Image.asset(
                'assets/icons/placeholder.jpg',
                width: width * 0.25,
                height: height * 0.35,
              ) : _imageWidget!,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                width: width * 0.2,
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
                      product['title'] = value!;
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
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                width: width * 0.2,
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
                      product['price'] = value!;
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                width: width * 0.2,
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
                      product['barCode'] = value!;
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
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                width: width * 0.2,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: new BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                  child: TextFormField(
                    maxLines: 4,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Description',
                        hintText: 'enter a description',
                        hintStyle: TextStyle(color: Colors.grey)),
                    onSaved: (value) {
                      product['description'] = value!;
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
            uploading ? Center(child: Container(height: 20.0,width: 20.0,child: CircularProgressIndicator(),),) : Center(
              child: SizedBox(
                  width: width * 0.1,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(0.0),
                        backgroundColor: MaterialStateProperty.all(
                            Colors.deepPurple.withOpacity(0.8)),
                      ),
                      onPressed: () {
                            _onSaved(context);
                      },
                      child: Text('Save Product'))),
            )
          ],
        ),
      ),
    );
  }

  pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage();
    if (photo != null) {
      setState(() {
        itemImagesList = itemImagesList + photo!;
        addImage(context);
      });
    }
  }

  addImage(BuildContext context) {
    for (var bytes in photo!) {
      _imageWidget = Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius:  BorderRadius.circular(8.0),
        ),
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width * 0.25,
        child: kIsWeb
            ? Image.network(File(bytes.path).path,fit: BoxFit.cover,)
            : Image.file(
          File(bytes.path),fit: BoxFit.cover,
        ),
      );
    }
  }


  Future<String> uplaodImageAndSaveItemInfo(BuildContext context) async {
    final productsProvider = Provider.of<ProductsProvider>(context,listen: false);

    PickedFile? pickedFile;
    String? productId = const Uuid().v4();
    for (int i = 0; i < itemImagesList.length; i++) {
      file = File(itemImagesList[i].path);
      pickedFile = PickedFile(file!.path);

      await productsProvider.uploadImageToStorage(pickedFile, productId);
    }
    return productId;
  }



}
