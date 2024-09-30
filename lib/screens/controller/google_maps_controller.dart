import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:last_sem_project/models/add_rover_location_to_api.dart';
import 'package:last_sem_project/utils/color_utils.dart';
import 'package:last_sem_project/utils/toast_utils/success_toast.dart';
import 'package:supercharged/supercharged.dart';

import '../../helper/network_helper.dart';
import '../../models/rover_locations_list_model.dart';
import '../../utils/toast_utils/error_toast.dart';

class GoogleMapsController extends GetxController {
  ApiService apiService = ApiService();

  late CameraPosition initialPosition = const CameraPosition(
      target: LatLng(20.294109672226185, 85.74343122872102), zoom: 50);

  final RxBool _isBusy = RxBool(false);
  bool get isBusy => _isBusy.value;

  setBusy(bool value) {
    _isBusy.value = value;
  }

  final RxBool _isRoverRunningOnRoute = RxBool(false);
  bool get isRoverRunningOnRoute => _isRoverRunningOnRoute.value;

  setIsRoverRunningOnRoute(bool value) {
    _isRoverRunningOnRoute.value = value;
  }

  final RxInt _currentLocationInList = RxInt(-1);
  int get currentLocationInList => _currentLocationInList.value;

  setCurrentLocationInList(int value) {
    _currentLocationInList.value = value;
  }

  final RxList<RoverLocationsListModel> _roverLocationsList = RxList([]);
  List<RoverLocationsListModel> get roverLocationsList => _roverLocationsList;

  setRoverLocationsList(List<RoverLocationsListModel> value) {
    clearRoverLocationsList();
    _roverLocationsList.addAll(value);
  }

  clearRoverLocationsList() {
    _roverLocationsList.clear();
  }

  final RxList<RoverLocations> _roverLocations = RxList([]);
  List<RoverLocations> get roverLocations => _roverLocations;

  setRoverLocations(List<RoverLocations> value) {
    _roverLocations.value = value;
  }

  clearRoverLocations() {
    _roverLocations.clear();
  }

  final RxList<LatLng> _googleMapPointsList = RxList([]);

  List<LatLng> get googleMapPointsList => _googleMapPointsList;

  setGoogleMapPointsList(List<LatLng> value) {
    _googleMapPointsList.value = value;
  }

  clearGoogleMapPointsList() {
    _googleMapPointsList.clear();
  }

  final RxList<LatLng> _googleMapPointsListForRoverCurrentLocation = RxList([]);

  List<LatLng> get googleMapPointsListForRoverCurrentLocation =>
      _googleMapPointsListForRoverCurrentLocation;

  setGoogleMapPointsListForRoverCurrentLocation(List<LatLng> value) {
    _googleMapPointsListForRoverCurrentLocation.value = value;
  }

  clearGoogleMapPointsListForRoverCurrentLocation() {
    _googleMapPointsListForRoverCurrentLocation.clear();
  }

  final RxList<Marker> _googleMapMarkerList = RxList([]);

  List<Marker> get googleMapMarkerList => _googleMapMarkerList;

  setGoogleMapMarkerList(List<Marker> value) {
    _googleMapMarkerList.value = value;
  }

  clearGoogleMapMarkerList() {
    _googleMapMarkerList.clear();
  }

  final RxList<Polyline> _googleMapPolyLineList = RxList([]);

  List<Polyline> get googleMapPolyLineList => _googleMapPolyLineList;

  setGoogleMapPolyLineList(List<Polyline> value) {
    _googleMapPolyLineList.value = value;
  }

  clearGoogleMapPolyLineList() {
    _googleMapPolyLineList.clear();
  }

  initiateController() {
    clearGoogleMapPolyLineList();
    clearGoogleMapMarkerList();
    clearGoogleMapPointsList();
    clearRoverLocations();
    setCurrentLocationInList(-1);
    setIsRoverRunningOnRoute(false);
  }

  /// Timer for google map location api call...
  Timer? timerOne;

/*  initiateGoogleMapLatLngListApiCall(BuildContext context) {
    const oneSec = Duration(seconds: 1);
    timerOne = Timer.periodic(oneSec, (Timer timer) async {
      await getRoverLocationApiList(context);
      addPointsToMarkerList();
      print(
          " Baladev Repeat task every one second"); // This statement will be printed after every one second
    });
  }*/

