
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../utils/utils.dart';
import '../../utils/utils_media.dart';
import '../theme/theme_colors.dart';


void viewPhoto(BuildContext buildContext, {File? fileImage, String imageUrl="", String fileName=""}) {
  showDialog(
    context: buildContext,
    builder: (BuildContext context) {

      ImageProvider imageProvider;
      if (fileImage != null) {
        imageProvider = FileImage(fileImage);
      } else {
        imageProvider = NetworkImage(imageUrl);
      }

      return Scaffold(
        backgroundColor: Colors.black.withOpacity(0.40),
        body: Container(
          color: Colors.black.withOpacity(0.5),
          child: Stack(
            children: [
              Center(
                child: Stack(
                  children: [
                    PhotoView(
                      imageProvider: imageProvider,
                      backgroundDecoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      loadingBuilder: (context, event) => Center(
                        child: CircularProgressIndicator(
                          value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                        ),
                      ),
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/images/chats/placeholder_photo.png',
                          width: 0,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 18,
                right: 18,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: colorMainGrey250,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 22,
                        color: Colors.black,
                      ),
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
              ),
              Visibility(
                visible: imageUrl.isNotEmpty,
                child: Positioned(
                  bottom: 18,
                  left: 29,
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: const Icon(
                          Icons.file_download_outlined,
                          size: 32,
                          color: colorMainGrey300,
                        ),
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        onPressed: () async {

                          await downloadFile(buildContext, imageUrl, fileName);

                          showSnackBar(buildContext, "이미지가 다운로드됨");

                        },
                      ),
                    )
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
