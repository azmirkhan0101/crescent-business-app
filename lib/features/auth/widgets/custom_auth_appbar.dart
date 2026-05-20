import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/context_extension.dart';
import '../../../utils/assets_gen/assets.gen.dart';

class CustomAuthAppbar extends StatelessWidget {
  const CustomAuthAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Row(
      children: [
        GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Container(
            height: isTab ? 60 : 40,
            width: isTab ? 60 : 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF5F4F6),
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.icons.backIcon,
                height: isTab ? 50 : 20.h,
                width:  isTab ? 48 : 19.w,
              ),
            ),
          ),
        ),

        const Spacer(),

        /// Asset Image
        SvgPicture.asset(
          Assets.icons.crescentLogo,
          height: isTab ? 50 : 32.h,
          width: isTab ? 50 : 32.w,
        ),
      ],
    );
  }
}