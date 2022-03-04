import 'package:flutter/cupertino.dart';

class BottomNavBarModel with ChangeNotifier {
  int currentScreen = 1;

  void changeScreen(screen) {
    currentScreen = screen;
    notifyListeners();
  }
}
