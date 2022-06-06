import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/products_provider.dart';

class EditProduct extends StatefulWidget {

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _form = GlobalKey<FormState>();

  File? file;

  final ImagePicker _picker = ImagePicker();

  List<XFile>? photo = <XFile>[];

  List<XFile> itemImagesList = <XFile>[];

  List<String> downloadUrl = <String>[];

  bool uploading = false;

  Widget? _imageWidget;

  Map<String, dynamic> product = {};

  void _onSaved(BuildContext context){
    final valid = _form.currentState!.validate();
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    //no photo picked, user is not uploading but may be updating properties eg title,description
    if(photo!.isEmpty){
      _form.currentState!.save();
      productsProvider.updateProduct();
    }else if(valid){
      _form.currentState!.save();
      uplaodImageAndSaveItemInfo(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    product = productsProvider.selectedProduct;
    return _editProduct(context);
  }

  Widget _editProduct(BuildContext context) {
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
              child: photo!.isEmpty ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius:  BorderRadius.circular(8.0),
                  ),
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Image.asset(
                              'assets/icons/placeholder.jpg', fit: BoxFit.cover,),
                        imageUrl:  product['imageUrl']),
                  ),
                ),
              ) : Padding(
                padding: const EdgeInsets.all(8.0),
                child: _imageWidget!,
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
                    initialValue: product['title'],
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
                    initialValue: product['price'].toString(),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Price',
                        hintText: 'enter a price',
                        hintStyle: TextStyle(color: Colors.grey)),
                    onSaved: (value) {
                      product['price'] = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a price!';
                      } else {
                        return null;
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
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius:  BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                  child: TextFormField(
                    initialValue: product['barCode'].toString(),
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
                      if (value.length < 3) {
                        return 'Please enter a valid barcode!';
                      } else {
                        return null;
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
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius:  BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, bottom: 2),
                  child: TextFormField(
                    initialValue: product['description'],
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
                      if (value.length < 10) {
                        return 'Please enter a valid description!';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
            ),
            uploading ? Center(child: SizedBox(height: 20.0,width: 20.0,child: CircularProgressIndicator(),),) : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.deepPurple.withOpacity(0.8)),
                    ),
                    onPressed: () {
                      _onSaved(context);
                    },
                    child: Text('update product')),
                SizedBox(width: 5.0,),
                ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0.0),
                      backgroundColor: MaterialStateProperty.all(
                          Colors.red),
                    ),
                    onPressed: () {
                      Provider.of<ProductsProvider>(context, listen: false).deleteProduct();
                    },
                    child: Text('delete product')),
              ],
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

      await productsProvider.updateImageToStorage(pickedFile, productId);
    }
    return productId;
  }
}
