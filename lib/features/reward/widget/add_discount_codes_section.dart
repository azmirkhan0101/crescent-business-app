import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/assets_path.dart';
import '../../../utils/app_text_styles.dart';
import '../../widgets/text_field_title_widget.dart';
import 'dash_divider_widget.dart';
import 'discount_card_widget.dart';


class AddDiscountCodesSection extends StatefulWidget {
  const AddDiscountCodesSection({super.key});

  @override
  State<AddDiscountCodesSection> createState() => _AddDiscountCodesSectionState();
}

class _AddDiscountCodesSectionState extends State<AddDiscountCodesSection> {
  bool isOneTimeUseChecked1 = true;
  bool isOneTimeUseChecked2 = true;

  @override
  Widget build(BuildContext context) {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitleWidget(text: "Add discount code(s)"),

       const SizedBox(height: 5),

        Text('Upload via .csv or add a URL to the gift card system',
            style:AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp)
        ),


         SizedBox(height: 10.h),




      ///discount field
        DiscountCardWidget(text:  "Discount Code",
          icon1: AssetsPath.documentIcon,
          icon2: AssetsPath.deleteIcon,

        ),








        const SizedBox(height: 10),



       /// link upload card
        DiscountCardWidget(text:  "https://google.com/",
          icon1: AssetsPath.linkIcon,
          icon2: AssetsPath.cloudIcon,
          textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: AppColors.blackTextColor
          ),
        ),



       // LinkPreviewBox(),
        const SizedBox(height: 10),
        //check box
        Row(
          children: [
            Checkbox(
              value: isOneTimeUseChecked1,
              onChanged: (bool? value) {
                setState(() => isOneTimeUseChecked1 = value!);
              },
             activeColor: Color(0xFF1AC461),
              checkColor: AppColors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            Text(
              'One Time Use',
              style: AppTextStyle.mediumStyle.copyWith(
                color: AppColors.blackTextColor,
              ),
            ),
          ],
        ),


        SizedBox(height: 8.h),



        /// link upload card
        DiscountCardWidget(text:  "https://google.com/",
        icon1: AssetsPath.linkIcon,
          icon2: AssetsPath.cloudIcon,
          textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: AppColors.secondaryTextColor
          ),
        ),





        //LinkPreviewBox(textColor: AppColors.secondaryTextColor,),
        SizedBox(height: 8.h),
        //check box
        Row(
          children: [
            Checkbox(
              value: isOneTimeUseChecked2,
              onChanged: (bool? value) {
                setState(() => isOneTimeUseChecked2 = value!);
              },

              activeColor: Color(0xFF1AC461),
              checkColor: AppColors.white,

              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),

            Text(
              'One Time Use',
              style: AppTextStyle.mediumStyle.copyWith(
                color: AppColors.blackTextColor,
              ),
            ),
          ],
        ),

         ///dash divider
        SizedBox(height: 8.h),
        SizedBox(
          width: double.infinity, // parent width পুরো নিবে
          child: DashedDivider(
            color: Colors.grey.shade400,
            height: 1,
          ),
        ),

        SizedBox(height: 8.h),
        /// add button
        Center(
          child: TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add, color: AppColors.blackTextColor,size: 16.w,),
            label: Text('Add more', style:AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp,color: AppColors.blackTextColor)),
          ),
        ),
      ],
    );
  }

}

