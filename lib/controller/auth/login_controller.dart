import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';
import 'dart:async';

import 'package:organization/utils/app_constants.dart';

class LoginController extends GetxController{

  //TODO: SAVE TOKEN IN STORAGE
  final storage = GetStorage();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isEmailValid() {
    return RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    ).hasMatch(emailController.text.trim());
  }

  bool isPasswordValid() {
    final regex = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~?%^()_\-+=<>.,;:{}\[\]|/]).{8,}$'
    );
    return regex.hasMatch(passwordController.text.trim());
  }

  //VALIDATE EMAIL PASSWORD AND THEN LOGIN
  login() async{
    if( !isEmailValid() || !isPasswordValid() ){
      showSnackBar(
          title: "Incorrect Credentials!",
          message: "Please enter email and password correctly.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }

    try {
      Map<String, dynamic> credentials = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      final url = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.login );
      http.Response response = await http.post( url, body: credentials ).timeout(Duration(seconds: 10));
      print("Status codeeee: ${response.statusCode}");
      print("Response: ${response.body}");
      if( response.statusCode == 200 ){//LOGIN SUCCESSFUL
        Map<String, dynamic> responseData = jsonDecode(response.body);
        saveOtpResponse( responseData );
        //check if verified or not
        showSnackBar(
            title: "Logged in!",
            message: "You have successfully logged in.",
            backgroundColor: AppColors.successGreen
        );
        Get.offAllNamed(AppRoutes.mainNav);
      }else if( response.statusCode == 400 ){//ACCOUNT FOUND, BUT NOT VERIFIED
        showSnackBar(
            title: "Account not verified!",
            message: "Verify your account using the OTP sent to your email.",
            backgroundColor: AppColors.warningYellow,
          textColor: AppColors.black
        );
        Uri resendSignupOtpUri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.otpResendSignup );
        Map<String, String> payLoad = {
          "email": emailController.text.trim()
        };
        try{
          //ASYNC BUT DO NOT WAIT
          unawaited(http.post( resendSignupOtpUri, body: payLoad ));
        }catch(e){
        }
        Map<String, dynamic> arguments = {
          emailKey : emailController.text.trim(),
          isSignupKey : true //CONTROLS IF OTP is FOR SIGNUP OR LOGIN
        };
        Get.toNamed( AppRoutes.otpVerify, arguments: arguments );
      } else if( response.statusCode == 401 ){//WRONG PASSWORD
        showSnackBar(
            title: "Incorrect password!",
            message: "The password you entered is incorrect.",
            backgroundColor: AppColors.errorRed
        );
      } else if( response.statusCode == 404 ){//NO ACCOUNT FOUND IN THAT EMAIL
        showSnackBar(
            title: "Account not found!",
            message: "No account found matching this email. Try creating an account.",
            backgroundColor: AppColors.errorRed
        );
      }else{
        showSnackBar(
            title: "Login Failed!",
            message: "Please try again.",
            backgroundColor: AppColors.errorRed
        );
      }
    } on SocketException {
      showSnackBar(
          title: "No internet connection!",
          message: "Please connect to the internet.",
          backgroundColor: AppColors.errorRed
      );
    } on TimeoutException {
      showSnackBar(
          title: "Time out!",
          message: "Please check your internet connection or try again later.",
          backgroundColor: AppColors.errorRed
      );
    }catch (e) {
      showSnackBar(
          title: "Something went wrong!",
          message: "Please try again later.",
          backgroundColor: AppColors.errorRed
      );
    }
  }

  //SAVE TOKENS IN STORAGE
  void saveOtpResponse(Map<String, dynamic> response) {

    final accessToken = response["data"]["accessToken"];
    final refreshToken = response["data"]["refreshToken"];

    storage.write( accessTokenKey, accessToken);
    storage.write( refreshTokenKey, refreshToken);
  }

  showSnackBar({required String title, required String message, required Color backgroundColor, Color textColor = AppColors.white}){
    Get.snackbar(
        title,
        message,
        backgroundColor: backgroundColor,
        colorText: textColor
    );


    @override
    void onClose() {
      emailController.dispose();
      passwordController.dispose();
      super.onClose();
    }
  }

}