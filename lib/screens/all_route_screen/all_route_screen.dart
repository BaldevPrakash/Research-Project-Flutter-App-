import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last_sem_project/screens/google_maps_screen/google_map_screen.dart';
import 'package:last_sem_project/utils/color_utils.dart';
import 'package:last_sem_project/utils/text_utils/normal_text.dart';

import '../../utils/shimmer_loader.dart';
import '../../utils/shimmer_tile.dart';
import '../controller/google_maps_controller.dart';

class AllRouteScreen extends StatefulWidget {
  const AllRouteScreen({super.key});

  @override
  State<AllRouteScreen> createState() => _AllRouteScreenState();
}

class _AllRouteScreenState extends State<AllRouteScreen> {
  late GoogleMapsController controller;
  Future<void> callApiForLocationList() async {
    await controller.getRoverLocationApiList(context);
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.isRegistered<GoogleMapsController>()
        ? Get.find<GoogleMapsController>()
        : Get.put(GoogleMapsController());
    callApiForLocationList();
  }

  @override
  Widget build(BuildContext context) {
    print(controller.roverLocationsList.length);
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
          text: "Route List",
          textSize: 24,
          textColor: kPrimaryWhite,
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: kSecondaryGray500),
                  ),
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  child: controller.isBusy
                      ? ShimmerLoader(
                          child: ShimmerHorizontalLoadingTile(
                            height: MediaQuery.of(context).size.height,
                          ),
                        )
                      : controller.roverLocationsList.isEmpty
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                NormalText(
                                  text: "No Data Available",
                                  textFontWeight: FontWeight.w600,
                                  textSize: 18,
                                ),
                                NormalText(
                                  text:
                                      "Go To Create Route For Adding New Route.",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.roverLocationsList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        controller.addPointsToMarkerList(index);
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GoogleMapsScreen(
                                                      index: index)),
                                        );
                                        setState(() {});
                                      },
                                      child: Container(
                                        decoration:
                                            customDecorationWithCustomBoxShadowColor(
                                                kSecondaryGray300,
                                                kBlueShade,
                                                kBlueShade,
                                                borderRadius: 8,
                                                X: 0,
                                                Y: 4),
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            NormalText(
                                              text: "Route ${index + 1}",
                                              textSize: 20,
                                              textFontWeight: FontWeight.w600,
                                            ),
                                            const Icon(
                                              Icons.arrow_forward_ios_outlined,
                                              color: kPrimaryBlack,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                  ],
                                );
                              }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration customDecorationWithCustomBoxShadowColor(
      Color boxShadowColor, Color borderColor, Color backGroundColor,
      {double X = 0.0, double Y = 1.0, double borderRadius = 8.0}) {
    return BoxDecoration(
        color: backGroundColor,
        border: Border.all(width: 1.0, color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
              color: boxShadowColor.withOpacity(0.25),
              spreadRadius: 0,
              blurRadius: 4,
              offset: Offset(X, Y))
        ]);
  }
}
