import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/utils/app_color.dart';


class RewardDetailsSection extends StatelessWidget {
  const RewardDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reward Details',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.blackTextColor,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            hintText: '10% Off Latte',
            labelText: 'Reward name',
          ),
        ),
        SizedBox(height: 15),
        TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Get a free coffee on your next visit.',
            labelText: 'Description',
          ),
        ),
      ],
    );
  }
}
