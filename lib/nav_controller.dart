import 'package:flutter/widgets.dart';

class NavController with ChangeNotifier {
  int activeScreenIndex = 0;

  navigateToScreen(int index) {
    activeScreenIndex = index;
    notifyListeners();
  }
}
