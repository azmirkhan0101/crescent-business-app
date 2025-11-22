import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationController extends GetxController {
  final pinController = TextEditingController();
  var isPinValid = false.obs;

  void onPinChanged(String val) {
    isPinValid.value = val.trim().length == 5;
  }

  void submit(Function(String pin) onSuccess) {
    if (isPinValid.value) {
      onSuccess(pinController.text.trim());
    } else {
      Get.snackbar("Error", "Please enter the complete pin");
    }
  }

  @override
  void onClose() {

    pinController.dispose();

    super.onClose();
  }

}
