import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organization/core/context_extension.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w300,
    this.color = Colors.black,
    required this.text,
    this.overflow = TextOverflow.ellipsis,
    this.decoration,
    this.language = false,

    ///this.decoration = TextDecoration.none,
  });

  final double left;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final TextDecoration? decoration;
  final bool? language;

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return Padding(
      padding: EdgeInsets.only(
        left: left,
        right: right,
        top: top,
        bottom: bottom,
      ),
      child: Text(
        textAlign: textAlign,
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: language == true
            ? GoogleFonts.familjenGrotesk(
                fontSize: isTab ? fontSize - 12 : fontSize.sp,
                fontWeight: fontWeight,
                color: color,
                decoration: decoration,
                decorationColor: Colors.black,
                decorationThickness: 2,
              )
            : GoogleFonts.inter(
                fontSize: isTab ? fontSize - 12 : fontSize.sp,
                fontWeight: fontWeight,
                color: color,
                decoration: decoration,
                decorationColor: Colors.black,
                decorationThickness: 2,
                textStyle: TextStyle(),
              ),
      ),
    );
  }
}
