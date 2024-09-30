import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../utils/toast_utils/error_toast.dart';

class ApiService {
  ApiService();

  Map<String, String> defaultHeaders = {
    'Content-Type': "application/json",
  };

  Future<NetworkResponse> getWithoutToken(String url, BuildContext context,
      {Map<String, String>? headers,
      Map<String, String>? qParams,
      bool isShowDialogForFailure = false,
      bool isDesktopView = true}) async {
    try {
      final http.Response response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 100),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );
      log("status code: ${response.statusCode}");
      log("on $url \n response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return NetworkResponse(
            response: jsonDecode(utf8.decode(response.bodyBytes)),
            statusCode: response.statusCode);
      }
      if (response.statusCode == 400) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.message != null) {
          errorToast(commonResponse.message!, context,
              isShortDurationText: false);
        } else {
          errorToast("somethingWentWrong", context);
        }
        throw Exception("Bad Request");
      }
      if (response.statusCode == 409) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.message != null) {
          throw Exception(commonResponse.message!);
        } else {
          throw Exception("somethingWentWrong");
        }
      }
      if (response.statusCode == 401 || response.statusCode == 400) {
        // await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 404) {
        throw Exception("Not Found");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }

      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }

      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      errorToast("pleaseCheckYourInternetConnectivityAndTryAgain", context);
      throw Exception('Not connected. Failed to load data');
    } catch (e) {
      /// If isShowDialogForFailure is true, no need to display the error toast, since will be displaying the error dialog instead.
      if (!isShowDialogForFailure) {
        if (e.toString().contains("Try after some time")) {
          errorToast('Try after some time', context);
        }

        if (e.toString().contains("Unauthorized")) {
          // errorToast(reLogin, context);
        } else if (e.toString().contains("Bad Request")) {
        } else {
          errorToast("somethingWentWrong", context);
        }
      }

      rethrow;
    }
  }

  Future<NetworkResponse> putWithoutToken(String url, BuildContext context,
      {required Map<String, dynamic> body,
      Map<String, String>? headers,
      bool isShowDialogForFailure = false,
      bool isDesktopView = true}) async {
    try {
      if (headers != null) {
        headers.addAll(defaultHeaders);
      }
      final http.Response response = await http
          .put(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers ?? defaultHeaders,
      )
          .timeout(
        const Duration(seconds: 100),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );
      log("status code: ${response.statusCode}");
      log("on $url \n response: ${response.body}");
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return NetworkResponse(
            response: jsonDecode(utf8.decode(response.bodyBytes)),
            statusCode: response.statusCode);
      }
      if (response.statusCode == 400) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.message != null) {
          errorToast(commonResponse.message!, context,
              isShortDurationText: false);
        } else {
          errorToast("somethingWentWrong", context);
        }
        throw Exception("Bad Request");
      }
      if (response.statusCode == 409) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.message != null) {
          throw Exception(commonResponse.message!);
        } else {
          throw Exception("somethingWentWrong");
        }
      }
      if (response.statusCode == 401 || response.statusCode == 400) {
        // await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 404) {
        throw Exception("Not Found");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }

      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }

      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      errorToast("pleaseCheckYourInternetConnectivityAndTryAgain", context);
      throw Exception('Not connected. Failed to load data');
    } catch (e) {
      /// If isShowDialogForFailure is true, no need to display the error toast, since will be displaying the error dialog instead.
      if (!isShowDialogForFailure) {
        if (e.toString().contains("Try after some time")) {
          errorToast('Try after some time', context);
        }

        if (e.toString().contains("Unauthorized")) {
          // errorToast(reLogin, context);
        } else if (e.toString().contains("Bad Request")) {
        } else {
          errorToast("somethingWentWrong", context);
        }
      }

      rethrow;
    }
  }

  Future<NetworkResponse> postWithoutToken(String url, BuildContext context,
      {required Map<String, dynamic> body,
      Map<String, String>? headers,
      bool isShowDialogForFailure = false,
      bool isDesktopView = true}) async {
    try {
      if (headers != null) {
        headers.addAll(defaultHeaders);
      }
      final http.Response response = await http
          .post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: headers ?? defaultHeaders,
      )
          .timeout(
        const Duration(seconds: 100),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );
      log("status code: ${response.statusCode}");
      log("on $url \n response: ${response.body}");
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return NetworkResponse(
            response: jsonDecode(utf8.decode(response.bodyBytes)),
            statusCode: response.statusCode);
      }
      if (response.statusCode == 400) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.message != null) {
          errorToast(commonResponse.message!, context,
              isShortDurationText: false);
        } else {
          errorToast("somethingWentWrong", context);
        }
        throw Exception("Bad Request");
      }
      if (response.statusCode == 409) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.message != null) {
          throw Exception(commonResponse.message!);
        } else {
          throw Exception("somethingWentWrong");
        }
      }
      if (response.statusCode == 401 || response.statusCode == 400) {
        // await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 404) {
        throw Exception("Not Found");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }

      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }

      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      errorToast("pleaseCheckYourInternetConnectivityAndTryAgain", context);
      throw Exception('Not connected. Failed to load data');
    } catch (e) {
      /// If isShowDialogForFailure is true, no need to display the error toast, since will be displaying the error dialog instead.
      if (!isShowDialogForFailure) {
        if (e.toString().contains("Try after some time")) {
          errorToast('Try after some time', context);
        }

        if (e.toString().contains("Unauthorized")) {
          // errorToast(reLogin, context);
        } else if (e.toString().contains("Bad Request")) {
        } else {
          errorToast("somethingWentWrong", context);
        }
      }

      rethrow;
    }
  }

  Future<NetworkResponse> deleteWithoutToken(String url, BuildContext context,
      {Map<String, dynamic>? body,
      Map<String, String>? headers,
      bool isShowDialogForFailure = false,
      bool isDesktopView = true}) async {
    try {
      if (headers != null) {
        headers.addAll(defaultHeaders);
      }
      final http.Response response = await http
          .delete(
        Uri.parse(url),
        headers: headers ?? defaultHeaders,
      )
          .timeout(
        const Duration(seconds: 100),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Replace 500 with your http code.
        },
      );
      log("status code: ${response.statusCode}");
      log("on $url \n response: ${response.body}");
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
        return NetworkResponse(
            response: jsonDecode(utf8.decode(response.bodyBytes)),
            statusCode: response.statusCode);
      }
      if (response.statusCode == 400) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.message != null) {
          errorToast(commonResponse.message!, context,
              isShortDurationText: false);
        } else {
          errorToast("somethingWentWrong", context);
        }
        throw Exception("Bad Request");
      }
      if (response.statusCode == 409) {
        CommonModel commonResponse =
            CommonModel.fromJson(jsonDecode(response.body));
        if (commonResponse.message != null) {
          throw Exception(commonResponse.message!);
        } else {
          throw Exception("somethingWentWrong");
        }
      }
      if (response.statusCode == 401 || response.statusCode == 400) {
        // await storeJwt(isDesktopView);
        throw Exception("Unauthorized");
      }
      if (response.statusCode == 404) {
        throw Exception("Not Found");
      }
      if (response.statusCode == 500) {
        throw Exception("Internal Server Error");
      }

      if (response.statusCode == 408) {
        throw Exception("Try after some time");
      }

      throw Exception("Something went wrong");
    } on SocketException catch (_) {
      errorToast("pleaseCheckYourInternetConnectivityAndTryAgain", context);
      throw Exception('Not connected. Failed to load data');
    } catch (e) {
      /// If isShowDialogForFailure is true, no need to display the error toast, since will be displaying the error dialog instead.
      if (!isShowDialogForFailure) {
        if (e.toString().contains("Try after some time")) {
          errorToast('Try after some time', context);
        }

        if (e.toString().contains("Unauthorized")) {
          // errorToast(reLogin, context);
        } else if (e.toString().contains("Bad Request")) {
        } else {
          errorToast("somethingWentWrong", context);
        }
      }

      rethrow;
    }
  }
}

class NetworkResponse {
  final dynamic response;
  final int statusCode;

  NetworkResponse({
    required this.response,
    required this.statusCode,
  });
}

class CommonModel {
  final String? message;

  CommonModel({
    this.message,
  });

  CommonModel.fromJson(Map<String, dynamic> json)
      : message = json['message'] as String?;

  Map<String, dynamic> toJson() => {'message': message};
}
