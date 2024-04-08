
import 'dart:io';

import 'package:artrooms/beans/bean_message.dart';
import 'package:artrooms/ui/screens/screen_photo_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../beans/bean_file.dart';


Future<void> doOpenPhotoView(BuildContext context, List<FileItem> listImages, {int initialIndex = 0}) async {

  await Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ScreenPhotoView(images: listImages, initialIndex: initialIndex);
  }));

}

List<FileItem> toFileItems(List<DataMessage> listAttachmentsImages) {

  List<FileItem> listImages = [];

  int index = 0;
  for (int i = 0; i < listAttachmentsImages.length; i++) {
    DataMessage dataMessage = listAttachmentsImages[i];

    for(String imageUrl in dataMessage.attachmentImages) {

      if(imageUrl.isNotEmpty) {

        FileItem fileItem = FileItem(
          index: index,
          file: File("/"),
          url: imageUrl,
        );

        listImages.add(fileItem);
        index++;
      }

    }

  }

  return listImages;
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
