import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:organization/data/models/business_model/business_model.dart';
import 'package:organization/routes/app_pages.dart';

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
  final TextEditingController locationSearchController = TextEditingController();

  BusinessModel businessModel = BusinessModel();

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
      if( !validatePhoneNumber() ) print("Phone errrrrrrrrrrrrr");
      if( !validateBusinessEmail() ) print("Email errrrrrrrrrrrrr");
      if( !validateWebsite() ) print("Website errrrrrrrrrrrrr");
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
    Get.toNamed(AppRoutes.uploadLogo);
  }
  void signUp() {

  }

  Future<void> signupBusiness({
    required String role,
    required String name,
    required String category,
    required String tagLine,
    required String description,
    required String businessPhoneNumber,
    required String businessEmail,
    required String businessWebsite,
    required List<String> locations,
    File? businessImage,
  }) async {
    final url = Uri.parse("http://10.10.20.42:5000/api/v1/auth/create-Profile");

    var request = http.MultipartRequest("POST", url);

    // ---------- TEXT FIELDS ----------
    request.fields["role"] = role;
    request.fields["name"] = name;
    request.fields["category"] = category;
    request.fields["tagLine"] = tagLine;
    request.fields["description"] = description;
    request.fields["businessPhoneNumber"] = businessPhoneNumber;
    request.fields["businessEmail"] = businessEmail;
    request.fields["businessWebsite"] = businessWebsite;

    // ---------- LIST<String> AS JSON ----------
    request.fields["locations"] = jsonEncode(locations);
    // example: ["Banani","Uttara"]

    // ---------- OPTIONAL IMAGE ----------
    if (businessImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'logo', // field name from backend
          businessImage.path,
        ),
      );
    }
    // ---------- SEND REQUEST ----------
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Status: ${response.statusCode}");
    print("Response: ${response.body}");
  }

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
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}
