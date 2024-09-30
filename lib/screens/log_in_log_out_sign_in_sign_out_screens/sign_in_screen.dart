import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:last_sem_project/screens/controller/login_sign_in_controller.dart';
import 'package:last_sem_project/utils/color_utils.dart';
import 'package:last_sem_project/utils/string_utils.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late LogInPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<LogInPageController>()
        ? Get.find<LogInPageController>()
        : Get.put(LogInPageController());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Call this method here to hide keyboard and unfocus text field
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [lightPurpleColor, backgroundLightOrangeColor],
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Weed Detection Project',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.08,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.height * 0.8,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: kSecondaryGray700,
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                        blurRadius: 4.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                            color: kPrimaryBlack,
                            fontSize: 32,
                            fontWeight: FontWeight.w600),
                        maxLines: 2,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        createAnAccountByUsingTheFormBelow,
                        style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                        maxLines: 2,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: controller.emailController,
                        cursorColor: kPrimaryBlack,
                        decoration: InputDecoration(
                          hintText: 'Enter your Email',
                          // errorText: 'Email is required...',
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        obscureText: !controller.isPasswordVisible,
                        controller: controller.passwordController,
                        cursorColor: kPrimaryBlack,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          // errorText: 'Password is required...',
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(controller.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  controller.setIsPasswordVisible(
                                      !controller.isPasswordVisible);
                                },
                              );
                            },
                          ),
                          alignLabelWithHint: false,
                          filled: true,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 42,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightPurpleColor,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            controller.signIn(context);
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Already have an account?',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: kPrimaryBlack,
                                  fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  controller.setIsLogin(!controller.isLogin);
                                },
                              text: ' Login in here.',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: kPrimaryBlue,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
