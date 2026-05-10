import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/core/api_service.dart';
import 'package:organization/data/models/profile/business_profile_model.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_constants.dart';

import '../../core/show_snackbar.dart';
import '../../services/firebase_notification_service.dart';
import '../../utils/app_color.dart';

class OtpVerificationController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final TextEditingController otpController = TextEditingController();
  var isOtpValid = false.obs;
  final storage = GetStorage();
  RxBool isOtpVerifying = false.obs;
  late String email;
  late bool
  isSignup; //CHECKS IF SIGNUP VERIFICATION OR FORGOT PASSWORD VERIFICATION

  void onOtpChanged(String val) {
    isOtpValid.value = val.trim().length == 6;
  }

  //SUBMIT OTP FOR SIGNUP EMAIL VERIFICATION
  void submitSignupOtp() async {
    if (isOtpVerifying.value) {
      return;
    }

    if (!isOtpValid.value) {
      Get.snackbar("Error", "Please enter the complete PIN");
      return;
    }

    isOtpVerifying.value = true;
    Map<String, dynamic> payLoad = {
      "email": email,
      "otp": otpController.text.trim(),
    };
    ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: false,
      endPoint: ApiEndpoints.otpSignup,
      body: payLoad,
    );
    final responseData = response.data;

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (responseData["success"] == true) {
        showSnackBar(
          title: "OTP verified!",
          message: "OTP Verified Successfully.",
          backgroundColor: AppColors.successGreen,
        );

        if (isSignup) {
          //SIGNUP OTP VERIFIED -> SAVE TOKENS & GET PROFILE DATA TO SHOW IN SETUP COMPLETE SCREEN
          saveOtpResponse(responseData);
          updateFcmToken();
        } else {
          isOtpVerifying.value = false;
          Get.offAndToNamed(AppRoutes.resetPassword);
        }
      } else {
        isOtpVerifying.value = false;
        showSnackBar(
          title: "Verification failed!",
          message: "OTP verification failed.",
          backgroundColor: AppColors.errorRed,
        );
      }
    } else if (response.statusCode == 400) {
      isOtpVerifying.value = false;
      //OTP NOT MATCHED
      showSnackBar(
        title: "Invalid OTP!",
        message: "The entered OTP is incorrect or has expired.",
        backgroundColor: AppColors.errorRed,
      );
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      isOtpVerifying.value = false;
      showSnackBar(
        title: "Invalid OTP!",
        message: "The entered OTP is incorrect or has expired.",
        backgroundColor: AppColors.errorRed,
      );
    } else {
      isOtpVerifying.value = false;
      showSnackBar(
        title: "Error!",
        message: "An error occurred. Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //UPDATE FCM TOKEN
  updateFcmToken() async {
    String deviceType = "android";

    late String? token;
    // Detect the device type
    if (Platform.isAndroid) {
      deviceType = 'android';
      token = await FirebaseMessaging.instance.getToken();
    } else {
      deviceType = 'ios';
      token = await FirebaseMessaging.instance.getAPNSToken();
    }

    final payLoad = {"fcmToken": token, "deviceType": deviceType};

    ApiResponse response = await apiService.networkRequest(
      method: 'PATCH',
      isAuthRequired: true,
      endPoint: ApiEndpoints.updateFcmToken,
      body: payLoad,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      //GET PROFILE AND GO TO MAIN -> HOME
      getProfileData();
    } else {
      isOtpVerifying.value = false;
      storage.erase();
      showSnackBar(
        title: "Something went wrong!",
        message: "Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //GET PROFILE DATA USING TOKEN AFTER SIGNUP OTP VERIFIED
  getProfileData() async {
    ApiResponse response = await apiService.networkRequest(
      method: 'GET',
      isAuthRequired: true,
      endPoint: ApiEndpoints.getProfile,
    );
    isOtpVerifying.value = false;
    if (response.statusCode == 200) {
      storage.write(
        requireVerificationKey,
        false,
      ); //VERIFICATION DONE, NOT REQUIRED ANY MORE
      //FETCHED PROFILE DATA
      BusinessProfileModel model = BusinessProfileModel.fromJson(
        response.data['data'],
      );
      //SAVE PROFILE DATA IN STORAGE
      storage.write(businessProfileModelKey, model.toJson());
      storage.write(
        businessIdKey,
        model.businessId,
      ); //SAVING ID SEPARATELY FOR RETRIEVING EASILY, ALSO AVAILABLE IN MODEL
      storage.write(
        businessAuthIdKey,
        model.businessAuthId,
      ); //SAVING AUTH ID SEPARATELY FOR RETRIEVING EASILY, ALSO AVAILABLE IN MODEL
      storage.write(subscriptionExpiryDateKey, model.subscriptionExpiryDate);
      //GO TO SETUP COMPLETE SCREEN AND FETCH PROFILE DATA THERE
      //SAVE SUBSCRIPTION IN STORAGE - IF SUBSCRIBED - GO HOME - ELSE GO TO SUBSCRIPTION SCREEN
      bool isSubscribed = model.isSubscribed ?? false;

      storage.write(subscriptionKey, isSubscribed);
      if (isSubscribed) {
        Get.offAllNamed(AppRoutes.setupComplete);
      } else {
        bool isAndroid = Platform.isAndroid;
        if( isAndroid ){
          Get.offAllNamed(AppRoutes.androidSubscription);
        }else{
          Get.offAllNamed(AppRoutes.iosSubscription);
        }
      }
    } else if (response.statusCode == 401) {
      //ACCESS TOKEN INVALID
      showSnackBar(
        title: "Session Expired!",
        message: "Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    } else if (response.statusCode == 404) {
      //ACCESS TOKEN INVALID
      showSnackBar(
        title: "Organisation not found!",
        message: "Try creating an account again.",
        backgroundColor: AppColors.errorRed,
      );
    } else {
      showSnackBar(
        title: "Error!",
        message: "Something went wrong. Please try again",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //SAVE TOKENS IN STORAGE
  void saveOtpResponse(Map<String, dynamic> response) {
    final accessToken = response["data"]["accessToken"];
    final refreshToken = response["data"]["refreshToken"];

    storage.write(accessTokenKey, accessToken);
    storage.write(refreshTokenKey, refreshToken);
  }

  //RESEND SIGNUP OTP
  void resendSignupOtp() async {
    Map<String, String> payLoad = {"email": email};
    ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: false,
      endPoint: ApiEndpoints.otpResendSignup,
      body: payLoad,
    );

    if (response.statusCode == 200) {
      showSnackBar(
        title: "Sent again",
        message: "OTP sent again in your email.",
        backgroundColor: AppColors.successGreen,
      );
    } else if (response.statusCode == 400) {
      showSnackBar(
        title: "OTP already sent",
        message: "Please wait before requesting a new one.",
        backgroundColor: AppColors.warningYellow,
      );
    } else {
      showSnackBar(
        title: "Error occurred!",
        message: "Something went wrong. Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //SUBMIT OTP FOR FORGOT PASSWORD VERIFICATION
  void submitForgotPasswordOtp() async {
    if (!isOtpValid.value) {
      Get.snackbar("Error", "Please enter the complete PIN");
      return;
    }

    String token = storage.read(forgotPasswordTokenKey);

    Map<String, dynamic> payLoad = {
      "token": token,
      "otp": otpController.text.trim(),
    };

    ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: false,
      endPoint: ApiEndpoints.otpVerifyForgotPassword,
      body: payLoad,
    );

    if (response.statusCode == 200) {
      //OTP VERIFIED -> GO TO RESET PASSWORD
      final responseData = response.data;
      if (responseData["success"] == true) {
        showSnackBar(
          title: "Success!",
          message: "OTP Verified Successfully.",
          backgroundColor: AppColors.successGreen,
        );
        String resetPasswordToken = responseData['data']['resetPasswordToken'];
        //closeDialog();
        Get.toNamed(AppRoutes.resetPassword, arguments: resetPasswordToken);
        return;
      } else {
        Get.snackbar("Verification failed!", "OTP verification failed.");
      }
    } else if (response.statusCode == 400 ||
        response.statusCode == 401 ||
        response.statusCode == 403) {
      showSnackBar(
        title: "Invalid OTP!",
        message: "The entered OTP is incorrect or has expired.",
        backgroundColor: AppColors.errorRed,
      );
    } else {
      Get.snackbar("Error!", "An unexpected error occurred. Please try again.");
    }
  }

  //RESEND FORGOT PASSWORD OTP
  void resendForgotPasswordOTP() async {
    String token = storage.read(forgotPasswordTokenKey);
    if (token.isEmpty) {
      return;
    }

    Map<String, dynamic> payLoad = {"token": token};

    ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: false,
      endPoint: ApiEndpoints.otpResendForgotPassword,
      body: payLoad,
    );

    if (response.statusCode == 200) {
      //OTP SENT AGAIN
      showSnackBar(
        title: "Sent",
        message: "OTP sent again. Please check your spam or junk folder too!",
        backgroundColor: AppColors.successGreen,
      );
    } else if (response.statusCode == 400) {
      //INVALID TOKEN
      showSnackBar(
        title: "Session Expired!.",
        message: "Please enter your email and try again",
        backgroundColor: AppColors.warningYellow,
      );
      Get.toNamed(AppRoutes.forgotPassword);
    } else if (response.statusCode == 404) {
      //LAST OTP STILL VALID
      showSnackBar(
        title: "Already Sent!",
        message:
            "OTP already sent in your email. Request a new otp after 5 minutes.",
        backgroundColor: AppColors.warningYellow,
      );
    } else {
      showSnackBar(
        title: "An error occurred!",
        message: "Something went wrong. Please try again later",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
