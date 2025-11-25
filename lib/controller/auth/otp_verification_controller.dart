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
  late bool isSignup;//CHECKS IF SIGNUP VERIFICATION OR FORGOT PASSWORD VERIFICATION

  void onOtpChanged(String val) {
    isOtpValid.value = val.trim().length == 6;
  }

  void submitSignupOtp() async {
    // 1. Input Validation
    if (!isOtpValid.value) {
      Get.snackbar("Error", "Please enter the complete PIN");
      return;
    }

    // 2. Setup Request
    Uri uri = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.otpSignup);

    Map<String, dynamic> payLoad = {
      "email": email,
      "otp": otpController.text.trim(),
    };

    try {
      // 3. Send Request
      final response =
      await http.post(uri, body: payLoad).timeout(const Duration(seconds: 8));
      print("Status code: ${response.statusCode}");

      // 4. Decode Response Body (needed for 4xx errors to get the message)
      final responseData = jsonDecode(response.body);

      // 5. Status Code Handling (Modified Block)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Success Codes: 200 OK or 201 Created

        saveOtpResponse(responseData);

        if (responseData["success"] == true) {
          Get.snackbar("Success!", "OTP Verified Successfully.");

          // 👉 Navigate to next screen here
          if( isSignup ){
            Get.offAllNamed(AppRoutes.setupCompleteOne);
          }else{
            Get.toNamed(AppRoutes.resetPassword);
          }
          return;
        } else {
          // Handle cases where status code is 200/201 but 'success' field is false
          Get.snackbar(
            "Verification failed!",
            "OTP verification failed.",
          );
        }
      } else if (response.statusCode == 400) {
        // 400 Bad Request: Usually means missing fields, malformed input.
        Get.snackbar(
          "Invalid OTP",
          "OTP didn't match.",
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // 401 Unauthorized / 403 Forbidden: Often used for invalid OTP or token.
        Get.snackbar(
          "Verification Failed",
          "The entered OTP is incorrect or has expired.",
        );
      } else if (response.statusCode >= 500) {
        // 5xx Server Errors
        Get.snackbar(
          "Server Error",
          "An internal server error occurred. Please try again later.",
        );
      } else {
        // Handle other non-success status codes (e.g., 404, etc.)
        Get.snackbar(
          "Error!",
          "An unexpected error occurred. Please try again.",
        );
      }
    } on TimeoutException catch (_) {
      // 6. Timeout Exception
      Get.snackbar(
        "Time out!",
        "Request timed out. Please check your network and try again.",
      );
    } catch (e) {
      // 7. General Exceptions (e.g., network error, JSON format error)
      Get.snackbar(
        "Error!",
        "Something went wrong. Check your connection or try again.",
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

  //RESEND SIGNUP OTP
  void resendSignupOtp() async{
    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.otpResendSignup );
    Map<String, String> payLoad = {
      "email": email
    };
    http.Response response = await http.post( uri, body: payLoad );

    if( response.statusCode == 200 ){
      Get.snackbar(
          "",
          "OTP sent again in your email."
      );
    }else if( response.statusCode == 400 ){
      Get.snackbar(
          "OTP already sent",
          "Please wait before requesting a new one."
      );
    }else{
      Get.snackbar(
          "Error!",
          "Something went wrong. Please try again,"
      );
    }
  }

  @override
  void onClose() {

    otpController.dispose();
    super.onClose();
  }

}
