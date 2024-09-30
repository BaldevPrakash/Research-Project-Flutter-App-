import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:last_sem_project/models/add_rover_location_to_api.dart';
import 'package:last_sem_project/utils/color_utils.dart';
import 'package:last_sem_project/utils/text_utils/normal_text.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'controller/google_maps_controller.dart';
import 'controller/joy_stick_controller.dart';

class JoyStickScreen extends StatefulWidget {
  const JoyStickScreen({super.key});
  @override
  State<JoyStickScreen> createState() => _JoyStickScreenState();
}

class _JoyStickScreenState extends State<JoyStickScreen> {
  late JoyStickController controller;
  late GoogleMapsController googleMapsController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.isRegistered<JoyStickController>()
        ? Get.find<JoyStickController>()
        : Get.put(JoyStickController());

    googleMapsController = Get.isRegistered<GoogleMapsController>()
        ? Get.find<GoogleMapsController>()
        : Get.put(GoogleMapsController());
  }

  @override
  void didChangeDependencies() {
    controller.X =
        MediaQuery.of(context).size.width / 2 - controller.ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://last-semester-project-8ef3ff6c0fd6.herokuapp.com:443'),
  );

  @override
  Widget build(BuildContext context) {
    double joystickX = 0.0;
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryBlue,
          title: const NormalText(
            text: 'Joystick',
            textSize: 24,
            textColor: kPrimaryWhite,
          ),
          iconTheme: const IconThemeData(
            color: kPrimaryWhite, // Change this to your desired color
          ),
          actions: [
            JoystickModeDropdown(
              mode: controller.joystickMode,
              onChanged: (JoystickMode value) {
                setState(() {
                  controller.joystickMode = value;
                });
              },
            ),
          ],
        ),
        body: SafeArea(
          child: JoystickArea(
            mode: controller.joystickMode,
            initialJoystickAlignment: const Alignment(0, 0.15),
            listener: (details) {
              setState(() {
                controller.X = controller.X + controller.step * details.x;
                controller.Y = controller.Y + controller.step * details.y;
                controller.setJoyStickX(details.x);
                final message = {
                  "x": (100 * details.x).toInt(),
                  "y": (-100 * details.y).toInt()
                };
                final jsonString = jsonEncode(message);
                _channel.sink.add(jsonString);
              });
            },
            child: Stack(
              children: [
                Container(
                  color: kWhiteColor,
                ),
                Ball(controller.X, controller.Y),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.65,
                  left: MediaQuery.of(context).size.width * 0.25,
                  child: Container(
                    height: 58,
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        controller
                            .setIsDataRecording(!controller.isDataRecording);
                        if (controller.isDataRecording) {
                        } else {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0))),
                              title: const NormalText(
                                text: "Save Route",
                                textSize: 18,
                                textFontWeight: FontWeight.w600,
                              ),
                              content: const NormalText(
                                  text: "Do You Want to Save The Route"),
                              actions: <Widget>[
                                SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                      controller.setIsDataRecording(false);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                    if (googleMapsController
                                        .roverLocations.isNotEmpty) {
                                      print("Baladev");
                                      print("Strore In API");
                                      await googleMapsController
                                          .updateRoverRoutePathApiCall(context);
                                      googleMapsController
                                          .clearRoverLocations();
                                    }
                                    controller.setIsDataRecording(false);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            kPrimaryBlue),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(
                                          color: !controller.isDataRecording
                                              ? appThemePrimaryBlueColor
                                              : kSecondaryError500,
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
                          !controller.isDataRecording
                              ? appThemePrimaryBlueColor
                              : kSecondaryError500,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: !controller.isDataRecording
                                  ? appThemePrimaryBlueColor
                                  : kSecondaryError500,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                      child: Text(
                        !controller.isDataRecording
                            ? "Start Recording"
                            : "Stop Recording",
                        style: GoogleFonts.inter(
                            color: kPrimaryWhite,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.75,
                  left: MediaQuery.of(context).size.width * 0.15,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryBlue, width: 1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const NormalText(
                          text: "Spray Weedicide",
                          textSize: 20,
                          textFontWeight: FontWeight.w600,
                          textColor: kPrimaryBlue,
                        ),
                        Transform.scale(
                          scale:
                              1, // Adjust the scale factor to change the size of the switch
                          child: Switch(
                            value: controller.isWeedicideSpraying,
                            onChanged: (value) {
                              if (value) {
                                var message = {"confidence": 1};
                                final jsonString = jsonEncode(message);
                                _channel.sink.add(jsonString);
                              } else {
                                var message = {"confidence": 0};
                                final jsonString = jsonEncode(message);
                                _channel.sink.add(jsonString);
                              }
                              controller.setIsWeedicideSpraying(value);
                            },
                            activeColor: kWhiteColor,
                            inactiveThumbColor: kSecondaryGray700,
                            activeTrackColor: kPrimaryBlue,
                            inactiveTrackColor: kSecondaryGray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                StreamBuilder(
                  stream: _channel.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && controller.isDataRecording) {
                      print("HAS DATA");
                      try {
                        final jsonData = jsonDecode(snapshot.data);
                        if (googleMapsController.roverLocations.isEmpty) {
                          print("First Time");
                          googleMapsController.roverLocations
                              .add(RoverLocations.fromJson(jsonData));
                        } else {
                          if (controller.joyStickX > 0.5 ||
                              controller.joyStickX < -0.5) {
                            googleMapsController.roverLocations.removeLast();
                            googleMapsController.roverLocations
                                .add(RoverLocations.fromJson(jsonData));
                          } else {
                            print("Baladev");
                            print((googleMapsController.calculateDistance(
                                googleMapsController.roverLocations.last.lat,
                                googleMapsController.roverLocations.last.lng,
                                jsonData["lat"],
                                jsonData["lng"])));
                            if ((googleMapsController.calculateDistance(
                                    googleMapsController
                                        .roverLocations.last.lat,
                                    googleMapsController
                                        .roverLocations.last.lng,
                                    jsonData["lat"],
                                    jsonData["lng"])) >=
                                4) {
                              googleMapsController.roverLocations
                                  .add(RoverLocations.fromJson(jsonData));
                            }
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
        ),
      ),
    );
  }
}

class JoystickModeDropdown extends StatelessWidget {
  final JoystickMode mode;
  final ValueChanged<JoystickMode> onChanged;

  const JoystickModeDropdown(
      {Key? key, required this.mode, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: kWhiteColor,
          boxShadow: const [
            BoxShadow(
              color: kSecondaryGray500,
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(1, 2),
            )
          ]),
      width: 150,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: FittedBox(
          child: DropdownButton(
            padding: const EdgeInsets.only(right: 15),
            // borderRadius: BorderRadius.circular(10),
            value: mode,
            onChanged: (v) {
              onChanged(v as JoystickMode);
            },
            items: const [
              DropdownMenuItem(
                  value: JoystickMode.horizontalAndVertical,
                  child: Text('Vertical And Horizontal')),
              DropdownMenuItem(
                  value: JoystickMode.horizontal, child: Text('Horizontal')),
              DropdownMenuItem(
                  value: JoystickMode.vertical, child: Text('Vertical')),
            ],
          ),
        ),
      ),
    );
  }
}

class Ball extends StatelessWidget {
  final double x;
  final double y;

  Ball(this.x, this.y, {Key? key}) : super(key: key);

  final JoyStickController controller = Get.isRegistered<JoyStickController>()
      ? Get.find<JoyStickController>()
      : Get.put(JoyStickController());

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate adjusted x and y values to keep the ball inside the screen
    double adjustedX = x;
    double adjustedY = y;

    double ballRadius = controller.ballSize / 2;

    // Ensure the ball stays within the left and right edges
    if (adjustedX - ballRadius < 0) {
      adjustedX = ballRadius;
    } else if (adjustedX + ballRadius > screenWidth) {
      adjustedX = screenWidth - ballRadius;
    }

    // Ensure the ball stays within the top and bottom edges
    if (adjustedY - ballRadius < 0) {
      adjustedY = ballRadius;
    } else if (adjustedY + ballRadius > screenHeight) {
      adjustedY = screenHeight - ballRadius;
    }
    return Positioned(
      left: adjustedX - ballRadius,
      top: adjustedY - ballRadius,
      child: Container(
        width: controller.ballSize,
        height: controller.ballSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: kPrimaryBlue,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3),
            )
          ],
        ),
      ),
    );
  }
}
