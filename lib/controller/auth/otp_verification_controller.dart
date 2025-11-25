import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';

import 'package:http/http.dart' as http;
import 'package:organization/utils/app_constants.dart';

class OtpVerificationController extends GetxController {

  final TextEditingController otpController = TextEditingController();
  var isOtpValid = false.obs;
  final storage = GetStorage();
  late String email;

  // String email(){
  //   return storage.read( emailKey );
  // }

  void onOtpChanged(String val) {
    isOtpValid.value = val.trim().length == 6;
  }


  // void submitOtp() async{
  //   if ( !isOtpValid.value ) {
  //     Get.snackbar("Error", "Please enter the complete pin");
  //     return;
  //   }
  //   //TODO: SUBMIT OTP
  //   Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.otpSignup );
  //   Map<String, dynamic> payLoad = {
  //     "email": email,
  //     "otp": otpController.text.trim()
  //   };
  //   http.Response response = await http.post( uri, body: payLoad );
  //   print("Response: ${response.body}");
  //   print("Status code: ${response.statusCode}");
  // }

  void submitOtp() async {

    if ( !isOtpValid.value ) {
      Get.snackbar("Error", "Please enter the complete pin");
      return;
    }

    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.otpSignup );

    Map<String, dynamic> payLoad = {
      "email": email,
      "otp": otpController.text.trim(),
    };

    try {
      final response = await http.post(uri, body: payLoad).timeout(Duration(seconds: 8));
      print("Status codeeeeeeeeee: ${response.statusCode}");
      // Handle non 200/201 status codes
      if ( response.statusCode != 200 && response.statusCode != 201 ) {
        Get.snackbar(
          "Error",
          "Server error occurred. Please try again.",
        );
        return;
      }

      final responseData = jsonDecode(response.body);
      saveOtpResponse( responseData );



      if (responseData["success"] == true) {
        Get.snackbar("Success", "OTP Verified Successfully");

        // 👉 Navigate to next screen here
        Get.offAllNamed(AppRoutes.setupCompleteOne);
        return;
      } else {
        Get.snackbar(
          "Failed",
          responseData["message"] ?? "OTP verification failed",
        );
      }
    } on TimeoutException catch(_){
      Get.snackbar(
        "Time out",
        "Request timed out. Please try again",
      );
    }
    catch (e) {
      // Handle exceptions (network, format, etc.)
      Get.snackbar(
        "Error",
        "Something went wrong. Please try again.",
      );
    }
  }

  //SAVE TOKENS IN STORAGE
  void saveOtpResponse(Map<String, dynamic> response) {

    final accessToken = response["data"]["accessToken"];
    final refreshToken = response["data"]["refreshToken"];

    storage.write( accessTokenKey, accessToken);
    storage.write( refreshTokenKey, refreshToken);
  }



  @override
  void onClose() {

    otpController.dispose();

    super.onClose();
  }

}
