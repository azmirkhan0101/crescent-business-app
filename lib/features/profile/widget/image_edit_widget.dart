import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/app_color.dart';

class ImageEditWidget extends StatelessWidget {

  final String? coverImageUrl;
  final String? logoImageUrl;

  Rxn<File> coverImage = Rxn<File>();
  Rxn<File> logoImage = Rxn<File>();

  final Function(File file)? onCoverPicked;
  final Function(File file)? onLogoPicked;

  ImageEditWidget({
    super.key,
    this.coverImageUrl,
    this.logoImageUrl,
    this.onCoverPicked,
    this.onLogoPicked
  });

  @override
  Widget build(BuildContext context) {
    const double coverHeight = 120;
    const double profileRadius = 55;

    return Column(
      children: [
        // 1. COVER SECTION
        Stack(
          children: [
    Container(
    height: 120.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: AppColors.grey001,
      ),
      child: Obx((){
        return _buildCoverImage();
      }),
    ),
            // COVER EDIT ICON
            Positioned(
              top: 12,
              right: 12,
              child: _EditIcon(onTap: (){
                pickImage( true );
              } ),
            ),
          ],
        ),

        // 2. PROFILE SECTION (Shifted up to overlap)
        Transform.translate(
          offset: const Offset(0, -profileRadius),
          child: Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2.r,
                      color: AppColors.successGreen,
                    ),
                  ),
                  child: ClipOval(child: Obx((){
                    return _buildLogoImage();
                  })),
                ),
                // PROFILE EDIT ICON
                _EditIcon(
                  size: 34,
                  iconSize: 18,
                  onTap: (){
                    pickImage( false );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  // ---------------- IMAGE BUILDERS ------------------
  Widget _buildCoverImage() {
    if ( coverImage.value != null ) {
      return Image.file(coverImage.value!, fit: BoxFit.cover);
    } else if ( coverImageUrl != null && coverImageUrl!.isNotEmpty) {
      return Image.network( coverImageUrl!, fit: BoxFit.cover);
    }
    return Icon(Icons.image, size: 100.r, color: Colors.white);
  }

  Widget _buildLogoImage() {
    if ( logoImage.value != null) {
      return Image.file(logoImage.value!, fit: BoxFit.cover);
    } else if ( logoImageUrl != null && logoImageUrl!.isNotEmpty ) {
      return Image.network( logoImageUrl!, fit: BoxFit.cover );
    }
    return Icon(Icons.business, size: 50.r, color: Colors.grey);
  }

  // ---------------- IMAGE PICKER ------------------
  Future<void> pickImage(bool isCover) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);

      if (isCover) {
        coverImage.value = file;
      } else {
        logoImage.value = file;
      }

      /// Call callback to notify parent
      if (isCover && onCoverPicked != null) {
        onCoverPicked!(file);
      }
      if (!isCover && onLogoPicked != null) {
        onLogoPicked!(file);
      }
    }
  }
}

class _EditIcon extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const _EditIcon({
    required this.onTap,
    this.size = 36,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    // We use a GestureDetector + Container to ensure a clean hit area
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.edit,
          size: iconSize,
          color: Colors.white,
        ),
      ),
    );
  }
}