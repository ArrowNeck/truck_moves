import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as pt;
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

  static Result<PreDepartureChecklist> saveChecklist(
      {required Map<String, dynamic> data}) async {
    try {
      final response = await CustomHttp.getDio().post(
          "$baseUrl$saveDepartureChecklist",
          options: Options(headers: {"jobId": data["jobId"]}),
          data: json.encode(data));
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
      final response = await CustomHttp.getDio().post("$baseUrl$legUrl",
          options: Options(headers: {"jobId": jobId}),
          data: {
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
      final response = await CustomHttp.getDio().post("$baseUrl$legUrl",
          options: Options(headers: {"jobId": leg.jobId}),
          data: {
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
      final response = await CustomHttp.getDio().post("$baseUrl$purchase",
          options: Options(headers: {"jobId": jobId}),
          data: {
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

      final response = await CustomHttp.getDio()
          .post("$baseUrl$imageUpload", data: formData);

      return ApiResult.success(data: response.data);
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Result<List<String>> uploadMultiple(
      {required List<String> paths}) async {
    try {
      FormData formData = FormData();
      for (String path in paths) {
        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(
              path,
              filename: pt.basename(path),
            ),
          ),
        );
      }

      final response = await CustomHttp.getDio().post(
          "$baseUrl$multipleImageUpload?IsCheckList=true",
          data: formData);

      return ApiResult.success(
          data: (response.data as List<dynamic>)
              .map((x) => x as String)
              .toList());
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  static Result<bool> breakDown(
      {required int jobId, required bool delayOccurred}) async {
    try {
      await CustomHttp.getDio().post(
        "$baseUrl$updateStatus?jobId=$jobId&delayOccurred=$delayOccurred&Stoped=${!delayOccurred}",
        options: Options(headers: {"jobId": jobId}),
      );
      return const ApiResult.success(data: true);
    } catch (e) {
      ErrorLog.show(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
