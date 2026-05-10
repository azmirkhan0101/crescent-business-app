import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/core/api_service.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/data/models/notification/notification_settings_model.dart';
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

  final ApiService apiService = Get.find<ApiService>();
  final storage = GetStorage();
  NotificationSettingsModel? settingsModel;

  //LOGO IMAGE URL
  RxString logoImageUrl = "".obs;
  RxString businessName = "".obs;
  RxString businessEmail = "".obs;

  //NOTIFICATION SETTINGS
  RxBool isPushNotificationEnabled = true.obs;
  RxBool isDonationUpdatesEnabled = true.obs;
  RxBool isRewardPerksEnabled = true.obs;

  //SWITCH TOGGLE API CALL LOADING CHECK
  RxBool isPushLoading = false.obs;
  RxBool isDonationLoading = false.obs;
  RxBool isRewardPerksLoading = false.obs;

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
    isSpecialCharPresent.value = value.contains(
      RegExp(r'[!@#$%^&*(),.?":{}|<>]'),
    );
  }

  //GET LOGO IMAGE URL AND USER NAME
  getProfileData() {
    BusinessProfileModel? model = BusinessProfileModel.fromJson(
      storage.read(businessProfileModelKey),
    );
    final settings = storage.read(notificationSettingsModelKey);
    if (settings == null) {
      settingsModel = null;
    } else {
      settingsModel = NotificationSettingsModel.fromJson(settings);
    }
    if (settings == null) {
      getNotificationSettings();
    }
    logoImageUrl.value = model.logoImage == null || model.logoImage!.isEmpty
        ? ""
        : "${model.logoImage}";
    businessName.value = model.name;
    businessEmail.value = model.businessEmail;

    isPushNotificationEnabled.value = settingsModel?.pushNotifications ?? true;
    isDonationUpdatesEnabled.value = settingsModel?.donations ?? true;
    isRewardPerksEnabled.value = settingsModel?.rewardsAndPerks ?? true;
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

    Map<String, dynamic> payload = {
      "oldPassword": currentPassword.text.trim(),
      "newPassword": newPassword.text.trim(),
    };

    ApiResponse response = await apiService.networkRequest(
      method: "PATCH",
      isAuthRequired: true,
      endPoint: ApiEndpoints.changePassword,
      body: payload,
    );

    if (response.statusCode == 200) {
      //PASSWORD CHANGED
      //SAVE TOKENS
      saveTokens(response.data);
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
  Future<void> deleteAccount() async {
    ApiResponse response = await apiService.networkRequest(
      method: "DELETE",
      isAuthRequired: true,
      endPoint: ApiEndpoints.deleteAccount,
    );

    if (response.statusCode == 200) {
      await storage.erase();
      Get.offAllNamed(AppRoutes.getStarted);
      showSnackBar(
        title: "Account deleted!",
        message: "Your account has been deleted.",
        backgroundColor: AppColors.successGreen,
      );
    } else {
      showSnackBar(
        title: "Error occurred!",
        message: "Something went wrong. Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  changeNotificationSettings({required int switchNumber}) async {
    if (switchNumber == 0) {
      //push
      isPushLoading.value = true;
    } else if (switchNumber == 1) {
      //donation
      isDonationLoading.value = true;
    } else {
      //reward perks
      isRewardPerksLoading.value = true;
    }

    NotificationSettingsModel settingsModel = NotificationSettingsModel(
      pushNotifications: switchNumber == 0
          ? !isPushNotificationEnabled.value
          : isPushNotificationEnabled.value,
      donations: switchNumber == 1
          ? !isDonationUpdatesEnabled.value
          : isDonationUpdatesEnabled.value,
      rewardsAndPerks: switchNumber == 2
          ? !isRewardPerksEnabled.value
          : isRewardPerksEnabled.value,
    );

    ApiResponse response = await apiService.networkRequest(
      method: "PATCH",
      isAuthRequired: true,
      endPoint: ApiEndpoints.notificationSettings,
      body: settingsModel.toJson(),
    );
    isPushLoading.value = false;
    isDonationLoading.value = false;
    isRewardPerksLoading.value = false;

    if (response.statusCode == 200) {
      settingsModel = NotificationSettingsModel.fromJson(response.data['data']);
      isPushNotificationEnabled.value = settingsModel.pushNotifications;
      isDonationUpdatesEnabled.value = settingsModel.donations;
      isRewardPerksEnabled.value = settingsModel.rewardsAndPerks;
    } else {
      showSnackBar(
        title: "Error occurred!",
        message: "Something went wrong. Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //GET NOTIFICATION SETTINGS
  getNotificationSettings() async {
    ApiResponse response = await apiService.networkRequest(
      method: "GET",
      isAuthRequired: true,
      endPoint: ApiEndpoints.notificationSettings,
    );

    if (response.statusCode == 200) {
      settingsModel = NotificationSettingsModel.fromJson(response.data['data']);
      isPushNotificationEnabled.value =
          settingsModel?.pushNotifications ?? true;
      isDonationUpdatesEnabled.value = settingsModel?.donations ?? true;
      isRewardPerksEnabled.value = settingsModel?.rewardsAndPerks ?? true;
    }
  }
}
