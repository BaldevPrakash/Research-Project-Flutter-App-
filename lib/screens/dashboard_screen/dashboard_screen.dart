import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:last_sem_project/screens/controller/home_screen_controller.dart';
import 'package:last_sem_project/screens/joy_stick_screen.dart';
import 'package:last_sem_project/utils/color_utils.dart';

import '../controller/google_maps_controller.dart';
import '../controller/joy_stick_controller.dart';
import '../home_screen.dart';
import '../icon_button_anchor.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late GoogleMapsController googleMapsController;
  late HomeScreenController homeScreenController;
  late JoyStickController joyStickController;

  Widget body = HomeScreen();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    homeScreenController = Get.isRegistered<HomeScreenController>()
        ? Get.find<HomeScreenController>()
        : Get.put(HomeScreenController());

    googleMapsController = Get.isRegistered<GoogleMapsController>()
        ? Get.find<GoogleMapsController>()
        : Get.put(GoogleMapsController());

    joyStickController = Get.isRegistered<JoyStickController>()
        ? Get.find<JoyStickController>()
        : Get.put(JoyStickController());

    homeScreenController.setSelectedIndex(0);
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButtonAnchor(),
          /*homeScreenController.getActionWidgets(
            homeScreenController.selectedIndex,
            joyStickController.joystickMode,
            (JoystickMode value) {
              setState(() {
                joyStickController.joystickMode = value;
              });
            },
          )*/
        ],
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: kPrimaryBlue,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
            homeScreenController
                .getAppBarTitle(homeScreenController.selectedIndex),
            style: TextStyle(color: kWhiteColor)),
      ),
      body: body,
      /*bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        *//*width: width,
        height: height * 0.08,*//*
        color: primaryBlack,
        child: GNav(
          onTabChange: (index) {
            setState(() {
              body = (index == 0 && homeScreenController.selectedIndex != index)
                  ? const HomeScreen()
                  : (index == 1 && homeScreenController.selectedIndex != index)
                      ? const JoyStickScreen()
                      : (index == 2 &&
                              homeScreenController.selectedIndex != index)
                          ? Container()
                          : Container();
              homeScreenController.setSelectedIndex(index);
            });
          },
          gap: 8,
          backgroundColor: primaryBlack,
          rippleColor:
              kSecondaryGray500, // tab button ripple color when pressed
          hoverColor: kSecondaryGray500, // tab button hover color
          haptic: false, // haptic feedback
          curve: Curves
              .easeInOutQuart, // tab animation curves                      gap: 8, // the tab button gap between icon and text
          color: kWhiteColor, // unselected icon color
          activeColor: kWhiteColor, // selected icon and text color
          iconSize: 24, // tab button icon size
          tabBackgroundColor:
              Colors.grey.shade800, // selected tab background color
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          tabs: const [
            GButton(
              icon: Icons.home_outlined,
              text: "Home",
            ),
            GButton(
              icon: Icons.games_outlined,
              text: "Control",
            ),
            GButton(
              icon: Icons.location_on_outlined,
              text: "Track",
            ),
          ],
        ),
      ),*/
    );
  }
}
