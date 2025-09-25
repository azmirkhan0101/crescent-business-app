import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/utils/assets_path.dart';

class BusinessProfileWidget extends StatelessWidget {
  const BusinessProfileWidget({
    super.key,
    this.topEdit,
    this.profileCenterEdit,
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            image: DecorationImage(
              image: AssetImage(AssetsPath.businessCoverImage),
              fit: BoxFit.cover,
            ),
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
                    width: 0.91.w,
                    color: const Color(0xFFE4E4E4),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.r),
                  child: Image.asset(
                    AssetsPath.businessProfileImage,
                    fit: BoxFit.cover,
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
