import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../utils/assets_path.dart';

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
            context.pop();
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF5F4F6),
            ),
            child: Center(
              child:    Image.asset(
                AssetsPath.backIcon,
                height: 20.h,
                width: 19.w,
              ),
            ),
          ),
        ),

        const Spacer(),

        /// Asset Image
        Image.asset(
          AssetsPath.moonIcon,
          height: 32.h,
          width: 32.w,
        ),
      ],
    );
  }
}