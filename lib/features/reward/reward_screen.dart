import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/controller/reward/reward_controller.dart';
import 'package:organization/features/reward/widget/filter_button.dart';
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
  RxBool switchActive = false.obs;

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
            onPressed: () {
              Get.toNamed(AppRoutes.createReward);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.grey06),
            ),
            icon: Icon(Icons.add, color: AppColors.black),
          ),
        ],
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          //get all rewards on refresh - no filter
          controller.selectedFilter.value = "all";
          controller.isFilterLoading.value = false;
          await controller.getAllRewards();
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),

          child: Obx(() {
            if (controller.isLoading.value == true &&
                controller.isFilterLoading.value == false &&
                controller.rewards.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (controller.isLoading.value == false &&
                controller.selectedFilter.value == "all" &&
                controller.rewards.isEmpty) {
              return noReward(context);
            } else {
              return Column(
                children: [
                  SingleChildScrollView(
                    controller: controller.scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Row(
                        spacing: 12.w,
                        children: [
                          FilterButton(
                            title: "All",
                            value: "all",
                            selected: controller.selectedFilter,
                            onTap: () {
                              controller.selectedFilter.value = "all";
                              controller.isFilterLoading.value = true;
                              controller.getAllRewards();
                            },
                          ),
                          FilterButton(
                            title: "Active",
                            value: "active",
                            selected: controller.selectedFilter,
                            onTap: () {
                              controller.selectedFilter.value = "active";
                              controller.isFilterLoading.value = true;
                              controller.getAllRewards();
                            },
                          ),
                          FilterButton(
                            title: "Disabled",
                            value: "disabled",
                            selected: controller.selectedFilter,
                            onTap: () {
                              controller.selectedFilter.value = "disabled";
                              controller.isFilterLoading.value = true;
                              controller.getAllRewards();
                            },
                          ),
                          FilterButton(
                            title: "Expiring soon",
                            value: "expires_soon",
                            selected: controller.selectedFilter,
                            onTap: () {
                              controller.selectedFilter.value = "expires_soon";
                              controller.isFilterLoading.value = true;
                              controller.getAllRewards();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(() {
                    if (controller.isFilterLoading.value == true ) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (controller.isFilterLoading.value == false &&
                        controller.rewards.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Center(child: Text("No rewards found!")),
                      );
                    } else {
                      return rewardList(context: context);
                    }
                  }),
                  SizedBox(height: 15.h,),
                  Obx((){
                    if (controller.isMoreLoading.value){
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }else{
                      return SizedBox.shrink();
                    }

                  }),
                  SizedBox(height: 90.h),
                ],
              );
            }
          }),
        ),
      ),
    );
  }

  //NO REWARD
  noReward(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              textAlign: TextAlign.center,
              maxLines: 4,
              "Track redemptions, edit existing rewards, or add something new to surprise your customers.",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: AppColors.secondaryTextColor,
              ),
            ),
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
          SizedBox(height: 50.h),
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
        RxBool rewardIsActive = model.isActive.obs;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          child: Obx(() {
            return RewardCard(
              image: model.image,
              title: model.title,
              expiryDate: model.expiryDate,
              redemptions: model.redemptions,
              isActive: rewardIsActive.value,
              type: model.type,
              isQr: isQr,
              isNfc: isNfc,
              isStaticCode: isStaticCode,
              isGiftCard: isGiftCard,
              isDiscountCode: isDiscountCode,
              onDeleteClick: () {
                showRewardDeleteDialog(rewardId: model.id, index: index );
              },
              onStatusChanged: (bool newStatus) {
                rewardIsActive.value = newStatus;
                //STATUS UPDATE API CALL
                controller.updateRewardStatus(
                  rewardId: model.id,
                  isActive: newStatus,
                );
              },
              onEditClick: () {
                Get.toNamed(AppRoutes.editReward, arguments: model);
              },
            );
          }),
        );
      },
    );
  }

  //DELETE ALERT
  void showRewardDeleteDialog({required String rewardId, required int index}) {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.delete, color: AppColors.red),
              Text(
                "Delete Reward",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete this reward?",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          actions: [
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12.w), // Spacing between buttons
                // Delete button
                Expanded(
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        controller.deleteReward( rewardId: rewardId, index: index );
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
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //REWARD DELETE BOTTOM SHEET
  // void showDeleteBottomSheet( String rewardId ) {
  //   Get.bottomSheet(
  //     BottomSheetWidget(
  //       title: "Delete Reward",
  //       description: "Are you sure you want to delete this reward? This action cannot be undone.",
  //       primaryButtonText: "Delete",
  //       secondaryButtonText: "Cancel",
  //       onPrimaryPressed: () {
  //         Get.back(closeOverlays: true);
  //         controller.deleteReward( rewardId );
  //       },
  //       onSecondaryPressed: () {
  //         Get.back(closeOverlays: true);
  //       },
  //     ),
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //   );
  // }
}
