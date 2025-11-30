import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/data/models/business_profile_model.dart';
import 'package:organization/utils/app_constants.dart';

import '../../data/models/business_signup_model.dart';
import '../../utils/api_endpoints.dart';
import '../../utils/app_color.dart';

class EditProfileController extends GetxController{

  late BusinessProfileModel model;
  final storage = GetStorage();
  RxList<String> locationNames = <String>[].obs;

  //BUSINESS DETAILS TO UPDATE - IF EMPTY, UPDATE WITH PREVIOUS DATA
  final TextEditingController nameController = TextEditingController();
  final TextEditingController taglineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  //COVER AND LOGO IMAGES - NULLABLE
  File? coverImage;
  File? logoImage;

  @override
  void onInit() {

    var profileData = storage.read( businessProfileModelKey );
    model = BusinessProfileModel.fromJson( profileData );
    locationNames.value = model.locations ?? [];

    super.onInit();
  }

  //UPDATE BUSINESS PROFILE
  updateBusinessProfile() async{
    showLoadingAlert( title: "Updating..." );
    final Map<String, dynamic> data = {
      "category": model.category ?? "",//CATEGORY UNCHANGED
      "name": nameController.text.trim().isEmpty ? model.name : nameController.text.trim(),
      "tagLine": taglineController.text.trim().isEmpty ? model.tagline : taglineController.text.trim(),
      "description": descriptionController.text.trim().isEmpty ? model.description : descriptionController.text.trim(),
      "businessPhoneNumber": phoneController.text.trim().isEmpty ? model.businessPhoneNumber : phoneController.text.trim(),
      "businessEmail": emailController.text.trim().isEmpty ? model.businessEmail : emailController.text.trim(),
      "businessWebsite": websiteController.text.trim().isEmpty ? model.businessWebsite : websiteController.text.trim(),
      "locations": locationNames
    };

    try {
      final url = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.updateProfile );
      var request = http.MultipartRequest("PATCH", url );

      request.headers["Authorization"] = "Bearer ${storage.read( accessTokenKey )}";
      request.headers["Accept"] = "application/json";
      // Add text data
      request.fields["data"] = jsonEncode(data);

      // Add optional cover image
      if (coverImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "coverImage",
            coverImage!.path,
          ),
        );
      }

      // Add optional logo image
      if (logoImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "logoImage",
            logoImage!.path,
          ),
        );
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      closeDialog();
      print("Update profile status code: ${response.statusCode}");
      if( response.statusCode == 200 ){
        print("Updated!!!!!!!!!");
        String result = response.body;
        print(result);
        Get.back();
      }else{
        print("Failed!!!!!!!!!");
        String result = response.body;
        print(result);
      }
    } catch (e) {
      print("Update error: $e");
      closeDialog();
    }

    print("Dattaaaaaa: ${data}");
  }


  //UPDATE PROFILE
  // Future<void> updateProfile() async {
  //   //TODO: GET TEXT FIELDS , GET IMAGE FILES, VALIDATE, UPDATE
  //
  //   showLoadingAlert( title: "Updating..." );
  //   try{
  //
  //     File? logo = businessModel.logo;
  //
  //     // Convert model to JSON string (because backend expects "data" as string)
  //     final jsonString = jsonEncode(businessModel.toJson());
  //
  //     // Create multipart request
  //     var request = http.MultipartRequest("POST", url);
  //
  //     // Add data field (this is a text field in form-data)
  //     request.fields["data"] = jsonString;
  //
  //     // Add profileImage (optional)
  //     if (logo != null) {
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //           "logoImage",
  //           logo.path,
  //         ),
  //       );
  //     } else {
  //       //If backend allows sending null (most do), send empty field
  //       //TODO: PASS NULL, NOT EMPTY STRING!!!!!!!!!!!!!!!!!!!!!!!!!!
  //       request.fields["logoImage"] = "";
  //     }
  //
  //     // Send request
  //     var response = await request.send();
  //     var responseBody = await response.stream.bytesToString();
  //     var responseData = jsonDecode(responseBody);
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {//ACCOUNT CREATED -> SAVE EMAIL -> GO TO OTP VERIFY
  //       bool isVerificationRequired = responseData['data']['requiresVerification'] ?? false;
  //       storage.write( requireVerificationKey, isVerificationRequired );
  //       storage.write( emailKey, businessModel.email );//saving for verify now(if user skips verification this time)
  //       Map<String, dynamic> arguments = {
  //         emailKey : businessModel.email,
  //         isSignupKey : true
  //       };
  //       closeDialog();
  //       Get.offAllNamed(AppRoutes.otpVerify, arguments: arguments );
  //     }else if( response.statusCode == 400 ){//USER ALREADY EXISTS
  //       showSnackBar(
  //           title: "User Exists!",
  //           message: responseData["message"] ?? "User already exist with this email. Try login instead",
  //           backgroundColor: AppColors.warningYellow
  //       );
  //     } else {
  //       showSnackBar(
  //           title: "Error occurred!",
  //           message: responseData["message"] ?? "Something went wrong. Please try again.",
  //           backgroundColor: AppColors.errorRed
  //       );
  //     }
  //   }catch(e){
  //     print("Signup catch :${e}");
  //     showSnackBar(
  //         title: "Error occurred!",
  //         message: "Something went wrong. Please try again.",
  //         backgroundColor: AppColors.errorRed
  //     );
  //   }finally{
  //     closeDialog();
  //   }
  //
  // }

  //SHOW LOADING ALERT DIALOG
  showLoadingAlert({String title = "Loading..."}){
    if( Get.isDialogOpen ?? false ){
      Get.back();
    }
    Get.dialog(
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

  //CLOSE ALERT DIALOG
  closeDialog(){
    if( Get.isDialogOpen ?? false ){
      Get.back();
    }
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
}