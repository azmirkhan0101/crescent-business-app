import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/profile/widget/Custom_text_field.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';

import '../../../utils/app_color.dart';
import '../../widgets/custom_text_field_widget.dart';
import '../../widgets/text_field_title_widget.dart';

class ExpiryLimitSection extends StatelessWidget {
  const ExpiryLimitSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitleWidget(text: "'Set Expiry Date'"),

        Text('Leave empty for ‘No Expiry’',
            style:AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp)
        ),
        const SizedBox(height: 10),
        // CustomTextFieldWidget(hintText:"Enter Date" ,
        //    suffixIcon: Image.asset(AssetsPath.calenderIcon),
        // ),


        const SizedBox(height: 5),
//////////////////////////////////////////////////////
        TextFieldTitleWidget(text: "'Redemption Limit'"),
        Text('Leave empty for ‘No Limit’',
            style:AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp)
        ),
        const SizedBox(height: 10),
        // CustomTextFieldWidget(hintText:"Enter Limit" ,
        //
        // ),


      ],
    );
  }
}