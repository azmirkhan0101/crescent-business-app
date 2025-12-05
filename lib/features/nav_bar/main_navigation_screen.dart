import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:organization/controller/nav/main_nav_controller.dart';import 'package:organization/utils/app_constants.dart';

import '../../utils/app_size.dart';

class MainNavigationScreen extends StatelessWidget {

  final MainNavController controller = Get.find<MainNavController>();
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          Obx((){
            return controller.bottomNavScreens[controller.currentIndex.value];
          }),
          Positioned(
            left: 0,
              right: 0,
              bottom: 0.h,
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppSizes.paddingLarge,
                  right: AppSizes.paddingLarge,
                  bottom: 30.h,
                ),
                child: Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x14000000),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Obx((){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(controller.bottomNavScreens.length, (index) {
                          final bool selected = index == controller.currentIndex.value;

                          return GestureDetector(
                            onTap: () {
                              if (!selected) {
                                controller.currentIndex.value = index;
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              height: selected ? 56.h : 40.h,
                              width: selected ? 64.w : 40.w,
                              decoration: BoxDecoration(
                                color: selected ? const Color(0xFFC08FFF) : Colors.transparent,
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: Center(
                                child: Image.asset(
                                  controller.navItemIconPath[index],
                                  width: 24.sp,
                                  height: 24.sp,
                                  color: selected ? const Color(0xFF51238D) : Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    })
                ),
              ),
          )
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 60),
        child: ElevatedButton(onPressed: (){
          print("Tokennnnnn: ${storage.read(accessTokenKey)}");
        }, child: Text("Click")),
      )
    );
  }
}
