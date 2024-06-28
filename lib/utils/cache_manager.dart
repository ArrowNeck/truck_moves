import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:truck_moves/models/driver.dart';

class CacheManger {
  static Future<void> saveDriver({required Driver driver}) async {
    final prefs = await SharedPreferences.getInstance();
    log(json.encode(driver));
    prefs.setString("DRIVER", json.encode(driver));
  }

  static Future<Driver?> getDriver() async {
    final prefs = await SharedPreferences.getInstance();
    String? driver = prefs.getString("DRIVER");
    return driver == null ? null : Driver.fromJson(json.decode(driver));
  }

  static Future<void> removeDriver() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("DRIVER");
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
