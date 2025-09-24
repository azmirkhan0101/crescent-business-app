import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/features/widgets/custom_button_widget.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_size.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/app_text_styles.dart';
import '../../utils/assets_path.dart';

import '../core/routes/route_path.dart';
import 'auth/widgets/rich_text_widget.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.h),
              /// heading text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetsPath.moonIcon,
                    height: AppSizes.moonIconH,
                    width: AppSizes.moonIconW,
                  ),
                  Text(
                    AppText.crescentChange,
                    style: AppTextStyle.headlineLStyle.copyWith(
                      fontSize: AppSizes.headlineM,
                    ),
                  ),
                ],
              ),
              /// welcome image
              Image.asset(
                AssetsPath.getStartedImage,
                height: AppSizes.getStartedImageH,
                width: AppSizes.getStartedImageW,
              ),
              /// text  section
              Text(
                textAlign: TextAlign.center,
                AppText.turnSpareChange,
                style: AppTextStyle.headlineLStyle,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 40.w,
                  right: 40.w,
                  top: 12.h,
                  bottom: 30.h,
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  AppText.joinMovement,
                  style: AppTextStyle.mediumStyle,
                ),
              ),
            /// loading
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 CustomAssetsImage(assetsPath: AssetsPath.loadingStarIcon,height: 12.5.h,width: 12.5.w,),
                  SizedBox(width: 1.5.w,),
                  CustomAssetsImage(assetsPath: AssetsPath.loadingDotIcon,height: 10.h,width: 10.w,),
                  SizedBox(width: 1.5.w,),
                  CustomAssetsImage(assetsPath: AssetsPath.loadingDotIcon,height: 10.h,width: 10.w,),
              ],
              ),
            ],
          ),
        ),
               ///button and login text
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: 50.h,
          ),
          child:       Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(text: AppText.getStarted, onPressed: () {
                context.push(RoutesPath.signIn);
              },
                buttonTextStyle: GoogleFonts.familjenGrotesk(
                color: AppColors.buttonTextColor,fontSize: 18.sp,fontWeight: FontWeight.w700),

              ),
              SizedBox(height: 12.h,),
              RichTextWidget(firstText:AppText.alreadyHaveAccount, lastText: AppText.login, onTap: () {
                context.push(RoutesPath.signIn);
              },),
            ],
          )
        ),

      ),
    );
  }
}


