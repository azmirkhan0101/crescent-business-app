import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:organization/core/context_extension.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';
import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../../utils/assets_path.dart';
import '../../widgets/custom_asset_image.dart';
import '../../widgets/custom_card_widget.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/text_field_title_widget.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    super.key,
    required this.headingText,
    required this.fieldText,
    required this.deleteTap,
  });
  final String headingText;
  final String fieldText;
  final void Function() deleteTap;

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitleWidget(text: headingText),
        SizedBox(height: AppSizes.paddingSmallH),
        Row(
          children: [
            Expanded(
              child: CustomCard(
                child: Row(
                  children: [
                    SvgPicture.asset(Assets.icons.location, height: isTab ? 30 : null,),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: CustomText(
                        text: fieldText,
                        fontSize: isTab ? 12.sp : 14.sp,
                        color: AppColors.blackTextColor,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: deleteTap,
              child: Container(
                width: isTab ? 60 : 52.w,
                height: isTab ? 60 : 52.w,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(color: Colors.red, width: 1.0),
                ),
                child: CustomAssetsImage(assetsPath: AssetsPath.deleteIcon),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
