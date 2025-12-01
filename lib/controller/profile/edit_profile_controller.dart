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
  Rx<File?> coverImage = Rx<File?>(null);
  Rx<File?> logoImage = Rx<File?>(null);

  @override
  void onInit() {

    var profileData = storage.read( businessProfileModelKey );
    model = BusinessProfileModel.fromJson( profileData );
    locationNames.value = model.locations ?? [];

    super.onInit();
  }

  //UPDATE BUSINESS PROFILE
  updateBusinessProfile() async{
    //showLoadingAlert( title: "Updating..." );
    final Map<String, dynamic> data = {
      "category": model.category,//CATEGORY UNCHANGED
      "name": nameController.text.trim().isEmpty ? model.name : nameController.text.trim(),
      "tagLine": taglineController.text.trim().isEmpty ? model.tagline : taglineController.text.trim(),
      "description": descriptionController.text.trim().isEmpty ? model.description : descriptionController.text.trim(),
      "businessPhoneNumber": phoneController.text.trim().isEmpty ? model.businessPhoneNumber : phoneController.text.trim(),
      "businessEmail": emailController.text.trim().isEmpty ? model.businessEmail : emailController.text.trim(),
      "businessWebsite": websiteController.text.trim().isEmpty ? model.businessWebsite : websiteController.text.trim(),
      "locations": locationNames
    };

    try {
      print("first");
      final url = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.updateProfile );
      print("second");
      var request = http.MultipartRequest("PATCH", url );
      print("third");
      request.headers["Authorization"] = "Bearer ${storage.read( accessTokenKey )}";
      print("fourth");
      request.headers["Accept"] = "application/json";
      print("fifth");
      // Add text data
      request.fields["data"] = jsonEncode(data);
      print("sixth");
      // Add optional cover image
      if( coverImage.value != null ){
        request.files.add(
          await http.MultipartFile.fromPath(
            "coverImage",
            coverImage.value!.path,
          ),
        );
      }
      print("seven");

      // Add optional logo image
      if( logoImage.value != null ){
        request.files.add(
          await http.MultipartFile.fromPath(
            "logoImage",
            logoImage.value!.path,
          ),
        );
      }
      print("eight");
      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      //closeDialog();
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
      //closeDialog();
    }

    print("Dattaaaaaa: ${data}");
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