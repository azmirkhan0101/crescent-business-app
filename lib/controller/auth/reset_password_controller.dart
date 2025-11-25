import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:organization/utils/api_endpoints.dart';

import '../../utils/app_color.dart';

class ResetPasswordController extends GetxController{

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  //VALIDATE INFORMATION OF ACCOUNT CREATION- EMAIL, PASSWORD
  bool isNewPasswordValid() {
    final regex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~?%^()_\-+=<>.,;:{}\[\]|/]).{8,}$'
    );
    return regex.hasMatch(newPasswordController.text.trim());
  }

  bool isConfirmPasswordValid() {
    final regex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~?%^()_\-+=<>.,;:{}\[\]|/]).{8,}$'
    );
    return regex.hasMatch(confirmPasswordController.text.trim());
  }

  resetPassword(){
    if( !isNewPasswordValid() || newPasswordController.text.trim() != confirmPasswordController.text.trim() ){
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
      //TODO: PREPARE THE PAYLOAD ACCORDING TO POSTMAN
    };
  }

  showSnackBar({required String title, required String message, required Color backgroundColor, Color textColor = AppColors.white}) {
    Get.snackbar(
        title,
        message,
        backgroundColor: backgroundColor,
        colorText: textColor
    );
  }
}