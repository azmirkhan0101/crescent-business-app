import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:organization/features/widgets/custom_text.dart';
import 'package:organization/utils/app_color.dart';

class NotificationCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String svgIconPath;
  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  const NotificationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.svgIconPath,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  late bool switchValue;

  @override
  void initState() {
    super.initState();
    switchValue = widget.isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: SvgPicture.asset(
          widget.svgIconPath,
          width: 28.w,
          height: 28.h,
        ),
        title: CustomText(
          textAlign: TextAlign.start,
          text: widget.title,
          fontWeight: FontWeight.w500,

          fontSize: 14,
        ),

        subtitle: CustomText(
          maxLines: 8,
          textAlign: TextAlign.start,
          text: widget.subtitle,
          fontWeight: FontWeight.w400,
          color: Color(0xFF808080),
          fontSize: 14,
        ),

        trailing: Switch(
          value: switchValue,
          onChanged: (value) {
            setState(() {
              switchValue = value;
            });
            widget.onChanged(value);
          },
          activeColor: AppColors.primaryColor,
        ),
      ),
    );
  }
}
