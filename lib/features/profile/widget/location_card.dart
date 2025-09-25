import 'package:flutter/material.dart';

class LocationCard extends StatelessWidget {
  final String address;
  final VoidCallback onDelete;

  const LocationCard({
    super.key,
    required this.address,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.grey),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              address,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
            tooltip: 'Delete Location',
          ),
        ],
      ),
    );
  }
}