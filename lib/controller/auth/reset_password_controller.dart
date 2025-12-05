import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_constants.dart';

import '../../core/show_snackbar.dart';
import '../../utils/app_color.dart';
import 'package:http/http.dart' as http;

class ResetPasswordController extends GetxController{

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final storage = GetStorage();
  late String resetPasswordToken;

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
      http.Response response = await http.post( uri, body: payLoad );
      print("Status codeee: ${response.statusCode}");
      print("Reset pass response: ${response.body}");
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
    }
  }
}