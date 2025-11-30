import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/assets_path.dart';

class BusinessProfileWidget extends StatelessWidget {

  final String? coverImage;
  final String? logoImage;

  const BusinessProfileWidget({
    super.key,
    this.topEdit,
    this.profileCenterEdit,
    required this.coverImage,
    required this.logoImage
  });

  final Positioned? topEdit;

  final Positioned? profileCenterEdit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        /// Cover image
        Container(
          height: 120.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: AppColors.grey001
          ),
          child: Image.asset(
            coverImage ?? "",
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) {
              return Icon(Icons.image_outlined, size: 100.r, color: Colors.white,);
            },
          ),
        ),

        /// Top edit button (optional)
        if (topEdit != null) topEdit!,

        /// Profile image
        Positioned(
          bottom: -50.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80.w,
                height: 80.w, // keep it square for circle
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.r,
                    color: AppColors.successGreen,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.r),
                  child: Image.asset(
                    coverImage ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) {
                      return Icon(Icons.business, size: 50.r, color: Colors.grey,);
                    },
                  ),
                ),
              ),

              /// Profile edit button (optional)
              if (profileCenterEdit != null) profileCenterEdit!,
            ],
          ),
        ),
      ],
    );
  }
}
