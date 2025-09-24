// import 'package:flutter/material.dart';
//
// class CustomStackCard extends StatelessWidget {
//   final String title;
//   final String subtitle;
//
//   const CustomStackCard({
//     super.key,
//     required this.title,
//     required this.subtitle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 160,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.9),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 6,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             subtitle,
//             style: const TextStyle(fontSize: 14, color: Colors.black54),
//           ),
//         ],
//       ),
//     );
//   }
// }
