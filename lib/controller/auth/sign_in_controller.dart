import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:organization/data/models/business_model/business_model.dart';
import 'package:organization/routes/app_pages.dart';

import '../../utils/app_color.dart';

class SignInController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController taglineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  BusinessModel businessModel = BusinessModel();

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

  bool get isValid =>
      emailController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty;

  void signIn(BuildContext context) {
    if (!isValid) {
      Get.snackbar(
        "Error",
        "Please enter both email and password",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    Get.toNamed(AppRoutes.mainNav);
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
