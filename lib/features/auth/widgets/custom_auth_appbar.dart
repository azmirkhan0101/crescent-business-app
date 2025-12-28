import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../utils/assets_gen/assets.gen.dart';

class CustomAuthAppbar extends StatelessWidget {
  const CustomAuthAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: (){
            Get.back();
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF5F4F6),
            ),
            child: Center(
              child: SvgPicture.asset(
                Assets.icons.backIcon,
                height: 20.h,
                width: 19.w,
              ),
            ),
          ),
        ),

        const Spacer(),

        /// Asset Image
        SvgPicture.asset(
          Assets.icons.crescentLogo,
          height: 32.h,
          width: 32.w,
        ),
      ],
    );
  }
}