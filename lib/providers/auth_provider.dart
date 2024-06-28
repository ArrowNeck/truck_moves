import 'package:flutter/material.dart';
import 'package:truck_moves/models/driver.dart';

class AuthProvider with ChangeNotifier {
  Driver? _driver;
  Driver get driver => _driver!;

  AuthProvider(Driver? driver) {
    _driver = driver;
  }

  void setDriver(Driver driver) {
    _driver = driver;
    notifyListeners();
  }

  void removeDriver() {
    _driver = null;
  }
}
