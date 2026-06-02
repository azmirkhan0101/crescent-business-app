import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/controller/auth/otp_verification_controller.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/core/api_service.dart';
import 'package:organization/data/models/signup/business_signup_model.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_constants.dart';

import '../../core/show_snackbar.dart';
import '../../utils/app_color.dart';

class SignUpController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController taglineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController businessPhoneController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController businessWebsiteController =
      TextEditingController();

  BusinessSignupModel businessSignupModel = BusinessSignupModel();
  final storage = GetStorage();
  RxBool isSignupLoading = false.obs;

  //================CHECK SOCIAL AUTH===================
  bool checkSocialAuth(){
    return storage.read( isSocialAuthKey ) ?? false;
  }

  //VALIDATE INFORMATION OF BUSINESS INFO
  void validateBusinessInfo() async {
    if (nameController.text.trim().isEmpty ||
        taglineController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      showSnackBar(
        title: "Information missing!",
        message: "Please enter the required information.",
        backgroundColor: AppColors.errorRed,
      );
      return;
    }
    businessSignupModel.name = nameController.text.trim();
    businessSignupModel.tagline = taglineController.text.trim();
    businessSignupModel.description = descriptionController.text.trim();

    //AUTH FLOW CONTROL IF SOCIAL LOGIN
    //SKIP EMAIL PASS IN ACCOUNT CREATION SCREEN IF SOCIAL AUTH
    bool isSocialAuth = storage.read( isSocialAuthKey ) ?? false;
    if( isSocialAuth ){
      businessSignupModel.email = "";
      businessSignupModel.password = "";
      Get.toNamed(AppRoutes.uploadLogo);
    }else{
      Get.toNamed(AppRoutes.accountCreation);
    }
  }

  //VALIDATE INFORMATION OF ACCOUNT CREATION- EMAIL, PASSWORD
  bool isEmailValid() {
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(emailController.text.trim());
  }

  bool isPasswordValid() {
    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~?%^()_\-+=<>.,;:{}\[\]|/]).{8,}$',
    );
    return regex.hasMatch(passwordController.text.trim());
  }

  //BUSINESS PHONE NUMBER VALIDATION
  bool validatePhoneNumber() {
    //if( businessPhoneController.text.trim().isEmpty ) return true;//bypass if field is empty
    final regex = RegExp(
      r'^\+?1?\d{9,15}$',
    ); // Supports optional country code and 9-15 digits
    return regex.hasMatch(businessPhoneController.text.trim());
  }

  //BUSINESS PHONE NUMBER VALIDATION
  bool validateBusinessEmail() {
    //if( businessEmailController.text.trim().isEmpty ) return true;//bypass if field is empty
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(businessEmailController.text.trim());
  }

  //BUSINESS WEBSITE VALIDATION
  bool isValidWebsiteUrl() {
    //if (businessWebsiteController.text.trim().isEmpty) return false;

    final uri = Uri.tryParse(businessWebsiteController.text.trim());

    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  //VALIDATE ALL BUSINESS CONTACT INFORMATION
  void validateBusinessContactInfo() {
    if (!isValidWebsiteUrl()) {
      showSnackBar(
        title: "Invalid website!",
        message: "Please provide valid business website url.",
        backgroundColor: AppColors.warningYellow,
      );
      return;
    }
    if (!validatePhoneNumber() || !validateBusinessEmail()) {
      showSnackBar(
        title: "Invalid information!",
        message: "Please provide valid business contact information.",
        backgroundColor: AppColors.warningYellow,
      );
      return;
    }
    businessSignupModel.businessPhoneNumber = businessPhoneController.text
        .trim();
    businessSignupModel.businessEmail = businessEmailController.text.trim();
    businessSignupModel.businessWebsite = businessWebsiteController.text.trim();
    Get.toNamed(AppRoutes.storeLocation);
  }

  //ACCOUNT CREATION CONTINUE CLICK -> VALIDATE INFO -> GO TO BUSINESS LOGO SCREEN
  void accountCreationContinue() {
    if (!isEmailValid() || !isPasswordValid()) {
      showSnackBar(
        title: "Invalid Email or Password Format!",
        message:
            "Please ensure your email is valid and your password meets the specified criteria.",
        backgroundColor: AppColors.warningYellow,
      );
      return;
    }
    businessSignupModel.email = emailController.text.trim();
    businessSignupModel.password = passwordController.text.trim();
    Get.toNamed(AppRoutes.uploadLogo);
  }

  //SIGN UP
  Future<void> signup() async {
    if (isSignupLoading.value) {
      return;
    }
    isSignupLoading.value = true;

    File? logo = businessSignupModel.logo;

    ApiResponse response = await apiService.multipartRequest(
      method: "POST",
      endPoint: ApiEndpoints.signup,
      isAuthRequired: false,
      fields: businessSignupModel.toJson(),
      logoImage: logo
    );
    isSignupLoading.value = false;

    var responseData = response.data;

    if (response.statusCode == 200 || response.statusCode == 201) {
      //ACCOUNT CREATED -> SAVE EMAIL -> GO TO OTP VERIFY
      bool isVerificationRequired =
          responseData['data']['requiresVerification'] ?? false;
      storage.write(requireVerificationKey, isVerificationRequired);
      storage.write(
        emailKey,
        businessSignupModel.email,
      ); //saving for verify now(if user skips verification this time)
      Map<String, dynamic> arguments = {
        emailKey: businessSignupModel.email,
        isSignupKey: true,
      };
      Get.offAllNamed(AppRoutes.otpVerify, arguments: arguments);
    } else if (response.statusCode == 400) {
      //USER ALREADY EXISTS
      showSnackBar(
        title: "User Exists!",
        message:
            responseData["message"] ??
            "User already exist with this email. Try login instead",
        backgroundColor: AppColors.warningYellow,
      );
    } else {
      showSnackBar(
        title: "Error occurred!",
        message:
            responseData["message"] ??
            "Something went wrong. Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //===========UPDATE BUSINESS PROFILE ON SOCIAL AUTH============
  Future<void> setupBusinessProfile() async {
    isSignupLoading.value = true;
    ApiResponse response = await apiService.multipartRequest(
        method: "PATCH",
        endPoint: ApiEndpoints.updateProfile,
        isAuthRequired: true,
        fields: businessSignupModel.toJson(),
        logoImage: businessSignupModel.logo,
    );



    if (response.statusCode == 200 || response.statusCode == 201 ) {
      final OtpVerificationController otpController = Get.find<OtpVerificationController>();
      await otpController.updateFcmToken();
    } else {
      showApiSnackBar(statusCode: response.statusCode, data: response.data);
    }
    isSignupLoading.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    businessEmailController.dispose();
    businessPhoneController.dispose();
    businessWebsiteController.dispose();
    nameController.dispose();
    taglineController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
