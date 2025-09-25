import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/features/widgets/custom_button_widget.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';
import '../../widgets/text_field_title_widget.dart';

class UploadImageSection extends StatelessWidget {
  const UploadImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitleWidget(text: "Upload Reward Image"),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
            GestureDetector(
                onTap:(){
                  debugPrint("upload");
                },
                child: CustomAssetsImage(assetsPath: AssetsPath.cloudIcon,height: 24.h,width: 24.w,)),
              const SizedBox(height: 5),
               Text(
                'Tap to upload',
                style:AppTextStyle.mediumStyle.copyWith(fontWeight: FontWeight.w600,color: AppColors.blackTextColor),
              ),
               Text(
                'PNG, JPG (max size 2 MB)',
                style:AppTextStyle.mediumStyle.copyWith(fontSize: 12.sp,color: Color(0xFF777777)),

              ),
               SizedBox(height: 10),
              //divider========================
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: const Color(0xFF777777),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'OR',
                      style: AppTextStyle.mediumStyle.copyWith(
                        fontSize: 12.sp,
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: const Color(0xFF777777),
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              // CustomButton(
              //   buttonTextStyle: AppTextStyle.buttonTextStyle.copyWith(fontSize: 12.sp,fontWeight: FontWeight.w600),
              //
              //     backgroundColor: Color(0x26C08FFF),
              //     text: "Open Camera", onPressed: (){}),




              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 24.w,
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // এখানে তোমার camera open করার কোড যাবে
                },
                child: Text(
                  "Open Camera",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.buttonTextColor,
                  ),
                ),
              )










            ],
          ),
        ),
      ],
    );
  }
}
