import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/controller/analytics/analytics_exporter.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/features/widgets/custom_button_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text.dart';

import '../../utils/assets_path.dart';
import 'auth/widgets/rich_text_widget.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                    height: 32.h,
                    width: 32.w,
                  ),
                  CustomText(
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.visible,
                    text: AppText.crescentChange,
                    fontWeight: FontWeight.w700,
                    language: true,
                    color: AppColors.headlineTColor,
                    fontSize: 20.sp,
                  ),
                ],
              ),

              /// welcome image
              Image.asset(
                "assets/images/get_started_image.png",
                height: 304.h,
              ),

              /// text  section
              CustomText(
                //textAlign: TextAlign.justify,
                overflow: TextOverflow.visible,
                text: AppText.turnSpareChange,
                fontWeight: FontWeight.w700,
                language: true,
                color: AppColors.headlineTColor,
                fontSize: 28.sp,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              CustomText(
                text: AppText.joinMovement,
                fontWeight: FontWeight.w400,
                language: true,
                color: AppColors.secondaryTextColor,
                fontSize: 18.sp,
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),

              SizedBox(height: 12.h),
              AnimatedLoadingRow(),
              /// loading
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     CustomAssetsImage(
              //       assetsPath: AssetsPath.loadingStarIcon,
              //       height: 15.h,
              //       width: 15.w,
              //     ),
              //     SizedBox(width: 1.5.w),
              //     CustomAssetsImage(
              //       assetsPath: AssetsPath.loadingDotIcon,
              //       height: 12.h,
              //       width: 12.w,
              //     ),
              //     SizedBox(width: 1.5.w),
              //     CustomAssetsImage(
              //       assetsPath: AssetsPath.loadingDotIcon,
              //       height: 12.h,
              //       width: 12.w,
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),

      ///button and auth text
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 50.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              text: AppText.getStarted,
              onPressed: () {
                Get.toNamed(AppRoutes.categorySelection);
              },
              buttonTextStyle: GoogleFonts.familjenGrotesk(
                color: AppColors.buttonTextColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),
            RichTextWidget(
              firstText: AppText.alreadyHaveAccount,
              lastText: AppText.login,
              onTap: () {
                Get.toNamed(AppRoutes.logIn);
              },
            ),
          ],
        ),
      ),
    );
  }
}




class AnimatedLoadingRow extends StatefulWidget {
  @override
  _AnimatedLoadingRowState createState() => _AnimatedLoadingRowState();
}

class _AnimatedLoadingRowState extends State<AnimatedLoadingRow> {
  // This list tracks the order of the items
  List<int> _order = [0, 1, 2];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the loop
    _timer = Timer.periodic(Duration(milliseconds: 1800), (timer) {
      setState(() {
        // Shift the list: [0, 1, 2] -> [2, 0, 1] -> [1, 2, 0]
        int last = _order.removeLast();
        _order.insert(0, last);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define your items in a list to map them to their current positions
    List<Widget> items = [
      CustomAssetsImage(
        assetsPath: AssetsPath.loadingStarIcon,
        height: 15.h,
        width: 15.w,
      ),
      CustomAssetsImage(
        assetsPath: AssetsPath.loadingDotIcon,
        height: 12.h,
        width: 12.w,
      ),
      CustomAssetsImage(
        assetsPath: AssetsPath.loadingDotIcon,
        height: 12.h,
        width: 12.w,
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _order.map((index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 0.75.w), // Half of your 1.5.w gap
          child: items[index],
        );
      }).toList(),
    );
  }
}

