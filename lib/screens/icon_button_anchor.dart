import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last_sem_project/utils/color_utils.dart';
import 'package:last_sem_project/utils/text_utils/normal_text.dart';

import 'controller/home_screen_controller.dart';

class IconButtonAnchor extends StatelessWidget {
  IconButtonAnchor({super.key});

  final HomeScreenController homeScreenController =
      Get.isRegistered<HomeScreenController>()
          ? Get.find<HomeScreenController>()
          : Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder: (context, controller, child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(
            Icons.more_vert,
            color: kWhiteColor,
          ),
        );
      },
      menuChildren: [
        MenuItemButton(
          child: const NormalText(
            text: 'Sign Out',
            textSize: 16,
          ),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            homeScreenController.deleteRoverLocationDataApiCall(context);
          },
        ),
      ],
    );
  }
}
