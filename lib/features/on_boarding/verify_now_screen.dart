import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/controller/auth/verify_now_controller.dart';
import 'package:organization/core/context_extension.dart';
import 'package:organization/features/widgets/custom_button_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_color.dart';

class VerifyNowScreen extends StatelessWidget {

  final VerifyNowController controller = Get.find<VerifyNowController>();

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox( height: 180.h,),
          Center(
            child: Image.asset("assets/images/unverified.png",
            height: isTab ? 250 : 150,
              width: isTab ? 250 : 150,
            ),
          ),
          SizedBox( height: 15.h ),
          CustomText(text: "Your account is not\n verified yet",
          fontSize: isTab ? 12.sp : 22,
            fontWeight: FontWeight.w700,
          ),
          SizedBox( height: 10.h),
          CustomText(text: "Verify your account to access all features.",
            fontSize: isTab ? 12.sp : 16,
            fontWeight: FontWeight.w500,
            color: AppColors.grey_1,
          ),
          Expanded(
              child: SizedBox.shrink(),
          ),
          ElevatedButton(
              onPressed: (){
                controller.sendVerificationOtp();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.successGreen,
                padding: EdgeInsets.symmetric( horizontal: 60.w, vertical: 10.h )
              ),
              child: Obx((){
                if( controller.isVerificationLoading.value ){
                  return CircularProgressIndicator(color: AppColors.white,);
                }else{
                  return CustomText( text: "Verify Now",
                    color: AppColors.white,
                    fontSize: isTab ? 12.sp : 15.sp,
                    fontWeight: FontWeight.w700,
                  );
                }
              })
          ),
          const SizedBox( height: 10,),
          TextButton(onPressed: (){
            Get.toNamed(AppRoutes.logIn);
          }, child: Text("Signin", style: TextStyle(fontSize: isTab ?8.sp : 18.sp, color: AppColors.primaryColor),)),
          SizedBox(
            height: 40.h,
          )
        ],
      ),
    );
  }
}
