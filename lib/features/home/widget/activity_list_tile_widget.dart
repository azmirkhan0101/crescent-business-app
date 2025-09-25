import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import '../data/models/activity_data_class.dart';


class ActivityListTileWidget extends StatelessWidget {
  final ActivityItem item;

  const ActivityListTileWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Left icon circle
        Container(
           height: 44.h,
          width: 44.w,
          decoration: BoxDecoration(
            color: item.iconColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child:Image.asset( item.icon,height: 24.h,width: 24.w,),


        ),
        const SizedBox(width: 16),

        /// Right side text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text:   item.text,
              color: AppColors.blackTextColor,
                fontWeight: FontWeight.w500,
                language: false,
                fontSize: 14.sp,
              ),


              const SizedBox(height: 4),
              CustomText(text: item.timestamp,
                color: AppColors.secondaryTextColor,
                fontWeight: FontWeight.w400,
                language: false,
                fontSize: 12.sp,
              ),

            ],
          ),
        ),
      ],
    );
  }
}
