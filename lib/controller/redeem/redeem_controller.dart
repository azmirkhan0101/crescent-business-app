import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:organization/utils/app_color.dart';

import '../../routes/app_pages.dart';
import '../../utils/app_constants.dart';

class RedeemController extends GetxController{

  final storage = GetStorage();
  
  redeemReward({required String code, required String method}) async{

    if( code.isEmpty ){
      showSnackBar(title: "Enter codes first!", message: "Enter codes to redeem.", backgroundColor: AppColors.warningYellow);
      return;
    }
    
    try{
      Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.redeemReward );

      Map<String, String> headers = {
        "Content-type" : "application/json",
        "Authorization" : "Bearer ${storage.read( accessTokenKey )}"
      };

      final payLoad = {
        "code": code,
        "staffAuthId": storage.read( businessAuthIdKey ),
        "method": method
      };

      print(storage.read( businessAuthIdKey ));
      http.Response response = await http.post( uri, body: jsonEncode( payLoad ), headers: headers );

      print("Redeem status: ${response.statusCode}");
      print("Redeem body: ${response.body}");

      if( response.statusCode == 200 || response.statusCode == 201 ){
        Get.toNamed(AppRoutes.scannerComplete);
      }else{
        showSnackBar(title: "Invalid codes!", message: "Please enter valid codes and try again.", backgroundColor: AppColors.warningYellow);
      }
    }catch(e){
      showSnackBar(title: "Something went wrong!", message: "Please check your internet connection and try again.", backgroundColor: AppColors.warningYellow);
    }
  }
}