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

import '../../core/show_snackbar.dart';
import '../../data/models/profile/business_profile_model.dart';
import '../../services/firebase_notification_service.dart';

class LoginController extends GetxController{

  final storage = GetStorage();
  RxBool isLoginLoading = false.obs;

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

  //VALIDATE EMAIL PASSWORD AND THEN LOGIN -> if verified -> go to home -> else -> go to verified screen
  login() async{

    if( isLoginLoading.value ){
      return;
    }

    if( !isEmailValid() || !isPasswordValid() ){
      showSnackBar(
          title: "Incorrect Credentials!",
          message: "Please enter email and password correctly.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }

    try {
      isLoginLoading.value = true;
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
        storage.write( requireVerificationKey, false );
        //GET PROFILE AND GO TO MAIN -> HOME
        await updateFcmToken();
        getProfileData();
      }else if( response.statusCode == 400 ){//ACCOUNT FOUND, BUT NOT VERIFIED
        showSnackBar(
            title: "Account not verified!",
            message: "Verify your account using the OTP sent to your email.",
            backgroundColor: AppColors.warningYellow,
          textColor: AppColors.black
        );
        storage.write( requireVerificationKey, true );
        storage.write( emailKey, emailController.text.trim());//SAVE EMAIL FOR VERIFY NOW SCREEN
        //go to verify now screen
        Get.offNamed( AppRoutes.verifyNow );

        // Uri resendSignupOtpUri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.otpResendSignup );
        // Map<String, String> payLoad = {
        //   "email": emailController.text.trim()
        // };
        // try{
        //   //ASYNC BUT DO NOT WAIT
        //   unawaited(http.post( resendSignupOtpUri, body: payLoad ));
        // }catch(e){
        // }
        // Map<String, dynamic> arguments = {
        //   emailKey : emailController.text.trim(),
        //   isSignupKey : true //CONTROLS IF OTP is FOR SIGNUP OR LOGIN
        // };
        // Get.offNamed( AppRoutes.otpVerify, arguments: arguments );
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
    }finally{
      isLoginLoading.value = false;
    }
  }

  //UPDATE FCM TOKEN
  updateFcmToken() async{

    try{
      String? token = await FirebaseNotificationService.instance.getToken();
      print( token );

      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.updateFcmToken );

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${storage.read( accessTokenKey )}",
      };

      String deviceType = "android";

      // Detect the device type
      if (Platform.isAndroid) {
        deviceType = 'android';
      } else{
        deviceType = 'ios';
      }

      final payLoad = {
        "fcmToken": token,
        "deviceType": deviceType
      };

      http.Response response = await http.patch( uri, headers: headers, body: jsonEncode( payLoad ) );

      print("Fcm Tokennnnn: ${response.body}");
      print("Fcm Tokennnnn: ${response.statusCode}");
    }catch(e){

    }
  }

  //GET PROFILE DATA USING TOKEN AFTER LOGIN SUCCESS
  getProfileData() async{

    //showLoadingAlert( title: "Syncing..." );

    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.getProfile );

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${storage.read( accessTokenKey )}",
      };

      http.Response response = await http.get( uri, headers: headers );
      if( response.statusCode == 200 ){//FETCHED PROFILE DATA
        BusinessProfileModel model = BusinessProfileModel.fromJson( jsonDecode( response.body )['data'] );
        //SAVE PROFILE DATA IN STORAGE
        storage.write( businessProfileModelKey, model.toJson() );
        storage.write( businessIdKey, model.businessId );//SAVING ID SEPARATELY FOR RETRIEVING EASILY, ALSO AVAILABLE IN MODEL
        storage.write( businessAuthIdKey, model.businessAuthId );//SAVING AUTH ID SEPARATELY FOR RETRIEVING EASILY, ALSO AVAILABLE IN MODEL
        //GO TO MAIN -> HOME -> GET HOME DATA, ANALYTICS THERE
        print("Profile data: ${response.body}");
        bool isSubscribed = model.isSubscribed ?? false;
        storage.write(subscriptionKey, isSubscribed );
        if( isSubscribed ){
          showSnackBar(
              title: "Logged in!",
              message: "You have successfully logged in.",
              backgroundColor: AppColors.successGreen
          );
          Get.offAllNamed(AppRoutes.mainNav);
        }else{
          showSnackBar(
              title: "Subscription Required!",
              message: "You need to subscribe to continue.",
              backgroundColor: AppColors.successGreen
          );
          Get.offAllNamed(AppRoutes.subscription);
        }
      }else if( response.statusCode == 401 ){//ACCESS TOKEN INVALID
        showSnackBar(
            title: "Session Expired!",
            message: "Please try again.",
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
      isLoginLoading.value = false;
    }
  }

  //SAVE TOKENS IN STORAGE
  void saveOtpResponse(Map<String, dynamic> response) {

    final accessToken = response["data"]["accessToken"];
    final refreshToken = response["data"]["refreshToken"];

    storage.write( accessTokenKey, accessToken);
    storage.write( refreshTokenKey, refreshToken);
  }

    @override
    void onClose() {
      emailController.dispose();
      passwordController.dispose();
      super.onClose();
    }

}