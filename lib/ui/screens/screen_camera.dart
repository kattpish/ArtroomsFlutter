// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
//
// class ScreenCamera extends StatefulWidget {
//   final CameraController cameraController;
//   final int direction;
//   const ScreenCamera({super.key, required this.cameraController, required this.direction});
//
//   @override
//   State<ScreenCamera> createState() => _ScreenCameraState();
// }
//
// class _ScreenCameraState extends State<ScreenCamera> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           CameraPreview(widget.cameraController),
//           GestureDetectorctor(
//             onTap: () {
//               setState(() {
//                 direction = direction == 0 ? 1 : 0;
//                 startCamera(direction);
//               });
//             },
//             child: button(Icons.flip_camera_ios_outlined, Alignment.bottomLeft),
//           ),
//           GestureDetector(
//             onTap: () {
//               widget.cameraController.takePicture().then((XFile? file) {
//                 if(mounted) {
//                   if(file != null) {
//                     print("Picture saved to ${file.path}");
//                   }
//                 }
//               });
//             },
//             child: button(Icons.camera_alt_outlined, Alignment.bottomCenter),
//           ),
//           Align(
//             alignment: AlignmentDirectional.topCenter,
//             child: Text(
//               "My Camera",
//               style: TextStyle(
//                 fontSize: 30,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//  {
//   return const SizedBox();
//   }}
// }
