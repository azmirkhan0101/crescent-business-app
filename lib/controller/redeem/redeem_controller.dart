import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

import '../../routes/app_pages.dart';
import '../../utils/app_constants.dart';

class RedeemController extends GetxController{

  final storage = GetStorage();
  
  redeemReward({required String code, required String method}) async{
    
    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.redeemReward );

    Map<String, String> headers = {
      "Authorization" : "Bearer ${storage.read( accessTokenKey )}"
    };

    final payLoad = {
      "code": code,
      "staffAuthId": storage.read( businessIdKey ),
      "method": method
    };

    http.Response response = await http.post( uri, body: jsonEncode( payLoad ), headers: headers );

    print("Redeem status: ${response.statusCode}");
    print("Redeem body: ${response.body}");

    if( response.statusCode == 200 || response.statusCode == 201 ){
      //Get.toNamed(AppRoutes.scannerComplete);
      print("Successsssss: ${response.statusCode}");
      Get.toNamed(AppRoutes.scannerComplete);
    }
  }
}