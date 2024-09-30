import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:get/get.dart';

import '../../helper/network_helper.dart';
import '../../utils/toast_utils/error_toast.dart';

class JoyStickController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);
  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  final RxBool _isWeedicideSpraying = RxBool(false);
  bool get isWeedicideSpraying => _isWeedicideSpraying.value;

  setIsWeedicideSpraying(bool value) {
    _isWeedicideSpraying.value = value;
  }

  final RxBool _isDataRecording = RxBool(false);
  bool get isDataRecording => _isDataRecording.value;

  setIsDataRecording(bool value) {
    _isDataRecording.value = value;
  }

  final RxDouble _joyStickX = RxDouble(0.0);
  double get joyStickX => _joyStickX.value;

  setJoyStickX(double value) {
    _joyStickX.value = value;
  }

  final ballSize = 20.0;
  final step = 10.0;

  double X = 100;
  double Y = 100;
  JoystickMode joystickMode = JoystickMode.horizontalAndVertical;

  /// Timer for google map location api call...
  Timer? timerOne;

  updateJoyStickDataApiCall(BuildContext context) {
    const oneSec = Duration(seconds: 1);
    timerOne = Timer.periodic(oneSec, (Timer timer) async {
      await updateRoverJoystickDataApiCall(context);
      print(
          " Baladev Repeat task every one second"); // This statement will be printed after every one second
    });
  }

  Future<void> updateRoverJoystickDataApiCall(BuildContext context) async {
    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      var apiBody = {"_id": "0", "X": X, "Y": Y};
      var apiUrl =
          "https://ap-south-1.aws.data.mongodb-api.com/app/finalproject-itibjxp/endpoint/rover_joystick_data";
      try {
        setBusy(true);
        var value = await apiService.putWithoutToken(
            apiUrl, Get.overlayContext ?? context,
            body: apiBody);

        if (value.statusCode == 200 ||
            value.statusCode == 201 && value.response != null) {
          // Convert JSON list into a list of RoverLocationListModel
          print("Updated Joystick Data.");
          setBusy(false);
        } else {
          setBusy(false);
        }
      } catch (e) {
        setBusy(false);
        if (e.toString().contains('Unauthorized')) {
          updateRoverJoystickDataApiCall(Get.overlayContext ?? context);
        }
      }
    } else {
      errorToast("pleaseCheckYourInternetConnectivityAndTryAgain",
          Get.overlayContext ?? context);
      setBusy(false);
    }
  }

  Future<bool> checkIsConnectedToInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      return false;
    }
  }
}
