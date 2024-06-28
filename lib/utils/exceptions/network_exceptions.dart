import 'dart:io';

import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exceptions.freezed.dart';

@freezed
abstract class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorizedRequest() = UnauthorizedRequest;

  const factory NetworkExceptions.badRequest() = BadRequest;

  const factory NetworkExceptions.notFound() = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError() = InternalServerError;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  const factory NetworkExceptions.badCertificate() = BadCertificate;

  const factory NetworkExceptions.badGateway() = BadGateway;

  static NetworkExceptions getDioException(error) {
    if (error is Exception) {
      try {
        NetworkExceptions networkExceptions;

        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = const NetworkExceptions.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
              break;
            case DioExceptionType.unknown:
              networkExceptions =
                  const NetworkExceptions.noInternetConnection();
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badCertificate:
              networkExceptions = const NetworkExceptions.badCertificate();
              break;
            case DioExceptionType.connectionError:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 400:
                  networkExceptions = const NetworkExceptions.badRequest();
                  break;
                case 401:
                  networkExceptions =
                      const NetworkExceptions.unauthorizedRequest();
                  break;
                case 403:
                  networkExceptions = const NetworkExceptions.notAcceptable();
                  break;
                case 404:
                  networkExceptions = const NetworkExceptions.notFound();
                  break;
                case 408:
                  networkExceptions = const NetworkExceptions.requestTimeout();
                  break;
                case 409:
                  networkExceptions = const NetworkExceptions.conflict();
                  break;
                case 500:
                  networkExceptions =
                      const NetworkExceptions.internalServerError();
                  break;
                case 501:
                  networkExceptions =
                      const NetworkExceptions.methodNotAllowed();
                  break;
                case 502:
                  networkExceptions = const NetworkExceptions.badGateway();
                  break;
                case 503:
                  networkExceptions =
                      const NetworkExceptions.serviceUnavailable();
                  break;
                default:
                  var responseCode = error.response!.statusCode;
                  networkExceptions = NetworkExceptions.defaultError(
                    "Received invalid status code: $responseCode",
                  );
              }
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = const NetworkExceptions.noInternetConnection();
        } else {
          networkExceptions = const NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } on FormatException catch (_) {
        return const NetworkExceptions.formatException();
      } catch (_) {
        return const NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return const NetworkExceptions.unableToProcess();
      } else {
        return const NetworkExceptions.unexpectedError();
      }
    }
  }

  static List<String> getErrorMessage(NetworkExceptions networkExceptions) {
    List<String> errorMessage = [];
    networkExceptions.when(requestCancelled: () {
      errorMessage = [
        "Request Cancelled",
        "The request was cancelled. Please try again",
        "assets/icons/error.svg"
      ];
    }, internalServerError: () {
      errorMessage = [
        "Internal Server Error",
        "Something went wrong on our end. Please try again later",
        "assets/icons/error.svg"
      ];
    }, notFound: () {
      errorMessage = [
        "Not Found",
        "The requested resource could not be found. Please check the URL or try again later",
        "assets/icons/error.svg"
      ];
    }, serviceUnavailable: () {
      errorMessage = [
        "Service Unavailable",
        "Our service is temporarily unavailable due to maintenance or high traffic. Please try again later",
        "assets/icons/maintenance.svg"
      ];
    }, methodNotAllowed: () {
      errorMessage = [
        "Not Implemented",
        "This feature is currently not supported. Please try again later",
        "assets/icons/error.svg"
      ];
    }, badRequest: () {
      errorMessage = [
        "Invalid Request",
        "We couldn't process your request. Please check the information you entered and try again",
        "assets/icons/error.svg"
      ];
    }, unauthorizedRequest: () {
      errorMessage = [
        "Unauthorized Access",
        "You need to log in to access this feature. Please log in and try again",
        "assets/icons/login.svg"
      ];
    }, unexpectedError: () {
      errorMessage = [
        "Unexpected Error Occurred",
        "An unexpected error occurred. Please try again later or contact support if the problem persists",
        "assets/icons/error.svg"
      ];
    }, requestTimeout: () {
      errorMessage = [
        "No Internet Connection",
        "The connection attempt took too long. Please check your internet connection and try again",
        "assets/icons/connection.svg"
      ];
    }, noInternetConnection: () {
      errorMessage = [
        "No Internet Connection",
        "You are not connected to the internet. Please check your connection and try again",
        "assets/icons/connection.svg"
      ];
    }, conflict: () {
      errorMessage = [
        "Conflict Detected",
        "There was a conflict with your request. Please check the information and try again",
        "assets/icons/error.svg"
      ];
    }, sendTimeout: () {
      errorMessage = [
        "No Internet Connection",
        "Sending data took too long. Please check your internet connection and try again",
        "assets/icons/connection.svg"
      ];
    }, unableToProcess: () {
      errorMessage = [
        "Data Processing Error",
        "There was an error processing the data. Please try again later or contact support if the problem persists",
        "assets/icons/nodata.svg"
      ];
    }, defaultError: (String error) {
      errorMessage = [
        "Unexpected Error Occurred",
        "An unexpected error occurred. Please try again later or contact support if the problem persists",
        "assets/icons/nodata.svg"
      ];
    }, formatException: () {
      errorMessage = [
        "Invalid Data Format",
        "The data received is in an unexpected format. Please check your input and try again",
        "assets/icons/nodata.svg"
      ];
    }, badCertificate: () {
      errorMessage = [
        "Secure Connection Failed",
        "The connection could not be established securely. Please check your network settings or try again later",
        "assets/icons/error.svg"
      ];
    }, notAcceptable: () {
      errorMessage = [
        "Access Denied",
        "You don't have permission to access this resource",
        "assets/icons/error.svg"
      ];
    }, badGateway: () {
      errorMessage = [
        "Bad Gateway",
        "There's a problem with our server. Please try again later",
        "assets/icons/error.svg"
      ];
    });
    return errorMessage;
  }
}
