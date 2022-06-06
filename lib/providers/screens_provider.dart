import 'package:flutter/cupertino.dart';

enum Screen{homePage,allProducts}

class ScreensProvider with ChangeNotifier{

  Screen screen = Screen.homePage;

  void changeScreen(Screen screen){
    this.screen = screen;
    notifyListeners();
  }

}