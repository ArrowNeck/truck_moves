import 'dart:convert';
import 'dart:developer';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/job_header.dart';
import 'package:truck_moves/utils/api_results/api_result.dart';
import 'package:truck_moves/utils/custom_http.dart';
import 'package:truck_moves/utils/exceptions/error_log.dart';
import 'package:truck_moves/utils/exceptions/network_exceptions.dart';

typedef Result<T> = Future<ApiResult<T>>;

class JobService {
  static Result<List<JobHeader>> currentJobsHeader({required int skip}) async {
    try {
      final response = await CustomHttp.getDio().get(
          "$baseUrl$jobHeader?\$filter=status eq 3 or status eq 4 or status eq 5 or status eq 6 or status eq 7 or status eq 8 or status eq 9&orderby=Status desc,PickupDate desc&\$top=7&\$skip=$skip");
      log(json.encode(response.data));
      return ApiResult.success(
          data: (response.data as List)
              .map((e) => JobHeader.fromJson(e))
              .toList());
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Result<List<JobHeader>> futureJobsHeader({required int skip}) async {
    try {
      final response = await CustomHttp.getDio().get(
          "$baseUrl$jobHeader?\$filter=status eq 1 or status eq 2&orderby=Status desc,PickupDate desc&\$top=7&\$skip=$skip");
      log(json.encode(response.data));
      return ApiResult.success(
          data: (response.data as List)
              .map((e) => JobHeader.fromJson(e))
              .toList());
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  // static Result<List<Checklist>> checklist() async {
  //   try {
  //     final response = await CustomHttp.getDio()
  //         .get("${baseUrl}${getChecklist}");
  //     return ApiResult.success(
  //         data: (response.data as List)
  //             .map((e) => Checklist.fromJson(e))
  //             .toList());
  //   } catch (e) {
  //     ErrorLog.show(e);
  //     return ApiResult.failure(error: NetworkExceptions.getDioException(e));
  //   }
  // }

  static Result<PreDepartureChecklist> saveChecklist(
      {required Map<String, dynamic> data}) async {
    log(json.encode(data));
    try {
      final response = await CustomHttp.getDio()
          .post("$baseUrl$saveDepartureChecklist", data: json.encode(data));
      return ApiResult.success(
          data: PreDepartureChecklist.fromJson(response.data));
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
