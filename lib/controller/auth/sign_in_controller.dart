import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organization/data/models/business_model/business_model.dart';
import 'package:organization/routes/app_pages.dart';

class SignInController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController taglineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  BusinessModel businessModel = BusinessModel();

  bool get isValid =>
      emailController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty;

  void signIn(BuildContext context) {
    if (!isValid) {
      Get.snackbar(
        "Error",
        "Please enter both email and password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    Get.toNamed(AppRoutes.mainNav);
    debugPrint(" Login with ${emailController.text}");
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
