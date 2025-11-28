import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:organization/features/on_boarding/widgets/onboarding_appbar.dart';
import 'package:organization/features/on_boarding/widgets/under_button_widget.dart';
import 'package:organization/utils/app_text.dart';
import 'package:organization/utils/assets_path.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../controller/auth/sign_up_controller.dart';
import '../profile/widget/location_widget.dart';
import '../widgets/custom_text.dart';
import '../widgets/custom_text_field_widget.dart';
import '../widgets/heading_text_widget.dart';
import '../widgets/text_field_title_widget.dart';

class StoreLocationScreen extends StatelessWidget {

  final SignUpController controller = Get.find<SignUpController>();
  final TextEditingController textEditingController = TextEditingController();
  RxList<String> locationNames = <String>[].obs;
  final String googleApiKey = dotenv.env['GOOGLE_API_KEY']!;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            OnBoardingAppbarWidget(
              totalSteps: 6,
              currentStep: 6,
              title: AppText.location,
              suffix: GestureDetector(
                onTap: () {
                  controller.businessModel.locations = [];
                  controller.signup();
                },
                child:CustomText(text: AppText.skip,fontSize: 14.sp,color: AppColors.secondaryTextColor,fontWeight: FontWeight.w400,),
              ),
            ),
            SizedBox(height: 30.h),

            /// heading Text
            HeadingTextWidget(
              title: "Add Your Store Locations",
              subTitle:
                  "Enter one or more store locations with smart search for quick entry.",
            ),
            SizedBox(height: 50.h),
            //LOCATION AUTOCOMPLETE - GOOGLE PLACES
            placesAutoCompleteTextField(),
            /// Form fields
            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //
            //     /// Email Field
            //     Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         TextFieldTitleWidget(text: "Search Location"),
            //         ElevatedButton(onPressed: (){
            //           if( controller.locationSearchController.text.trim().isNotEmpty ){
            //             locationNames.add(controller.locationSearchController.text.trim());
            //             controller.locationSearchController.clear();
            //           }
            //         },
            //             style: ElevatedButton.styleFrom(
            //               backgroundColor: AppColors.successGreen,
            //               textStyle: TextStyle(color: AppColors.white),
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(12)
            //               )
            //             ),
            //             child: Text("Add", style: TextStyle(color: AppColors.white),))
            //       ],
            //     ),
            //     SizedBox(height: AppSizes.paddingSmallH),
            //     CustomTextField(
            //       hintText: "Search",
            //       prefixImagePath:
            //       AssetsPath.searchIcon,
            //       controller: controller.locationSearchController,
            //     ),
            //     SizedBox(height: 16.h),
            //     Divider(height: 1.w, color: Colors.grey.shade200),
            //   ],
            // ),
            Obx((){
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: locationNames.length,
                  itemBuilder: (context, index){
                    return LocationWidget(
                      headingText: "Location ${index+1}",
                      fieldText: locationNames[index],
                      deleteTap: () {
                        locationNames.removeAt(index);
                      },
                    );
                  });
            }
            ),
          ],
        ),
      ),

      /// continue Button
      bottomNavigationBar: UnderButtonWidget(
        onPressed: () {
          controller.businessModel.locations = locationNames;
          controller.signup();
        },
        buttonText: AppText.continueText,
      ),
    );
  }

  placesAutoCompleteTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: textEditingController,
        googleAPIKey:googleApiKey,
        inputDecoration: InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        //countries: ["in", "fr"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
        },

        itemClick: (Prediction prediction) {
          final placeName = prediction.description ?? "";
          textEditingController.text = placeName;
          //ADD PLACE NAME IN LOCATIONS LIST
          locationNames.add( placeName );
          textEditingController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
        },
        seperatedBuilder: Divider(),
        containerHorizontalPadding: 10,

        // Optional: specify keyboard type (defaults to TextInputType.streetAddress)
        // keyboardType: TextInputType.text,


        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description ?? ""}"))
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

