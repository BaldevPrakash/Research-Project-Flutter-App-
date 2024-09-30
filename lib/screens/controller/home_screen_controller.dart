import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:last_sem_project/screens/icon_button_anchor.dart';

import '../../helper/network_helper.dart';
import '../../utils/toast_utils/error_toast.dart';
import '../joy_stick_screen.dart';
import 'google_maps_controller.dart';

GoogleMapsController googleMapsController = Get.isRegistered<GoogleMapsController>()
    ? Get.find<GoogleMapsController>()
    : Get.put(GoogleMapsController());

class HomeScreenController extends GetxController {
  ApiService apiService = ApiService();

  final RxBool _isBusy = RxBool(false);
  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  final RxInt _selectedIndex = RxInt(0);
  int get selectedIndex => _selectedIndex.value;

  setSelectedIndex(int value) {
    _selectedIndex.value = value;
  }

  String getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return ("Welcome Onboard");
      case 1:
        return ("Control Rover");
      case 2:
        return ("Track Rover");
      case 3:
        return ("Weed Detection");
      default:
        return ("Welcome Onboard");
    }
  }

  getActionWidgets(index, joystickMode, onChanged) {
    switch (index) {
      case 0:
        return (IconButtonAnchor());
      case 1:
        return (Container(
          child: JoystickModeDropdown(
            mode: joystickMode,
            onChanged: onChanged,
          ),
        ));
      case 2:
        return (Container());
      case 3:
        return (Container());
      default:
        return (Container());
    }
  }

  Future<void> deleteRoverLocationDataApiCall(BuildContext context) async {
    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      var apiBody = {};
      var apiUrl =
          "https://ap-south-1.aws.data.mongodb-api.com/app/finalproject-itibjxp/endpoint/rover_joystick_data";
      try {
        setBusy(true);
        var value = await apiService.deleteWithoutToken(
          apiUrl,
          Get.overlayContext ?? context,
        );

        if (value.statusCode == 200 ||
            value.statusCode == 201 && value.response != null) {
          // Convert JSON list into a list of RoverLocationListModel
          print("Deleted Rover Location Data.");
          setBusy(false);
        } else {
          setBusy(false);
        }
      } catch (e) {
        setBusy(false);
        if (e.toString().contains('Unauthorized')) {
          deleteRoverLocationDataApiCall(Get.overlayContext ?? context);
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
