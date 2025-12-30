import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:organization/controller/profile/business_profile_controller.dart';
import 'package:organization/features/profile/widget/image_edit_widget.dart';
import 'package:organization/features/profile/widget/location_widget.dart';
import 'package:organization/features/profile/widget/profile_heading_text_widget.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/assets_gen/assets.gen.dart';

import '../../utils/app_size.dart';
import '../../utils/app_text.dart';
import '../widgets/custom_text_field_widget.dart';

class EditProfileScreen extends StatelessWidget {

  final BusinessProfileController controller = Get.find<BusinessProfileController>();
  final TextEditingController textEditingController = TextEditingController();
  final String googleApiKey = dotenv.env['GOOGLE_API_KEY']!;
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      //app bar
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.w),
          onPressed: () {
            Get.back();
          },
        ),
        title: CustomText(
          text: 'Edit Profile',
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.blackTextColor,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done, size: 20.w),
            onPressed: () {
              controller.updateBusinessProfile();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover and logo image
            Obx((){
              return ImageEditWidget(
                coverImageUrl: controller.coverImageUrl.value,
                logoImageUrl: controller.logoImageUrl.value,
                onCoverPicked: (file){
                  controller.coverImage.value = file;
                },
                onLogoPicked: (file){
                  controller.logoImage.value = file;
                },
              );
            }),
            /// Form fields
            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// name
                  ProfileHeadingTextWidget(title: AppText.name),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    hintText: controller.editProfileModel.name,
                    controller: controller.nameController,
                  ),
                  SizedBox(height: 16.h),

                  /// tagline
                  ProfileHeadingTextWidget(title: AppText.tagline),
                  CustomTextField(
                    hintText: controller.editProfileModel.tagline,
                    controller: controller.taglineController,
                  ),
                  SizedBox(height: 16.h),

                  /// description
                  ProfileHeadingTextWidget(title: AppText.description),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    maxLines: 5,
                    hintText: controller.editProfileModel.description,
                    controller: controller.descriptionController,
                  ),
                  SizedBox(height: 16.h),
                  /// globalization
                  ProfileHeadingTextWidget(title: AppText.website),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    prefixIconPath: Assets.icons.globe,
                    hintText: controller.editProfileModel.businessWebsite ?? "",
                    controller: controller.websiteController,
                  ),
                  SizedBox(height: 16.h),
                  /// business phone
                  ProfileHeadingTextWidget(title: AppText.businessPhone),
                  CustomTextField(
                    prefixIconPath: Assets.icons.call,
                    hintText: controller.editProfileModel.businessPhoneNumber ?? "",
                    controller: controller.phoneController,
                  ),
                  SizedBox(height: 16.h),

                  /// email
                  ProfileHeadingTextWidget(title: AppText.email),
                  SizedBox(height: AppSizes.paddingSmallH),
                  CustomTextField(
                    prefixIconPath: Assets.icons.mail,
                    hintText: controller.editProfileModel.businessEmail ?? "",
                    controller: controller.emailController,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            /// location title row
            ProfileHeadingTextWidget(title: AppText.location),
            SizedBox(height: 12.h),

            //LOCATION AUTOCOMPLETE - GOOGLE PLACES
            PlacesSearchField(
              googleApiKey: googleApiKey,
              textEditingController: textEditingController,
              onItemClick: (placeName){
              controller.locationNames.add(placeName);
            }, focusNode: focusNode,
            ),
            Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.locationNames.length,
                itemBuilder: (context, index) {
                  return LocationWidget(
                    headingText: "Location ${index + 1}",
                    fieldText: controller.locationNames[index],
                    deleteTap: () {
                      controller.locationNames.removeAt(index);
                    },
                  );
                },
              );
            }),
            SizedBox(height: 30.h,)
          ],
        ),
      ),
    );
  }

  //image picker
  Future<File?> pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    } else {
      return null;
    }
  }
}


class PlacesSearchField extends StatelessWidget {

  final String googleApiKey;
  final TextEditingController textEditingController;
  final Function(String) onItemClick;
  final FocusNode focusNode;

   PlacesSearchField({
    super.key,
     required this.googleApiKey,
     required this.textEditingController,
     required this.onItemClick,
     required this.focusNode,
   });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.text,
        textEditingController: textEditingController,
        googleAPIKey: googleApiKey,
        focusNode: focusNode,
        inputDecoration: InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        //countries: ["in", "fr"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          //print("placeDetails" + prediction.lat.toString());
        },
        itemClick: (Prediction prediction) {
          final placeName = prediction.description ?? "";
          textEditingController.text = placeName;
          //ADD PLACE NAME IN LOCATIONS LIST
          onItemClick(placeName);
          //controller.locationNames.add(placeName);
          textEditingController.selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0),
          );
          textEditingController.clear();
          focusNode.requestFocus();
        },
        seperatedBuilder: Divider(),
        containerHorizontalPadding: 10,
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 7),
                Expanded(child: Text("${prediction.description ?? ""}")),
              ],
            ),
          );
        },
        isCrossBtnShown: true,
        // default 600 ms ,
      ),
    );
  }
}
