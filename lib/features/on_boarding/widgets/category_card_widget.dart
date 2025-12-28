import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/assets_path.dart';
import '../../widgets/custom_asset_image.dart';
import '../data/models/category_item_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected
            ? Color(0x33C08FFF) // deep background when selected
            : AppColors.white,
        elevation: 2,
        shadowColor: const Color(0x05000000), // #00000005 (2% opacity)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(
            color: isSelected
                ? AppColors.primaryColor
                : const Color(0xFFEDEDED),
            width: 1.5,
          ),
        ),
        child: Container(
          height: 80.h,
          padding: EdgeInsets.only(
            top: 8.h,
            right: 8.w,
            bottom: 10.h,
            left: 10.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top-right radio indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  CustomAssetsImage(
                    assetsPath: isSelected
                        ? AssetsPath.radioSelected
                        : AssetsPath.radioUnselected,
                    height: isSelected ? 14.h : 10.h, // bigger when selected
                    width: isSelected ? 14.h : 10.h,
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // icon + text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    category.icon,
                    height: 18.h, // bigger when selected
                    width: 16.w,
                  ),

                  SizedBox(height: 2.h),
                  Text(category.title, style: AppTextStyle.cardTextStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
//
//
//

//
//
//
// Container(
//   decoration: BoxDecoration(
//     color: isSelected ? category.colorCode : Colors.grey.shade200,
//     borderRadius: BorderRadius.circular(12),
//     border: Border.all(
//       color: isSelected ? Colors.black : Colors.grey.shade400,
//       width: 1.5,
//     ),
//   ),
//   padding: const EdgeInsets.all(12),
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Image.asset(
//         category.iconPath,
//         height: 40,
//         width: 40,
//         color: isSelected ? Colors.black : Colors.grey,
//       ),
//       const SizedBox(height: 8),
//       Text(
//         category.title,
//         style: TextStyle(
//           fontWeight: FontWeight.w600,
//           color: isSelected ? Colors.black : Colors.grey,
//         ),
//         textAlign: TextAlign.center,
//       ),
//     ],
//   ),
// ),
