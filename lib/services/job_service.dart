import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:truck_moves/constant.dart';
import 'package:truck_moves/models/job.dart';
import 'package:truck_moves/utils/api_results/api_result.dart';
import 'package:truck_moves/utils/custom_http.dart';
import 'package:truck_moves/utils/exceptions/error_log.dart';
import 'package:truck_moves/utils/exceptions/network_exceptions.dart';

typedef Result<T> = Future<ApiResult<T>>;

class JobService {
  static Result<List<Job>> currentJobsHeader({required int skip}) async {
    try {
      final response = await CustomHttp.getDio().get(
          "$baseUrl$jobHeader?\$filter=status eq 3 or status eq 4 or status eq 5 or status eq 6 or status eq 7 or status eq 8 or status eq 9&orderby=Status desc,PickupDate desc&\$top=7&\$skip=$skip");
      log(json.encode(response.data));
      return ApiResult.success(
          data: (response.data as List).map((e) => Job.fromJson(e)).toList());
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Result<List<Job>> futureJobsHeader({required int skip}) async {
    try {
      final response = await CustomHttp.getDio().get(
          "$baseUrl$jobHeader?\$filter=status eq 1 or status eq 2&orderby=Status desc,PickupDate desc&\$top=7&\$skip=$skip");
      log(json.encode(response.data));
      return ApiResult.success(
          data: (response.data as List).map((e) => Job.fromJson(e)).toList());
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

  static Result<Leg> createLeg(
      {required int jobId, required String location}) async {
    try {
      final response = await CustomHttp.getDio().post("$baseUrl$legUrl", data: {
        "id": 0,
        "jobId": jobId,
        "startLocation": location,
        "acknowledged": true
      });
      return ApiResult.success(data: Leg.fromJson(response.data));
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Result<Leg> closeLeg(
      {required Leg leg,
      required String location,
      required bool isCompleted}) async {
    try {
      final response = await CustomHttp.getDio().post("$baseUrl$legUrl", data: {
        "id": leg.id,
        "jobId": leg.jobId,
        "startLocation": leg.startLocation,
        "endLocation": location,
        "isCompleted": isCompleted
      });
      return ApiResult.success(data: Leg.fromJson(response.data));
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Result<dynamic> addPurchase(
      {required int driverId, required int jobId, required String url}) async {
    try {
      final response =
          await CustomHttp.getDio().post("$baseUrl$purchase", data: {
        "id": 0,
        "jobId": jobId,
        "status": 1,
        "driver": driverId,
        "fromMobile": true,
        "organiseNow": false,
        "assignee": null,
        "reciptUrl": url,
        "isFuel": null,
        "vendor": null,
        "liters": null,
        "cost": null,
        "itemDescription": null
      });
      return ApiResult.success(data: response.data);
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Result<String> upload({required String path}) async {
    try {
      String fileName = path.split('/').last;

      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(path, filename: fileName),
        "Ispurchase": true,
      });

      final response = await CustomHttp.getDio().post(
          // options: Options(sendTimeout: const Duration(seconds: 5)),
          "$baseUrl$imageUpload",
          data: formData);

      return ApiResult.success(data: response.data);
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
