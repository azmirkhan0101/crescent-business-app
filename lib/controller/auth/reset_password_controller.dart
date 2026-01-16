import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';

import '../../core/show_snackbar.dart';
import '../../utils/app_color.dart';

class ResetPasswordController extends GetxController{

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final storage = GetStorage();
  RxBool isResetLoading = false.obs;
  late String resetPasswordToken;

  //REQUIREMENT CHECKBOX CONTROLLER
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

  //VALIDATE NEW EMAIL
  bool isNewPasswordValid() {
    final regex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~?%^()_\-+=<>.,;:{}\[\]|/]).{8,}$'
    );
    return regex.hasMatch(newPasswordController.text.trim());
  }

  // bool isConfirmPasswordValid() {
  //   final regex = RegExp(
  //       r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~?%^()_\-+=<>.,;:{}\[\]|/]).{8,}$'
  //   );
  //   return regex.hasMatch(confirmPasswordController.text.trim());
  // }

  resetPassword() async{

    if( isResetLoading.value ){
      return;
    }

    if( !isNewPasswordValid() ){
      showSnackBar(
          title: "Password incomplete!",
          message: "Please enter a valid password!",
          backgroundColor: AppColors.errorRed
      );
      return;
    }else if( newPasswordController.text.trim() != confirmPasswordController.text.trim() ){
      showSnackBar(
          title: "Password not matched",
          message: "The new password and confirm password are not matched!",
          backgroundColor: AppColors.errorRed
      );
      return;
    }
    //TODO:
    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.resetPassword );
    Map<String, dynamic> payLoad = {
      "resetPasswordToken": resetPasswordToken,
      "newPassword": newPasswordController.text.trim()
    };

    try{
      isResetLoading.value = true;
      http.Response response = await http.post( uri, body: payLoad );

      if( response.statusCode == 200 ){
        showSnackBar(
            title: "Success!",
            message: "Password reset was successful!",
            backgroundColor: AppColors.successGreen
        );
        Get.offAndToNamed(AppRoutes.logIn);
      }else if( response.statusCode == 401 || response.statusCode == 403 ){
        showSnackBar(
            title: "Failed!",
            message: "Session Expired! Please try again with your email.",
            backgroundColor: AppColors.errorRed
        );
        Get.offAndToNamed(AppRoutes.forgotPassword);
      }
    }catch(e){
      showSnackBar(
          title: "An Error Occurred!",
          message: "Check your internet connection and try again!",
          backgroundColor: AppColors.errorRed
      );
    }finally{
      isResetLoading.value = false;
    }
  }
}