import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions(BuildContext context) async {

  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.storage,
  ].request();

  final statusCamera = await Permission.camera.request();
  final statusStorage = statuses[Permission.storage];

  if (statusCamera.isGranted && statusStorage!.isGranted) {
    print("Camera and Storage permissions granted.");
  } else {
    print("Permissions not granted. Camera: $statusCamera, Storage: $statusStorage");

    if (statusStorage!.isPermanentlyDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Storage Permission'),
          content: Text('This app needs storage access to function properly. Please open settings and grant storage permission.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Open Settings'),
              onPressed: () => openAppSettings(),
            ),
          ],
        ),
      );
    }
  }
}
