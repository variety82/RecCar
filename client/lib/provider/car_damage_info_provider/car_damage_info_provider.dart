import 'package:flutter/foundation.dart';

class DamageInfoNotifier extends ValueNotifier<List<Map<String, dynamic>>> {
  DamageInfoNotifier(List<Map<String, dynamic>> value) : super(value);

  void updateInfo(List<Map<String, dynamic>> newValue) {
    print(value);
    print(newValue);
    print('newwwww');
    value = newValue;
    notifyListeners();
  }
}
