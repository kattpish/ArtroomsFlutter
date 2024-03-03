
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> requestPermissions(BuildContext context) async {

  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.photos,
  ].request();

  final statusCamera = await Permission.camera.request();
  final statusPhotos = statuses[Permission.photos];

  if (statusCamera.isGranted && statusPhotos!.isGranted) {
    if (kDebugMode) {
      print("Camera and Storage permissions granted.");
    }
  } else {
    if (kDebugMode) {
      print("Permissions not granted. Camera: $statusCamera, Photos: $statusPhotos");
    }
  }

}
