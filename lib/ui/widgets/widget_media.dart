
import 'dart:io';

import 'package:artrooms/ui/screens/screen_photo_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../beans/bean_file.dart';


void doOpenPhotoView(BuildContext buildContext, {File? fileImage, String imageUrl="", String fileName=""}) {

    Navigator.push(buildContext, MaterialPageRoute(builder: (context) {
      return ScreenPhotoView(fileImage: fileImage, imageUrl: imageUrl, fileName: fileName,);
    }));
    return;

}

Future<File?> doPickImageWithCamera() async {

  final ImagePicker picker = ImagePicker();

  final XFile? photo = await picker.pickImage(source: ImageSource.camera);

  if (photo != null) {
    return File(photo.path);
  } else {
    return null;
  }

}

Future<List<FileItem>> doPickFiles() async {

  List<FileItem> fileItems = [];

  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.any,
    allowedExtensions: [],
  );

  if (result != null) {

    List<File> files = result.paths.map((path) {
      return File(path!);
    }).toList();

    for(File file in files) {

      FileItem fileItem = FileItem(
        file: file,
        path: file.path
      );

      fileItems.add(fileItem);
    }

  } else {
    if (kDebugMode) {
      print("No file selected");
    }
  }

  return fileItems;
}
