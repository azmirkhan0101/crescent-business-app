import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  //var isEmailValid = false.obs;

  bool isEmailValid() {
    return RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    ).hasMatch(emailController.text.trim());
  }

  // void submit(Function(String email) onSuccess) {
  //   if (formKey.currentState?.validate() ?? false) {
  //     onSuccess(emailController.text.trim());
  //   } else {
  //     Get.snackbar("Error", "Please enter a valid email");
  //   }
  // }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
