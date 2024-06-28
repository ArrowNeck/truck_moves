import 'package:flutter/material.dart';
import 'package:truck_moves/utils/exceptions/network_exceptions.dart';

class ErrorLog {
  static show(Object e) {
    final error =
        NetworkExceptions.getErrorMessage(NetworkExceptions.getDioException(e));
    debugPrint("--------------------***ERROR***--------------------");
    debugPrint(e.toString());
    debugPrint(error.first);
    debugPrint("--------------------***ERROR***--------------------");
  }
}
