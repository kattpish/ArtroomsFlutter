// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatelessWidget {
//   const CustomTextField({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.topLeft,
//       children: <Widget>[
//         TextFormField(
//           controller: _controller, // TextEditingController
//           decoration: const InputDecoration(
//             hintText: 'Enter something...',
//           ),
//           cursorColor: Colors.transparent, // Hide cursor
//           style: const TextStyle(color: Colors.transparent), // Hide text
//           onChanged: (value) {
//             // Update the RichText widget
//             setState(() {});
//           },
//         ),
//         Positioned(
//           top: 0,
//           left: 0,
//           child: IgnorePointer( // Ignore touches on the RichText
//             child: RichText(
//               text: TextSpan(
//                 children: _buildTextSpans(_controller.text),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
