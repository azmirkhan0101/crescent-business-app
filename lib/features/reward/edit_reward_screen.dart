import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organization/features/reward/widget/expiry_limit_section.dart';
import 'package:organization/features/reward/widget/redemption_methods_section.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';

import '../../controller/reward/reward_controller.dart';
import '../../routes/app_pages.dart';
import '../../utils/app_color.dart';
import '../../utils/app_text.dart';
import '../on_boarding/widgets/bottom_button_widget.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/text_field_title_widget.dart';

class EditRewardScreen extends StatelessWidget {

  final RewardController controller = Get.find<RewardController>();
  bool isInstoreTabSelected = true;//GET IT FROM ARGS
  String imageUrl2 = "https://plus.unsplash.com/premium_photo-1683749809341-23a70a91b195?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fHJld2FyZHxlbnwwfHwwfHx8MA%3D%3D";
  String imageUrl = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Edit Reward',
          style: AppTextStyle.headlineLStyle.copyWith(fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reward Details',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.blackTextColor,
              ),
            ),
            SizedBox(height: 12.h),

            // reward name
            TextFieldTitleWidget(text: "Reward name"),
            SizedBox(height: 8.h),
            CustomTextField(
              hintText: "10% Off Latte",
              controller: controller.titleController,
            ),
            SizedBox(height: 16.h),
            //description
            TextFieldTitleWidget(text: AppText.description),
            CustomTextField(
              hintText: "Get a free coffee on your next visit.",
              maxLines: 3,
              controller: controller.descriptionController,
            ),
            ///upload image section
            SizedBox(height: 20.h),
            ///upload image section
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomCard(
                  height: 100.h,
                  width: 100.w,
                  child: Obx((){
                    return buildRewardImage();
                  })
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        height: 40,
                        buttonTextStyle: AppTextStyle.buttonTextStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),

                        backgroundColor: Color(0x26C08FFF),
                        width: double.infinity,
                        text: "Change Image",
                        onPressed: () {
                          showBottomSheet(context);
                        },
                      ),
                      SizedBox(height: 10,),
                      CustomButton(
                        height: 40,
                        buttonTextStyle: AppTextStyle.buttonTextStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white
                        ),

                        backgroundColor: AppColors.errorRed,
                        width: double.infinity,
                        text: "Delete image",
                        onPressed: () {
                          controller.rewardImage.value = null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            //EXPIRY DATE AND LIMIT
            ExpiryLimitSection(
              controller: controller.redemptionLimitController,
              onDateSelected: (date){
                controller.expiryDate = date;
              },
            ),
            SizedBox(height: 25),

            //RedemptionMethodsSection
            /// RedemptionMethodsSection
            Obx((){
              return RedemptionMethodsSection(
                qrCode: controller.qrCode.value,
                nfcTap: controller.nfcTap.value,
                staticCode: controller.staticCode.value,
                onQRCodeChanged: (isChecked){
                  controller.qrCode.value = isChecked;
                },
                onNfcTapChanged: (isChecked){
                  controller.nfcTap.value = isChecked;
                },
                onStaticCodeChanged: (isChecked){
                  controller.staticCode.value = isChecked;
                }, onTabChanged: (bool instoreTabSelected) {
                isInstoreTabSelected = instoreTabSelected;
              },
                //ONLINE OPTIONS
                discountCode: controller.discountCode.value,
                giftCard: controller.giftCard.value,
                onDiscountCodeChanged: (bool isChecked) {
                  controller.discountCode.value = isChecked;
                }, onGiftCardChanged: (bool isChecked) {
                controller.giftCard.value = isChecked;
              },
              );
            }),
            SizedBox( height: 20.h,),
            BottomButtonWidget(
                onPressed: (){
                  print("Online reward:");
                  if( isInstoreTabSelected ){//INSTORE REWARD
                    controller.createRewardInStore();
                  }else{//ONLINE REWARD
                    print("Online reward: ${controller.discountCode.value},,,,${controller.giftCard.value}");
                  }
                },
                buttonText: "Update"
            )
          ],
        ),
      )
    );
  }


  //SHOW BOTTOM SHEET
  showBottomSheet( BuildContext context ){
    Get.bottomSheet(BottomSheet(
        onClosing: (){},
        backgroundColor: AppColors.primaryColor,
        enableDrag: true,
        builder: (context){
      return Container(
        height: 150.h,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: (){
              if( Get.isBottomSheetOpen ?? false ){
                Get.back();
              }
              pickCameraImage();
            },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successGreen
                ),
                child: Text("Camera", style: TextStyle(color: AppColors.white),)),
            ElevatedButton(onPressed: (){
              if( Get.isBottomSheetOpen ?? false ){
                Get.back();
              }
              pickGalleryImage();
            }, style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen
            ),child: Text("Gallery", style: TextStyle(color: AppColors.white),)),
          ],
        ),
      );
    }));
  }

  //PICK REWARD IMAGE FROM GALLERY
  Future<void> pickGalleryImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      controller.rewardImage.value = File(image.path);
    }
  }

  //PICK REWARD IMAGE FROM CAMERA
  Future<void> pickCameraImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      controller.rewardImage.value = File(image.path);
    }
  }


//SHOW IMAGE BASED ON DATA
  Widget buildRewardImage() {
    if ( controller.rewardImage.value != null ) {
      return Image.file(controller.rewardImage.value!, fit: BoxFit.cover);
    } else if ( imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network( imageUrl!, fit: BoxFit.cover);
    }
    return Icon(Icons.image, size: 50.r, color: Colors.grey);
  }


}
