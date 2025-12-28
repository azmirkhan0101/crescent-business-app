import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organization/features/widgets/custom_asset_image.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text_styles.dart';
import 'package:organization/utils/assets_path.dart';

import '../../widgets/text_field_title_widget.dart';

class UploadImageSection extends StatelessWidget {

  final Function(File?) onImageSelected;
  Rx<File?> rewardImage = Rx<File?>(null);

  UploadImageSection({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldTitleWidget(text: "Upload Reward Image"),
        const SizedBox(height: 10),
        //SHOW IMAGE IN PREVIEW AFTER SELECTION
        Obx((){
          if( rewardImage.value == null ){
            return SizedBox.shrink();
          }else{
            return Center(
              child: Container(
                padding: const EdgeInsets.all(4), // space between green border and white area
                decoration: BoxDecoration(
                  color: AppColors.successGreen,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Container(
                  padding: const EdgeInsets.all(4), // space between white area and image
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      rewardImage.value!,
                      height: 100.h,
                      width: 100.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }
        }),

        SizedBox( height: 15,),

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
                onTap: (){
                  pickGalleryImage();
                },
                child: Column(
                  children: [
                    CustomAssetsImage(assetsPath: AssetsPath.cloudIcon,height: 24.h,width: 24.w,),
                    const SizedBox(height: 5),
                    Text(
                      'Tap to upload',
                      style:AppTextStyle.mediumStyle.copyWith(fontWeight: FontWeight.w600,color: AppColors.blackTextColor),
                    ),
                  ],
                ),
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
                      'Or',
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
                  pickCameraImage();
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


  //PICK REWARD IMAGE FROM GALLERY
  Future<void> pickGalleryImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      rewardImage.value = File(image.path);
      onImageSelected( File(image.path) );
    }
  }

  //PICK REWARD IMAGE FROM CAMERA
  Future<void> pickCameraImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      rewardImage.value = File(image.path);
      onImageSelected( File(image.path) );
    }
  }
}
