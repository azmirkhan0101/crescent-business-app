import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final bool showPlusIcon;

  const HeaderWidget({
    super.key,
    required this.title,
    this.showPlusIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showPlusIcon)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}