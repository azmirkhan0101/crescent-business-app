import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/controller/reward/reward_controller.dart';
import 'package:organization/features/reward/widget/reward_card_widget.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/features/widgets/custom_button_widget.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_constants.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';

import '../../data/models/reward/reward_model.dart';
import '../../routes/app_pages.dart';
import '../widgets/bottom_sheet_widget.dart';

class RewardScreen extends StatelessWidget {
  final RewardController controller = Get.find<RewardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          "Reward",
          style: AppTextStyle.headlineLStyle.copyWith(fontSize: 20.sp),
        ),
        actions: [
          IconButton(
              onPressed: (){
                Get.toNamed(AppRoutes.createReward);
              },
              style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.grey06)),
              icon: Icon(Icons.add, color: AppColors.black,)
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async{
          await controller.getAllRewards();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),

          child: Obx(() {
          if (controller.isLoading.value == true && controller.rewards.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.isLoading.value == false &&
              controller.rewards.isEmpty) {
            return noReward( context );
          } else {
            return Column(
              children: [
                rewardList(context: context),
                SizedBox(height: 90.h),
              ],
            );
          }
                    }),
      ),
      )
    );
  }

  //NO REWARD
  noReward( BuildContext context ) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomAssetsImage(
            assetsPath: AssetsPath.stackCardImage,
            height: 176.h,
            width: 285.w,
          ),
          Text(
            "Manage Your Rewards",
            style: AppTextStyle.headlineLStyle.copyWith(fontSize: 18.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            textAlign: TextAlign.center,
            maxLines: 3,
            "Track redemptions, edit existing rewards, or add something new to surprise your customers.",
            style: AppTextStyle.mediumStyle,
          ),
          SizedBox(height: 12.h),
          CustomButton(
            backgroundColor: const Color(0x26C08FFF),
            widget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 23, color: AppColors.buttonTextColor),
                SizedBox(width: 3.w),
                Text(
                  "Add Reward",
                  style: AppTextStyle.buttonTextStyle.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            onPressed: () {
              print("Id: ${controller.storage.read(businessIdKey)}");
              Get.toNamed(AppRoutes.createReward);
              //controller.getAllRewards();
              //controller.getRewardAnalyticsStats();
            },
            text: AppText.continueText,
            buttonTextStyle: GoogleFonts.familjenGrotesk(
              color: AppColors.buttonTextColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 50.h,)
        ],
      ),
    );
  }

  //REWARD LIST
  rewardList({required BuildContext context}) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.rewards.length,
      itemBuilder: (context, index) {
        RewardModel model = controller.rewards[index];

        //INSTORE REDEMPTIONS
        final bool isQr = model.inStoreMethods?.qrCode ?? false;
        final bool isNfc = model.inStoreMethods?.nfcTap ?? false;
        final bool isStaticCode = model.inStoreMethods?.staticCode ?? false;
        //ONLINE REDEMPTIONS
        final bool isGiftCard = model.onlineMethods?.giftCard ?? false;
        final bool isDiscountCode = model.onlineMethods?.discountCode ?? false;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          child: RewardCard(
            title: model.title,
            expiryDate: model.expiryDate.toString(),
            redemptions: model.redemptions,
            isActive: model.isActive,
            type: model.type,
            isQr: isQr,
            isNfc: isNfc,
            isStaticCode: isStaticCode,
            isGiftCard: isGiftCard,
            isDiscountCode: isDiscountCode,
            onDeleteClick: (){
              showDeleteBottomSheet( model.id );
              //showRewardDeleteDialog( model.id );
            }
          ),
        );
      },
    );
  }

  //REWARD DELETE BOTTOM SHEET
  void showDeleteBottomSheet( String rewardId ) {
    Get.bottomSheet(
      BottomSheetWidget(
        title: "Delete Reward",
        description: "Are you sure you want to delete this reward? This action cannot be undone.",
        primaryButtonText: "Delete",
        secondaryButtonText: "Cancel",
        onPrimaryPressed: () {
          Get.back(closeOverlays: true);
          controller.deleteReward( rewardId );
        },
        onSecondaryPressed: () {
          Get.back(closeOverlays: true);
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
  //TODO: DELETE THIS IF DIALOG CLOSE DOES NOT WORK. THE ABOVE BOTTOM SHEET WILL DO THE WORK
  //DELETE ALERT
  void showRewardDeleteDialog( String rewardId ) {
    Get.defaultDialog(
      title: "Delete Reward",
      titleStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      middleText: "Are you sure you want to delete this reward?",
      middleTextStyle: const TextStyle(
        fontSize: 15,
        color: Colors.black54,
      ),
      barrierDismissible: true,
      confirm: Container(
        height: 42,
        width: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFE53935), // Soft red for delete
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: () {
            Get.back(closeOverlays: true);
            controller.deleteReward( rewardId );
          },
          child: const Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      cancel: Container(
        height: 42,
        width: 120,
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE), // Light grey background
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: () {
            //Get.back();
            Navigator.of(Get.context!).pop();//TODO: DIALOG NOT CLOSING
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
