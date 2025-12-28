import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:organization/features/on_boarding/widgets/onboarding_appbar.dart';
import 'package:organization/utils/app_text.dart';

import '../../../utils/app_color.dart';
import '../../../utils/app_size.dart';
import '../../controller/auth/sign_up_controller.dart';
import '../profile/widget/location_widget.dart';
import '../widgets/custom_button_widget.dart';
import '../widgets/custom_text.dart';
import '../widgets/heading_text_widget.dart';

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
                  controller.businessSignupModel.locations = [];
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
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric( horizontal: 25.w, vertical: 30.h ),
        child: Obx((){
          return CustomButton(
            isLoading: controller.isSignupLoading.value,
            text: AppText.continueText,
            onPressed: () {
              controller.businessSignupModel.locations = locationNames;
              controller.signup();
            },
            buttonTextStyle: GoogleFonts.familjenGrotesk(
              color: AppColors.buttonTextColor,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          );
        }),
      ),
      //
      // BottomButtonWidget(
      //   onPressed: () {
      //     controller.businessSignupModel.locations = locationNames;
      //     controller.signup();
      //   },
      //   buttonText: AppText.continueText,
      // ),
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

