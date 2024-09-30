import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/color_utils.dart';
import '../utils/text_utils/normal_text_with_letter_spacing.dart';
import 'all_route_screen/all_route_screen.dart';
import 'controller/google_maps_controller.dart';
import 'controller/joy_stick_controller.dart';
import 'joy_stick_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapsController googleMapsController;
  late JoyStickController joyStickController;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    googleMapsController = Get.isRegistered<GoogleMapsController>()
        ? Get.find<GoogleMapsController>()
        : Get.put(GoogleMapsController());

    joyStickController = Get.isRegistered<JoyStickController>()
        ? Get.find<JoyStickController>()
        : Get.put(JoyStickController());
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const JoyStickScreen()),
              );
              setState(() {});
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: kWhiteColor,
                border: Border.all(color: kSecondaryGray300),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: kSecondaryGray500,
                      blurRadius: 10,
                      offset: Offset(4, 4))
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalTextWithLetterSpacing(
                      textAlign: TextAlign.center,
                      text: "Create New Tracks",
                      textSize: 20,
                      letterSpacingValue: 1.5,
                      textFontWeight: FontWeight.w500,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: kPrimaryBlack,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AllRouteScreen(),
                ),
              );
              setState(() {});
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: kWhiteColor,
                border: Border.all(color: kSecondaryGray300),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      color: kSecondaryGray500,
                      blurRadius: 10,
                      offset: Offset(4, 4))
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NormalTextWithLetterSpacing(
                      textAlign: TextAlign.center,
                      text: "Explore Rover Tracks",
                      textSize: 20,
                      letterSpacingValue: 1.5,
                      textFontWeight: FontWeight.w500,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: kPrimaryBlack,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
