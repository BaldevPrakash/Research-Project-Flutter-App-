import 'package:firebase_auth/firebase_auth.dart';
import 'package:last_sem_project/main.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last_sem_project/utils/toast_utils/error_toast.dart';

class LogInPageController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final RxBool _isLogin = RxBool(true);

  bool get isLogin => _isLogin.value;

  setIsLogin(bool value) {
    _isLogin.value = value;
  }

  final RxBool _isPasswordVisible = RxBool(false);

  bool get isPasswordVisible => _isPasswordVisible.value;

  setIsPasswordVisible(bool value) {
    _isPasswordVisible.value = value;
  }

  final user = FirebaseAuth.instance.currentUser;

  void initialiseVariables() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    setIsPasswordVisible(false);
  }

  Future logIn(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Navigator.of(Get.overlayContext ?? context, rootNavigator: true).pop();
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Navigator.of(Get.overlayContext ?? context, rootNavigator: true)
          .pop(); // Ensure the loading indicator is dismissed in case of an error
      errorToast(e.toString(), Get.overlayContext ?? context);
    } catch (e) {
      // Catch any other exceptions that might occur
      Navigator.of(Get.overlayContext ?? context, rootNavigator: true)
          .pop(); // Ensure the loading indicator is dismissed
      errorToast(e.toString(), Get.overlayContext ?? context);
    }
  }

  Future signIn(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Navigator.of(Get.overlayContext ?? context, rootNavigator: true).pop();
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      Navigator.of(Get.overlayContext ?? context, rootNavigator: true)
          .pop(); // Ensure the loading indicator is dismissed in case of an error
      errorToast(e.toString(), Get.overlayContext ?? context);
    } catch (e) {
      // Catch any other exceptions that might occur
      Navigator.of(Get.overlayContext ?? context, rootNavigator: true)
          .pop(); // Ensure the loading indicator is dismissed
      errorToast(e.toString(), Get.overlayContext ?? context);
    }
  }
}
