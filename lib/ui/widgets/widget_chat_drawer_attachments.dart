
import 'dart:io';

import 'package:artrooms/ui/widgets/widget_media.dart';

import 'package:flutter/material.dart';

import '../../beans/bean_file.dart';
import '../../beans/bean_message.dart';
import '../../listeners/scroll_bouncing_physics.dart';


Widget widgetChatDrawerAttachments(BuildContext context, List<DataMessage> listAttachmentsImages) {

  List<FileItem> listImages = toFileItems(listAttachmentsImages);

  return ScrollConfiguration(
    behavior: scrollBehavior,
    child: SingleChildScrollView(
      // physics: const ScrollPhysicsBouncing(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for(FileItem fileItem in listImages)
            Container(
              margin: const EdgeInsets.only(right: 4),
              child: InkWell(
                onTap: () {
                  doOpenPhotoView(context, listImages, initialIndex: fileItem.index);
                },
                child: Container(
                  width: 80,
                  height: 80,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 1, color: Color(0xFFF3F3F3)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/chats/placeholder_photo.png',
                    image: fileItem.url,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 100),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/chats/placeholder_photo.png',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
