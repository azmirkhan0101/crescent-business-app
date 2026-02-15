import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/features/subscription/payment_screen.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';

import '../../data/models/profile/business_profile_model.dart';
import '../../routes/app_pages.dart';
import '../../utils/app_constants.dart';
import 'package:http/http.dart' as http;

class SubscriptionController extends GetxController{

  @override
  void onInit() {

    //isSubscribed.value = storage.read(subscriptionKey) ?? false;
    isSubscribed.value = !isSubscriptionExpired();
    super.onInit();
  }

  bool isSubscriptionExpired(){
    String? subscriptionExpiryDate = storage.read( subscriptionExpiryDateKey );
    if( subscriptionExpiryDate == null && storage.read( subscriptionKey) == false ) return true;
    DateTime expiryDate = DateTime.parse( subscriptionExpiryDate! );
    DateTime nowUtc = DateTime.now().toUtc();

    return nowUtc.isAfter( expiryDate );

  }

  RxBool isSubscribed = false.obs;
  
  final storage = GetStorage();
  RxBool isSubscribing = false.obs;


  //SUBSCRIBE
  subscribe({required String plan}) async{

    if( isSubscribing.value ){
      return;
    }

    if( isSubscribed.value ){
      return;
    }
    
    Uri uri = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.subscribe );

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${storage.read( accessTokenKey )}",
    };


    // monthly, yearly
    Map<String, String> payLoad = {
      "planType": plan
    };

    try{
      isSubscribing.value = true;
      http.Response response = await http.post( uri, headers: headers, body: jsonEncode(payLoad) );
      if( response.statusCode == 200 || response.statusCode == 201 ){//SUBSCRIPTION SUCCESSFUL
        String payment = jsonDecode(response.body)['data']['url'];
        Get.to( PaymentWebViewScreen(paymentUrl: payment));
        showSnackBar(title: "Subscribed!", message: "You have successfully subscribed for $plan plan.", backgroundColor: AppColors.successGreen);
      }else{
        showSnackBar(title: "Error occurred!", message: "Something went wrong. Please try again.", backgroundColor: AppColors.errorRed);
      }
    }catch(e){
      showSnackBar(title: "No internet!", message: "Please check your internet connection and try again.", backgroundColor: AppColors.warningYellow);
    }finally{
      isSubscribing.value = false;
    }
  }


  //GET PROFILE ON PAYMENT SUCCESS
  getProfileData() async {

    try {
      Uri uri = Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.getProfile);

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${storage.read(accessTokenKey)}",
      };

      http.Response response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        //FETCHED PROFILE DATA
        BusinessProfileModel model = BusinessProfileModel.fromJson(
          jsonDecode(response.body)['data'],
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
          Get.offAllNamed(AppRoutes.subscription);
        }
      } else if (response.statusCode == 401) {
        //ACCESS TOKEN INVALID
        showSnackBar(
          title: "Session Expired!",
          message: "Please try again.",
          backgroundColor: AppColors.errorRed,
        );
      }else{
      }
    } catch (e) {
      showSnackBar(
        title: "Error!",
        message: "Something went wrong. Please try again",
        backgroundColor: AppColors.errorRed,
      );
    }
  }

}
