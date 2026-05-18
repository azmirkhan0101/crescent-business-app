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
import '../../core/subscription_service.dart';
import '../../utils/app_color.dart';

class OtpVerificationController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final TextEditingController otpController = TextEditingController();
  var isOtpValid = false.obs;
  final storage = GetStorage();
  RxBool isOtpVerifying = false.obs;
  late String email;
  late bool isSignup;

  void onOtpChanged(String val) {
    isOtpValid.value = val.trim().length == 6;
  }

  void submitSignupOtp() async {
    if (isOtpVerifying.value) return;
    if (!isOtpValid.value) {
      Get.snackbar("Error", "Please enter the complete PIN");
      return;
    }

    isOtpVerifying.value = true;
    Map<String, dynamic> payLoad = {"email": email, "otp": otpController.text.trim()};

    ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: false,
      endPoint: ApiEndpoints.otpSignup,
      body: payLoad,
    );
    final responseData = response.data;

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (responseData["success"] == true) {
        showSnackBar(title: "OTP verified!", message: "OTP Verified Successfully.", backgroundColor: AppColors.successGreen);

        if (isSignup) {
          saveOtpResponse(responseData);
          updateFcmToken();
        } else {
          isOtpVerifying.value = false;
          Get.offAndToNamed(AppRoutes.resetPassword);
        }
      } else {
        isOtpVerifying.value = false;
        showSnackBar(title: "Verification failed!", message: "OTP verification failed.", backgroundColor: AppColors.errorRed);
      }
    } else if (response.statusCode == 400 || response.statusCode == 401 || response.statusCode == 403) {
      isOtpVerifying.value = false;
      showSnackBar(title: "Invalid OTP!", message: "The entered OTP is incorrect or has expired.", backgroundColor: AppColors.errorRed);
    } else {
      isOtpVerifying.value = false;
      showSnackBar(title: "Error!", message: "An error occurred. Please try again.", backgroundColor: AppColors.errorRed);
    }
  }

  updateFcmToken() async {
    String deviceType = Platform.isAndroid ? 'android' : 'ios';

    String? token;
    if( Platform.isIOS ){
      String? apnsToken;
      for( int i = 0; i < 5; i++ ){
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if( apnsToken != null ){
          break;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    try{
      token = await FirebaseMessaging.instance.getToken();
    }catch(e){}

    print("FCM token: $token");

    final payLoad = {"fcmToken": token, "deviceType": deviceType};

    await apiService.networkRequest(
      method: 'PATCH',
      isAuthRequired: true,
      endPoint: ApiEndpoints.updateFcmToken,
      body: payLoad,
    );

    getProfileData();
  }

  getProfileData() async {
    ApiResponse response = await apiService.networkRequest(
      method: 'GET',
      isAuthRequired: true,
      endPoint: ApiEndpoints.getProfile,
    );
    isOtpVerifying.value = false;

    if (response.statusCode == 200) {
      storage.write(requireVerificationKey, false);
      BusinessProfileModel model = BusinessProfileModel.fromJson(response.data['data']);

      storage.write(businessProfileModelKey, model.toJson());
      storage.write(businessIdKey, model.businessId);
      storage.write(businessAuthIdKey, model.businessAuthId);
      storage.write(subscriptionExpiryDateKey, model.subscriptionExpiryDate);

      bool isSubscribed = model.isSubscribed ?? false;
      storage.write(subscriptionKey, isSubscribed);

      // Important: Link RevenueCat identity to new backend user
      if (model.businessAuthId != null) {
        await SubscriptionService.to.loginUser(model.businessAuthId);
      }
      await SubscriptionService.to.checkPremiumStatus();

      if (SubscriptionService.to.hasPremium) {
        Get.offAllNamed(AppRoutes.setupComplete);
      } else {
        Get.offAllNamed(AppRoutes.paywallScreen);
      }
    } else if (response.statusCode == 401) {
      showSnackBar(title: "Session Expired!", message: "Please try again.", backgroundColor: AppColors.errorRed);
    } else if (response.statusCode == 404) {
      showSnackBar(title: "Organisation not found!", message: "Try creating an account again.", backgroundColor: AppColors.errorRed);
    } else {
      showSnackBar(title: "Error!", message: "Something went wrong. Please try again", backgroundColor: AppColors.errorRed);
    }
  }

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