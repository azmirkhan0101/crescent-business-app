import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/data/models/business_profile_model.dart';
import 'package:organization/data/models/business_signup_model.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_constants.dart';

import '../../utils/app_color.dart';

class OtpVerificationController extends GetxController {

  final TextEditingController otpController = TextEditingController();
  var isOtpValid = false.obs;
  final storage = GetStorage();
  late String email;
  late bool isSignup;//CHECKS IF SIGNUP VERIFICATION OR FORGOT PASSWORD VERIFICATION

  void onOtpChanged(String val) {
    isOtpValid.value = val.trim().length == 6;
  }

  //SUBMIT OTP FOR SIGNUP EMAIL VERIFICATION
  void submitSignupOtp() async {

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
      final response = await http.post(uri, body: payLoad).timeout(const Duration(seconds: 8));
      print("Status code: ${response.statusCode}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {

        if (responseData["success"] == true) {
          showSnackBar(
              title: "OTP verified!",
              message: "OTP Verified Successfully.",
              backgroundColor: AppColors.successGreen
          );

          if( isSignup ){//SIGNUP OTP VERIFIED -> SAVE TOKENS & GET PROFILE DATA TO SHOW IN SETUP COMPLETE SCREEN
            saveOtpResponse(responseData);
            storage.write( requireVerificationKey, false );//VERIFICATION DONE, NOT REQUIRED ANY MORE
            getProfileData();
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
      } else if (response.statusCode == 400) {//OTP NOT MATCHED
        showSnackBar(
            title: "Invalid OTP!",
            message: "The entered OTP is incorrect or has expired.",
            backgroundColor: AppColors.errorRed
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // 401 Unauthorized / 403 Forbidden: Often used for invalid OTP or token.
        showSnackBar(
            title: "Invalid OTP!",
            message: "The entered OTP is incorrect or has expired.",
            backgroundColor: AppColors.errorRed
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

  //GET PROFILE DATA USING TOKEN AFTER SIGNUP OTP VERIFIED
  getProfileData() async{

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.getProfile );

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${storage.read( accessTokenKey )}",
      };

      http.Response response = await http.get( uri, headers: headers );
      print("Get profile Status codeeeeee: ${response.statusCode}");
      print("Get profile response: ${response.body}");
      if( response.statusCode == 200 ){//FETCHED PROFILE DATA
        BusinessProfileModel model = BusinessProfileModel.fromJson( jsonDecode( response.body ) );
        print("This lineeeeeeeeeeeeeeeeeeeee");
        //SAVE PROFILE DATA IN STORAGE
        storage.write( businessProfileModelKey, model.toJson() );
        print("Thennnnnnnnnnnnnnnnn");
        //GO TO SETUP COMPLETE SCREEN AND FETCH PROFILE DATA THERE
        Get.offAllNamed(AppRoutes.setupComplete);
      }else if( response.statusCode == 401 ){//ACCESS TOKEN INVALID
        showSnackBar(
            title: "Session Expired!",
            message: "Please try again.",
            backgroundColor: AppColors.errorRed
        );
      }
    }catch(e){
      print("Get profile Errrorrrrrrrrrr: ${e}");
      showSnackBar(
          title: "Error!",
          message: "Something went wrong. Please try again",
          backgroundColor: AppColors.errorRed
      );
    }finally{
      print("Inside finallyyyyyyyyyyy");
      if( Get.isDialogOpen! ){
        Get.back();
      }
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

    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.otpResendSignup );
      Map<String, String> payLoad = {
        "email": email
      };
      http.Response response = await http.post( uri, body: payLoad );

      if( response.statusCode == 200 ){
        showSnackBar(
            title: "Sent again",
            message: "OTP sent again in your email.",
            backgroundColor: AppColors.successGreen
        );
      }else if( response.statusCode == 400 ){
        showSnackBar(
            title: "OTP already sent",
            message:  "Please wait before requesting a new one.",
            backgroundColor: AppColors.warningYellow
        );
      }else{
        showSnackBar(
            title: "Error occurred!",
            message: "Something went wrong. Please try again.",
            backgroundColor: AppColors.errorRed
        );
      }
    }catch(e){
      showSnackBar(
          title: "Error occurred!",
          message: "Something went wrong. Please try again.",
          backgroundColor: AppColors.errorRed
      );
    }


  }

  //SUBMIT OTP FOR FORGOT PASSWORD VERIFICATION
  void submitForgotPasswordOtp() async {
    // 1. Input Validation
    if (!isOtpValid.value) {
      Get.snackbar("Error", "Please enter the complete PIN");
      return;
    }

    // 2. Setup Request
    Uri uri = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.otpVerifyForgotPassword );
    String token = storage.read( forgotPasswordTokenKey );

    Map<String, dynamic> payLoad = {
      "token": token,
      "otp": otpController.text.trim(),
    };

    try {
      // 3. Send Request
      final response = await http.post(uri, body: payLoad).timeout(const Duration(seconds: 8));
      print("Status code: ${response.statusCode}");
      print("Forgot Password otp submit Response: ${response.body}");

      if ( response.statusCode == 200 ) {//OTP VERIFIED -> GO TO RESET PASSWORD
        final responseData = jsonDecode(response.body);
        if (responseData["success"] == true) {
          showSnackBar(
              title: "Success!",
              message: "OTP Verified Successfully.",
              backgroundColor: AppColors.successGreen
          );
          String resetPasswordToken = responseData['data']['resetPasswordToken'];
          Get.toNamed( AppRoutes.resetPassword, arguments: resetPasswordToken );
          return;
        } else {
          Get.snackbar(
            "Verification failed!",
            "OTP verification failed.",
          );
        }
      } else if (response.statusCode == 400) {
        showSnackBar(
            title: "Invalid OTP!",
            message: "The entered OTP is incorrect or has expired.",
            backgroundColor: AppColors.errorRed
        );
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        showSnackBar(
            title: "Verification Failed!",
            message: "The entered OTP is incorrect or has expired.",
            backgroundColor: AppColors.errorRed
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

  //RESEND FORGOT PASSWORD OTP
  void resendForgotPasswordOTP() async{
    String token = storage.read( forgotPasswordTokenKey );
    if( token.isEmpty ){
      return;
    }
    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.otpResendForgotPassword );
      Map<String, dynamic> payLoad = {
        "token": token
      };
      http.Response response = await http.post( uri, body: payLoad );
      print("Resend Forgot OTP status: ${response.statusCode}");
      print("Response: ${response.body}");
      if( response.statusCode == 200 ){//OTP SENT AGAIN
        showSnackBar(
            title: "Sent",
            message: "OTP sent again. Please check your spam or junk folder too!",
            backgroundColor: AppColors.successGreen
        );
      }else if( response.statusCode == 400 ){//INVALID TOKEN
        showSnackBar(
            title: "Session Expired!.",
            message: "Please enter your email and try again",
            backgroundColor: AppColors.warningYellow
        );
        Get.toNamed(AppRoutes.forgotPassword);
      } else if( response.statusCode == 404 ){//LAST OTP STILL VALID
        showSnackBar(
            title: "Already Sent!",
            message: "OTP already sent in your email. Request a new otp after 5 minutes.",
            backgroundColor: AppColors.warningYellow
        );
      }
    }catch(e){
      showSnackBar(
          title: "An error occurred!",
          message: "Something went wrong. Please try again later",
          backgroundColor: AppColors.errorRed
      );
    }

  }

  showSnackBar({required String title, required String message, required Color backgroundColor, Color textColor = AppColors.white}) {
    Get.snackbar(
        title,
        message,
        backgroundColor: backgroundColor,
        colorText: textColor
    );
  }


  @override
  void onClose() {

    otpController.dispose();
    super.onClose();
  }

}
