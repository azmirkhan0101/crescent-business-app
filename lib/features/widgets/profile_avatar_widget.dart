import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organization/utils/app_color.dart';

class ProfileAvatar extends StatefulWidget {
  final String assetImage; // placeholder asset
  final VoidCallback? onTap; // extra action optional

  const ProfileAvatar({
    super.key,
    required this.assetImage,
    this.onTap,
  });

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
      if (widget.onTap != null) {
        widget.onTap!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 140.w,
          width: 140.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 2),
            color: _selectedImage == null ? const Color(0xFFFAFAFA) : null,
            image: _selectedImage != null
                ? DecorationImage(
              image: FileImage(_selectedImage!),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: _selectedImage == null
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
            onTap: _pickImage,
            child: Container(
              height: 32.w,
              width: 32.w,
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
}
