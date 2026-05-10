import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/core/api_service.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/features/subscription/payment_screen.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';

import '../../data/models/profile/business_profile_model.dart';
import '../../routes/app_pages.dart';
import '../../utils/app_constants.dart';

class IosSubscriptionController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();

  @override
  void onInit() {
    isSubscribed.value = !isSubscriptionExpired();
    super.onInit();
  }

  bool isSubscriptionExpired() {
    String? subscriptionExpiryDate = storage.read(subscriptionExpiryDateKey);
    if (subscriptionExpiryDate == null &&
        storage.read(subscriptionKey) == false)
      return true;
    DateTime expiryDate = DateTime.parse(subscriptionExpiryDate!);
    DateTime nowUtc = DateTime.now().toUtc();

    return nowUtc.isAfter(expiryDate);
  }

  RxBool isSubscribed = false.obs;

  final storage = GetStorage();
  RxBool isSubscribing = false.obs;

  //SUBSCRIBE
  subscribe({required String plan}) async {
    if (isSubscribing.value) {
      return;
    }

    if (isSubscribed.value) {
      return;
    }

    // monthly, yearly
    Map<String, String> payLoad = {"planType": plan};

    isSubscribing.value = true;
    ApiResponse response = await apiService.networkRequest(
      method: "POST",
      isAuthRequired: true,
      endPoint: ApiEndpoints.subscribe,
      body: payLoad,
    );
    isSubscribing.value = false;

    if (response.statusCode == 200 || response.statusCode == 201) {
      //SUBSCRIPTION SUCCESSFUL
      String payment = response.data['data']['url'];
      Get.to(PaymentWebViewScreen(paymentUrl: payment));
      showSnackBar(
        title: "Subscribed!",
        message: "You have successfully subscribed for $plan plan.",
        backgroundColor: AppColors.successGreen,
      );
    } else {
      showSnackBar(
        title: "Error occurred!",
        message: "Something went wrong. Please try again.",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

  //GET PROFILE ON PAYMENT SUCCESS
  getProfileData() async {

      ApiResponse response = await apiService.networkRequest(
        method: "GET",
        isAuthRequired: true,
        endPoint: ApiEndpoints.getProfile
      );

      if (response.statusCode == 200) {
        //FETCHED PROFILE DATA
        BusinessProfileModel model = BusinessProfileModel.fromJson(
          response.data['data'],
        );
        //SAVE PROFILE DATA IN STORAGE
        storage.write(businessProfileModelKey, model.toJson());
        //GO TO MAIN -> HOME -> GET HOME DATA, ANALYTICS THERE
        bool isSubscribed = model.isSubscribed ?? false;
        storage.write(subscriptionKey, isSubscribed);
        storage.write(subscriptionExpiryDateKey, model.subscriptionExpiryDate);
        if (isSubscribed) {
          showSnackBar(
            title: "Subscribed!",
            message: "You have successfully subscribed.",
            backgroundColor: AppColors.successGreen,
          );
          Get.offAllNamed(AppRoutes.mainNav);
        } else {
          showSnackBar(
            title: "Subscription Required!",
            message: "You need to subscribe to continue.",
            backgroundColor: AppColors.successGreen,
          );
          bool isAndroid = Platform.isAndroid;
          if( isAndroid ){
            Get.offAllNamed(AppRoutes.androidSubscription);
          }else{
            Get.offAllNamed(AppRoutes.iosSubscription);
          }
        }
      } else if (response.statusCode == 401) {
        //ACCESS TOKEN INVALID
        showSnackBar(
          title: "Session Expired!",
          message: "Please try again.",
          backgroundColor: AppColors.errorRed,
        );
      } else {
        showSnackBar(
          title: "Error occurred!",
          message: "Something went wrong. Please try again.",
          backgroundColor: AppColors.errorRed,
        );
      }
  }
}