  /// calculate distance between two points on earth...
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    // returns distance in meters
    return 12742 * 1000 * asin(sqrt(a));
  }

  addPointsToMarkerList(int index) {
    if (_roverLocationsList.isNotEmpty) {
      if (_roverLocationsList[index].roverLocations!.isNotEmpty) {
        initialPosition = CameraPosition(
            target: LatLng(
                _roverLocationsList[index].roverLocations![0].lat as double,
                _roverLocationsList[index].roverLocations![0].lng as double),
            zoom: 40);
        for (int i = 0;
            i < _roverLocationsList[index].roverLocations!.length;
            i++) {
          _googleMapPointsList.add(LatLng(
              _roverLocationsList[index].roverLocations![i].lat as double,
              _roverLocationsList[index].roverLocations![i].lng as double));
          if (i == 0 ||
              i == _roverLocationsList[index].roverLocations!.length - 1) {
            _googleMapMarkerList.add(
              Marker(
                markerId: MarkerId('$i'),
                position: _googleMapPointsList[i],
                infoWindow: InfoWindow(
                  title: "Rover Position $i",
                ),
              ),
            );
          }
        }
        _googleMapPolyLineList.add(Polyline(
            polylineId: PolylineId("polylineId 0"),
            points: _googleMapPointsList,
            color: kPrimaryBlue /*Colors.cyan*/,
            width: 16));
      }
    }

/*    if (_googleMapPointsList.isNotEmpty) {
      for (int i = 0; i < _googleMapPointsList.length; i++) {
        _googleMapMarkerList.add(
          Marker(
            markerId: MarkerId('$i'),
            position: _googleMapPointsList[i],
            infoWindow: InfoWindow(
              title: "Rover Position $i",
            ),
          ),
        );

        _googleMapPolyLineList.add(Polyline(
            polylineId: PolylineId("polylineId $i"),
            points: _googleMapPointsList,
            color: Colors.cyan));
      }
    }*/
  }

  addLatLngToThePointsListAndAddPointsToMarkerList(double lat, double lng) {
    if (_googleMapPointsList.isEmpty) {
      _googleMapPointsList.add(LatLng(lat, lng));
      _googleMapMarkerList.add(
        Marker(
          markerId: const MarkerId('1'),
          position: LatLng(lat, lng),
          infoWindow: const InfoWindow(
            title: "Rover Position 1",
          ),
        ),
      );
    } else {
      double dist = (calculateDistance(
          lat,
          lng,
          _googleMapPointsList[_googleMapPointsList.length - 1].latitude,
          _googleMapPointsList[_googleMapPointsList.length - 1].longitude));

      if (dist >= 3.0) {
        _googleMapPointsList.add(LatLng(lat, lng));
        _googleMapMarkerList.add(
          Marker(
            markerId: MarkerId('${_googleMapPointsList.length}'),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: "Rover Position ${_googleMapPointsList.length}",
            ),
          ),
        );
      }
    }
  }

  /// Rover Tracking List Model
  Future<void> getRoverLocationApiList(BuildContext context) async {
    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      var apiUrl =
          "https://ap-south-1.aws.data.mongodb-api.com/app/finalproject-itibjxp/endpoint/rover_locations";
      try {
        setBusy(true);
        var value = await apiService.getWithoutToken(
            apiUrl, Get.overlayContext ?? context);

        if (value.statusCode == 200 && value.response != null) {
          // Convert JSON list into a list of RoverLocationListModel

          List<dynamic> jsonList = value.response;
          List<RoverLocationsListModel> roverLocationsListJson = jsonList
              .map((dynamic e) => RoverLocationsListModel.fromJson(e))
              .toList();

          setRoverLocationsList(roverLocationsListJson);

          setBusy(false);
        } else {
          setBusy(false);
          clearRoverLocationsList();
        }
      } catch (e) {
        setBusy(false);
        clearRoverLocationsList();
        if (e.toString().contains('Unauthorized')) {
          getRoverLocationApiList(Get.overlayContext ?? context);
        }
      }
    } else {
      errorToast("pleaseCheckYourInternetConnectivityAndTryAgain",
          Get.overlayContext ?? context);
      setBusy(false);
      clearRoverLocationsList();
    }
  }

  Future<void> updateRoverRoutePathApiCall(BuildContext context) async {
    bool isConnectedToInternet = await checkIsConnectedToInternet();
    if (isConnectedToInternet) {
      var apiBody =
          AddRoverLocationModel(roverLocations: roverLocations).toJson();
      var apiUrl =
          "https://ap-south-1.aws.data.mongodb-api.com/app/finalproject-itibjxp/endpoint/rover_locations";
      try {
        setBusy(true);
        var value = await apiService.postWithoutToken(
            apiUrl, Get.overlayContext ?? context,
            body: apiBody);

        if (value.statusCode == 200 ||
            value.statusCode == 201 && value.response != null) {
          // Convert JSON list into a list of RoverLocationListModel
          successToast(
              descriptionText: "Updated Route Path Successfully.",
              context: Get.overlayContext ?? context);
          print("Updated Route Path Successfully.");
          setBusy(false);
        } else {
          setBusy(false);
        }
      } catch (e) {
        setBusy(false);
        if (e.toString().contains('Unauthorized')) {
          updateRoverRoutePathApiCall(Get.overlayContext ?? context);
        }
      }
    } else {
      errorToast("pleaseCheckYourInternetConnectivityAndTryAgain",
          Get.overlayContext ?? context);
      setBusy(false);
    }
  }

  /// Checking if connected to internet or not.
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
