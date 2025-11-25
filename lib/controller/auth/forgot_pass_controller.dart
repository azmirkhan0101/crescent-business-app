import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_constants.dart';

import '../../utils/app_color.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();

  bool isEmailValid() {
    return RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    ).hasMatch(emailController.text.trim());
  }

  //VALIDATE EMAIL AND SEND OTP
  sendVerificationCode() async{
    if( !isEmailValid() ){
      showSnackBar(
          title: "Invalid Email!",
          message: "Please enter a valid email address.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }
    //TODO: CHECK POSTMAN, CHECK IF ACCOUNT EXIST->SEND VERIFY CODE->ELSE SHOW SNACKBAR

    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.otpForgotPassword );

    Map<String, String> payLoad = {
      "email": emailController.text.trim()
    };
    http.Response response = await http.post( uri, body: payLoad );
    //TODO: CHECK UI(is email field editable or coming from login screen) AND POSTMAN FOR RESPONSE
    if( response.statusCode == 200 ){//TODO: MAY BE ACCOUNT EXIST->CODE SENT
      Map<String, dynamic> arguments = {
        emailKey : emailController.text.trim(),
        isSignupKey : false
      };
      Get.toNamed( AppRoutes.otpVerify, arguments: arguments );
    }else if( response.statusCode == 400 ){//TODO: MAY BE NO ACCOUNT FOUND
      showSnackBar(
          title: "Incorrect Email!",
          message: "No account found matching this email.",
          backgroundColor: AppColors.errorRed
      );
    }
  }

  showSnackBar({required String title, required String message, required Color backgroundColor, Color textColor = AppColors.white}) {
    Get.snackbar(
        title,
        message,
        backgroundColor: backgroundColor,
        colorText: textColor
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
