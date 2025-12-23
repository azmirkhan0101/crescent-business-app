import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:organization/data/models/reward/reward_model.dart';
import 'package:organization/utils/app_constants.dart';

class EditRewardController extends GetxController{

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


  updateReward(){

    if( isUpdating.value ){
      return;
    }

    isUpdating.value = true;

  }
}