import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/utils/app_color.dart';
import '../../../core/routes/route_path.dart';

class CustomRowWidget extends StatelessWidget {
  const CustomRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Rewards',
          style: GoogleFonts.familjenGrotesk(
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
            color: AppColors.blackTextColor,
          ),
        ),

        IconButton(
          style: IconButton.styleFrom(
            shape: CircleBorder(),
            backgroundColor: AppColors.white,
          ),
          icon: Icon(Icons.add, color: Colors.black, size: 20.w),
          onPressed: () {
            context.push(RoutesPath.createReward);
          },
        ),
      ],
    );
  }
}
