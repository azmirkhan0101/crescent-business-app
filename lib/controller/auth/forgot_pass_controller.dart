import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>(); // ✅ FormKey
  var isEmailValid = false.obs;

  void onEmailChanged(String value) {
    isEmailValid.value = formKey.currentState?.validate() ?? false;
  }

  void submit(Function(String email) onSuccess) {
    if (formKey.currentState?.validate() ?? false) {
      onSuccess(emailController.text.trim());
    } else {
      Get.snackbar("Error", "Please enter a valid email");
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
