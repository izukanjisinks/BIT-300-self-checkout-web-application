import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;

import 'package:self_checkout_web/Views/Widgets/upload_page.dart';
import 'package:self_checkout_web/providers/notifications_provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/auth_provider.dart';
import 'message_widget.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String notification = '';
  final TextEditingController _controller = TextEditingController();
  final _form = GlobalKey<FormState>();

  List<Widget> itemPhotosWidgetList = <Widget>[];

  final ImagePicker _picker = ImagePicker();
  File? file;
  List<XFile>? photo = <XFile>[];
  List<XFile> itemImagesList = <XFile>[];

  List<String> downloadUrl = <String>[];

  bool uploading = false;
  bool picked = false;
  bool imagePresent = false;
  bool gettingNotifications = true;
  bool set = true;

  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    final notificationProv =
        Provider.of<NotificationsProvider>(context, listen: false);
    notificationProv.getNotifications(context);
    super.initState();
  }

  void _onSaved(BuildContext context) {
    final notificationProv =
        Provider.of<NotificationsProvider>(context, listen: false);
    final storeName = Provider.of<AuthProvider>(context, listen: false)
        .userCredentials['storeName'];
    final valid = _form.currentState!.validate();
    if (valid) {
      _form.currentState!.save();

      notificationProv.notification['message'] = notification;

      notificationProv.notificationWidgets.add(MessageWidget(
          notification: notificationProv.notification['message']));

      _controller.clear();
      if (imagePresent) {
        uplaodImageAndSaveItemInfo(context);
      } else {
        notificationProv.sendNotification(storeName);
      }
      setState(() {
        uploading = false;
        picked = false;
        imagePresent = false;
      });
    }
  }

  bool deletingNotifications = false;

  @override
  Widget build(BuildContext context) {
    final notificationProv = Provider.of<NotificationsProvider>(context);

    gettingNotifications = notificationProv.gettingNotifications;
    deletingNotifications = notificationProv.deleting;
    itemPhotosWidgetList = notificationProv.notificationWidgets;
    return _notificationContainer(context);
  }

  Widget _notificationContainer(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.22,
      height: height * 0.96,
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
      child: gettingNotifications
          ? Center(
              child: Container(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(),
            ))
          : deletingNotifications
              ? Center(
                  child: Container(
                  height: 30.0,
                  width: 30.0,
                  child: CircularProgressIndicator(),
                ))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Notifications',
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ),
                    Expanded(
                        child: itemPhotosWidgetList.isEmpty
                            ? Center(
                                child: Text('No Notifications'),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                children: itemPhotosWidgetList,
                                crossAxisAlignment: CrossAxisAlignment.end,
                              ))),
                    _sendNotification(context)
                  ],
                ),
    );
  }

  Widget _sendNotification(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: new BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                child: Form(
                  key: _form,
                  child: TextFormField(
                    controller: _controller,
                    maxLines: 3,
                    style: TextStyle(color: Colors.grey),
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'send message',
                    ),
                    onSaved: (value) {
                      notification = value.toString();
                    },
                    validator: (value) {
                      if (value!.isEmpty) return 'enter a value';
                    },
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          picked = true;
                        } else {
                          picked = false;
                        }
                      });
                    },
                  ),
                ),
              ),
              Container(
                child: picked
                    ? IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          _onSaved(context);
                        },
                      )
                    : IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          pickPhotoFromGallery();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => const UploadPage()),
                          // );
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void imageUrl() {
    //FirebaseStorage.instance.refFromURL(url).child(path)
  }

  void uploadImage({required Function(html.File file) onSelected}) {
    html.FileUploadInputElement uploadImage = html.FileUploadInputElement()
      ..accept = 'image/*';

    uploadImage.click();

    uploadImage.onChange.listen((event) {
      final file = uploadImage.files!.first;
      final reader = html.FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        print('finished loading');
      });
      onSelected(file);
    });
  }

  void uploadToStorage() {
    uploadImage(onSelected: (file) {
      html.File _file = file;
      // FirebaseStorage.instance
      //     .refFromURL('gs://self-checkout-system-d3842.appspot.com')
      //     .child('productImages')
      //     .putFile(_file);
    });
  }

  void picker() async {
    // var picked = await FilePicker.platform.pickFiles();
    //
    // File file = picked?.files.first as File;

    // if (picked != null) {
    //   print(picked.files.first.extension);
    //   Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('productImages/${picked.files.first.name}');
    //   TaskSnapshot uploadTask = await firebaseStorageRef.putFile(file);
    // }
  }

  pickPhotoFromGallery() async {
    photo = await _picker.pickMultiImage();
    if (photo != null) {
      setState(() {
        itemImagesList = itemImagesList + photo!;
        picked = true;
        imagePresent = true;
        addImage(context);
        photo!.clear();
      });
    }
  }

  addImage(BuildContext context) {
    final notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: false);
    for (var bytes in photo!) {
      notificationsProvider.notificationWidgets.add(Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.0),
          ),
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.2,
          child: kIsWeb
              ? Image.network(
                  File(bytes.path).path,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  File(bytes.path),
                  fit: BoxFit.cover,
                ),
        ),
      ));
    }
  }

  Future<String> uplaodImageAndSaveItemInfo(BuildContext context) async {
    final notificationProv =
        Provider.of<NotificationsProvider>(context, listen: false);

    setState(() {
      uploading = true;
    });
    PickedFile? pickedFile;
    String? productId = const Uuid().v4();
    for (int i = 0; i < itemImagesList.length; i++) {
      file = File(itemImagesList[i].path);
      pickedFile = PickedFile(file!.path);

      await notificationProv.uploadImageToStorage(
          pickedFile, productId, context);
    }
    return productId;
  }
}
