import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organization/utils/app_color.dart';

class BusinessProfileWidget extends StatefulWidget {
  final String? coverImageUrl;
  final String? logoImageUrl;

  final File? coverImageFile;
  final File? logoImageFile;

  final Function(File file)? onCoverPicked;
  final Function(File file)? onLogoPicked;

  final bool isEditScreen;

  const BusinessProfileWidget({
    super.key,
    required this.coverImageUrl,
    required this.logoImageUrl,
    this.coverImageFile,
    this.logoImageFile,
    this.onCoverPicked,
    this.onLogoPicked,
    this.isEditScreen = false,
  });

  @override
  State<BusinessProfileWidget> createState() => _BusinessProfileWidgetState();
}

class _BusinessProfileWidgetState extends State<BusinessProfileWidget> {
  File? _coverFile;
  File? _logoFile;

  @override
  void initState() {
    super.initState();

    /// Initialize with parent-provided files if they exist
    _coverFile = widget.coverImageFile;
    _logoFile = widget.logoImageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        /// ---------------- COVER ----------------
        Container(
          height: 120.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: AppColors.grey001,
          ),
          child: _buildCoverImage(),
        ),

        if (widget.isEditScreen)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                print("Cover clicked");
                pickImage(true);
              },
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: Colors.black,
                child: Icon(Icons.edit, size: 16.r, color: Colors.white),
              ),
            ),
          ),

        /// ---------------- LOGO ----------------
        Positioned(
          bottom: -50.h,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80.w,
                height: 80.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(width: 2.r, color: AppColors.successGreen),
                ),
                child: ClipOval(child: _buildLogoImage()),
              ),
              if (widget.isEditScreen)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    //HEY CHATGPT, THIS CLICK IS NOT WORKING.
                    onTap: () {
                      pickImage(false);
                    },
                    child: IconButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                      ),
                      icon: Icon(Icons.edit, size: 16.r, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- IMAGE BUILDERS ------------------
  Widget _buildCoverImage() {
    if (_coverFile != null) {
      return Image.file(_coverFile!, fit: BoxFit.cover);
    } else if (widget.coverImageUrl != null &&
        widget.coverImageUrl!.isNotEmpty) {
      return Image.network(
        widget.coverImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(Icons.image, size: 100.r, color: Colors.white),
          );
        },
      );
    }
    return Icon(Icons.image, size: 100.r, color: Colors.white);
  }

  Widget _buildLogoImage() {
    if (_logoFile != null) {
      return Image.file(_logoFile!, fit: BoxFit.cover);
    } else if (widget.logoImageUrl != null && widget.logoImageUrl!.isNotEmpty) {
      return Image.network(
        widget.logoImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(Icons.business, size: 50.r, color: Colors.grey),
          );
        },
      );
    }
    return Icon(Icons.business, size: 50.r, color: Colors.grey);
  }

  // ---------------- IMAGE PICKER ------------------
  Future<void> pickImage(bool isCover) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);

      setState(() {
        if (isCover) {
          _coverFile = file;
        } else {
          _logoFile = file;
        }
      });

      /// Call callback to notify parent
      if (isCover && widget.onCoverPicked != null) {
        widget.onCoverPicked!(file);
      }
      if (!isCover && widget.onLogoPicked != null) {
        widget.onLogoPicked!(file);
      }
    }
  }
}
