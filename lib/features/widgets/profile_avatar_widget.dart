import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/core/context_extension.dart';

class ProfileAvatar extends StatefulWidget {

  final String assetImage;
  final VoidCallback pickImage;
  final File? selectedImage;

  const ProfileAvatar({super.key, required this.assetImage, required this.selectedImage, required this.pickImage, });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Stack(
      children: [
        Container(
          height: isTab ? 180 : 140.w,
          width: isTab ? 180 : 140.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 2),
            color: widget.selectedImage == null ? const Color(0xFFFAFAFA) : null,
            image: widget.selectedImage != null
                ? DecorationImage(
                    image: FileImage(widget.selectedImage!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: widget.selectedImage == null
              ? Center(
                  child: Image.asset(
                    widget.assetImage,
                    height: 36.w,
                    width: 36.w,
                    color: Colors.grey,
                  ),
                )
              : null,
        ),

        /// small "+" button at bottom right
        Positioned(
          bottom: 8,
          right: 8,
          child: GestureDetector(
            onTap: widget.pickImage,
            child: Container(
              height: isTab ? 60 : 32.w,
              width: isTab ? 60 : 32.w,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  //
  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //
  //   if (image != null) {
  //     widget.onImageSelected( File( image.path ) );
  //     setState(() {
  //       widget.selectedImage = File(image.path);
  //     });
  //   }
  // }

}
