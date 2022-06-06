import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  final String notification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(

        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: new BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(notification,style: TextStyle(color: Colors.grey),),
        ),
      ),
    );
  }
}