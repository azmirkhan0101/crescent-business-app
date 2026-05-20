import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/core/context_extension.dart';
import 'package:organization/data/models/reward/reward_model.dart';
import 'package:organization/features/profile/widget/profile_reward_card_widget.dart';


class RewardsTab extends StatelessWidget {

  final List<RewardModel> rewards;

  const RewardsTab({
    super.key,
    required this.rewards
  });

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: rewards.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.h,
              crossAxisSpacing: 8.w,
              mainAxisExtent: isTab ? 250 : 150.h,
            ),
            itemBuilder: (context, index) {

              final RewardModel model = rewards[index];
              //INSTORE REDEMPTIONS
              final bool isQr = model.inStoreMethods?.qrCode ?? false;
              final bool isNfc = model.inStoreMethods?.nfcTap ?? false;
              final bool isStaticCode = model.inStoreMethods?.staticCode ?? false;
              //ONLINE REDEMPTIONS
              final bool isGiftCard = model.onlineMethods?.giftCard ?? false;
              final bool isDiscountCode = model.onlineMethods?.discountCode ?? false;

              return ProfileRewardCardWidget(
                image: model.image,
                title: model.title,
                  expiryDate: model.expiryDate.toString(),
                type: model.type,
                isQr: isQr,
                isNfc: isNfc,
                isStaticCode: isStaticCode,
                isGiftCard: isGiftCard,
                isDiscountCode: isDiscountCode,
              );
            },
          ),
          SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
