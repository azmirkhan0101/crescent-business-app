import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';

import '../../utils/app_constants.dart';
import 'package:http/http.dart' as http;

class SubscriptionController extends GetxController{

  @override
  void onInit() {

    isSubscribed.value = storage.read(subscriptionKey) ?? false;
    super.onInit();
  }

  RxBool isSubscribed = false.obs;
  
  final storage = GetStorage();
  RxBool isSubscribing = false.obs;
  
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

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if( response.statusCode == 201 ){//SUBSCRIPTION SUCCESSFUL
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

}