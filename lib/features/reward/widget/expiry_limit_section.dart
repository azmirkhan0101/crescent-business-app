import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_text_styles.dart';
import '../../../utils/assets_path.dart';
import '../../widgets/custom_text_field_widget.dart';
import '../../widgets/text_field_title_widget.dart';

class ExpiryLimitSection extends StatelessWidget {

  final TextEditingController controller;

  const ExpiryLimitSection({super.key, required this.controller});

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


        CustomTextField(hintText:"30/06/2025" ,suffixImagePath: AssetsPath.calenderIcon,),
        const SizedBox(height: 5),
//////////////////////////////////////////////////////
        TextFieldTitleWidget(text: "'Redemption Limit'"),
        Text('Leave empty for ‘No Limit’',
            style:AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp)
        ),
        const SizedBox(height: 10),
        CustomTextField(
          hintText:"",
        controller: controller,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
