import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_constants.dart';

import '../../core/show_snackbar.dart';
import '../../utils/app_color.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordController extends GetxController {

  final TextEditingController emailController = TextEditingController();
  final storage = GetStorage();
  RxBool isVerifying = false.obs;

  bool isEmailValid() {
    return RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    ).hasMatch(emailController.text.trim());
  }

  //VALIDATE EMAIL AND SEND OTP
  sendVerificationCode() async{

    if( isVerifying.value ){
      return;
    }

    isVerifying.value = true;

    if( !isEmailValid() ){
      showSnackBar(
          title: "Invalid Email!",
          message: "Please enter a valid email address.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }

    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.otpForgotPassword );

      Map<String, String> payLoad = {
        "email": emailController.text.trim()
      };
      http.Response response = await http.post( uri, body: payLoad );
      print("Status codeeee: ${response.statusCode}");
      print("Response: ${response.body}");

      if( response.statusCode == 200 ){//OTP SENT TO EMAIL

        storage.write( forgotPasswordTokenKey, "" );//EMPTY TOKEN ON SUCCESS
        var responseData = jsonDecode( response.body );
        final String forgotPasswordToken = responseData['data']['token'];
        storage.write( forgotPasswordTokenKey, forgotPasswordToken );
        Map<String, dynamic> arguments = {
          emailKey : emailController.text.trim(),
          isSignupKey : false
        };
        Get.toNamed( AppRoutes.otpVerify, arguments: arguments );
      }else if( response.statusCode == 400 ){//OTP STILL VALID
        showSnackBar(
            title: "OTP already sent!",
            message: "Check your email or request a new otp after 5 minutes!.",
            backgroundColor: AppColors.warningYellow
        );
        Map<String, dynamic> arguments = {
          emailKey : emailController.text.trim(),
          isSignupKey : false
        };
        Get.toNamed( AppRoutes.otpVerify, arguments: arguments );
      }else if( response.statusCode == 404 ){//NO ACCOUNT FOUND
        showSnackBar(
            title: "Incorrect Email!",
            message: "No account found matching this email.",
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
      isVerifying.value = false;
    }


  }
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
