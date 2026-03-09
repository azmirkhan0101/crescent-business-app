import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/core/api_response.dart';
import 'package:organization/core/api_service.dart';
import 'package:organization/core/show_snackbar.dart';
import 'package:organization/data/models/redeem/redeemed_model.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_color.dart';

import '../../routes/app_pages.dart';
import '../../utils/app_constants.dart';

class RedeemController extends GetxController {
  final ApiService apiService = Get.find<ApiService>();
  final storage = GetStorage();

  //RxString nfcTag = "".obs;
  RxBool isStaticCodeInvalid = false.obs;

  //REDEEM REWARD
  Future<void> redeemReward({
    required String code,
    required String method,
  }) async {
    if (code.isEmpty) {
      if (method == "static-code") {
        isStaticCodeInvalid.value = true;
      }
      showSnackBar(
        title: "Code required!",
        message: "Enter codes to redeem.",
        backgroundColor: AppColors.warningYellow,
      );
      return;
    }
    final payLoad = {
      "code": code,
      "staffAuthId": storage.read(businessAuthIdKey),
      "method": method,
    };

    ApiResponse response = await apiService.networkRequest(
      method: "POST",
      isAuthRequired: true,
      endPoint: ApiEndpoints.redeemReward,
      body: payLoad,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      RedeemedRewardModel redeemedRewardModel = RedeemedRewardModel.fromJson(
        response.data['data'],
      );
      isStaticCodeInvalid.value = false;
      Get.toNamed(AppRoutes.scannerComplete, arguments: redeemedRewardModel);
    } else {
      if (method == "static-code") {
        isStaticCodeInvalid.value = true;
      }
      showSnackBar(
        title: "Invalid codes!",
        message: "Please enter valid codes and try again.",
        backgroundColor: AppColors.warningYellow,
      );
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
