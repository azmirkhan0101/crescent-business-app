import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';

import '../../data/models/profile/business_profile_model.dart';
import '../../utils/app_color.dart';
import '../../utils/app_constants.dart';

class ProfileSettingsController extends GetxController {
  //1. change password
  //2. subscriptions
  //3. logout
  //4. delete account
  //5. notification

  @override
  void onInit() {

    getProfileData();
    super.onInit();
  }


  final storage = GetStorage();
  //LOGO IMAGE URL
  RxString logoImageUrl = "".obs;
  RxString businessName = "".obs;
  RxString businessEmail = "".obs;

  //NOTIFICATION SETTINGS
  bool isPushNotificationEnabled = true;
  bool isDonationUpdatesEnabled = true;
  bool isRewardPerksEnabled = true;

  //REQUIREMENT CHECKBOX CONTROLLER - FOR CHANGE PASSWORD SCREEN
  RxBool isEightCharacters = false.obs;
  RxBool isBothCasesPresent = false.obs;
  RxBool isNumeralPresent = false.obs;
  RxBool isSpecialCharPresent = false.obs;

  void checkRequirements(String value) {
    // 1. Check length
    isEightCharacters.value = value.length >= 8;

    // 2. Check for both Upper and Lower case
    isBothCasesPresent.value =
        value.contains(RegExp(r'[a-z]')) && value.contains(RegExp(r'[A-Z]'));

    // 3. Check for numbers
    isNumeralPresent.value = value.contains(RegExp(r'[0-9]'));

    // 4. Check for special characters
    isSpecialCharPresent.value =
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }


  //GET LOGO IMAGE URL AND USER NAME
  getProfileData(){
    BusinessProfileModel? model = BusinessProfileModel.fromJson(storage.read( businessProfileModelKey ));
    logoImageUrl.value = model.logoImage == null || model.logoImage!.isEmpty
        ? ""
        : "${model.logoImage}";
    businessName.value = model.name;
    businessEmail.value = model.businessEmail;

    isPushNotificationEnabled = storage.read( pushNotificationKey ) ?? true;
    isDonationUpdatesEnabled = storage.read( donationUpdatesKey ) ?? true;
    isRewardPerksEnabled = storage.read( rewardPerksKey ) ?? true;
    }


  //=================CHANGE PASSWORD=======================//
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  //CHECK CURRENT PASSWORD IF VALID OR NOT
  bool isCurrentPasswordValid() {
    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~?%^()_\-+=<>.,;:{}\[\]|/]).{8,}$',
    );
    return regex.hasMatch(currentPassword.text.trim());
  }

  //CHECK NEW PASSWORDS IF VALID OR NOT
  bool isNewPasswordValid() {
    final regex = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~?%^()_\-+=<>.,;:{}\[\]|/]).{8,}$',
    );
    if (regex.hasMatch(newPassword.text.trim())) {
      return newPassword.text.trim() == confirmPassword.text.trim();
    } else {
      return false;
    }
  }

  //CHANGE PASSWORD
  changePassword() async {
    if (!isNewPasswordValid() || !isCurrentPasswordValid()) {
      showSnackBar(
        title: "Password incomplete!",
        message: "Please enter a valid password!",
        backgroundColor: AppColors.errorRed,
      );
      return;
    }

    try {
      Map<String, dynamic> payload = {
        "oldPassword": currentPassword.text.trim(),
        "newPassword": newPassword.text.trim(),
      };

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${storage.read(accessTokenKey)}",
      };

      Uri uri = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.changePassword);

      http.Response response = await http.patch(
        uri,
        body: jsonEncode(payload),
        headers: headers,
      );

      if (response.statusCode == 200) {
        //PASSWORD CHANGED
        //SAVE TOKENS
        saveTokens(jsonDecode(response.body));
        //GO BACK
        Get.back();
        showSnackBar(
          title: "Password Changed!",
          message: "Password has been changed successfully.",
          backgroundColor: AppColors.successGreen,
        );
      } else if (response.statusCode == 401) {
        //CURRENT PASSWORD IS WRONG
        showSnackBar(
          title: "Incorrect password!",
          message: "Current password is wrong.!",
          backgroundColor: AppColors.errorRed,
        );
      } else {
        showSnackBar(
          title: "Error Occurred!",
          message: "Something went wrong. Please try again",
          backgroundColor: AppColors.errorRed,
        );
      }
    } catch (e) {
      showSnackBar(
        title: "No internet!",
        message: "Please check your internet connection and try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //SAVE TOKENS IN STORAGE
  void saveTokens(Map<String, dynamic> response) {
    final accessToken = response["data"]["accessToken"];
    final refreshToken = response["data"]["refreshToken"];

    storage.write(accessTokenKey, accessToken);
    storage.write(refreshTokenKey, refreshToken);
  }

  //LOGOUT
  logOut() async {
    await storage.erase();
    Get.offAllNamed(AppRoutes.logIn);
  }

  //DELETE ACCOUNT
  deleteAccount() async{

    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.deleteAccount );
      Map<String, String> headers = {
        "Authorization" : "Bearer ${storage.read( accessTokenKey )}"
      };

      http.Response response = await http.delete( uri, headers: headers );

      if( response.statusCode == 200 ){
        await storage.erase();
        Get.offAllNamed( AppRoutes.getStarted );
        showSnackBar(
          title: "Account deleted!",
          message: "Your account has been deleted.",
          backgroundColor: AppColors.successGreen,
        );
      }else{
        showSnackBar(
          title: "Error occurred!",
          message: "Something went wrong. Please try again.",
          backgroundColor: AppColors.errorRed,
        );
      }
    }catch(e){
      showSnackBar(
        title: "No internet!",
        message: "Please check your internet connection.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //TOGGLE PUSH NOTIFICATION
togglePushNotification({required bool value}){
    isPushNotificationEnabled = value;
    storage.write( pushNotificationKey, isPushNotificationEnabled );
}

  //TOGGLE PUSH NOTIFICATION
  toggleDonationUpdates({required bool value}){
    isDonationUpdatesEnabled = value;
    storage.write( donationUpdatesKey, isDonationUpdatesEnabled );
  }

  //TOGGLE PUSH NOTIFICATION
  toggleRewardPerks({required bool value}){
    isRewardPerksEnabled = value;
    storage.write( rewardPerksKey, isRewardPerksEnabled );
  }

}
