import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:organization/controller/profile/privacy_controller.dart';
import 'package:organization/controller/profile/terms_controller.dart';
import 'package:organization/core/context_extension.dart';

import '../widgets/custom_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {

  final PrivacyController controller = Get.find<PrivacyController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: Obx((){
        if( controller.isLoading.value ){
          return Center(child: CircularProgressIndicator());
        }else{
          if( controller.htmlData.value.isEmpty ){
            return Center(child: CustomText(
                text: "No data found!",
              fontSize: context.isTab ? 12.sp : 16.sp,
            ));
          }
          return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Html(
                data: controller.htmlData.value,
                style: {
                  "body": Style(
                    fontSize: FontSize(14),
                    lineHeight: LineHeight(1.6),
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  "h1": Style(fontSize: FontSize(22)),
                  "h2": Style(fontSize: FontSize(18)),
                },
              )
          );
        }
      })
    );
  }
}