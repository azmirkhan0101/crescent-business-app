import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/profile/widget/profile_reward_card_widget.dart';


import '../data/models/reward_model.dart'; // 👈 rewardOptions import


class RewardsTab extends StatelessWidget {
  const RewardsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: rewardOptions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.h,
        crossAxisSpacing: 8.w,
        mainAxisExtent: 140.h,
      ),
      itemBuilder: (context, index) {
        final option = rewardOptions[index];
        return ProfileRewardCardWidget(
          topIcon: option.topIcon,
          title: option.title,
          subtitle: option.subtitle,
          bottomIcon1: option.bottomIcon1,
          bottomIcon2: option.bottomIcon2,
          bottomText: option.bottomText,
        );
      },
    );
  }
}
