import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:self_checkout_web/Views/Widgets/Dialogs.dart';

import '../../providers/products_provider.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //centering the search bar
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Container(width: width * 0.4,child: const CupertinoSearchTextField()),
        ),
        const Spacer(),
        productsProvider.addPdt ? Container() : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              Dialogs().aboutDialog(context);
            },
            child: Container(
              width: 80.0,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.deepPurple,
                  ),
                  Text('About')
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
