import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
          const Padding(
              padding:  EdgeInsets.only(top: 8.0),
              child: CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.account_circle,size: 90.0,),
              )
          ),
          const SizedBox(
            height: 12.0,
          ),
          const Text(
            'E-Store Admin',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(
            height: 4.0,
          ),
          const SizedBox(
            height: 7.0,
          ),
          GestureDetector(
            onTap: () async {
              String email = "mailto:Estore@gmail.com?subject=''&body=''";

              if (await canLaunch(email)) {
                await launch(email);
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                  content: Text(
                    'Failed to launch WhatsApp!',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.deepPurple,
                ));
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('If you need any help, contact admain at '),
                  Text('Estore@gmail.com',style: TextStyle(color: Colors.deepPurple),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final theme = Theme.of(context);

    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 65.0
        ),
        child: Container(
          height: 5.0,
          decoration: BoxDecoration(
            color: theme.dividerColor,
            borderRadius: const BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}