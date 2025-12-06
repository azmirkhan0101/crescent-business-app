import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/reward/widget/custom_date_picker_field.dart';

import '../../../utils/app_text_styles.dart';
import '../../widgets/custom_text_field_widget.dart';
import '../../widgets/text_field_title_widget.dart';

class ExpiryLimitSection extends StatelessWidget {

  final TextEditingController controller;
  final Function(DateTime) onDateSelected;

  const ExpiryLimitSection({super.key, required this.controller, required this.onDateSelected,});

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

        CustomDatePickerField(
            onDateSelected: (date){
              if( date!= null ){
                onDateSelected(date);
              }
            }
        ),
        // CustomTextField(hintText:"no expiry date selected",
        //   suffixImagePath: AssetsPath.calenderIcon,
        // ),
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
