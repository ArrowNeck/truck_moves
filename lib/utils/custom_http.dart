import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class CustomHttp {
  static final Dio _dio = Dio();

  static setInterceptor({String? token}) {
    if (kDebugMode) {
      print("Intercept called...............");
      print(token);
    }
    _dio.interceptors.first = (InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers["Content-Type"] = "application/json";
        options.headers["fromMobile"] = "true";
        options.headers["Authorization"] =
            token == null ? null : "Bearer $token";
        options.connectTimeout = const Duration(milliseconds: 25000);
        options.receiveTimeout = const Duration(milliseconds: 20000);
        options.sendTimeout = const Duration(milliseconds: 25000);

        return handler.next(options);
      },
      onResponse: (response, handler) async {
        if (kDebugMode) {
          log("URL : ${response.realUri}");
          log("RESPONSE : ${json.encode(response.data)}");
        }
        return handler.resolve(response);
      },
      onError: (error, handler) async {
        debugPrint('!----------Error-----------!');
        debugPrint(error.response.toString());
        debugPrint("STATUS CODE : ${error.response?.statusCode}");
        debugPrint(error.response?.realUri.toString() ?? "");
        debugPrint('!--------------------------!');

        return handler.next(error);
      },
    ));
  }

  static Dio getDio() {
    return _dio;
  }
}
