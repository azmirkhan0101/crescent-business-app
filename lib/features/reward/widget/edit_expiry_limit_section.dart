import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/reward/widget/custom_date_picker_field.dart';

import '../../../core/context_extension.dart';
import '../../../utils/app_text_styles.dart';
import '../../widgets/custom_text_field_widget.dart';
import '../../widgets/text_field_title_widget.dart';

class EditExpiryLimitSection extends StatelessWidget {

  final TextEditingController controller;
  final Function(DateTime) onDateSelected;
  final DateTime? initialDate;
  final bool isInstore;//CONTROLS LIMIT TEXT FIELD - HIDES IF TYPE = ONLINE

  const EditExpiryLimitSection({
    super.key,
    required this.controller,
    required this.onDateSelected,
    this.initialDate,
    required this.isInstore,
  });

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitleWidget(text: "Set Expiry Date"),

        Text('Leave empty for ‘No Expiry’',
            style:AppTextStyle.mediumStyle.copyWith(fontSize: isTab ? 8.sp: 12.sp)
        ),
        const SizedBox(height: 10),

        CustomDatePickerField(
            initialDate: initialDate,
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
      if( isInstore )
        TextFieldTitleWidget(text: "Redemption Limit"),
        if( isInstore )
        Text('Leave empty for ‘No Limit’',
            style:AppTextStyle.mediumStyle.copyWith(fontSize: isTab ? 8.sp: 12.sp)
        ),
        if( isInstore )
        const SizedBox(height: 10),
        if( isInstore )
        CustomTextField(
          hintText:"",
          controller: controller,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }
}
