import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/data/models/redeem/redeemed_model.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';

import '../../routes/app_pages.dart';
import '../../utils/app_constants.dart';

class RedeemController extends GetxController{

  final storage = GetStorage();
  //RxString nfcTag = "".obs;
  RxBool isStaticCodeInvalid = false.obs;

  //SIMULATION
  redeemReward2({required String code, required String method}) async{
    RedeemedRewardModel redeemedRewardModel = RedeemedRewardModel.fromJson( redeemResponse );
    isStaticCodeInvalid.value = false;
    Get.toNamed(AppRoutes.scannerComplete, arguments: redeemedRewardModel );
  }

  //REDEEM REWARD
  redeemReward({required String code, required String method}) async{

    if( code.isEmpty ){
      if( method == "static-code" ){
        isStaticCodeInvalid.value = true;
      }
      showSnackBar(title: "Code required!", message: "Enter codes to redeem.", backgroundColor: AppColors.warningYellow);
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

      http.Response response = await http.post( uri, body: jsonEncode( payLoad ), headers: headers );
      print("Redeem: ${response.statusCode}");
      print("Redeem: ${response.body}");

      if( response.statusCode == 200 || response.statusCode == 201 ){
        RedeemedRewardModel redeemedRewardModel = RedeemedRewardModel.fromJson( jsonDecode( response.body ) );
        isStaticCodeInvalid.value = false;
        Get.toNamed(AppRoutes.scannerComplete, arguments: redeemedRewardModel );
      }else{
        if( method == "static-code" ){
          isStaticCodeInvalid.value = true;
        }
        showSnackBar(title: "Invalid codes!", message: "Please enter valid codes and try again.", backgroundColor: AppColors.warningYellow);
      }
    }catch(e){
      print("Redeem catch: $e");
      showSnackBar(title: "Something went wrong!", message: "Please check your internet connection and try again.", backgroundColor: AppColors.warningYellow);
    }
  }

  //NFC REDEEM
  // Future<void> startNfcRead() async {
  //   final availability = await NfcManager.instance.checkAvailability();
  //   if (availability != NfcAvailability.enabled){
  //     showSnackBar(title: "NFC Unavailable!", message: "NFC is not available on this device.", backgroundColor: AppColors.warningYellow);
  //     return;
  //   }else{
  //     showSnackBar(title: "NFC is available!", message: "NFC sensor found on this device.", backgroundColor: AppColors.successGreen);
  //   }
  //
  //   NfcManager.instance.startSession(
  //     pollingOptions: {NfcPollingOption.iso14443},
  //     onDiscovered: (NfcTag tag) async {
  //       final ndef = Ndef.from(tag);
  //
  //       if (ndef == null || ndef.cachedMessage == null) {
  //         NfcManager.instance.stopSession();
  //         return;
  //       }
  //
  //       nfcTag.value = ndef.toString();
  //       redeemReward(code: ndef?.toString() ?? "", method: "nfc");
  //
  //       NfcManager.instance.stopSession();
  //     },
  //   );
  // }

//sample response
final redeemResponse = {
  "_id": "6936fb00af5237d44d7883ce",
  "user": "69301feaddbf3fdf987e86e8",
  "reward": {
    "_id": "6936d61243232039a271a5f3",
    "title": "Free Tea",
    "description": "Get a free coffee with any purchase above \$10",
    "type": "in-store",
    "category": "food",
    "redeemedCount": 120,
    "image": "htttp://www.imageurl.com"
  },
  "business": {
    "_id": "6936d5e943232039a271a5ea",
    "name": "TechMart BD",
    "locations": [
      "Dhaka",
      "Chattogram",
      "Sylhet"
    ]
  },
  "pointsSpent": 500,
  "status": "redeemed",
  "assignedCode": "698929DDD596",
  "availableRedemptionMethods": [
    "qr",
    "static-code",
    "nfc"
  ],
  "expiresAt": "2026-01-07T16:21:20.917Z",
  "idempotencyKey": "df325cb190dc276a8484544264c398fb",
  "claimedAt": "2025-12-08T16:21:20.918Z",
  "createdAt": "2025-12-08T16:21:20.919Z",
  "updatedAt": "2025-12-11T10:31:21.779Z",
  "redeemedAt": "2025-12-11T10:31:21.774Z",
  "redemptionMethod": "static-code",
  "redeemedByStaff": "6936d5e943232039a271a5ea"
};


}