import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/controller/auth/sign_up_controller.dart';
import 'package:organization/features/on_boarding/widgets/category_card_widget.dart';
import 'package:organization/features/on_boarding/widgets/onboarding_appbar.dart';
import 'package:organization/features/on_boarding/widgets/under_button_widget.dart';
import 'package:organization/routes/app_pages.dart';
import 'package:organization/utils/app_color.dart';
import 'package:organization/utils/app_text.dart';
import '../widgets/heading_text_widget.dart';
import 'data/models/category_item_model.dart';

class CategorySelectionScreen extends StatefulWidget {

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final SignUpController controller = Get.find<SignUpController>();
  final List<CategoryModel> categories = CategoryModel.sampleList;
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60.h),
            OnBoardingAppbarWidget(
              totalSteps: 6,
              currentStep: 1,
              title: AppText.category,
            ),

            SizedBox(height: 30.h),

            /// heading Text
            HeadingTextWidget(
              title: AppText.selectBusinessCategory,
              subTitle: AppText.categoryDescription,
            ),

            SizedBox(height: 16.h),

            /// GridView দিয়ে category selection
            GridView.builder(
              itemCount: categories.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                mainAxisExtent: 90.h,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return CategoryCard(
                  category: category,
                  isSelected: selectedIndex == index,
                  onTap: () {
                    setState(() {
                      if (selectedIndex == index) {
                        selectedIndex = null;
                      } else {
                        selectedIndex = index;
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),

      // Bottom Button
      bottomNavigationBar: UnderButtonWidget(
        onPressed: () {
          if (selectedIndex != null) {
            controller.businessModel.category = categories[selectedIndex!].title;
            Get.toNamed(AppRoutes.businessInfo);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please select a category")),
            );
          }
        },
        buttonText: AppText.continueText,
      ),
    );
  }
}
