import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:organization/utils/app_color.dart';

class CustomDatePickerField extends StatefulWidget {
  final Function(DateTime?) onDateSelected;
  final DateTime? initialDate;

  const CustomDatePickerField({
    Key? key,
    required this.onDateSelected,
    this.initialDate,
  }) : super(key: key);

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  Future<void> _pickDate() async {
    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(const Duration(days: 1));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tomorrow,
      firstDate: tomorrow,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final onlyDate = DateTime(picked.year, picked.month, picked.day);

      setState(() {
        selectedDate = onlyDate;
      });

      widget.onDateSelected(onlyDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide( width: 1, color: Colors.grey.shade400)
      ),
      elevation: 0,
      child: ListTile(
        title: Text(
          selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
              : "No date selected",
          style: TextStyle(
            color: selectedDate == null ? Colors.grey : Colors.black,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.calendar_month),
          onPressed: _pickDate,
        ),
      ),
    );
  }
}
