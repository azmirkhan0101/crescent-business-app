import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
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
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  //==================APPLE SIGN IN=================
  Future<void> loginWithApple() async {
    // Only attempt Apple Sign-In on iOS devices
    if (!Platform.isIOS) {
      showSnackBar(
          title: "Platform Error",
          message: "Apple Sign-In is only supported on iOS devices.",
          backgroundColor: AppColors.errorRed
      );
      return;
    }

    try {
      isLoginLoading.value = true;

      // 1. Generate secure nonces required for Firebase Apple Sign-In verification
      final String rawNonce = _generateNonce();
      final String hashedNonce = _sha256ofString(rawNonce);

      // 2. Request credential from Apple
      final AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      // 3. Construct OAuth credentials for Firebase
      // Passing both rawNonce and authorizationCode ensures stable backend verification
      final AuthCredential authCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      // 4. Authenticate user with Firebase
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(authCredential);

      String? firebaseIdToken = await userCredential.user?.getIdToken();
      print("Firebase ID Token: $firebaseIdToken");
      if (firebaseIdToken == null) {
        throw Exception("Failed to retrieve Firebase ID Token.");
      }

      // 5. Safely parse Name & Email
      // (Apple only sends email/name on first auth; subsequent times are read from Firebase)
      String email = appleCredential.email ?? userCredential.user?.email ?? "";
      if (email.isEmpty) {
        throw Exception("Failed to retrieve user email from Apple Sign-In.");
      }

      String displayName = "Unknown";
      if (appleCredential.givenName != null) {
        displayName = "${appleCredential.givenName} ${appleCredential.familyName ?? ''}".trim();
      } else if (userCredential.user?.displayName != null && userCredential.user!.displayName!.isNotEmpty) {
        displayName = userCredential.user!.displayName!;
      }

      // 6. Build Payload with 'BUSINESS' role to match your Google flow
      Map<String, dynamic> credentials = {
        "role": "BUSINESS",
        "firebaseIdToken": firebaseIdToken,
        "displayName": displayName
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        bool requiresProfile = response.data['data']['requiresProfile'];
        saveOtpResponse(response.data);
        print("Requires profile = $requiresProfile");

        if (requiresProfile) {
          Get.offAllNamed(AppRoutes.categorySelection);
        } else {
          updateFcmToken();
        }
      } else {
        showApiSnackBar(statusCode: response.statusCode, data: response.data);
      }

    } on SignInWithAppleAuthorizationException catch (e) {
      print("Apple Sign-In Error Code: ${e.code}");
      print("Message: ${e.message}");

      if (e.code != AuthorizationErrorCode.canceled) {
        showSnackBar(
            title: "Authentication Error",
            message: e.message,
            backgroundColor: AppColors.errorRed
        );
      }
    } catch (e) {
      errorSnackBar();
    } finally {
      isLoginLoading.value = false;
    }
  }

  // Helper method: Generates a cryptographically secure random nonce
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  // Helper method: Returns the sha256 hash of the input in hex notation
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
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
