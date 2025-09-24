// import 'package:flutter/material.dart';
//
// class ImageTitleColumn extends StatelessWidget {
//   final String imagePath;
//   final String title;
//   final String subtitle;
//
//   const ImageTitleColumn({
//     super.key,
//     required this.imagePath,
//     required this.title,
//     required this.subtitle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Image.asset(imagePath, width: double.infinity, fit: BoxFit.cover),
//         const SizedBox(height: 8),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           subtitle,
//           style: const TextStyle(
//             fontSize: 16,
//             color: Colors.white70,
//           ),
//         ),
//       ],
//     );
//   }
// }
