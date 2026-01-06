import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/data/models/home/recent_activity_item_model.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';

import '../../../utils/assets_path.dart';


class ActivityListTileWidget extends StatelessWidget {
  final RecentActivityItemModel item;
  final int maxLines;

  const ActivityListTileWidget({
    super.key,
    required this.item,
    required this.maxLines
  });

  @override
  Widget build(BuildContext context) {

    String iconPath;
    String titlePrefix;
    if( item.type == "creation" ){//CREATION ICON
      iconPath = AssetsPath.activity3Icon;
      titlePrefix = "New Reward Published: ";
    }else{//REDEEM
      titlePrefix = "${item.userName} redeemed ";
      if( item.redemptionMethod == "static-code" ){//STATIC CODE ICON
        iconPath = AssetsPath.staticCodeIcon;
      }else if( item.redemptionMethod == "qr" ){//QR CODE ICON
        iconPath = AssetsPath.activity1Icon;
      }else if( item.redemptionMethod == "nfc" ){//NFC TAP ICON
        iconPath = AssetsPath.activity2Icon;
      }else if( item.redemptionMethod == "discount-code" ){//DISCOUNT CODE ICON
        iconPath = AssetsPath.discountCodeIcon;
      }else{//GIFT CARD ICON - "gift-card"
        iconPath = AssetsPath.giftCardIcon;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Left icon circle
        Container(
           height: 44.h,
          width: 44.w,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: item.type == "creation" ? AppColors.successGreen.withOpacity(0.2) : AppColors.errorRed.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child:Image.asset(
            iconPath,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        /// Right side text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "$titlePrefix\"${item.rewardTitle}\"",
              color: AppColors.blackTextColor,
                fontWeight: FontWeight.w500,
                language: false,
                fontSize: 14.sp,
                maxLines: maxLines,
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 4),
              CustomText(text: item.timeAgo,
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
