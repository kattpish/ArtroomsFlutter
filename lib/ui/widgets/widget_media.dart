
import 'package:flutter/material.dart';

import '../../beans/bean_file.dart';
import '../theme/theme_colors.dart';


void viewPhotoUrl(BuildContext context, String imageUrl) {
  viewPhoto(context, "", imageUrl);
}

void viewPhotoFile(BuildContext context, FileItem file) {
  viewPhoto(context, file.path, "");
}

void viewPhoto(BuildContext context, String imagePath, String imageUrl) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.black.withOpacity(0.40),
          body: Container(
            color: Colors.black.withOpacity(0.5),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: colorMainGrey200,
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
                    ],
                  ),
                ),
                Expanded(
                  child: imagePath.isNotEmpty
                      ? Image.asset(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.none,
                  )
                  : FadeInImage.assetNetwork(
                    placeholder: 'assets/images/profile/placeholder.png',
                    image: imageUrl,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 100),
                    fadeOutDuration: const Duration(milliseconds: 100),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/profile/placeholder.png',
                        fit: BoxFit.cover,
                      );
                    },
                  )
                  ,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
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
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
  );
}
