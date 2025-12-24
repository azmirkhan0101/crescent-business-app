import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mime/mime.dart';
import 'package:organization/data/models/reward/reward_model.dart';
import 'package:organization/utils/api_endpoints.dart';
import 'package:organization/utils/app_constants.dart';
import 'package:http/http.dart' as http;

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../core/show_snackbar.dart';
import '../../utils/app_color.dart';

class EditRewardController extends GetxController{

  final storage = GetStorage();

  RewardModel? model;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController limitController = TextEditingController();
  RxString csvFileName = "".obs;
  Rx<File?>? csvFile = Rx<File?>(null);
  Rx<File?>? rewardImage = Rx<File?>(null);
  RxString rewardImageUrl = "".obs;
  RxBool isUpdating = false.obs;

  DateTime? dateTime;
  RxBool isInstore = true.obs;
  
  RxBool qrCode = false.obs;
  RxBool nfcTap = false.obs;
  RxBool staticCode = false.obs;
  RxBool discountCode = false.obs;
  RxBool giftCard = false.obs;

  //CONTROL CHECK BOXES - AT LEAST ONE VALUE MUST BE TRUE
  void toggleQrCode(bool value) {
    qrCode.value = value;

    if (!qrCode.value && !staticCode.value && !nfcTap.value) {
      qrCode.value = true; // keep at least one true
    }
  }
  void toggleStaticCode(bool value) {
    staticCode.value = value;

    if (!qrCode.value && !staticCode.value && !nfcTap.value) {
      staticCode.value = true;
    }
  }
  void toggleNfcTap(bool value) {
    nfcTap.value = value;

    if (!qrCode.value && !staticCode.value && !nfcTap.value) {
      nfcTap.value = true;
    }
  }

  //CONTROL CHECK BOXES - AT LEAST ONE VALUE MUST REMAIN TRUE
  void toggleDiscountCode(bool value) {
    discountCode.value = value;

    if (!discountCode.value && !giftCard.value) {
      discountCode.value = true; // keep at least one true
    }
  }

  void toggleGiftCard(bool value) {
    giftCard.value = value;

    if (!discountCode.value && !giftCard.value) {
      giftCard.value = true; // keep at least one true
    }
  }

  @override
  void onInit() {

    if (Get.arguments is RewardModel) {
      model = Get.arguments as RewardModel;
    } else {
      model = null;
    }

    initializeValues( model );

    super.onInit();
  }

  initializeValues( RewardModel? model ){
    if( model == null ){
      return;
    }

    isInstore.value = model.type == typeInStore;
    titleController.text = model.title;
    descriptionController.text = model.description;
    dateTime = model.expiryDate;
    limitController.text = model.redemptionLimit.toString();
    if( model.image != null ){
      rewardImageUrl.value = "${model.image}";
    }else{
      rewardImageUrl.value = "";
    }

    if( isInstore.value ){
      qrCode.value = model.inStoreMethods?.qrCode ?? false;
      nfcTap.value = model.inStoreMethods?.nfcTap ?? false;
      staticCode.value = model.inStoreMethods?.staticCode ?? false;
    }else{
      discountCode.value = model.onlineMethods?.discountCode ?? false;
      giftCard.value = model.onlineMethods?.giftCard ?? false;
    }
  }


  //UPDATE INSTORE REWARD
  updateInstoreReward({required String rewardId}) async{

    if( isUpdating.value ){
      return;
    }

    //isUpdating.value = true;

    Uri uri = Uri.parse( ApiEndpoints.baseUrl + ApiEndpoints.updateReward(rewardId: rewardId) );

    Map<String, String> headers = {
      "Content-type" : "application/json",
      "Authorization" : "Bearer ${storage.read( accessTokenKey )}"
    };

    final payLoad = {
      "title": titleController.text.trim().isEmpty ? model?.title : titleController.text.trim(),
      "description": descriptionController.text.trim().isEmpty ? model?.description : descriptionController.text.trim(),
      "category": model?.category,
      "redemptionLimit": model?.redemptionLimit,
      "startDate": model?.startDate,
      "expiryDate": dateTime,
      "featured": model?.featured,
      "isActive": model?.isActive,
      "updateReason": "Updated redemption methods and expiry date",
      "inStoreRedemptionMethods": {
        "qrCode": qrCode.value,
        "staticCode": staticCode.value,
        "nfcTap": nfcTap.value
      },
      "onlineRedemptionMethods": null
    };


    try{
      var request = http.MultipartRequest("PATCH", uri );
      request.headers.addAll({
        "Authorization": "Bearer ${storage.read( accessTokenKey )}",
        "Content-Type": "application/json",
      });

      request.fields["data"] = jsonEncode( payLoad );

      if( rewardImage?.value != null ){
        final compressedImage = await compressImage( rewardImage!.value! );
        if( compressedImage != null ){
          final mimeType =
              lookupMimeType(compressedImage.path)?.split('/') ??
                  ['application', 'octet-stream'];

          request.files.add(
              await http.MultipartFile.fromPath(
                "rewardImage",
                compressedImage.path,
                contentType: http.MediaType(
                  mimeType[0],
                  mimeType[1],
                ),
              )
          );
        }
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if( response.statusCode == 201 ){//REWARD CREATED
        //GO BACK TO REWARDS SCREEN
        //getAllRewards();
        Get.back();
        showSnackBar(
            title: "Done!",
            message: "Reward created successfully",
            backgroundColor: AppColors.successGreen
        );
      }

      print("Status: ${response.statusCode}");
      print("Body: $responseBody");
    }catch(e){
      print("Create error: ${e}");
      showSnackBar(
          title: "No internet!",
          message: "Check your internet connection and try again.",
          backgroundColor: AppColors.errorRed
      );
    }finally{
      // isCreating.value = false;
      // qrCode.value = true;
      // staticCode.value = false;
      // nfcTap.value = false;
      // titleController.clear();
      // descriptionController.clear();
      // rewardImage.value = null;
      // expiryDate = null;
      // redemptionLimitController.clear();
    }
  }



  //COMPRESS IMAGE
  Future<File?> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 50,// 0 - 100
      format: CompressFormat.jpeg,
    );

    return result != null ? File(result.path) : null;
  }
}