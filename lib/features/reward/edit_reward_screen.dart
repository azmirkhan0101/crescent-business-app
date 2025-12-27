import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organization/controller/reward/edit_reward_controller.dart';
import 'package:organization/features/reward/widget/custom_checkbox.dart';
import 'package:organization/features/reward/widget/edit_expiry_limit_section.dart';
import 'package:organization/features/reward/widget/expiry_limit_section.dart';
import 'package:organization/features/reward/widget/online_options_widget.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:organization/utils/app_text_styles.dart';

import '../../utils/app_color.dart';
import '../../utils/app_text.dart';
import '../on_boarding/widgets/bottom_button_widget.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/text_field_title_widget.dart';

class EditRewardScreen extends StatelessWidget {

  final EditRewardController controller = Get.find<EditRewardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
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
              hintText: "",
              controller: controller.titleController,
            ),
            SizedBox(height: 16.h),
            //description
            TextFieldTitleWidget(text: AppText.description),
            CustomTextField(
              hintText: "",
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
                          controller.rewardImage?.value = null;
                          controller.rewardImageUrl.value = "";
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            //EXPIRY DATE AND LIMIT
            Obx((){
              return EditExpiryLimitSection(
                initialDate: controller.dateTime,
                controller: controller.limitController,
                onDateSelected: (date){
                  controller.dateTime = date;
                }, isInstore: controller.isInstore.value,
              );
            }),
            SizedBox(height: 25),

            //RedemptionMethodsSection
            Text("Select redemption methods:",
            style: TextStyle(color: AppColors.black,
            fontSize: 15.sp,
              fontWeight: FontWeight.w500
            ),
            ),
            Obx((){
              if( controller.isInstore.value ){
                return inStoreOptions();
              }else{
                String fileName = controller.csvFileName.value;
                if( fileName.isEmpty ){
                  fileName = "Discount Codes";
                }
                return OnlineOptions(
                  fileName: fileName,
                  onPickFile: (){
                    pickCSV();
                  },
                  onDelete: (){
                    controller.csvFile?.value = null;
                  },
                  discountCode: controller.discountCode.value,
                  giftCard: controller.giftCard.value,
                  onDiscountCodeChanged: (bool isChecked) {
                    controller.toggleDiscountCode( isChecked );
                  }, onGiftCardChanged: (bool isChecked) {
                  controller.toggleGiftCard( isChecked );
                },
                );
              }
            }),
            SizedBox( height: 20.h,),
            Center(child:
            Obx((){
              return CustomButton(
                isLoading: controller.isUpdating.value,
                text: "Save",
                onPressed: () {
                  if( controller.isInstore.value ){//INSTORE REWARD
                    controller.updateInstoreReward();
                  }else{//ONLINE REWARD
                    controller.updateOnlineReward();
                  }
                },
                buttonTextStyle: GoogleFonts.familjenGrotesk(
                  color: AppColors.buttonTextColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              );
            }),),
            SizedBox( height: 40.h,),
          ],
        ),
      )
    );
  }


  //SHOW BOTTOM SHEET
  showBottomSheet( BuildContext context ){
    Get.bottomSheet(BottomSheet(
        onClosing: (){},
        backgroundColor: AppColors.white,
        enableDrag: true,
        builder: (context){
      return Container(
        height: 150.h,
        child: Column(
          children: [
            SizedBox(height: 25.h,),
            Text("Select option to upload photo"),
            SizedBox(height: 15.h,),
            Row(
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
                      backgroundColor: AppColors.primaryColor
                    ),
                    child: Text("Camera", style: TextStyle(color: AppColors.white),)),
                ElevatedButton(onPressed: (){
                  if( Get.isBottomSheetOpen ?? false ){
                    Get.back();
                  }
                  pickGalleryImage();
                }, style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor
                ),child: Text("Gallery", style: TextStyle(color: AppColors.white),)),
              ],
            ),
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
      controller.rewardImage?.value = File(image.path);
    }
  }

  //PICK REWARD IMAGE FROM CAMERA
  Future<void> pickCameraImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      controller.rewardImage?.value = File(image.path);
    }
  }


//SHOW IMAGE BASED ON DATA
  Widget buildRewardImage() {
    if ( controller.rewardImage?.value != null ) {
      return Image.file(controller.rewardImage!.value!, fit: BoxFit.cover);
    } else if ( controller.rewardImageUrl.value != null && controller.rewardImageUrl.value!.isNotEmpty) {
      return Image.network(
        controller.rewardImageUrl.value!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.redeem,
              size: 100.r,
              color: Colors.white,
            ),
          );
        },
      );
    }
    return Icon(Icons.image, size: 50.r, color: Colors.grey);
  }


  //INSTORE OPTIONS
  inStoreOptions() {
    return Column(
      children: [
        Obx((){
          return CustomCard(
              height: 52.h,
              child: CustomCheckbox(
                  title: "QR Code",
                  isChecked: controller.qrCode.value,
                  onChanged: (isChecked){
                    controller.toggleQrCode( isChecked ?? false );
                  }
              )
          );
        }),
        SizedBox(height: 8.h),
        Obx((){
          return CustomCard(
              height: 52.h,
              child: CustomCheckbox(
                  title: "NFC Tap",
                  isChecked: controller.nfcTap.value,
                  onChanged: (isChecked){
                    controller.toggleNfcTap( isChecked ?? false );
                  }
              )
          );
        }),
        SizedBox(height: 8.h),
        Obx((){
          return CustomCard(
              height: 52.h,
              child: CustomCheckbox(
                  title: "Static Code",
                  isChecked: controller.staticCode.value,
                  onChanged: (isChecked){
                    controller.toggleStaticCode( isChecked ?? false );
                  }
              )
          );
        })
      ],
    );
  }

  //PICK CSV FILE FOR DISCOUNT CODES - ONLINE REWARD
  Future<void> pickCSV() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null && result.files.single.path != null) {
      controller.csvFileName.value = result.files.single.name;
      controller.csvFile?.value = File(result.files.single.path!);
    }
  }


}
