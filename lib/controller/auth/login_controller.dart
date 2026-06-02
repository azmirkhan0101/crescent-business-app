import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/core/api_service.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_constants.dart';

import '../../core/app_validator.dart';
import '../../core/show_snackbar.dart';
import '../../core/subscription_service.dart';
import '../../data/models/profile/business_profile_model.dart';
import '../../services/google_signin_service.dart';

class LoginController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final storage = GetStorage();
  RxBool isLoginLoading = false.obs;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //===============ACTIVATE SOCIAL LOGIN=================
  Future<void> activateSocialLogin() async{
    await storage.write( isSocialAuthKey, true );
  }

  //=================DEACTIVATE SOCIAL LOGIN=============
  Future<void> deActivateSocialLogin() async{
    await storage.write( isSocialAuthKey, false );
  }

  //=================RAW LOGIN=====================
  Future<void> login() async {
    if (isLoginLoading.value) return;

    if (!isEmailValid(email: emailController.text.trim()) ||
        !isPasswordValid(password: passwordController.text.trim())) {
      incorrectCredentialsSnackBar();
      return;
    }

    isLoginLoading.value = true;
    Map<String, dynamic> credentials = {
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };
    ApiResponse response = await apiService.networkRequest(
      method: 'POST',
      isAuthRequired: false,
      endPoint: ApiEndpoints.login,
      body: credentials,
    );

    if (response.statusCode == 200) {
      saveOtpResponse(response.data);
      updateFcmToken();
    } else if (response.statusCode == 400) {
      isLoginLoading.value = false;
      showSnackBar(
        title: "Account not verified!",
        message: "Verify your account using the OTP sent to your email.",
        backgroundColor: AppColors.warningYellow,
        textColor: AppColors.black,
      );
      storage.write(requireVerificationKey, true);
      storage.write(emailKey, emailController.text.trim());
      Get.offNamed(AppRoutes.verifyNow);
    } else if (response.statusCode == 401) {
      isLoginLoading.value = false;
      showSnackBar(
        title: "Incorrect password!",
        message: "The password you entered is incorrect.",
        backgroundColor: AppColors.errorRed,
      );
    } else if (response.statusCode == 404) {
      isLoginLoading.value = false;
      showSnackBar(
        title: "Account not found!",
        message:
            response.data['message'] ??
            "No account found matching this email. Try creating an account.",
        backgroundColor: AppColors.errorRed,
      );
    } else {
      isLoginLoading.value = false;
      showSnackBar(
        title: "Login Failed!",
        message: "Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //================GOOGLE SIGN IN==================
  Future<void> loginWithGoogle() async {
    try {
      isLoginLoading.value = true;

      final GoogleSigninService googleSignInService = GoogleSigninService();

      final GoogleSignInAccount account = await googleSignInService
          .signInWithGoogle();

      final GoogleSignInAuthentication auth = googleSignInService.getAuthTokens(
        account
      );

      final AuthCredential authCredential = GoogleAuthProvider.credential( idToken: auth.idToken );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential( authCredential );
      String? firebaseIdToken = await userCredential.user?.getIdToken();
      print("Firebase ID Token: $firebaseIdToken");
      if( firebaseIdToken == null ){
        throw Exception("Failed to retrieve Firebase ID Token.");
      }

      Map<String, dynamic> credentials = {
        "role": "BUSINESS",
        "firebaseIdToken": firebaseIdToken,
        "displayName": account.displayName ?? "Unknown"
      };
      ApiResponse response = await apiService.networkRequest(
        method: 'POST',
        isAuthRequired: false,
        endPoint: ApiEndpoints.socialLogin,
        body: credentials
      );
      print("Endpoint: ${ApiEndpoints.socialLogin}");
      print("Payload for Backend: $credentials");

      print("Social auth code: ${response.statusCode}");
      print("Social auth response: ${response.data}");

      if( response.statusCode == 200 || response.statusCode == 201 ){
        bool requiresProfile = response.data['data']['requiresProfile'];
        saveOtpResponse(response.data);
        print("Requires profile = $requiresProfile");

        if( requiresProfile ){
          Get.offAllNamed(AppRoutes.categorySelection);
        }else{
          updateFcmToken();
        }
      }else{
        showApiSnackBar(statusCode: response.statusCode, data: response.data );
      }

      // 4. Send `googleAuthData` to your backend API here manually.
      // Example:
      // final response = await yourBackendApi.login(googleAuthData);
      // if (response.statusCode == 200) {
      //   Get.offAllNamed('/home');
      // }
    } on GoogleSignInException catch (e) {
      print("Google Sign-In Error Code: ${e.code}");
      print("Description: ${e.description}");
      print("Details: ${e.details}");

      if (e.code != GoogleSignInExceptionCode.canceled) {
        showSnackBar(
            title: "Authentication Error",
            message: e.description ?? "Google Sign-In was not successful.",
            backgroundColor: AppColors.errorRed
        );
      }
    } catch (e) {
      errorSnackBar();
    }finally{
      isLoginLoading.value = false;
    }
  }

  String? getHighResImageUrl(String? url) {
    if (url == null) return null;
    return url.replaceAll('s96-c', 's500-c');
  }

  //=====================FCM UPDATE================
  Future<void> updateFcmToken() async {
    String deviceType = Platform.isAndroid ? 'android' : 'ios';

    String? token;

    if (Platform.isIOS) {
      String? apnsToken;
      for (int i = 0; i < 5; i++) {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) {
          break;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    try {
      token = await FirebaseMessaging.instance.getToken();
    } catch (e) {}

    print("FCM token: $token");

    final payLoad = {"fcmToken": token, "deviceType": deviceType};

    await apiService.networkRequest(
      method: 'PATCH',
      isAuthRequired: true,
      endPoint: ApiEndpoints.updateFcmToken,
      body: payLoad
    );

    getProfileData();
  }

  //===============GET PROFILE=====================
  Future<void> getProfileData() async {
    ApiResponse response = await apiService.networkRequest(
      method: 'GET',
      isAuthRequired: true,
      endPoint: ApiEndpoints.getProfile,
      shouldPrint: true
    );

    isLoginLoading.value = false;

    if (response.statusCode == 200) {
      storage.write(requireVerificationKey, false);
      BusinessProfileModel model = BusinessProfileModel.fromJson(
        response.data['data'],
      );

      storage.write(businessProfileModelKey, model.toJson());
      storage.write(businessIdKey, model.businessId);
      storage.write(businessAuthIdKey, model.businessAuthId);

      bool isSubscribed = model.isSubscribed ?? false;
      storage.write(subscriptionKey, isSubscribed);
      storage.write(subscriptionExpiryDateKey, model.subscriptionExpiryDate);

      // Identify the user in RevenueCat using your backend User ID
      if (model.businessAuthId != null) {
        await SubscriptionService.to.loginUser(model.businessAuthId);
      }

      // Update our dual-premium state cache
      await SubscriptionService.to.checkPremiumStatus();

      // Proceed if backend OR RC is active
      if (SubscriptionService.to.hasPremium) {
        showSnackBar(
          title: "Logged in!",
          message: "You have successfully logged in.",
          backgroundColor: AppColors.successGreen,
        );
        Get.offAllNamed(AppRoutes.mainNav);
      } else {
        showSnackBar(
          title: "Subscription Required!",
          message: "Your free premium has expired. Please subscribe.",
          backgroundColor: AppColors.warningYellow,
        );
        Get.offAllNamed(AppRoutes.paywallScreen);
      }
    } else{
      storage.erase();
      showApiSnackBar(statusCode: response.statusCode, data: response.data);
    }
  }

  //==========================SAVE TOKENS==========
  void saveOtpResponse(Map<String, dynamic> response) {
    final accessToken = response["data"]["accessToken"];
    final refreshToken = response["data"]["refreshToken"];
    storage.write(accessTokenKey, accessToken);
    storage.write(refreshTokenKey, refreshToken);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
