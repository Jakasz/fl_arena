import 'package:fl_arena/storage/firebase_data.dart';
import 'package:flutter/material.dart';

class FbProvider extends ChangeNotifier {
  List<FirebaseData> _rtdb = [];
  int _selectedIndex = -1;
  List<FirebaseData> get rtdb => _rtdb;
  int get selectedIndex => _selectedIndex;

  updateDB(List<FirebaseData> data) {
    _rtdb = data;
    notifyListeners();
  }

  updateSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  cleanDB() {
    _rtdb.clear();
  }
}
