import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:organization/core/context_extension.dart';

class CustomDropdown extends StatefulWidget {

  final List<String> items;
  final Function(String) onSelected;

  const CustomDropdown({super.key, required this.items, required this.onSelected });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {

  // First item selected by default
  late String selectedValue = widget.items[0];

  @override
  Widget build(BuildContext context) {

    bool isTab = context.isTab;

    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      //itemHeight: isTab ? 150 : null,
      value: selectedValue,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        labelText: "Select Category",
        labelStyle: isTab ? TextStyle(fontSize: 25) : null,
        hintStyle: isTab ? TextStyle(fontSize: 25) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: widget.items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item ,style: TextStyle(fontSize: isTab ? 10.sp : null),),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;
        setState(() {
          selectedValue = value;
        });
        widget.onSelected(value); // passing selected value
      },
    );
  }
}
