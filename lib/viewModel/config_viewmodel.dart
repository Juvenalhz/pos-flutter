import 'package:flutter/material.dart';
import 'package:pay/utils/dropdown_items.dart';

class ConfigViewModel with ChangeNotifier {
  bool _changes = false;
  String _dropDownChoice = DropDownItems.typePinpadList[1];

  bool get changes => _changes;
  String get dropDownChoice => _dropDownChoice;

  updateChanges(bool change) {
    _changes = change;
    notifyListeners();
  }

  setDropDownChoice(String value) {
    _dropDownChoice = value;
    notifyListeners();
  }
}
