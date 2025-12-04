import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/data/models/business_profile_model.dart';
import 'package:organization/utils/app_constants.dart';

import '../../routes/app_pages.dart';
import '../../utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

import '../../utils/app_color.dart';

class BusinessProfileController extends GetxController{

  final storage = GetStorage();
  Rxn<BusinessProfileModel> model = Rxn<BusinessProfileModel>();//FOR RETRIEVE FROM STORAGE
  late BusinessProfileModel editProfileModel;//FOR RETRIEVE FROM API
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
    model.value = BusinessProfileModel.fromJson( profileData );
    editProfileModel = BusinessProfileModel.fromJson( profileData );
    locationNames.value = editProfileModel.locations ?? [];

    super.onInit();
  }

  //UPDATE BUSINESS PROFILE
  updateBusinessProfile() async{
    //showLoadingAlert( title: "Updating..." );
    final Map<String, dynamic> data = {
      "category": editProfileModel.category,//CATEGORY UNCHANGED
      "name": nameController.text.trim().isEmpty ? editProfileModel.name : nameController.text.trim(),
      "tagLine": taglineController.text.trim().isEmpty ? editProfileModel.tagline : taglineController.text.trim(),
      "description": descriptionController.text.trim().isEmpty ? editProfileModel.description : descriptionController.text.trim(),
      "businessPhoneNumber": phoneController.text.trim().isEmpty ? editProfileModel.businessPhoneNumber : phoneController.text.trim(),
      "businessEmail": emailController.text.trim().isEmpty ? editProfileModel.businessEmail : emailController.text.trim(),
      "businessWebsite": websiteController.text.trim().isEmpty ? editProfileModel.businessWebsite : websiteController.text.trim(),
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
      if( coverImage.value != null ){
        request.files.add(
          await http.MultipartFile.fromPath(
            "coverImage",
            coverImage.value!.path,
          ),
        );
      }

      // Add optional logo image
      if( logoImage.value != null ){
        request.files.add(
          await http.MultipartFile.fromPath(
            "logoImage",
            logoImage.value!.path,
          ),
        );
      }
      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      //closeDialog();
      print("Update profile status code: ${response.statusCode}");
      if( response.statusCode == 200 ){
        print("Updated!!!!!!!!!");
        String result = response.body;
        print(result);
        //GO BACK TO PROFILE SCREEN
        Get.back();
        //RELOAD UPDATED PROFILE DATA
        getUpdatedProfileData();
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

  //GET PROFILE DATA USING TOKEN AFTER PROFILE UPDATED
  getUpdatedProfileData() async{

    model.value = null;//NULL WHILE DATA IS LOADING
    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.getProfile );

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${storage.read( accessTokenKey )}",
      };

      http.Response response = await http.get( uri, headers: headers );
      if( response.statusCode == 200 ){//FETCHED PROFILE DATA
        BusinessProfileModel model = BusinessProfileModel.fromJson( jsonDecode( response.body )['data'] );
        //SAVE PROFILE DATA IN STORAGE
        storage.write( businessProfileModelKey, model.toJson() );
        //RETRIEVE PROFILE DATA FROM STORAGE NOW TO SHOW IN PROFILE SCREEN
        readUpdatedProfileData();
      }else if( response.statusCode == 401 ){//ACCESS TOKEN INVALID
        showSnackBar(
            title: "Session Expired!",
            message: "Please try again.",
            backgroundColor: AppColors.errorRed
        );
      }
    }catch(e){
      showSnackBar(
          title: "Error!",
          message: "Something went wrong. Please try again",
          backgroundColor: AppColors.errorRed
      );
    }finally{
      //closeDialog();
    }
  }

  //READ UPDATED PROFILE DATA FROM STORAGE
  readUpdatedProfileData(){
    var profileData = storage.read( businessProfileModelKey );
    model.value = BusinessProfileModel.fromJson( profileData );
  }

  //SHOW SNACKBAR
  showSnackBar({required String title, required String message, required Color backgroundColor, Color textColor = AppColors.white}) {
    Get.snackbar(
        title,
        message,
        backgroundColor: backgroundColor,
        colorText: textColor
    );
  }
}