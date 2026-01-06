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

      if( response.statusCode == 200 || response.statusCode == 201 ){
        RedeemedRewardModel redeemedRewardModel = RedeemedRewardModel.fromJson( (jsonDecode( response.body ))['data'] );
        isStaticCodeInvalid.value = false;
        Get.toNamed(AppRoutes.scannerComplete, arguments: redeemedRewardModel );
      }else{
        if( method == "static-code" ){
          isStaticCodeInvalid.value = true;
        }
        showSnackBar(title: "Invalid codes!", message: "Please enter valid codes and try again.", backgroundColor: AppColors.warningYellow);
      }
    }catch(e){
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

}