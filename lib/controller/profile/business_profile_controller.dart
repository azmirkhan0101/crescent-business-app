import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mime/mime.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/core/api_service.dart';
import 'package:organization/data/models/profile/business_profile_model.dart';
import 'package:organization/data/models/reward/reward_model.dart';
import 'package:organization/utils/app_constants.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../../core/show_snackbar.dart';
import '../../utils/api_endpoints.dart';
import '../../utils/app_color.dart';
import '../reward/reward_controller.dart';

class BusinessProfileController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final storage = GetStorage();
  Rxn<BusinessProfileModel> model =
      Rxn<BusinessProfileModel>(); //FOR RETRIEVE FROM STORAGE
  late BusinessProfileModel editProfileModel; //FOR RETRIEVE FROM API
  RxList<String> locationNames = <String>[].obs;

  //BUSINESS DETAILS TO UPDATE - IF EMPTY, UPDATE WITH PREVIOUS DATA
  TextEditingController nameController = TextEditingController();
  TextEditingController taglineController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  //COVER AND LOGO IMAGES - NULLABLE
  Rx<File?> coverImage = Rx<File?>(null);
  Rx<File?> logoImage = Rx<File?>(null);

  //COVER IMAGE URL
  RxString coverImageUrl = "".obs;

  //LOGO IMAGE URL
  RxString logoImageUrl = "".obs;

  //REWARD LIST FOR REWARDS TAB
  final RewardController rewardController = Get.find<RewardController>();
  RxList<RewardModel> rewards = <RewardModel>[].obs;

  @override
  void onInit() {
    getProfileData();
    editProfileModel = BusinessProfileModel.fromJson(
      storage.read(businessProfileModelKey),
    );
    locationNames.value = editProfileModel.locations ?? [];

    ever(rewardController.rewards, (newData) {
      rewards.value = newData;
    });

    super.onInit();
  }

  //RETRIEVE PROFILE DATA FROM STORAGE
  getProfileData() {
    model.value = BusinessProfileModel.fromJson(
      storage.read(businessProfileModelKey),
    );
    final retrievedModel = model.value;
    if (retrievedModel != null) {
      logoImageUrl.value =
          retrievedModel.logoImage == null || retrievedModel.logoImage!.isEmpty
          ? ""
          : "${retrievedModel.logoImage}";
      coverImageUrl.value =
          retrievedModel.coverImage == null ||
              retrievedModel.coverImage!.isEmpty
          ? ""
          : "${retrievedModel.coverImage}";
    }
  }

  //SET MODEL VALUES IN CONTROLLERS FOR EDITING
  setControllerValues() {
    nameController.text = model.value?.name ?? "";
    taglineController.text = model.value?.tagline ?? "";
    descriptionController.text = model.value?.description ?? "";
    websiteController.text = model.value?.businessWebsite ?? "";
    phoneController.text = model.value?.businessPhoneNumber ?? "";
    emailController.text = model.value?.businessEmail ?? "";
  }

  //UPDATE BUSINESS PROFILE
  updateBusinessProfile2() async {
    final Map<String, dynamic> data = {
      "category": editProfileModel.category,
      "name": nameController.text.trim().isEmpty
          ? editProfileModel.name
          : nameController.text.trim(),
      "tagLine": taglineController.text.trim().isEmpty
          ? editProfileModel.tagline
          : taglineController.text.trim(),
      "description": descriptionController.text.trim().isEmpty
          ? editProfileModel.description
          : descriptionController.text.trim(),
      "businessPhoneNumber": phoneController.text.trim().isEmpty
          ? editProfileModel.businessPhoneNumber
          : phoneController.text.trim(),
      "businessEmail": emailController.text.trim().isEmpty
          ? editProfileModel.businessEmail
          : emailController.text.trim(),
      "businessWebsite": websiteController.text.trim().isEmpty
          ? editProfileModel.businessWebsite
          : websiteController.text.trim(),
      "locations": locationNames,
    };

    ApiResponse response = await apiService.multipartRequest(
      method: "PATCH",
      endPoint: ApiEndpoints.updateProfile,
      isAuthRequired: true,
      fields: data,
      coverImage: coverImage.value,
      logoImage: logoImage.value
    );

    if (response.statusCode == 200) {
      //GO BACK TO PROFILE SCREEN
      Get.back();
      showSnackBar(
        title: "Profile updated",
        message: "Your profile has been updated!",
        backgroundColor: AppColors.successGreen,
      );
      //RELOAD UPDATED PROFILE DATA
      getUpdatedProfileData();
    } else {
      showSnackBar(
        title: "Error Occurred",
        message: "Something went wrong. Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  updateBusinessProfile() async{
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
      //request.headers["Accept"] = "application/json";
      // Add text data
      request.fields["data"] = jsonEncode(data);
      // Add optional cover image
      if( coverImage.value != null ){

        final compressedCoverImage = await compressImage( coverImage.value! );
        if( compressedCoverImage != null ){
          final mimeType =
              lookupMimeType(compressedCoverImage.path)?.split('/') ??
                  ['application', 'octet-stream'];

          request.files.add(
              await http.MultipartFile.fromPath(
                "coverImage",
                compressedCoverImage.path,
                contentType: http.MediaType(
                  mimeType[0],
                  mimeType[1],
                ),
              )
          );
        }

        // Add optional logo image
        if( logoImage.value != null ){
          final compressedLogoImage = await compressImage( logoImage.value! );
          if( compressedLogoImage != null ) {
            final mimeType =
                lookupMimeType(compressedLogoImage.path)?.split('/') ??
                    ['application', 'octet-stream'];

            request.files.add(
                await http.MultipartFile.fromPath(
                  "logoImage",
                  compressedLogoImage.path,
                  contentType: http.MediaType(
                    mimeType[0],
                    mimeType[1],
                  ),
                )
            );
          }
        }
      }
      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if( response.statusCode == 200 ){
        //GO BACK TO PROFILE SCREEN
        Get.back();
        showSnackBar(title: "Profile updated", message: "Your profile has been updated!", backgroundColor: AppColors.successGreen);
        //RELOAD UPDATED PROFILE DATA
        getUpdatedProfileData();
      }else{
        showSnackBar(title: "Error Occurred", message: "Something went wrong. Please try again.", backgroundColor: AppColors.errorRed);
      }
    } catch (e) {
      showSnackBar(title: "No internet", message: "Please check your internet connection and try again.", backgroundColor: AppColors.warningYellow);
    }

  }

  //GET PROFILE DATA USING TOKEN AFTER PROFILE UPDATED
  getUpdatedProfileData() async {
    model.value = null; //NULL WHILE DATA IS LOADING

    ApiResponse response = await apiService.networkRequest(
      method: 'GET',
      isAuthRequired: true,
      endPoint: ApiEndpoints.getProfile,
    );

    if (response.statusCode == 200) {
      //FETCHED PROFILE DATA
      BusinessProfileModel model = BusinessProfileModel.fromJson(
        response.data['data'],
      );
      //SAVE PROFILE DATA IN STORAGE
      storage.write(businessProfileModelKey, model.toJson());
      //RETRIEVE PROFILE DATA FROM STORAGE NOW TO SHOW IN PROFILE SCREEN
      getProfileData();
    } else if (response.statusCode == 401) {
      //ACCESS TOKEN INVALID
      showSnackBar(
        title: "Session Expired!",
        message: "Please try again.",
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

  //COMPRESS IMAGE
  Future<File?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,// 0 - 100
      format: CompressFormat.jpeg,
    );

    return result != null ? File(result.path) : null;
  }

}
