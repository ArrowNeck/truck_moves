import 'dart:convert';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/driver.dart';
import 'package:truck_moves/utils/api_results/api_result.dart';
import 'package:truck_moves/utils/custom_http.dart';
import 'package:truck_moves/utils/exceptions/error_log.dart';
import 'package:truck_moves/utils/exceptions/network_exceptions.dart';

typedef Result<T> = Future<ApiResult<T>>;

class AuthService {
  static Result<Driver> login(
      {required String email, required String password}) async {
    try {
      final params = {"userName": email, "password": password};
      final response = await CustomHttp.getDio()
          .post(baseUrl + userLogin, data: json.encode(params));
      return ApiResult.success(data: Driver.fromJson(response.data));
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Result<bool> logout() async {
    try {
      await CustomHttp.getDio().post(baseUrl + userLogout);
      return const ApiResult.success(data: true);
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
