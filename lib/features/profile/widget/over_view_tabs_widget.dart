import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:organization/data/models/profile/business_profile_model.dart';
import 'package:organization/features/profile/widget/profile_heading_text_widget.dart';
import 'package:organization/features/widgets/custom_card_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/features/widgets/info_card_widget.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';

class OverviewTab extends StatelessWidget {

  final BusinessProfileModel model;
  OverviewTab({
    required this.model
});

  RxList<String> storeLocations = <String>[].obs;

  @override
  Widget build(BuildContext context) {

    storeLocations.value = model.locations ?? [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InfoCard(
                  gradientColor1: Color(0xFFF3EAFE), // 5% opacity
                  gradientColor2: Color(0xFFE9D9FB), // 10% opacity
                  gradientColor3: Color(0xFFD8C2F6), // 40% opacity
                  icon: Assets.icons.globe,
                  title: AppText.website,
                  subtitle: model.businessWebsite,
                  iconBgColor: Color(0xFFE2D4F9),
                  iconColor: Color(0xFF9B6DFF),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: InfoCard(
                  iconColor: Color(0xFF4CAF50),
                  gradientColor1: Color(0xFFF0FFD9), // 5% opacity
                  gradientColor2: Color(0xFFE6FBCB), // 10% opacity
                  gradientColor3: Color(0xFFD2F7A2), // 40% opacity
                  icon: Assets.icons.call,
                  title: AppText.businessPhone,
                  subtitle: model.businessPhoneNumber,

                  iconBgColor: Color(0xFFDBF7B6),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          InfoCard(
            height: 120.h,
            width: double.infinity,
            gradientColor1: Color(0xFFFFFFE0), // 5% opacity
            gradientColor2: Color(0xFFFFF9D9), // 10% opacity
            gradientColor3: Color(0xFFFFF2B0), // 40% opacity
            icon: Assets.icons.mail,
            title: AppText.email,
            subtitle: model.businessEmail,
            iconBgColor: Color(0xFFFFF2C2),
            iconColor: Color(0xFFFFC107),
          ),
          SizedBox(height: 12.h),
          ProfileHeadingTextWidget(title: "Overview"),
          SizedBox(height: 12.h),
          CustomCard(
            child: CustomText(
              text: model.description,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.justify,
              maxLines: null,
              language: false,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.blackTextColor,
            ),
          ),
          ProfileHeadingTextWidget(title: AppText.location),
          Obx((){
            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: storeLocations.length,
                itemBuilder: (context, index){
              return locationItem(locationName: storeLocations[index]);
                });
          }),
          SizedBox(
            height: 80.h,
          )
        ],
      ),
    );
  }


  //LOCATION ITEM
locationItem({required String locationName}){
    return CustomCard(
      height: 52.h,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(Assets.icons.location),
          SizedBox(width: 8.w),
          Expanded(
            child: CustomText(
              text: locationName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              language: false,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: AppColors.blackTextColor,
              textAlign: TextAlign.left
            ),
          ),
        ],
      ),
    );
}
}
