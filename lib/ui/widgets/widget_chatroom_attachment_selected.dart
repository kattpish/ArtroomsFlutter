
import 'package:artrooms/ui/widgets/widget_media.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../beans/bean_file.dart';
import '../theme/theme_colors.dart';


Widget attachmentSelected(BuildContext context, List<FileItem> filesImages, {required Null Function(FileItem fileItem) onRemove}) {
  List<FileItem> filesAttachment = [];

  for (FileItem fileImage in filesImages) {
    if (fileImage.isSelected) {
      filesAttachment.add(fileImage);
    }
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 4),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (FileItem fileItem in filesAttachment)
            Container(
              margin: const EdgeInsets.only(right: 4, top: 4, bottom: 4),
              child: InkWell(
                onTap: () {
                  doOpenPhotoView(context, fileImage: fileItem.file, fileName: fileItem.name);
                },
                child: Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFFF3F3F3)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Image.file(
                        fileItem.file,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: colorMainGrey400,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 12,
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(4),
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            onRemove(fileItem);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget buildSheet(BuildContext context, List<FileItem> filesImages,
    {required Null Function(FileItem fileItem) onRemove}) {
  List<FileItem> filesAttachment = [];

  for (FileItem fileImage in filesImages) {
    if (fileImage.isSelected) {
      filesAttachment.add(fileImage);
    }
    print("file attachment");
    print(filesAttachment);
  }
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Expanded(
        child: Container(
          color: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 4),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (FileItem fileItem in filesAttachment)
              Container(
                margin: const EdgeInsets.only(right: 4, top: 4, bottom: 4),
                child: InkWell(
                  onTap: () {
                    doOpenPhotoView(context, fileImage: fileItem.file, fileName: fileItem.name);
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 1, color: Color(0xFFF3F3F3)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Image.file(
                          fileItem.file,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: colorMainGrey400,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 12,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(4),
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              onRemove(fileItem);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
          ),
      )
    ],
  );
}