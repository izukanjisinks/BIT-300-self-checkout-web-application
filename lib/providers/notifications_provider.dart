import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_web/providers/auth_provider.dart';
import 'package:uuid/uuid.dart';

import '../Views/Widgets/message_widget.dart';

class NotificationsProvider with ChangeNotifier{

  Map<String,dynamic> notification = {
    'topicId' : 'self-checkout-topic',
    'message' : '',
    'imageUrl' : '',
    'storeName' : ''
  };

  String downUrl = '';

  List<Map<String,dynamic>> notifications = [];

  List<Widget> notificationWidgets = [];

  List<String> docIds = [];

  bool gettingNotifications = true;

  bool deleting = false;

  uploadImageToStorage(PickedFile? pickedFile, String productId,BuildContext context) async {
    final storeName = Provider.of<AuthProvider>(context, listen: false).userCredentials['storeName'];
    String? pId = const Uuid().v4();
    Reference reference =
    FirebaseStorage.instance.ref().child('announcements/$productId/product_$pId');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();
    downUrl = value;
    notification['imageUrl'] = downUrl;
    sendNotification(storeName);
  }

  void sendNotification(String storeName) async{
    notification['storeName'] = storeName;
    var collection = FirebaseFirestore.instance.collection('announcements');
    await collection.add(notification).then((value) {
      notifications.add(notification);
      print(value.id);
      docIds.add(value.id);
    });
    //we reset the notification
    notification = {
      'topicId' : 'self-checkout-topic',
      'message' : '',
      'imageUrl' : '',
      'storeName' : ''
    };
  }


  void getNotifications(BuildContext context) async{
    final storeName = Provider.of<AuthProvider>(context, listen: false).userCredentials['storeName'];
    var collection = FirebaseFirestore.instance.collection('announcements').where('storeName',isEqualTo: storeName);
   final snapshots = await collection.get();
   convert(snapshots,context);
  }

  void convert(QuerySnapshot<Map<String,dynamic>> snapShot,BuildContext context){

    for(int i = 0; i < snapShot.docs.length; i++){
      notifications.add(snapShot.docs[i].data());
      docIds.add(snapShot.docs[i].id);
    }
    setNotifications(context);
    //refresh
    gettingNotifications = false;
    notifyListeners();
  }

  void setNotifications(BuildContext context){
    for(int i = 0; i < notifications.length; i++){
      if(notifications[i]['imageUrl'].isNotEmpty){
      notificationWidgets.add(Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius:  BorderRadius.circular(8.0),
          ),
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Image.asset(
                      'assets/icons/placeholder.jpg', fit: BoxFit.cover,),
                imageUrl:  notifications[i]['imageUrl']),
          ),
        ),
      ),
      );
      }
      notificationWidgets.add(MessageWidget(notification: notifications[i]['message']));
    }
  }

  void deleteNotifications(BuildContext context) async{
    deleting = true;
    notifyListeners();
    var collection = FirebaseFirestore.instance.collection('announcements');

    for(int i = 0; i < notifications.length; i++){
      if(notifications[i]['imageUrl'].isNotEmpty) {
        print(notifications[i]['imageUrl']);
        await FirebaseStorage.instance.ref(notifications[i]['imageUrl']).delete();
      }
      notifications.removeAt(i);
    }

    for(int i = 0; i < docIds.length; i++){
    await collection.doc(docIds[i]).delete();
      docIds.removeAt(i);
    }
    deleting = false;
    notificationWidgets = [];
    notifyListeners();
  }




}