import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';
import 'dart:async';

class LoginController extends GetxController{

  //TODO: SAVE TOKEN IN STORAGE

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

      final url = Uri.parse( ApiEndpoints.baseUrl+ApiEndpoints.login );
      http.Response response = await http.post( url, body: credentials ).timeout(Duration(seconds: 10));

      if( response.statusCode == 200 ){

        Map<String, dynamic> responseData = jsonDecode(response.body);
        String accessToken = responseData['data']['accessToken'];
        //TODO: SAVE THIS TOKENNNNNNNNNNNN
        Get.offAllNamed(AppRoutes.mainNav);
        showSnackBar(
            title: "Logged in!",
            message: "You have successfully logged in.",
            backgroundColor: AppColors.successGreen
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

  showSnackBar({required String title, required String message, required Color backgroundColor}){
    Get.snackbar(
        title,
        message,
        backgroundColor: backgroundColor,
        colorText: AppColors.white
    );
  }

}