import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropDownConWidget extends StatefulWidget {
  const DropDownConWidget({
    super.key,
    this.height,
    this.width,
    this.backgroundColor,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.textStyle,
  });

  final double? height;
  final double? width;
  final Color? backgroundColor;

  /// dropdown items
  final List<String> items;

  /// initial selected value
  final String? initialValue;

  /// callback to parent
  final ValueChanged<String>? onChanged;

  /// custom text style
  final TextStyle? textStyle;

  @override
  State<DropDownConWidget> createState() => _DropDownConWidgetState();
}

class _DropDownConWidgetState extends State<DropDownConWidget> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue ?? widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: widget.height ?? 40.h,
          width: widget.width ?? 150.w,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0x199E9E9E),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              style: widget.textStyle ??
                  TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedValue = newValue;
                  });
                  widget.onChanged?.call(newValue); // callback to parent
                }
              },
              items: widget.items
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      value,
                      style: widget.textStyle ??
                          TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0x199E9E9E),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.arrow_back, size: 20),

        ),
      ],
    );
  }
}
