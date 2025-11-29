import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/data/models/business_signup_model.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_constants.dart';

import '../../utils/app_color.dart';

class SignUpController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController taglineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController businessPhoneController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController businessWebsiteController = TextEditingController();

  BusinessModel businessModel = BusinessModel();
  final storage = GetStorage();

  //VALIDATE INFORMATION OF BUSINESS INFO
  void validateBusinessInfo(){
    if( nameController.text.trim().isEmpty || taglineController.text.trim().isEmpty || descriptionController.text.trim().isEmpty ){
      showSnackBar(
          title: "Information missing!",
          message: "Please enter the required information.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }
    businessModel.name = nameController.text.trim();
    businessModel.tagline = taglineController.text.trim();
    businessModel.description = descriptionController.text.trim();
    Get.toNamed(AppRoutes.accountCreation);
  }

  //VALIDATE INFORMATION OF ACCOUNT CREATION- EMAIL, PASSWORD
  bool isEmailValid() {
    return RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    ).hasMatch(emailController.text.trim());
  }
  bool isPasswordValid() {
    final regex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~?%^()_\-+=<>.,;:{}\[\]|/]).{8,}$'
    );
    return regex.hasMatch(passwordController.text.trim());
  }
  //BUSINESS PHONE NUMBER VALIDATION
  bool validatePhoneNumber() {
    final regex = RegExp(r'^\+?1?\d{9,15}$');  // Supports optional country code and 9-15 digits
    return regex.hasMatch(businessPhoneController.text.trim());
  }
  //BUSINESS PHONE NUMBER VALIDATION
  bool validateBusinessEmail() {
    return RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    ).hasMatch(businessEmailController.text.trim());
  }
  //BUSINESS WEBSITE VALIDATION
  bool validateWebsite() {
    final regex = RegExp(
      r'^(https?:\/\/)?([a-z0-9-]+\.)+[a-z]{2,6}(\S*)$',
      caseSensitive: false,
    );
    return regex.hasMatch(businessWebsiteController.text.trim());
  }
  //VALIDATE ALL BUSINESS CONTACT INFORMATION
  void validateBusinessContactInfo(){
    if( !validatePhoneNumber() || !validateBusinessEmail() || !validateWebsite() ){
      showSnackBar(
          title: "Invalid information!",
          message: "Please provide valid business contact information.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }
    businessModel.businessPhoneNumber = businessPhoneController.text.trim();
    businessModel.businessEmail = businessEmailController.text.trim();
    businessModel.businessWebsite = businessWebsiteController.text.trim();
    Get.toNamed(AppRoutes.storeLocation);
  }


  //ACCOUNT CREATION CONTINUE CLICK -> VALIDATE INFO -> GO TO BUSINESS LOGO SCREEN
  void accountCreationContinue(){
    if( !isEmailValid() || !isPasswordValid() ){
      showSnackBar(
          title: "Invalid Email or Password Format!",
          message: "Please ensure your email is valid and your password meets the specified criteria.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }
    businessModel.email = emailController.text.trim();
    businessModel.password = passwordController.text.trim();
    Get.toNamed(AppRoutes.uploadLogo);
  }

  //SIGN UP
  Future<void> signup() async {

    await showLoadingAlert( title: "Signing up..." );
    try{
      final url = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.signup );
      File? logo = businessModel.logo;

      // Convert model to JSON string (because backend expects "data" as string)
      final jsonString = jsonEncode(businessModel.toJson());
      print("Json Of Model: ${jsonString}");

      // Create multipart request
      var request = http.MultipartRequest("POST", url);

      // Add data field (this is a text field in form-data)
      request.fields["data"] = jsonString;

      // Add profileImage (optional)
      if (logo != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "logoImage",
            logo.path,
          ),
        );
      } else {
        //If backend allows sending null (most do), send empty field
        //TODO: PASS NULL, NOT EMPTY STRING!!!!!!!!!!!!!!!!!!!!!!!!!!
        request.fields["logoImage"] = "";
      }

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var responseData = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {//ACCOUNT CREATED -> SAVE EMAIL -> GO TO OTP VERIFY
        bool isVerificationRequired = responseData['data']['requiresVerification'] ?? false;
        storage.write( requireVerificationKey, isVerificationRequired );
        storage.write( emailKey, businessModel.email );//saving for verify now(if user skips verification this time)
        Map<String, dynamic> arguments = {
          emailKey : businessModel.email,
          isSignupKey : true
        };
        Get.toNamed(AppRoutes.otpVerify, arguments: arguments );
      }else if( response.statusCode == 400 ){//USER ALREADY EXISTS
        showSnackBar(
            title: "User Exists!",
            message: responseData["message"] ?? "User already exist with this email. Try login instead",
            backgroundColor: AppColors.warningYellow
        );
      } else {
        showSnackBar(
            title: "Error occurred!",
            message: responseData["message"] ?? "Something went wrong. Please try again.",
            backgroundColor: AppColors.errorRed
        );
      }
    }catch(e){
      print("Signup catch :${e}");
      showSnackBar(
          title: "Error occurred!",
          message: "Something went wrong. Please try again.",
          backgroundColor: AppColors.errorRed
      );
    }finally{
      if( Get.isDialogOpen ?? false ){
        Get.back();
      }
    }

  }

  //SHOW LOADING ALERT DIALOG
  Future<void> showLoadingAlert({String title = "Loading..."}) async{
    if( Get.isDialogOpen ?? false ){
      Get.back();
    }
    return Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text( title ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  //SNACKBAR
  showSnackBar({required String title, required String message, required Color backgroundColor}){
    Get.snackbar(
        title,
        message,
        backgroundColor: backgroundColor,
        colorText: AppColors.white
    );
  }

  @override
  void onClose() {
    if( emailController != null ) emailController.dispose();
    if( passwordController != null ) passwordController.dispose();
    if( businessEmailController != null ) businessEmailController.dispose();
    if( businessPhoneController != null ) businessPhoneController.dispose();
    if( businessWebsiteController != null ) businessWebsiteController.dispose();
    if( nameController != null ) nameController.dispose();
    if( taglineController != null ) taglineController.dispose();
    if( descriptionController != null ) descriptionController.dispose();

    super.onClose();
  }
}
