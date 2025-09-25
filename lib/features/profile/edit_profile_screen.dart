import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:organization/core/routes/route_path.dart';
import 'package:organization/features/profile/widget/business_profile_image_widget.dart';
import 'package:organization/features/profile/widget/location_widget.dart';
import 'package:organization/features/profile/widget/profile_heading_text_widget.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/assets_path.dart';
import '../../utils/app_size.dart';
import '../../utils/app_text.dart';
import '../../utils/app_text_styles.dart';
import '../widgets/custom_text_field_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,
      ///app bar
      appBar: AppBar(
        scrolledUnderElevation:0,
        clipBehavior: Clip.none,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.w),
          onPressed: () {
            context.pop();
          },
        ),
        title:
        CustomText(text:   'Edit Profile',fontSize: 18.sp,fontWeight: FontWeight.w700,
        color: AppColors.blackTextColor,
        ),


        // Text(
        //   'Edit Profile',
        //   style: AppTextStyle.headlineLStyle.copyWith(fontSize: 17.sp),
        // ),
        actions: [
          IconButton(
            icon: Icon(Icons.done, size: 20.w),
            onPressed: () {
             // context.push(RoutesPath.home);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Cover image
            BusinessProfileWidget(
              /// Cover image edit button
              topEdit: Positioned(
                right: 12.w,
                top: 20.h,
                child: Container(
                 padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: AppColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: CustomAssetsImage(assetsPath: AssetsPath.editIcon,color: AppColors.white,height: 14.h,width: 14.w,)),
                ),
              ),

              /// Profile image edit button
              profileCenterEdit: Positioned(
                bottom: 0,
                right: 0,
                child:GestureDetector(
                  onTap: (){
                    context.push(RoutesPath.uploadLogo);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    //padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      color: AppColors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: CustomAssetsImage(assetsPath: AssetsPath.editIcon,color: AppColors.white,height: 14.h,width: 14.w,)),
                  ),
                ),
              ),
            ),

            SizedBox(height: 60.h),

            /// Form fields
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// name
                  ProfileHeadingTextWidget(title: AppText.name),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    hintText: "Sweet Whisk Bakery",
                  ),
                  SizedBox(height: 16.h),
                  /// tagline
                  ProfileHeadingTextWidget(title: AppText.tagline),
                  CustomTextField(
                    hintText: "Whipping Up Smiles, One Treat at a Time!",
                  ),
                  SizedBox(height: 16.h),
                  /// description
                  ProfileHeadingTextWidget(title: AppText.description),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    maxLines: 5,
                    hintText: AppText.sweetWhiskDescription,

                    ),



                  SizedBox(height: 16.h),
                  /// globalization
                  ProfileHeadingTextWidget(title: AppText.website),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    prefixImagePath:
                   AssetsPath.globeIcon,


                    hintText: "sweetwhiskbakery.com",
                  ),
                  SizedBox(height: 16.h),
                  /// business phone
                  ProfileHeadingTextWidget(title: AppText.businessPhone),
                  CustomTextField(
                    prefixImagePath:
                      AssetsPath.callIcon,
                    hintText: "(555) 123-4567",
                  ),
                  SizedBox(height: 16.h),
                  /// email
                  ProfileHeadingTextWidget(title: AppText.email),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    prefixImagePath:
                       AssetsPath.mailIcon,
                    hintText: "contact@sweetwhiskbakery.com",
                 ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            /// location title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileHeadingTextWidget(title: AppText.location),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add, color: AppColors.black, size: 20.w),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            /// location 1
            LocationWidget(
              headingText: AppText.location1,
              fieldText: AppText.store1Address,
              deleteTap: () {},
            ),
            SizedBox(height: 16.h),

            /// location 2
            LocationWidget(
              headingText: AppText.location2,
              fieldText: AppText.store1Address,
              deleteTap: () {},
            ),
          ],
       ),
      ),
    );
  }
}
