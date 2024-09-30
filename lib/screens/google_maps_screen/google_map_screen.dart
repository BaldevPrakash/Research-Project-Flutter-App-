import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:last_sem_project/screens/controller/joy_stick_controller.dart';
import 'package:last_sem_project/utils/color_utils.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../utils/text_utils/normal_text.dart';
import '../controller/google_maps_controller.dart';

class GoogleMapsScreen extends StatefulWidget {
  const GoogleMapsScreen({super.key, required this.index});
  final int index;
  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  late GoogleMapsController controller;
  late JoyStickController joyStickController;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    controller = Get.isRegistered<GoogleMapsController>()
        ? Get.find<GoogleMapsController>()
        : Get.put(GoogleMapsController());

    joyStickController = Get.isRegistered<JoyStickController>()
        ? Get.find<JoyStickController>()
        : Get.put(JoyStickController());
    controller.initiateController();
    controller.addPointsToMarkerList(widget.index);
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    super.dispose();
    _channel.sink.close();
  }

  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://last-semester-project-8ef3ff6c0fd6.herokuapp.com:443'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(-20)),
        centerTitle: true,
        // actions: const [IconButtonAnchor()],
        backgroundColor: kPrimaryBlue,
        iconTheme: const IconThemeData(
          color: kPrimaryWhite, // Change this to your desired color
        ),
        title: const NormalText(
          text: "Track Your Rover",
          textColor: kWhiteColor,
          textSize: 20,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GetX<GoogleMapsController>(
              builder: (controller) {
                return GoogleMap(
                  zoomGesturesEnabled: true, // Allow zoom gestures
                  zoomControlsEnabled: true, // Show zoom controls
                  mapType: MapType.satellite,
                  markers: Set<Marker>.of(controller.googleMapMarkerList),
                  polylines: Set<Polyline>.of(controller.googleMapPolyLineList),
                  initialCameraPosition: controller.initialPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                );
              },
            ),
            Obx(
              () => Positioned(
                top: MediaQuery.of(context).size.height * 0.75,
                left: MediaQuery.of(context).size.width * 0.19,
                child: Container(
                  height: 58,
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.setIsRoverRunningOnRoute(
                          !controller.isRoverRunningOnRoute);
                      controller
                          .clearGoogleMapPointsListForRoverCurrentLocation();
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          setState(() {
                            if (controller.googleMapPolyLineList.length > 1) {
                              controller
                                  .clearGoogleMapPointsListForRoverCurrentLocation();
                              controller.googleMapPolyLineList.removeLast();
                            }
                          });
                        },
                      );
                      if (controller.isRoverRunningOnRoute) {
                        var jsonString = jsonEncode({"x": 200, "y": 0});
                        _channel.sink.add(jsonString);
                        jsonString = jsonEncode({
                          "lat": controller.roverLocationsList[widget.index]
                              .roverLocations![0].lat,
                          "lng": controller.roverLocationsList[widget.index]
                              .roverLocations![0].lng
                        });
                        _channel.sink.add(jsonString);
                        if (controller.roverLocationsList[widget.index]
                                .roverLocations!.length >
                            1) {
                          controller.setCurrentLocationInList(1);
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            title: const NormalText(
                              text: "Stop Route",
                              textSize: 18,
                              textFontWeight: FontWeight.w600,
                            ),
                            content: const NormalText(
                                text: "Do You Want to Stop The Route"),
                            actions: <Widget>[
                              SizedBox(
                                height: 48,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    controller.setIsRoverRunningOnRoute(true);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    side: const BorderSide(
                                        width: 1, color: Colors.transparent),
                                  ),
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.inter(
                                        color: kPrimaryBlack,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(ctx).pop();
                                  var jsonString = jsonEncode({"x": 0, "y": 0});
                                  _channel.sink.add(jsonString);
                                  controller.setIsRoverRunningOnRoute(false);
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (_) {
                                      setState(() {
                                        if (controller
                                                .googleMapPolyLineList.length >
                                            1) {
                                          controller.googleMapPolyLineList
                                              .removeLast();
                                          controller
                                              .clearGoogleMapPointsListForRoverCurrentLocation();
                                        }
                                      });
                                    },
                                  );
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          kSecondaryError500),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: const BorderSide(
                                        color: kSecondaryError500,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  child: Text(
                                    "Yes",
                                    style: GoogleFonts.inter(
                                        color: kPrimaryWhite,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        !controller.isRoverRunningOnRoute
                            ? appThemePrimaryBlueColor
                            : kSecondaryError500,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                            color: !controller.isRoverRunningOnRoute
                                ? appThemePrimaryBlueColor
                                : kSecondaryError500,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      !controller.isRoverRunningOnRoute
                          ? "Start Route Journey"
                          : "Stop Route Journey",
                      style: GoogleFonts.inter(
                          color: kPrimaryWhite,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData && controller.isRoverRunningOnRoute) {
                  try {
                    final jsonData = jsonDecode(snapshot.data);
                    double lat = jsonData["lat"];
                    double lng = jsonData["lng"];
                    controller.googleMapPointsListForRoverCurrentLocation
                        .add(LatLng(lat, lng));
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        if (controller.googleMapPolyLineList.length > 1) {
                          controller.googleMapPolyLineList.removeLast();
                          controller.googleMapPolyLineList.add(
                            Polyline(
                                polylineId: PolylineId("polylineId 1"),
                                points: controller
                                    .googleMapPointsListForRoverCurrentLocation,
                                color: kPrimaryWhite,
                                width: 5),
                          );
                        } else {
                          controller.googleMapPolyLineList.add(
                            Polyline(
                                polylineId: PolylineId("polylineId 1"),
                                points: controller
                                    .googleMapPointsListForRoverCurrentLocation,
                                color: kPrimaryWhite,
                                width: 5),
                          );
                        }
                      });
                    });
                    double dist = (controller.calculateDistance(
                        lat,
                        lng,
                        controller
                            .roverLocationsList[widget.index]
                            .roverLocations![controller.currentLocationInList]
                            .lat,
                        controller
                            .roverLocationsList[widget.index]
                            .roverLocations![controller.currentLocationInList]
                            .lng));
                    if (dist <= 2.0) {
                      var jsonString = jsonEncode({
                        "tlat": controller
                            .roverLocationsList[widget.index]
                            .roverLocations![controller.currentLocationInList]
                            .lat,
                        "tlon": controller
                            .roverLocationsList[widget.index]
                            .roverLocations![controller.currentLocationInList]
                            .lng
                      });
                      _channel.sink.add(jsonString);

                      if ((controller.currentLocationInList + 1) <
                          controller.roverLocationsList[widget.index]
                              .roverLocations!.length) {
                        controller.setCurrentLocationInList(
                            controller.currentLocationInList + 1);
                      }
                    }
                  } catch (e) {
                    print('Error parsing JSON: $e');
                  }
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
