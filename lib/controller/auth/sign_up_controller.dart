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

import '../../core/show_snackbar.dart';
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

  BusinessSignupModel businessSignupModel = BusinessSignupModel();
  final storage = GetStorage();

  void hideLoading() {
    if (Get.isDialogOpen == true) {
      Get.back(closeOverlays: true);
    }
  }

  void hideLoadingDialog() {
    if (Get.isDialogOpen == true) {
      // Close until no dialog with our key exists
      Get.until((route) {
        if (route is GetPageRoute) return true; // ordinary route — stop here
        return true;
      });

      Get.back();
    }
  }



  //VALIDATE INFORMATION OF BUSINESS INFO
  void validateBusinessInfo() async{
    if( nameController.text.trim().isEmpty || taglineController.text.trim().isEmpty || descriptionController.text.trim().isEmpty ){
      showSnackBar(
          title: "Information missing!",
          message: "Please enter the required information.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }
    businessSignupModel.name = nameController.text.trim();
    businessSignupModel.tagline = taglineController.text.trim();
    businessSignupModel.description = descriptionController.text.trim();
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
    //ACCEPT EMPTY WEBSITE
    if( businessWebsiteController.text.trim().isEmpty ){
      return true;
    }
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
    businessSignupModel.businessPhoneNumber = businessPhoneController.text.trim();
    businessSignupModel.businessEmail = businessEmailController.text.trim();
    businessSignupModel.businessWebsite = businessWebsiteController.text.trim();
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
    businessSignupModel.email = emailController.text.trim();
    businessSignupModel.password = passwordController.text.trim();
    Get.toNamed(AppRoutes.uploadLogo);
  }

  //SIGN UP
  Future<void> signup() async {

    try{
      final url = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.signup );
      File? logo = businessSignupModel.logo;

      // Convert model to JSON string (because backend expects "data" as string)
      final jsonString = jsonEncode(businessSignupModel.toJson());

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
      }

      // Send request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var responseData = jsonDecode(responseBody);
      print("Status: ${response.statusCode}");
      print("Body: ${responseBody}");

      //TODO: ERROR DEBUG
      if( logo != null ){
        logImageDetails(logo);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {//ACCOUNT CREATED -> SAVE EMAIL -> GO TO OTP VERIFY
        print("1");
        bool isVerificationRequired = responseData['data']['requiresVerification'] ?? false;
        print("2");
        storage.write( requireVerificationKey, isVerificationRequired );
        print("3");
        storage.write( emailKey, businessSignupModel.email );//saving for verify now(if user skips verification this time)
        print("4");
        Map<String, dynamic> arguments = {
          emailKey : businessSignupModel.email,
          isSignupKey : true
        };
        print("5");
        Get.offAllNamed(AppRoutes.otpVerify, arguments: arguments );
        print("6");
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
    }

  }

  void logImageDetails(File file) async {
    final name = file.path.split('/').last;
    final size = await file.length();
    final ext = file.path.split('.').last;

    print("----- IMAGE INFO -----");
    print("Name: $name");
    print("Extension: $ext");
    print("Size: $size bytes");
    print("Size KB: ${size / 1024}");
    print("Size MB: ${size / (1024 * 1024)}");
    print("Path: ${file.path}");
    print("----------------------");
  }


  //SHOW LOADING ALERT DIALOG
  // showLoadingAlert({String title = "Loading..."}){
  //   if( Get.isDialogOpen ?? false ){
  //     Get.back();
  //   }
  //   Get.dialog(
  //     AlertDialog(
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           CircularProgressIndicator(),
  //           SizedBox(height: 20),
  //           Text( title ),
  //         ],
  //       ),
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

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
