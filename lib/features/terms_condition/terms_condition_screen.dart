


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_color.dart';
import '../widgets/custom_text.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

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
          'Terms & Conditions',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child:RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
            children: [
              TextSpan(
                text: "Terms Condition\n",
                style:GoogleFonts.syne(fontSize: 18.sp, fontWeight: FontWeight.w600,),
              ),
              TextSpan(
                text: "Last Updated: 30-10-2025\n\n",
                style: GoogleFonts.syne(fontSize: 14.sp, fontWeight: FontWeight.w500,),
              ),

              TextSpan(
                text:
                "Crave Crusher [\"we,\" \"us,\" or \"our\"] is committed to protecting your personal information and maintaining your trust. This Privacy Policy explains how we collect, use, store, and protect your data when you use the Crave Crusher mobile application and website (the \"App\").\n\n"
                    "By using Crave Crusher, you agree to this Privacy Policy. If you do not agree, please stop using the App.\n\n",

                style: GoogleFonts.syne(fontSize: 12.sp, fontWeight: FontWeight.w400,),
              ),

              // 1
              TextSpan(
                text: "1. Information We Collect\n",
                style: GoogleFonts.syne(fontSize: 13.sp, fontWeight: FontWeight.w600,),
              ),
              TextSpan(
                text:
                "We collect information to provide and improve our services. The types of data we collect include:\n\n",
                style: GoogleFonts.syne(fontSize: 12.sp, fontWeight: FontWeight.w400,),
              ),

              // 1.1
              TextSpan(
                text: "1.1. Personal Information:\n",
                style: GoogleFonts.syne(fontSize: 13.sp, fontWeight: FontWeight.w600,),
              ),
              TextSpan(
                text:
                "Name, email address, and profile details (optional). Login credentials (encrypted). Any information you choose to include in your posts, comments, or battles.\n\n",
                style: GoogleFonts.syne(fontSize: 12.sp, fontWeight: FontWeight.w400,),
              ),

              // 1.2
              TextSpan(
                text: "1.2. Usage Information:\n",
                style: GoogleFonts.syne(fontSize: 13.sp, fontWeight: FontWeight.w600,),
              ),
              TextSpan(
                text:
                "App interactions, features you use, and activity duration. Battle progress, completion data, and reward achievements. Device information such as model, OS version, and IP address (for security and analytics).\n\n",
                style: GoogleFonts.syne(fontSize: 12.sp, fontWeight: FontWeight.w400,),
              ),

              // 1.3
              TextSpan(
                text: "1.3. Optional Information:\n",
                style: GoogleFonts.syne(fontSize: 13.sp, fontWeight: FontWeight.w600,),
              ),
              TextSpan(
                text:
                "Profile picture or avatar. Notification and reminder preferences.\n\n",
                style: GoogleFonts.syne(fontSize: 12.sp, fontWeight: FontWeight.w400,),
              ),

              // 2
              TextSpan(
                text: "2. How We Use Your Information\n",
                style: GoogleFonts.syne(fontSize: 13.sp, fontWeight: FontWeight.w600,),
              ),
              TextSpan(
                text:
                "We use your data to operate, improve, and personalize the Crave Crusher experience. Specifically:\n\n"
                    "• To create and manage your account.\n"
                    "• To track and display your battle progress.\n"
                    "• To send reminders, notifications, and motivational updates.\n"
                    "• To show community posts and manage user interactions.\n"
                    "• To analyze app performance and improve features.\n"
                    "• To ensure user safety and enforce community standards.\n\n"
                    "We never sell your personal information to third parties.\n\n",
                style: GoogleFonts.syne(fontSize: 12.sp, fontWeight: FontWeight.w400,),
              ),

              // 3
              TextSpan(
                text: "3. Data Storage and Security\n",
                style: GoogleFonts.syne(fontSize: 13.sp, fontWeight: FontWeight.w600,),
              ),
              TextSpan(
                text:
                "Your information is securely stored on encrypted servers. We use industry-standard measures to protect your data against unauthorized access, loss, or misuse.\n\n"
                    "While we do our best to safeguard your data, no system is completely secure. You use the App and share information at your own risk.\n\n",
                style: GoogleFonts.syne(fontSize: 12.sp, fontWeight: FontWeight.w400,),
              ),

              // 4
              TextSpan(
                text: "4. Sharing of Information\n",
                style: GoogleFonts.syne(fontSize: 13.sp, fontWeight: FontWeight.w600,),
              ),
              TextSpan(
                text:
                "We may share limited data only in the following cases:\n\n"
                    "• With Service Providers: Trusted partners who assist in hosting, analytics, or messaging.\n"
                    "• For Legal Reasons: If required by law, court order, or government request.\n"
                    "• To Protect Rights: To investigate potential violations or enforce our Terms of Service.\n\n"
                    "We do not share your data with advertisers for personal targeting. Ads shown in the App (if any) are based on general content categories, not your personal identity.\n\n",
                style: GoogleFonts.syne(fontSize: 12.sp, fontWeight: FontWeight.w400,),

              ),

              // 5
              TextSpan(
                text: "5. Your Data Rights\n",
                style: GoogleFonts.syne(fontSize: 13.sp, fontWeight: FontWeight.w600,),
              ),
              TextSpan(
                text:
                "Depending on your country or region, you may have the right to:\n\n"
                    "• Access the personal data we hold about you.\n"
                    "• Request correction or deletion of your data.\n"
                    "• Withdraw consent for data processing.\n"
                    "• Disable notifications or delete your account.\n\n"
                    "You can manage these settings directly within the App or contact us for assistance.\n\n",
                style: GoogleFonts.syne(fontSize: 12.sp, fontWeight: FontWeight.w400,),

              ),

              // 6
              TextSpan(
                text: "6. Data Retention\n",
                style: GoogleFonts.syne(fontSize: 13.sp, fontWeight: FontWeight.w600,),
              ),
              TextSpan(
                text:
                "We retain your personal information only as long as necessary for providing our services. If you delete your account, your personal data will be permanently removed within 30 days, except where retention is required by law or security purposes.\n\n",

                style: GoogleFonts.syne(fontSize: 12.sp, fontWeight: FontWeight.w400,),
              ),

              // 7
              TextSpan(
                text: "7. Children's Privacy\n",
                style: GoogleFonts.syne(fontSize: 13.sp, fontWeight: FontWeight.w600,),
              ),
              TextSpan(
                text:
                "Crave Crusher is intended for users aged 13 and above. We do not knowingly collect data from children under 13. If we learn that a child's data has been collected, it will be deleted immediately.\n\n",

                style: GoogleFonts.syne(fontSize: 12.sp, fontWeight: FontWeight.w400,),
              ),
            ],
          ),
        ),

      )
      ,




    );
  }
}